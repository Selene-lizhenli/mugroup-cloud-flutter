import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/warehouse/warehouse_receipt_item.dart';
import 'package:cloud/pages/warehouse/warehouse_receipt_status.dart';
import 'package:cloud/providers/warehouse_provider.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/warehouse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sliver_tools/sliver_tools.dart';

@RoutePage()
class WarehouseReceiptDetailPage extends HookConsumerWidget {
  final int receiptId;
  final String? initialOrderNo;

  const WarehouseReceiptDetailPage({
    super.key,
    required this.receiptId,
    this.initialOrderNo,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reloadKey = useState(0);
    final selectedTab = useState(0);
    final searchController = useTextEditingController();
    final searchFocusNode = useFocusNode();
    final search = useState(searchController.text);
    final scrollController = useScrollController();
    // Supplier groups collapsed by the user (default: all expanded).
    final collapsedSuppliers = useState<Set<String>>(const {});
    // Active supplier filter chip (null = 全部).
    final supplierFilter = useState<String?>(null);
    // Guards the one-time "collapse by default when crowded" decision.
    final didInitCollapse = useRef(false);

    final itemsState = useState<List<WarehouseReceiptItem>>([]);
    final isItemsLoading = useState(true);
    final itemsError = useState<Object?>(null);
    final requestSeq = useRef(0);
    final itemsRefreshTick = ref.watch(warehouseReceiptItemsRefreshProvider);

    useEffect(() {
      Timer? timer;

      void listener() {
        timer?.cancel();
        timer = Timer(const Duration(milliseconds: 350), () {
          search.value = searchController.text;
        });
      }

      searchController.addListener(listener);
      return () {
        timer?.cancel();
        searchController.removeListener(listener);
      };
    }, [searchController]);

    final receiptSnapshot = useFuture(
      useMemoized(
        () => fetchWarehouseReceipt(receiptId),
        [receiptId, reloadKey.value],
      ),
    );

    Future<void> loadItems() async {
      final seq = ++requestSeq.value;

      itemsError.value = null;
      isItemsLoading.value = true;

      try {
        final items = await getWarehouseReceiptFlatItems(
          receiptId,
          queryParameters: {
            if (_statusValue(selectedTab.value) != null)
              'status': _statusValue(selectedTab.value),
            if (search.value.trim().isNotEmpty) 'search': search.value.trim(),
          },
        );

        if (requestSeq.value != seq) return;
        itemsState.value = items;
      } catch (error) {
        if (requestSeq.value != seq) return;
        itemsError.value = error;
        itemsState.value = [];
      } finally {
        if (requestSeq.value == seq) {
          isItemsLoading.value = false;
        }
      }
    }

    Future<void> reload() async {
      reloadKey.value++;
    }

    Future<void> openItemDetail(int itemId) async {
      final beforeRefreshTick = ref.read(warehouseReceiptItemsRefreshProvider);

      searchFocusNode.unfocus();
      FocusManager.instance.primaryFocus?.unfocus();

      await context.router.push(WarehouseReceiptItemDetailRoute(id: itemId));

      searchFocusNode.unfocus();
      FocusManager.instance.primaryFocus?.unfocus();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        searchFocusNode.unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      });

      if (ref.read(warehouseReceiptItemsRefreshProvider) == beforeRefreshTick) {
        await reload();
      }
    }

    useEffect(() {
      if (itemsRefreshTick == 0) return null;
      reload();
      return null;
    }, [itemsRefreshTick]);

    useEffect(() {
      loadItems();
      return null;
    }, [receiptId, selectedTab.value, search.value, reloadKey.value]);

    // When a receipt has many items across several suppliers, start collapsed
    // so the user sees the supplier overview first. Runs once after the first
    // non-empty load, then respects the user's manual toggles.
    useEffect(() {
      final list = itemsState.value;
      if (didInitCollapse.value || list.isEmpty) return null;
      final gs = _groupBySupplier(list);
      if (gs.length > 1 && list.length > 15) {
        collapsedSuppliers.value = gs.map((g) => g.key).toSet();
      }
      didInitCollapse.value = true;
      return null;
    }, [itemsState.value]);

