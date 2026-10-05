import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/warehouse/warehouse_location.dart';
import 'package:cloud/models/warehouse/warehouse_receipt_item.dart';
import 'package:cloud/models/warehouse/warehouse_receipt_item_entry.dart';
import 'package:cloud/models/warehouse/warehouse_receipt_mixed_carton.dart';
import 'package:cloud/pages/quote/quote_product_add/widgets/voice_record_button.dart';
import 'package:cloud/pages/warehouse/warehouse_receipt_status.dart';
import 'package:cloud/providers/warehouse_provider.dart';
import 'package:cloud/services/warehouse.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

@RoutePage()
class WarehouseReceiptItemDetailPage extends HookConsumerWidget {
  final int id;

  const WarehouseReceiptItemDetailPage({
    super.key,
    @pathParam required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsExpanded = useState(false);
    // Local entries list — seeded from initial load, updated in-place after each save.
    final entriesState = useState<List<WarehouseReceiptItemEntry>?>(null);
    // When set, the form edits this specific (already saved) entry instead of
    // creating a new one / completing the pending entry.
    final editingEntryId = useState<int?>(null);

    final itemSnapshot = useFuture(
      useMemoized(() => fetchWarehouseReceiptItem(id), [id]),
    );

    // Re-seed entries whenever a (new) item arrives. Keyed on the item object
    // identity so navigating to another item (same widget element, new `id`)
    // resets the local list instead of keeping the previous item's entries.
    // The fetched future only changes on initial load or `id` change, so this
    // does not clobber the in-place updates made by `onSaved`.
    useEffect(() {
      final loaded = itemSnapshot.data;
      if (loaded != null) {
        entriesState.value = loaded.entries ?? [];
      }
      return null;
    }, [itemSnapshot.data]);

    final isLoading = itemSnapshot.connectionState == ConnectionState.waiting;
    final item = itemSnapshot.data;

    Widget body;
    if (itemSnapshot.hasError) {
      body = Center(child: Text('加载失败: ${itemSnapshot.error}'));
    } else if (item == null) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      final entries = entriesState.value ?? [];
      // There can be multiple pending (预入库) records, so the form never
      // auto-targets one — the user must explicitly tap a record to edit /
      // 补充箱数. With no selection the form creates a new record.
      final editingId = editingEntryId.value;
      final editingEntry = editingId == null
          ? null
          : entries.where((e) => e.id == editingId).firstOrNull;

      Future<void> deleteEntry(WarehouseReceiptItemEntry entry) async {
        // Only pending (预入库) records may be deleted.
        if (entry.enteredAt != null) return;
        if (entry.id == null || item.id == null) return;
        EasyLoading.show(status: '删除中...');
        try {
          await deleteWarehouseReceiptItemEntry(item.id!, entry.id!);
          entriesState.value = (entriesState.value ?? [])
              .where((e) => e.id != entry.id)
              .toList();
          if (editingEntryId.value == entry.id) editingEntryId.value = null;
          ref.read(warehouseReceiptItemsRefreshProvider.notifier).state++;
          EasyLoading.showSuccess('已删除');
        } catch (_) {
          EasyLoading.showError('删除失败');
        }
      }

      body = Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
            children: [
              _ItemSummaryCard(item: item, entries: entries),
              const SizedBox(height: 12),
              _EntryFormCard(
                // Include item id so navigating to another item always rebuilds
                // a fresh form, even when both items are in create mode
                // (otherwise the 'form-new' key would reuse the old State and
                // keep the previously typed values).
                key: ValueKey('form-${item.id}-${editingEntry?.id ?? 'new'}'),
                item: item,
                pendingEntry: editingEntry,
                onCancelEdit: editingId != null
                    ? () => editingEntryId.value = null
                    : null,
                onSaved: (saved) {
                  final current = entriesState.value ?? [];
                  if (current.any((e) => e.id == saved.id)) {
                    entriesState.value = current
                        .map((e) => e.id == saved.id ? saved : e)
                        .toList();
                  } else {
                    entriesState.value = [...current, saved];
                  }
                  editingEntryId.value = null;
                  ref
                      .read(warehouseReceiptItemsRefreshProvider.notifier)
                      .state++;
                },
              ),
              if (entries.isNotEmpty) ...[
                const SizedBox(height: 12),
                _EntriesListCard(
                  entries: entries,
                  editingEntryId: editingId,
                  onEdit: (entry) {
                    editingEntryId.value = entry.id;
                    FocusScope.of(context).unfocus();
                  },
                  onDelete: (entry) async {
                    final confirmed = await _confirmDelete(context);
                    if (confirmed == true) await deleteEntry(entry);
                  },
                ),
              ],
              const SizedBox(height: 12),
              _OriginalSpecsCard(
                item: item,
                expanded: detailsExpanded.value,
                onChanged: (v) => detailsExpanded.value = v,
              ),
            ],
          ),
          if (isLoading)
            const Positioned.fill(
              child: ColoredBox(
                color: Color(0x44000000),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('货号详情'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: body,
      ),
    );
  }
}

// ─── Item Summary ─────────────────────────────────────────────────────────────

class _ItemSummaryCard extends StatelessWidget {
  final WarehouseReceiptItem item;
  final List<WarehouseReceiptItemEntry> entries;

