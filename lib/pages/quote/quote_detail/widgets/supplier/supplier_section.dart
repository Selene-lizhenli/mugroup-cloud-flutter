import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/quote/quote_supplier_group.dart';
import 'package:cloud/pages/quote/quote_detail/providers/quote_detail_provider.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SupplierSection extends ConsumerWidget {
  final int? quoteId;
  const SupplierSection({super.key, this.quoteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quoteDetailProvider);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      color: colorScheme.surface,
      padding: const EdgeInsets.fromLTRB(14, 3, 14, 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== 标题 =====
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Text('相关服务商',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 14,
                )),
          ),
          const Divider(height: 1),
          // ===== 内容区 =====
          Builder(
            builder: (_) {
              // loading
              if (state.isSupplierLoading) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: MuProgressIndicator()),
                );
              }

              // error
              if (state.supplierError != null) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    '供应商加载失败',
                    style: TextStyle(color: colorScheme.error),
                  ),
                );
              }

              final list = state.suppliers;

              // empty
              if (list.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      '暂无供应商数据',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 12,
                        color: colorScheme.surfaceContainerHighest,
                      ),
                    ),
                  ),
                );
              }

              // ===== 平铺列表 =====
              return Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    for (final item in list) ...[
                      _SupplierCard(
                        item: item,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SupplierCard extends StatelessWidget {
  final QuoteSupplierGroup? item;
  const _SupplierCard({this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.secondary.withOpacity(0.04),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 名称
          Text(
            item?.supplier?.name ?? '未知供应商',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 11,
            ),
          ),

          const SizedBox(height: 6),

          // 开票信息
          Row(
            children: [
              _TagText(
                label: '总数量',
                value: item?.qty.toString() ?? '-',
              ),
              const SizedBox(width: 12),
              _TagText(
                label: '种类',
                value: item?.count.toString() ?? '-',
              ),
              const SizedBox(width: 12),
              _TagText(
                label: '是否能开票',
                value: item?.supplier?.canBill == true ? '是' : '否',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TagText extends StatelessWidget {
  final String label;
  final String value;
  const _TagText({
    required this.label,
    required this.value,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
      text: TextSpan(
        style: theme.textTheme.bodySmall,
        children: [
          TextSpan(
            text: '$label：',
            style: TextStyle(
              fontSize: 9,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              fontSize: 9,
              color: colorScheme.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