    final receipt = receiptSnapshot.data;
    final items = itemsState.value;
    final isReceiptLoading =
        receiptSnapshot.connectionState == ConnectionState.waiting;
    final showInitialItemsLoading = isItemsLoading.value && items.isEmpty;
    final showOverlayLoading = isItemsLoading.value && items.isNotEmpty;
    final orderNo = _normalizeText(receipt?.orderNo) ??
        _normalizeText(initialOrderNo) ??
        '未填写订单号';

    final allGroups = _groupBySupplier(items);
    final multiSupplier = allGroups.length > 1;
    // Drop a stale filter if that supplier disappeared (e.g. after search).
    final activeFilter = allGroups.any((g) => g.key == supplierFilter.value)
        ? supplierFilter.value
        : null;
    final groups = activeFilter == null
        ? allGroups
        : allGroups.where((g) => g.key == activeFilter).toList();
    final visibleKeys = groups.map((g) => g.key).toSet();
    final allCollapsed = visibleKeys.isNotEmpty &&
        visibleKeys.every(collapsedSuppliers.value.contains);

    void toggleAll() {
      final next = Set<String>.from(collapsedSuppliers.value);
      if (allCollapsed) {
        next.removeAll(visibleKeys);
      } else {
        next.addAll(visibleKeys);
      }
      collapsedSuppliers.value = next;
    }