  const _ItemSummaryCard({required this.item, required this.entries});

  @override
  Widget build(BuildContext context) {
    final itemNo = item.itemNo?.trim();
    final normalizedItemNo = itemNo?.isEmpty == true ? null : itemNo;
    final customerItemNo = item.customerItemNo?.trim();
    final normalizedCustomerItemNo =
        customerItemNo?.isEmpty == true ? null : customerItemNo;
    final itemNumbersMatch = normalizedItemNo != null &&
        normalizedCustomerItemNo == normalizedItemNo;
    final showCustomerItemNo = normalizedCustomerItemNo != null &&
        normalizedCustomerItemNo != normalizedItemNo;
    final info = receiptItemStatus(item, entries);
    final badgeBg = info.bg;
    final badgeFg = info.fg;
    // For entered states show the carton progress (已入/计划); otherwise just
    // the record count so the badge still carries a number.
    final String badgeText;
    if (info.isEntered) {
      final planned = info.plannedQty;
      badgeText = planned != null && planned > 0
          ? '${info.label} ${_qtyText(info.enteredQty)}/$planned 箱'
          : '${info.label} ${_qtyText(info.enteredQty)} 箱';
    } else if (info.status == ReceiptEntryStatus.pre) {
      badgeText = '预入库 ${entries.length} 条';
    } else {
      badgeText = '未入库';
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (normalizedItemNo != null)
                    _ItemNumberLine(
                      label: itemNumbersMatch ? '产品/客户货号' : '产品编号',
                      value: normalizedItemNo,
                    ),
                  if (showCustomerItemNo) ...[
                    if (normalizedItemNo != null) const SizedBox(height: 4),
                    _ItemNumberLine(
                      label: '客户货号',
                      value: normalizedCustomerItemNo,
                    ),
                  ],
                  if (normalizedItemNo == null &&
                      normalizedCustomerItemNo == null)
                    const _ItemNumberLine(
                      label: '货号',
                      value: '未填写',
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(badgeText,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: badgeFg)),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemNumberLine extends StatelessWidget {
  final String label;
  final String value;

  const _ItemNumberLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Entry Form (create or update pending entry) ──────────────────────────────

class _EntryFormCard extends StatefulWidget {
  final WarehouseReceiptItem item;
  final WarehouseReceiptItemEntry? pendingEntry; // null = create mode
  final VoidCallback? onCancelEdit;
  final void Function(WarehouseReceiptItemEntry saved) onSaved;

  const _EntryFormCard({
    super.key,
    required this.item,
    required this.pendingEntry,
    this.onCancelEdit,
    required this.onSaved,
  });

  @override
  State<_EntryFormCard> createState() => _EntryFormCardState();
}

class _EntryFormCardState extends State<_EntryFormCard> {
  static const _fieldOrder = [
    'actualOuterLength',
    'actualOuterWidth',
    'actualOuterHeight',
    'actualOuterGrossWeight',
    'actualOuterCapacity',
    'actualCartonQty',
  ];

  late final Map<String, TextEditingController> _controllers;
  late final Map<String, FocusNode> _focusNodes;
  WarehouseLocation? _location;
  List<WarehouseReceiptMixedCarton> _mixedCartons = [];
  WarehouseReceiptMixedCarton? _selectedMixedCarton;
  bool _isMixedCarton = false;
  bool _loadingMixedCartons = false;
  bool _mixedCartonsLoadFailed = false;
  bool _submitting = false;
  bool _voiceProcessing = false;
  bool _voiceHadResult = false;

  @override
  void initState() {
    super.initState();
    _controllers = {for (final n in _fieldOrder) n: TextEditingController()};
    _focusNodes = {for (final n in _fieldOrder) n: FocusNode()};
    _prefill();
    _loadCachedLocation();
    _loadMixedCartons();
  }

  void _prefill() {
    final p = widget.pendingEntry;
    if (p != null) {
      _set('actualOuterLength', p.actualOuterLength);
      _set('actualOuterWidth', p.actualOuterWidth);
      _set('actualOuterHeight', p.actualOuterHeight);
      _set('actualOuterGrossWeight', p.actualOuterGrossWeight);
      _set('actualOuterCapacity', p.actualOuterCapacity);
      _set('actualCartonQty', p.actualCartonQty);
      _location = p.location;
      _isMixedCarton = p.mixedCartonId != null;
      _selectedMixedCarton = p.mixedCarton;
      if (p.mixedCarton != null) {
        _mixedCartons = [p.mixedCarton!];
      }
    }
  }

  Future<void> _loadCachedLocation() async {
    if (widget.pendingEntry != null) return;

    final locationId = widget.item.cachedLocationId;
    if (locationId == null) return;

    try {
      final location = await getWarehouseLocation(locationId);
      if (!mounted || _location != null) return;
      setState(() => _location = location);
    } catch (_) {
      // The picker still allows the user to select a location if hydration fails.
    }
  }

  Future<void> _loadMixedCartons() async {
    final receiptId = widget.item.receiptId;
    if (receiptId == null) return;

    setState(() {
      _loadingMixedCartons = true;
      _mixedCartonsLoadFailed = false;
    });
    try {
      final mixedCartons = await getWarehouseReceiptMixedCartons(receiptId);
      if (!mounted) return;
      setState(() {
        _mixedCartons = mixedCartons;
        final selectedId = _selectedMixedCarton?.id;
        if (selectedId != null) {
          _selectedMixedCarton = mixedCartons
              .where((mixedCarton) => mixedCarton.id == selectedId)
              .firstOrNull;
        }
      });
    } catch (_) {
      if (mounted) {
        setState(() => _mixedCartonsLoadFailed = true);
        EasyLoading.showError('混箱列表加载失败');
      }
    } finally {
      if (mounted) setState(() => _loadingMixedCartons = false);
    }
  }

  void _selectMixedCarton(WarehouseReceiptMixedCarton mixedCarton) {
    _controllers['actualOuterLength']?.text =
        mixedCarton.actualOuterLength?.toString() ?? '';
    _controllers['actualOuterWidth']?.text =
        mixedCarton.actualOuterWidth?.toString() ?? '';
    _controllers['actualOuterHeight']?.text =
        mixedCarton.actualOuterHeight?.toString() ?? '';
    _controllers['actualOuterGrossWeight']?.text =
        mixedCarton.actualOuterGrossWeight?.toString() ?? '';
    _controllers['actualOuterCapacity']?.text =
        mixedCarton.actualOuterCapacity?.toString() ?? '';
    _controllers['actualCartonQty']?.text =
        (mixedCarton.entriesCount ?? 0) == 0 ? '1' : '0';
    setState(() => _selectedMixedCarton = mixedCarton);
  }

  void _setMixedCartonMode(bool mixed) {
    if (_isMixedCarton == mixed) return;

    setState(() {
      _isMixedCarton = mixed;
      _selectedMixedCarton = null;
    });
    for (final controller in _controllers.values) {
      controller.clear();
    }
    if (mixed) {
      _controllers['actualCartonQty']?.text = '自动';
    }
  }

  Future<void> _createMixedCarton() async {
    final receiptId = widget.item.receiptId;
    if (receiptId == null) return;

    final values = await _showCreateMixedCartonDialog(context);
    if (values == null || !mounted) return;

    EasyLoading.show(status: '创建混箱中...');
    try {
      final mixedCarton =
          await createWarehouseReceiptMixedCarton(receiptId, values);
      if (!mounted) return;
      setState(() {
        _mixedCartons = [..._mixedCartons, mixedCarton];
        _isMixedCarton = true;
      });
      _selectMixedCarton(mixedCarton);
      EasyLoading.showSuccess('已创建 ${mixedCarton.code}');
    } catch (_) {
      EasyLoading.showError('创建混箱失败');
    }
  }

  void _set(String key, dynamic value) {
    if (value == null) return;
    _controllers[key]?.text = value.toString();
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    for (final f in _focusNodes.values) {
      f.dispose();
    }
    super.dispose();
  }

  void _focusNext(String current) {
    final idx = _fieldOrder.indexOf(current);
    if (idx < _fieldOrder.length - 1) {
      _focusNodes[_fieldOrder[idx + 1]]?.requestFocus();
    } else {
      _focusNodes[current]?.unfocus();
    }
  }

  void _applyVoiceResult(dynamic result) {
    if (result is! Map) return;
    final map = {
      'actualOuterLength': result['actual_outer_length'],
      'actualOuterWidth': result['actual_outer_width'],
      'actualOuterHeight': result['actual_outer_height'],
      'actualOuterGrossWeight': result['actual_outer_gross_weight'],
    }..removeWhere((_, v) => v == null || v.toString().isEmpty);
    if (map.isEmpty) return;
    for (final e in map.entries) {
      _controllers[e.key]?.text = e.value.toString();
    }
    setState(() => _voiceHadResult = true);
    EasyLoading.showSuccess('语音识别已填充');
  }

  num? _parseNum(String key) {
    final t = _controllers[key]?.text.trim() ?? '';
    if (t.isEmpty) return null;
    return num.tryParse(t);
  }

  int? _parseInt(String key) {
    final t = _controllers[key]?.text.trim() ?? '';
    if (t.isEmpty) return null;
    return int.tryParse(t);
  }

  Future<void> _submit() async {
    if (_submitting || _voiceProcessing || widget.item.id == null) return;
    if (_isMixedCarton && _selectedMixedCarton?.id == null) {
      EasyLoading.showError('请选择混箱');
      return;
    }

    // Editing an already-entered (已入库) record requires explicit confirmation.
    final pending = widget.pendingEntry;
    if (pending?.enteredAt != null) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('修改已入库记录'),
          content: const Text('该记录已入库,确定要修改吗?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('确定修改'),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }

    final data = <String, dynamic>{
      'mixed_carton_id': _isMixedCarton ? _selectedMixedCarton?.id : null,
      'actual_outer_capacity': _parseInt('actualOuterCapacity'),
      'location_id': _location?.id,
      if (!_isMixedCarton) ...{
        'actual_outer_length': _parseNum('actualOuterLength'),
        'actual_outer_width': _parseNum('actualOuterWidth'),
        'actual_outer_height': _parseNum('actualOuterHeight'),
        'actual_outer_gross_weight': _parseNum('actualOuterGrossWeight'),
        'actual_carton_qty': _parseInt('actualCartonQty'),
      },
    };
    data.removeWhere(
      (key, value) => value == null && key != 'mixed_carton_id',
    );

    setState(() => _submitting = true);
    EasyLoading.show(status: '保存中...');
    try {
      final saved = pending != null
          ? await updateWarehouseReceiptItemEntry(
              widget.item.id!, pending.id!, data)
          : await createWarehouseReceiptItemEntry(widget.item.id!, data);
      EasyLoading.showSuccess('保存成功');
      widget.onSaved(saved);
      // In create mode the card is reused (same `form-new` key) when the saved
      // entry is already complete, so its controllers must be cleared
      // explicitly to be ready for the next measurement.
      if (pending == null && mounted) {
        for (final c in _controllers.values) {
          c.clear();
        }
        setState(() {
          _location = saved.location;
          _isMixedCarton = false;
          _selectedMixedCarton = null;
          _voiceHadResult = false;
        });
      }
    } on FormatException {
      EasyLoading.showError('请输入有效的数字');
    } on DioException catch (error) {
      final responseData = error.response?.data;
      final serverMessage = responseData is Map
          ? responseData['message']?.toString().trim()
          : null;
      EasyLoading.showError(
        serverMessage?.isNotEmpty == true ? serverMessage! : '保存失败',
      );
    } catch (_) {
      EasyLoading.showError('保存失败');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pending = widget.pendingEntry;
    final String title;
    if (pending == null) {
      title = '测量数据';
    } else if (pending.enteredAt != null) {
      title = '编辑入库记录';
    } else {
      title = '补充箱数';
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                if (!_isMixedCarton)
                  VoiceRecordButton(
                    apiPath:
                        '/api/open/agents/warehouse/receipt-item-measurement-by-audio',
                    onProcessing: (processing) {
                      setState(() {
                        _voiceProcessing = processing;
                        if (processing) {
                          _voiceHadResult = false;
                          EasyLoading.show(status: '语音识别中...');
                        } else if (!_voiceHadResult) {
                          EasyLoading.dismiss();
                        }
                      });
                    },
                    onSuccess: _applyVoiceResult,
                  ),
              ],
            ),
            const SizedBox(height: 14),
            const Text('装箱方式',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('普通箱'),
                  selected: !_isMixedCarton,
                  onSelected: (_) => _setMixedCartonMode(false),
                ),
                ChoiceChip(
                  label: const Text('混箱'),
                  selected: _isMixedCarton,
                  onSelected: (_) => _setMixedCartonMode(true),
                ),
              ],
            ),
            if (_isMixedCarton) ...[
              const SizedBox(height: 12),
              if (_loadingMixedCartons)
                InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    isDense: true,
                  ),
                  child: const Row(
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 10),
                      Text('正在加载混箱…'),
                    ],
                  ),
                )
              else if (_mixedCartonsLoadFailed && _mixedCartons.isEmpty)
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: _loadMixedCartons,
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('混箱加载失败，点击重试'),
                  ),
                )
              else if (_mixedCartons.isEmpty)
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: _createMixedCarton,
                    child: const Row(
                      children: [
                        Icon(Icons.inventory_2_outlined, size: 18),
                        SizedBox(width: 8),
                        Text('暂无混箱，请先新建'),
                        Spacer(),
                        Icon(Icons.add, size: 18),
                        SizedBox(width: 4),
                        Text('新建混箱'),
                      ],
                    ),
                  ),
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: _mixedCartons.any(
                          (item) => item.id == _selectedMixedCarton?.id,
                        )
                            ? _selectedMixedCarton?.id
                            : null,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: '选择混箱',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          isDense: true,
                        ),
                        items: _mixedCartons
                            .where((mixedCarton) => mixedCarton.id != null)
                            .map(
                              (mixedCarton) => DropdownMenuItem<int>(
                                value: mixedCarton.id,
                                child: Text(_mixedCartonLabel(mixedCarton)),
                              ),
                            )
                            .toList(),
                        onChanged: (id) {
                          final mixedCarton = _mixedCartons
                              .where((item) => item.id == id)
                              .firstOrNull;
                          if (mixedCarton != null) {
                            _selectMixedCarton(mixedCarton);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: _createMixedCarton,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('新建'),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 8),
              Text(
                '混箱的长宽高和重量由混箱资料统一维护，货号装量仍可修改。',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _Field(
                    label: '外箱长',
                    unit: 'cm',
                    decimal: true,
                    controller: _controllers['actualOuterLength']!,
                    focusNode: _focusNodes['actualOuterLength']!,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => _focusNext('actualOuterLength'),
                    enabled: !_isMixedCarton,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _Field(
                    label: '外箱宽',
                    unit: 'cm',
                    decimal: true,
                    controller: _controllers['actualOuterWidth']!,
                    focusNode: _focusNodes['actualOuterWidth']!,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => _focusNext('actualOuterWidth'),
                    enabled: !_isMixedCarton,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _Field(
                    label: '外箱高',
                    unit: 'cm',
                    decimal: true,
                    controller: _controllers['actualOuterHeight']!,
                    focusNode: _focusNodes['actualOuterHeight']!,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => _focusNext('actualOuterHeight'),
                    enabled: !_isMixedCarton,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _Field(
                    label: '外箱重量',
                    unit: 'kg',
                    decimal: true,
                    controller: _controllers['actualOuterGrossWeight']!,
                    focusNode: _focusNodes['actualOuterGrossWeight']!,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => _focusNext('actualOuterGrossWeight'),
                    enabled: !_isMixedCarton,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _Field(
                    label: _isMixedCarton ? '该货号装量' : '外箱装量',
                    unit: '',
                    decimal: false,
                    controller: _controllers['actualOuterCapacity']!,
                    focusNode: _focusNodes['actualOuterCapacity']!,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => _focusNext('actualOuterCapacity'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _Field(
                    label: '箱数',
                    unit: '箱',
                    decimal: false,
                    controller: _controllers['actualCartonQty']!,
                    focusNode: _focusNodes['actualCartonQty']!,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) =>
                        _focusNodes['actualCartonQty']?.unfocus(),
                    enabled: !_isMixedCarton,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _LocationRow(
              location: _location,
              onPick: () async {
                final picked = await _showLocationPicker(context, _location);
                if (picked != null) setState(() => _location = picked);
              },
              onClear: _location != null
                  ? () => setState(() => _location = null)
                  : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (widget.onCancelEdit != null) ...[
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: (_submitting || _voiceProcessing)
                            ? null
                            : widget.onCancelEdit,
                        child: const Text('取消'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: FilledButton(
                      onPressed:
                          (_submitting || _voiceProcessing) ? null : _submit,
                      child: Text(_submitting ? '保存中...' : '保存'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Entries List (compact) ──────────────────────────────────────────────────

class _EntriesListCard extends StatelessWidget {
  final List<WarehouseReceiptItemEntry> entries;
  final int? editingEntryId;
  final void Function(WarehouseReceiptItemEntry entry) onEdit;
  final Future<void> Function(WarehouseReceiptItemEntry entry) onDelete;

  const _EntriesListCard({
    required this.entries,
    required this.editingEntryId,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('入库记录',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            for (var i = 0; i < entries.length; i++) ...[
              _EntryRow(
                index: i + 1,
                entry: entries[i],
                editing:
                    entries[i].id != null && entries[i].id == editingEntryId,
                onEdit: () => onEdit(entries[i]),
                onDelete: () => onDelete(entries[i]),
              ),
              if (i + 1 < entries.length) const Divider(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}

class _EntryRow extends StatelessWidget {
  final int index;
  final WarehouseReceiptItemEntry entry;
  final bool editing;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _EntryRow({
    required this.index,
    required this.entry,
    required this.editing,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isComplete = entry.enteredAt != null;
    final l = entry.actualOuterLength;
    final w = entry.actualOuterWidth;
    final h = entry.actualOuterHeight;
    final wt = entry.actualOuterGrossWeight;
    final qty = entry.actualCartonQty;
    final mixedCartonCode = entry.mixedCarton?.code;

    return InkWell(
      onTap: onEdit,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: editing ? const Color(0xFFF1F6FF) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('第 $index 条',
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 6),
                      _MiniStatusBadge(complete: isComplete),
                      if (mixedCartonCode != null) ...[
                        const SizedBox(width: 6),
                        Text(
                          '混箱 $mixedCartonCode',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF7B1FA2),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                      if (editing) ...[
                        const SizedBox(width: 6),
                        Text('编辑中',
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.blue[700],
                                fontWeight: FontWeight.w600)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (l != null && w != null && h != null)
                    Text('$l × $w × $h cm',
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey[600])),
                  if (wt != null)
                    Text('重量 $wt kg',
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (qty != null)
                  Text('$qty 箱',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                if (isComplete)
                  Text(
                    _fmt(entry.enteredAt),
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                  ),
                if (entry.location != null)
                  Text(
                    entry.location!.displayName,
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                  ),
              ],
            ),
            // Only pending (预入库) records can be deleted.
            if (!isComplete)
              GestureDetector(
                onTap: onDelete,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, top: 2),
                  child: Icon(Icons.delete_outline,
                      size: 20, color: Colors.grey[400]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MiniStatusBadge extends StatelessWidget {
  final bool complete;

  const _MiniStatusBadge({required this.complete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: complete ? const Color(0xFFE8F5E9) : const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        complete ? '已入库' : '预入库',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: complete ? const Color(0xFF2E7D32) : const Color(0xFF1565C0),
        ),
      ),
    );
  }
}

// ─── Original Specs ───────────────────────────────────────────────────────────

class _OriginalSpecsCard extends StatelessWidget {
  final WarehouseReceiptItem item;
  final bool expanded;
  final ValueChanged<bool> onChanged;

  const _OriginalSpecsCard({
    required this.item,
    required this.expanded,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        key: const PageStorageKey('warehouse-receipt-item-details'),
        initiallyExpanded: expanded,
        onExpansionChanged: onChanged,
        title: const Text('原始规格',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        subtitle: const Text('点击展开查看原始规格'),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          side: BorderSide.none,
        ),
        collapsedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          side: BorderSide.none,
        ),
        children: [
          const SizedBox(height: 4),
          _SpecsGrid(children: [
            _SpecItem(label: '内装箱量', value: _d(item.innerCapacity)),
            _SpecItem(label: '外箱装量', value: _d(item.outerCapacity)),
            _SpecItem(label: '箱数', value: _d(item.cartonQty)),
            _SpecItem(label: '外箱长', value: _d(item.outerLength, suffix: 'cm')),
            _SpecItem(label: '外箱宽', value: _d(item.outerWidth, suffix: 'cm')),
            _SpecItem(label: '外箱高', value: _d(item.outerHeight, suffix: 'cm')),
            _SpecItem(label: '外箱体积', value: _d(item.outerVolume, suffix: 'm³')),
            _SpecItem(
                label: '外箱毛重', value: _d(item.outerGrossWeight, suffix: 'kg')),
            _SpecItem(
                label: '外箱净重', value: _d(item.outerNetWeight, suffix: 'kg')),
          ]),
        ],
      ),
    );
  }
}

String _mixedCartonLabel(WarehouseReceiptMixedCarton mixedCarton) {
  final dimensions = [
    mixedCarton.actualOuterLength,
    mixedCarton.actualOuterWidth,
    mixedCarton.actualOuterHeight,
  ].map((value) => value?.toString() ?? '-').join('×');

  final weight = mixedCarton.actualOuterGrossWeight?.toString() ?? '-';
  return '${mixedCarton.code ?? '混箱'}  $dimensions cm / $weight kg';
}

Future<Map<String, dynamic>?> _showCreateMixedCartonDialog(
    BuildContext context) async {
  final formKey = GlobalKey<FormBuilderState>();

  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('新建混箱'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: FormBuilder(
            key: formKey,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _MixedCartonDialogField(
                  name: 'actual_outer_capacity',
                  label: '默认外箱装量（可选）',
                  decimal: false,
                  required: false,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 12),
                _MixedCartonDialogField(
                  name: 'actual_outer_length',
                  label: '外箱长（cm）',
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 12),
                _MixedCartonDialogField(
                  name: 'actual_outer_width',
                  label: '外箱宽（cm）',
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 12),
                _MixedCartonDialogField(
                  name: 'actual_outer_height',
                  label: '外箱高（cm）',
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 12),
                _MixedCartonDialogField(
                  name: 'actual_outer_gross_weight',
                  label: '外箱重量（kg）',
                  textInputAction: TextInputAction.done,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () {
            if (formKey.currentState?.saveAndValidate() != true) return;
            Navigator.of(dialogContext).pop(
              Map<String, dynamic>.from(formKey.currentState!.value)
                ..removeWhere((_, value) => value == null),
            );
          },
          child: const Text('创建'),
        ),
      ],
    ),
  );
}

class _MixedCartonDialogField extends StatelessWidget {
  final String name;
  final String label;
  final bool decimal;
  final bool required;
  final TextInputAction textInputAction;

  const _MixedCartonDialogField({
    required this.name,
    required this.label,
    required this.textInputAction,
    this.decimal = true,
    this.required = true,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: name,
      keyboardType: TextInputType.numberWithOptions(decimal: decimal),
      textInputAction: textInputAction,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          decimal ? RegExp(r'^\d*\.?\d*$') : RegExp(r'^\d*$'),
        ),
      ],
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        isDense: true,
      ),
      validator: (value) {
        final text = value?.trim() ?? '';
        if (!required && text.isEmpty) return null;
        final parsed = num.tryParse(text);
        if (parsed == null || parsed <= 0) return '请输入大于 0 的数字';
        return null;
      },
      valueTransformer: (value) {
        final text = value?.trim() ?? '';
        if (text.isEmpty) return null;
        return decimal ? num.parse(text) : int.parse(text);
      },
    );
  }
}

class _SpecsGrid extends StatelessWidget {
  final List<Widget> children;
  const _SpecsGrid({required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < children.length; i += 2) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: children[i]),
              const SizedBox(width: 12),
              Expanded(
                  child: i + 1 < children.length
                      ? children[i + 1]
                      : const SizedBox.shrink()),
            ],
          ),
          if (i + 2 < children.length) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _SpecItem extends StatelessWidget {
  final String label;
  final String value;
  const _SpecItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            const SizedBox(height: 4),
            Text(value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

// ─── Shared Widgets ───────────────────────────────────────────────────────────

class _Field extends StatelessWidget {
  final String label;
  final String unit;
  final bool decimal;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;

  const _Field({
    required this.label,
    required this.unit,
    required this.decimal,
    required this.controller,
    required this.focusNode,
    required this.textInputAction,
    this.onSubmitted,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: enabled,
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.numberWithOptions(decimal: decimal),
      textInputAction: textInputAction,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          decimal ? RegExp(r'^\d*\.?\d*$') : RegExp(r'^\d*$'),
        ),
      ],
      onTap: () => controller.selection =
          TextSelection(baseOffset: 0, extentOffset: controller.text.length),
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        labelText: label,
        suffixText: unit,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        isDense: true,
      ),
    );
  }
}

class _LocationRow extends StatelessWidget {
  final WarehouseLocation? location;
  final VoidCallback onPick;
  final VoidCallback? onClear;

  const _LocationRow({
    required this.location,
    required this.onPick,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPick,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFD0D5DD)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on_outlined,
                size: 18, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                location?.displayName ?? '选择库位（可选）',
                style: TextStyle(
                  fontSize: 14,
                  color: location != null ? Colors.black87 : Colors.grey[500],
                ),
              ),
            ),
            if (location != null && onClear != null)
              GestureDetector(
                onTap: onClear,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(Icons.clear, size: 18, color: Colors.grey[400]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Location Picker ─────────────────────────────────────────────────────────

Future<WarehouseLocation?> _showLocationPicker(
  BuildContext context,
  WarehouseLocation? current,
) {
  return showModalBottomSheet<WarehouseLocation>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) => _LocationPickerSheet(current: current),
  );
}

class _LocationPickerSheet extends StatefulWidget {
  final WarehouseLocation? current;
  const _LocationPickerSheet({this.current});

  @override
  State<_LocationPickerSheet> createState() => _LocationPickerSheetState();
}

class _LocationPickerSheetState extends State<_LocationPickerSheet> {
  List<WarehouseLocation>? _allLocations;
  bool _loading = true;
  String? _error;
  final _searchController = TextEditingController();
  String _search = '';

  @override
  void initState() {
    super.initState();
    _searchController
        .addListener(() => setState(() => _search = _searchController.text));
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final locs = await getAllWarehouseLocations();
      if (mounted) {
        setState(() {
          _allLocations = locs;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = '加载失败，请重试';
        });
      }
    }
  }

  List<WarehouseLocation> get _filtered {
    final all = _allLocations ?? [];
    final q = _search.trim().toLowerCase();
    if (q.isEmpty) return all;
    return all.where((l) => l.displayName.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (ctx, sc) => Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('选择库位',
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
                decoration: InputDecoration(
                  hintText: '搜索库位',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _search.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: _searchController.clear),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Divider(height: 1),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(child: Text(_error!))
                      : _filtered.isEmpty
                          ? Center(
                              child: Text(
                              _search.isEmpty ? '暂无库位' : '未找到相关库位',
                              style: TextStyle(color: Colors.grey[500]),
                            ))
                          : ListView.builder(
                              controller: sc,
                              itemCount: _filtered.length,
                              itemBuilder: (ctx, i) {
                                final loc = _filtered[i];
                                final sel = widget.current?.id == loc.id;
                                return ListTile(
                                  title: Text(loc.displayName),
                                  trailing: sel
                                      ? const Icon(Icons.check,
                                          color: Colors.green)
                                      : null,
                                  selected: sel,
                                  onTap: () => Navigator.of(context).pop(loc),
                                );
                              }),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Helpers ─────────────────────────────────────────────────────────────────

Future<bool?> _confirmDelete(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('删除入库记录'),
      content: const Text('确定要删除这条入库记录吗？此操作不可撤销。'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('删除'),
        ),
      ],
    ),
  );
}

String _fmt(DateTime? v) {
  if (v == null) return '--';
  return DateFormat('yyyy-MM-dd HH:mm').format(v);
}

/// Render a carton count without a trailing ".0" for whole numbers.
String _qtyText(num value) {
  return value == value.truncate()
      ? value.toInt().toString()
      : value.toString();
}

String _d(dynamic value, {String suffix = ''}) {
  if (value == null) return '--';
  final t = value.toString();
  if (t.isEmpty) return '--';
  return suffix.isEmpty ? t : '$t $suffix';
}
