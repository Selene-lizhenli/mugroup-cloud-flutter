import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/quote/quote_supplier_group.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';

class QuoteListSupplierCard extends StatelessWidget {
  final QuoteSupplierGroup supplier;
  final double totalAmount;
  final bool isSelected;
  final VoidCallback onToggle;
  final VoidCallback? onTap;
  final int? productId;

  const QuoteListSupplierCard({
    super.key,
    required this.supplier,
    required this.totalAmount,
    required this.isSelected,
    required this.onToggle,
    this.onTap,
    this.productId,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    // 获取供应商标识
    final supplierNo = supplier.supplier?.supplierNo ?? '';
    final shortName = supplier.supplier?.shortName ?? '';
    final supplierName = supplier.supplier?.name ?? '';
    final supplierDisplay = supplierNo.isNotEmpty
        ? supplierNo
        : (shortName.isNotEmpty ? shortName : supplierName);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
        decoration: BoxDecoration(
          color: colorScheme.outlineVariant.withOpacity(0.32),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: colorScheme.outlineVariant.withOpacity(0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Checkbox(
                    value: isSelected,
                    onChanged: (_) => onToggle(),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    side: BorderSide(
                      color: colorScheme.outlineVariant,
                      width: 1.5,
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        supplierDisplay,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 13,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 4),
                      if (supplierName.isNotEmpty)
                        Expanded(
                          child: Text(
                            supplierName,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 12,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: _InfoColumn(
                    label: '产品种类',
                    value: '${supplier.count ?? 0}',
                  ),
                ),
                Expanded(
                  child: _InfoColumn(
                    label: '总采购量',
                    value: '${supplier.qty ?? 0}',
                  ),
                ),
                Expanded(
                  child: _InfoColumn(
                    label: '总金额(EUR)',
                    value: totalAmount.toStringAsFixed(2),
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

class _InfoColumn extends StatelessWidget {
  final String label;
  final String value;

  const _InfoColumn({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 12,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