    Widget body;
    if (receiptSnapshot.hasError) {
      body = Center(child: Text('加载失败: ${receiptSnapshot.error}'));
    } else if (receipt == null && isReceiptLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (receipt == null) {
      body = const Center(child: Text('未找到入库单'));
    } else if (itemsError.value != null && items.isEmpty) {
      body = Center(child: Text('加载失败: ${itemsError.value}'));
    } else if (showInitialItemsLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      body = RefreshIndicator(
        onRefresh: reload,
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _SearchBar(
                            controller: searchController,
                            focusNode: searchFocusNode,
                            keyword: searchController.text,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _StatusFilterButton(
                          selectedIndex: selectedTab.value,
                          onSelected: (index) {
                            if (selectedTab.value == index) return;
                            selectedTab.value = index;
                          },
                        ),
                        if (multiSupplier)
                          IconButton(
                            tooltip: allCollapsed ? '全部展开' : '全部收起',
                            icon: Icon(allCollapsed
                                ? Icons.unfold_more
                                : Icons.unfold_less),
                            onPressed: toggleAll,
                            visualDensity: VisualDensity.compact,
                            constraints: const BoxConstraints(
                                minWidth: 40, minHeight: 40),
                          ),
                      ],
                    ),
                    if (multiSupplier) ...[
                      const SizedBox(height: 10),
                      _SupplierFilterChips(
                        groups: allGroups,
                        selected: activeFilter,
                        onSelect: (key) {
                          supplierFilter.value = key;
                          // Filtering to a supplier should reveal its items
                          // even if groups started collapsed.
                          if (key != null &&
                              collapsedSuppliers.value.contains(key)) {
                            collapsedSuppliers.value =
                                Set<String>.from(collapsedSuppliers.value)
                                  ..remove(key);
                          }
                        },
                      ),
                    ],
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),
            if (items.isEmpty)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: Center(child: Text('暂无明细')),
                ),
              )
            else
              for (final group in groups)
                SliverClip(
                  child: MultiSliver(
                    children: [
                      SliverPinnedHeader(
                        child: _SupplierHeader(
                          group: group,
                          collapsed: collapsedSuppliers.value.contains(group.key),
                          onToggle: () {
                            final next =
                                Set<String>.from(collapsedSuppliers.value);
                            if (!next.remove(group.key)) next.add(group.key);
                            collapsedSuppliers.value = next;
                          },
                        ),
                      ),
                      if (!collapsedSuppliers.value.contains(group.key))
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, i) => Padding(
                              padding: EdgeInsets.fromLTRB(
                                  12, i == 0 ? 0 : 10, 12, 0),
                              child: _ReceiptItemCard(
                                item: group.items[i],
                                onTap: group.items[i].id == null
                                    ? null
                                    : () => openItemDetail(group.items[i].id!),
                              ),
                            ),
                            childCount: group.items.length,
                          ),
                        ),
                      const SliverToBoxAdapter(child: SizedBox(height: 12)),
                    ],
                  ),
                ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          orderNo,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            tooltip: '新增明细',
            icon: const Icon(Icons.add),
            onPressed: () async {
              searchFocusNode.unfocus();
              FocusManager.instance.primaryFocus?.unfocus();
              await showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (_) => _AddPurchaseDetailSheet(
                  receiptId: receiptId,
                  onAdded: reload,
                ),
              );
            },
          ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            Positioned.fill(child: body),
            if (showOverlayLoading)
              const Positioned.fill(
                child: ColoredBox(
                  color: Color(0x22000000),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

String? _statusValue(int index) {
  switch (index) {
    case 1:
      return 'entered';
    case 2:
      return 'unentered';
    default:
      return null;
  }
}

String? _normalizeText(String? value) {
  final normalized = value?.trim();
  if (normalized == null || normalized.isEmpty) return null;
  return normalized;
}

/// A supplier group within a single receipt.
class _SupplierGroup {
  final String key; // grouping key (supplier name or fallback)
  final String label; // display name
  final List<WarehouseReceiptItem> items;

  const _SupplierGroup({
    required this.key,
    required this.label,
    required this.items,
  });

  /// Count of items considered fully received (已入库 / 超量).
  int get enteredCount => items.where((it) {
        final s = receiptItemStatus(it, it.entries ?? const []).status;
        return s == ReceiptEntryStatus.full || s == ReceiptEntryStatus.over;
      }).length;
}

/// Group items by supplier, preserving first-appearance order. Items without a
/// supplier fall into a single "未指定供应商" group at the end.
List<_SupplierGroup> _groupBySupplier(List<WarehouseReceiptItem> items) {
  const fallbackKey = '__none__';
  final order = <String>[];
  final buckets = <String, List<WarehouseReceiptItem>>{};

  for (final item in items) {
    final name = _normalizeText(item.supplierShortName);
    final key = name ?? fallbackKey;
    if (!buckets.containsKey(key)) {
      buckets[key] = [];
      order.add(key);
    }
    buckets[key]!.add(item);
  }

  return [
    for (final key in order)
      _SupplierGroup(
        key: key,
        label: key == fallbackKey ? '未指定供应商' : key,
        items: buckets[key]!,
      ),
  ];
}

class _SupplierFilterChips extends StatelessWidget {
  final List<_SupplierGroup> groups;
  final String? selected;
  final ValueChanged<String?> onSelect;

  const _SupplierFilterChips({
    required this.groups,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        children: [
          _chip('全部', selected == null, () => onSelect(null)),
          for (final g in groups)
            _chip('${g.label} (${g.items.length})', selected == g.key,
                () => onSelect(g.key)),
        ],
      ),
    );
  }

  Widget _chip(String label, bool active, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: active,
        showCheckmark: false,
        labelStyle: TextStyle(
          fontSize: 12,
          color: active ? Colors.white : Colors.grey[700],
          fontWeight: FontWeight.w500,
        ),
        selectedColor: const Color(0xFF1565C0),
        backgroundColor: const Color(0xFFF4F5F7),
        side: BorderSide.none,
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onSelected: (_) => onTap(),
      ),
    );
  }
}

class _SupplierHeader extends StatelessWidget {
  final _SupplierGroup group;
  final bool collapsed;
  final VoidCallback onToggle;

