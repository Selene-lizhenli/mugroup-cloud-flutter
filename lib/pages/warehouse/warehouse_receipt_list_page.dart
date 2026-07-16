import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/warehouse/warehouse_receipt.dart';
import 'package:cloud/pages/warehouse/warehouse_receipt_detail_page.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/services/warehouse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cloud/constants/theme_config.dart';

@RoutePage()
class WarehouseReceiptListPage extends HookConsumerWidget {
  const WarehouseReceiptListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final search = useState(searchController.text);
    final reloadKey = useState(0);
    final paddingTop = MediaQuery.of(context).padding.top; //刘海屏高度
    final colorScheme = Theme.of(context).colorScheme;

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
        () => getWarehouseReceipts(
          queryParameters: search.value.trim().isEmpty
              ? null
              : {'search': search.value.trim()},
        ),
        [search.value, reloadKey.value],
      ),
    );

    Future<void> reload() async {
      reloadKey.value++;
    }

    final isLoading =
        receiptSnapshot.connectionState == ConnectionState.waiting;
    final response = receiptSnapshot.data;
    final receipts = response?.data ?? const <WarehouseReceipt>[];

    Widget content;
    if (receiptSnapshot.hasError) {
      content = Center(child: Text('加载失败: ${receiptSnapshot.error}'));
    } else if (response == null && isLoading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (receipts.isEmpty) {
      content = const Center(child: Text('暂无入库单'));
    } else {
      content = RefreshIndicator(
        onRefresh: reload,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
          itemCount: receipts.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final receipt = receipts[index];
            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: _ReceiptCard(receipt: receipt),
              ),
            );
          },
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color.fromARGB(255, 35, 35, 35),
        title: const Text('入库单'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, // 起点：右上角
                  end: Alignment.bottomCenter, // 终点：左下角
                  colors: [
                    Color.lerp(
                      colorScheme.primary,
                      colorScheme.surface,
                      0.65,
                    )!,
                    colorScheme.surface,
                    colorScheme.surface,
                    colorScheme.surface,
                  ],
                  stops: const [0.0, 0.25, 0.32, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topRight,
              child: Image.asset(
                'assets/element/warehouse_receive.png',
                fit: BoxFit.contain,
                width: 220,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: paddingTop + appbarHeight,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
               
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            hintText: '搜索订单号 / 供应商',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            isDense: true,
                          ),
                          onSubmitted: (value) => search.value = value,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isLoading == true)
                  const SizedBox(
                    height: 200,
                    child: Center(
                      child:
                          MuProgressIndicator(showText: true, text: '加载中...'),
                    ),
                  )
                else if (response == null)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        '暂无数据',
                        style: TextStyle(
                          color: colorScheme.surfaceContainerHighest,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                else
                  Expanded(child: content),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptCard extends StatelessWidget {
  final WarehouseReceipt receipt;

  const _ReceiptCard({required this.receipt});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final metaItems = [
      _ReceiptMetaItem(label: '外销员', value: receipt.seller?.name),
      _ReceiptMetaItem(label: '采购员', value: receipt.purchaser?.name),
      _ReceiptMetaItem(label: '跟单员', value: receipt.merchandiser?.name),
    ].where((e) => e.value != null && e.value!.trim().isNotEmpty).toList();
    final footerItems = [
      _ReceiptMetaItem(label: '部门', value: receipt.department?.name),
      _ReceiptMetaItem(label: '出运日期', value: _formatDate(receipt.shippedAt)),
    ].where((e) => e.value != null && e.value!.trim().isNotEmpty).toList();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      margin: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: colorScheme.primary.withOpacity(0.01),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              offset: const Offset(0, 0),
              blurRadius: 12,
            ),
          ],
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: receipt.id == null
              ? null
              : () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => WarehouseReceiptDetailPage(
                        receiptId: receipt.id!,
                        initialOrderNo: receipt.orderNo,
                      ),
                    ),
                  );
                },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 13, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        receipt.orderNo?.isNotEmpty == true
                            ? receipt.orderNo!
                            : '未填写订单号',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (receipt.supplierShortName?.trim().isNotEmpty ==
                        true) ...[
                      const SizedBox(width: 10),
                      _SupplierBadge(name: receipt.supplierShortName!.trim()),
                    ],
                  ],
                ),
                if (metaItems.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  _ReceiptMetaGrid(items: metaItems),
                ],
                if (footerItems.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  for (var i = 0; i < footerItems.length; i++) ...[
                    _ReceiptSingleLine(item: footerItems[i]),
                    if (i + 1 < footerItems.length) const SizedBox(height: 6),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SupplierBadge extends StatelessWidget {
  final String name;

  const _SupplierBadge({required this.name});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Container(
      constraints: const BoxConstraints(maxWidth: 160),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

String? _formatDate(DateTime? value) {
  if (value == null) return null;
  return DateFormat('yyyy-MM-dd').format(value);
}

class _ReceiptMetaItem {
  final String label;
  final String? value;

  const _ReceiptMetaItem({
    required this.label,
    required this.value,
  });
}

class _ReceiptMetaGrid extends StatelessWidget {
  final List<_ReceiptMetaItem> items;

  const _ReceiptMetaGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < items.length; i += 2) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _ReceiptMetaLine(item: items[i])),
              const SizedBox(width: 12),
              Expanded(
                child: i + 1 < items.length
                    ? _ReceiptMetaLine(item: items[i + 1])
                    : const SizedBox.shrink(),
              ),
            ],
          ),
          if (i + 2 < items.length) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _ReceiptMetaLine extends StatelessWidget {
  final _ReceiptMetaItem item;

  const _ReceiptMetaLine({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 52,
          child: Text(
            item.label,
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            item.value ?? '--',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

class _ReceiptSingleLine extends StatelessWidget {
  final _ReceiptMetaItem item;

  const _ReceiptSingleLine({required this.item});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style.copyWith(
              fontSize: 13,
              color: Colors.grey[700],
            ),
        children: [
          TextSpan(
            text: '${item.label} ',
            style: TextStyle(color: Colors.grey[600]),
          ),
          TextSpan(
            text: item.value ?? '--',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
