import 'package:cloud/models/crm/company.dart';
import 'package:cloud/models/quote/quotation_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

class BaseInfoSection extends ConsumerWidget {
  final QuotationList? item;

  const BaseInfoSection({super.key, this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final Company? company = item?.company;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _InfoItem(
                    label: '外销员',
                    value: item?.user?.name ?? '-',
                  ),
                ),
                Expanded(
                  child: _InfoItem(
                    value: item?.quoteAt ?? '-',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _InfoItem(
                    label: '报价币种',
                    value: item?.curreny ?? 'CNY',
                  ),
                ),
                Expanded(
                  child: _InfoItem(
                    label: '汇率',
                    value: item?.exchange?.toString() ?? '-',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: _InfoItem(
                  label: '客户',
                  value: company?.name ?? '-',
                ),
              ),
            ])
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.year}-${_two(date.month)}-${_two(date.day)}';
  }

  String _two(int n) => n.toString().padLeft(2, '0');
}

class _InfoItem extends StatelessWidget {
  final String? label;
  final String value;
  final String? type;

  const _InfoItem({
    this.label,
    required this.value,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final Cont = type == "ver" ? Column : Row;
    if (type == "ver") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Text(
              label!,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.surfaceContainerHighest,
              ),
            ),
          const SizedBox(height: 4),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Text(
              label!,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.surfaceContainerHighest,
              ),
            ),
          if (label != null) const SizedBox(width: 6),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }
  }
}