  const _SupplierHeader({
    required this.group,
    required this.collapsed,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final total = group.items.length;
    final entered = group.enteredCount;
    final allDone = entered == total && total > 0;

    return Material(
      color: const Color(0xFFF4F5F7),
      child: InkWell(
        onTap: onToggle,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Row(
            children: [
              Container(
                width: 3,
                height: 16,
                decoration: BoxDecoration(
                  color: const Color(0xFF1565C0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  group.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$total 项 · 已入 $entered/$total',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: allDone
                      ? const Color(0xFF2E7D32)
                      : Colors.grey.shade600,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                collapsed ? Icons.expand_more : Icons.expand_less,
                size: 20,
                color: Colors.grey.shade600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String keyword;

  const _SearchBar({
    required this.controller,
    required this.focusNode,
    required this.keyword,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: TextInputAction.search,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: '搜索产品编号',
        prefixIcon: const Icon(Icons.search, size: 20),
        prefixIconConstraints:
            const BoxConstraints(minWidth: 36, minHeight: 0),
        suffixIcon: keyword.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.clear, size: 18),
                tooltip: '清除',
                visualDensity: VisualDensity.compact,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 0),
                padding: EdgeInsets.zero,
                onPressed: () {
                  controller.clear();
                  focusNode.unfocus();
                },
              ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 11),
      ),
    );
  }
}

class _StatusFilterButton extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _StatusFilterButton({
    required this.selectedIndex,
    required this.onSelected,
  });

  static const _labels = ['全部', '已入库', '未入库'];

  @override
  Widget build(BuildContext context) {
    final active = selectedIndex != 0;
    final fg = active ? const Color(0xFF1565C0) : Colors.grey[800];

    return PopupMenuButton<int>(
      tooltip: '入库状态',
      initialValue: selectedIndex,
      position: PopupMenuPosition.under,
      onSelected: onSelected,
      itemBuilder: (_) => [
        for (var i = 0; i < _labels.length; i++)
          PopupMenuItem<int>(
            value: i,
            height: 44,
            child: Row(
              children: [
                Icon(Icons.check,
                    size: 18,
                    color: i == selectedIndex
                        ? const Color(0xFF1565C0)
                        : Colors.transparent),
                const SizedBox(width: 8),
                Text(_labels[i]),
              ],
            ),
          ),
      ],
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFE3F2FD) : const Color(0xFFF4F5F7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.filter_list, size: 16, color: fg),
            const SizedBox(width: 4),
            Text(
              _labels[selectedIndex],
              style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600, color: fg),
            ),
            Icon(Icons.arrow_drop_down, size: 18, color: fg),
          ],
        ),
      ),
    );
  }
}

class _ReceiptItemCard extends StatelessWidget {
  final WarehouseReceiptItem item;
  final Future<void> Function()? onTap;

  const _ReceiptItemCard({
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final entriesCount = item.entriesCount ?? 0;
    final completedEntries =
        item.entries?.where((e) => e.enteredAt != null).toList() ?? [];
    final isPreEntered = entriesCount > 0 && completedEntries.isEmpty;
    final latestCompleted =
        completedEntries.isNotEmpty ? completedEntries.last : null;
    final latestEntry = item.entries?.isNotEmpty == true
        ? item.entries!.last
        : null;
    final statusInfo = receiptItemStatus(item, item.entries ?? const []);

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap == null ? null : () => unawaited(onTap!()),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      item.itemNo?.isNotEmpty == true
                          ? item.itemNo!
                          : '未填写产品编号',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _StatusBadge(info: statusInfo, count: entriesCount),
                ],
              ),
              if (latestCompleted?.actualCartonQty != null) ...[
                const SizedBox(height: 8),
                _ItemLine(
                  label: '最近箱数',
                  value: latestCompleted!.actualCartonQty.toString(),
                ),
              ],
              if (latestCompleted?.location != null) ...[
                const SizedBox(height: 4),
                _ItemLine(
                  label: '库位',
                  value: latestCompleted!.location!.displayName,
                ),
              ],
              if (latestCompleted?.enteredAt != null) ...[
                const SizedBox(height: 4),
                _ItemLine(
                  label: '最近入库',
                  value: _formatEnteredAt(latestCompleted!.enteredAt),
                ),
              ] else if (isPreEntered && latestEntry?.createdAt != null) ...[
                const SizedBox(height: 4),
                _ItemLine(
                  label: '测量时间',
                  value: _formatEnteredAt(latestEntry!.createdAt),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

String _formatEnteredAt(DateTime? value) {
  if (value == null) return '--';
  return DateFormat('yyyy-MM-dd HH:mm').format(value);
}

class _StatusBadge extends StatelessWidget {
  final ReceiptStatusInfo info;
  final int count;

  const _StatusBadge({required this.info, required this.count});

  @override
  Widget build(BuildContext context) {
    final String text;
    if (info.isEntered) {
      final planned = info.plannedQty;
      text = planned != null && planned > 0
          ? '${info.label} ${_qty(info.enteredQty)}/$planned'
          : info.label;
    } else if (info.status == ReceiptEntryStatus.pre) {
      text = count > 0 ? '${info.label} ($count)' : info.label;
    } else {
      text = info.label;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: info.bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: info.fg,
        ),
      ),
    );
  }
}

String _qty(num value) {
  return value == value.truncate() ? value.toInt().toString() : value.toString();
}

class _ItemLine extends StatelessWidget {
  final String label;
  final String value;

  const _ItemLine({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 68,
          child: Text(
            label,
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}

// ─── Add purchase-contract detail ─────────────────────────────────────────────

/// Bottom sheet to search purchase-contract details and add them to the receipt.
class _AddPurchaseDetailSheet extends StatefulWidget {
  final int receiptId;

  /// Called after each successful add so the underlying list can refresh.
  final VoidCallback onAdded;

  const _AddPurchaseDetailSheet({
    required this.receiptId,
    required this.onAdded,
  });

  @override
  State<_AddPurchaseDetailSheet> createState() =>
      _AddPurchaseDetailSheetState();
}

class _AddPurchaseDetailSheetState extends State<_AddPurchaseDetailSheet> {
  static const _pageSize = 20;

  final _searchController = TextEditingController();
  Timer? _debounce;

  final List<WarehouseReceiptItem> _items = [];
  // Identity keys of details already added to this receipt (within this session).
  final Set<String> _added = {};
  String? _addingKey;

  String _search = '';
  bool _loading = false;
  bool _loadingMore = false;
  String? _error;
  int _page = 1;
  int _totalPages = 1;
  int _searchSeq = 0;

  @override
  void initState() {
    super.initState();
    // Do not search on open — wait for the user to type a keyword.
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (_searchController.text.trim() == _search) return;
      _search = _searchController.text.trim();
      _runSearch();
    });
  }

  Future<void> _runSearch() async {
    final seq = ++_searchSeq;
    setState(() {
      _loading = true;
      _error = null;
      _page = 1;
    });
    try {
      final resp = await searchReceiptPurchaseContractDetails(
        widget.receiptId,
        queryParameters: {
          if (_search.isNotEmpty) 'search': _search,
          'page': 1,
          'page_size': _pageSize,
        },
      );
      if (seq != _searchSeq || !mounted) return;
      setState(() {
        _items
          ..clear()
          ..addAll(resp.data);
        _totalPages = resp.meta?.pagination?.totalPages ?? 1;
        _loading = false;
      });
    } catch (e) {
      if (seq != _searchSeq || !mounted) return;
      setState(() {
        _loading = false;
        _error = '加载失败，请重试';
      });
    }
  }

  Future<void> _loadMore() async {
    if (_loadingMore || _loading || _page >= _totalPages) return;
    final seq = _searchSeq;
    setState(() => _loadingMore = true);
    try {
      final nextPage = _page + 1;
      final resp = await searchReceiptPurchaseContractDetails(
        widget.receiptId,
        queryParameters: {
          if (_search.isNotEmpty) 'search': _search,
          'page': nextPage,
          'page_size': _pageSize,
        },
      );
      if (seq != _searchSeq || !mounted) return;
      setState(() {
        _items.addAll(resp.data);
        _page = nextPage;
        _totalPages = resp.meta?.pagination?.totalPages ?? _totalPages;
        _loadingMore = false;
      });
    } catch (_) {
      if (seq != _searchSeq || !mounted) return;
      setState(() => _loadingMore = false);
    }
  }

  /// Stable identity for a candidate row. Prefer `record_id`; fall back to the
  /// row index when it is missing so the UI still tracks add state per row.
  String _keyFor(WarehouseReceiptItem detail, int index) =>
      detail.recordId ?? 'idx-$index';

  Future<void> _add(WarehouseReceiptItem detail, String key) async {
    if (_added.contains(key) || _addingKey != null) return;
    setState(() => _addingKey = key);
    try {
      await addReceiptPurchaseContractDetailItem(widget.receiptId, detail);
      if (!mounted) return;
      setState(() {
        _added.add(key);
        _addingKey = null;
      });
      EasyLoading.showSuccess('已添加');
      widget.onAdded();
    } catch (_) {
      if (!mounted) return;
      setState(() => _addingKey = null);
      // Error toast is surfaced by the API interceptor.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (ctx, sc) => GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('新增明细',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                textInputAction: TextInputAction.search,
                onTapOutside: (_) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                decoration: InputDecoration(
                  hintText: '搜索货号 / 客户货号 / 采购单号',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _search.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: _searchController.clear,
                        ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Divider(height: 1),
            Expanded(child: _buildList(sc)),
          ],
          ),
        ),
      ),
    );
  }

  Widget _buildList(ScrollController sheetController) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text(_error!));
    }
    if (_items.isEmpty) {
      return Center(
        child: Text(
          _search.isEmpty ? '请输入关键词搜索' : '未找到相关明细',
          style: TextStyle(color: Colors.grey[500]),
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        if (n.metrics.pixels >= n.metrics.maxScrollExtent - 200) {
          _loadMore();
        }
        return false;
      },
      child: ListView.separated(
        controller: sheetController,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
        itemCount: _items.length + (_page < _totalPages ? 1 : 0),
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (ctx, i) {
          if (i >= _items.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          }
          final detail = _items[i];
          final key = _keyFor(detail, i);
          return _PurchaseDetailRow(
            detail: detail,
            added: _added.contains(key),
            adding: _addingKey == key,
            onAdd: () => _add(detail, key),
          );
        },
      ),
    );
  }
}

class _PurchaseDetailRow extends StatelessWidget {
  final WarehouseReceiptItem detail;
  final bool added;
  final bool adding;
  final VoidCallback onAdd;

  const _PurchaseDetailRow({
    required this.detail,
    required this.added,
    required this.adding,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final itemNo = _normalizeText(detail.itemNo) ?? '未填写货号';
    final customer = _normalizeText(detail.customerItemNo);
    final supplier = _normalizeText(detail.supplierShortName);
    final orderNo = _normalizeText(detail.purchaseOrderNo);
    final cartonQty = detail.cartonQty;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    itemNo,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  if (customer != null) ...[
                    const SizedBox(height: 2),
                    Text('客户货号：$customer',
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey[600])),
                  ],
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 12,
                    runSpacing: 2,
                    children: [
                      if (supplier != null)
                        Text(supplier,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600])),
                      if (orderNo != null)
                        Text(orderNo,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600])),
                      if (cartonQty != null)
                        Text('箱数 $cartonQty',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _AddButton(added: added, adding: adding, onAdd: onAdd),
          ],
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final bool added;
  final bool adding;
  final VoidCallback onAdd;

  const _AddButton({
    required this.added,
    required this.adding,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    if (adding) {
      return const SizedBox(
        width: 64,
        height: 32,
        child: Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    if (added) {
      return const SizedBox(
        width: 64,
        height: 32,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check, size: 16, color: Color(0xFF2E7D32)),
              SizedBox(width: 2),
              Text('已添加',
                  style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF2E7D32),
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      );
    }
    return SizedBox(
      height: 32,
      child: FilledButton(
        onPressed: onAdd,
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          minimumSize: const Size(0, 32),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text('添加', style: TextStyle(fontSize: 13)),
      ),
    );
  }
}
