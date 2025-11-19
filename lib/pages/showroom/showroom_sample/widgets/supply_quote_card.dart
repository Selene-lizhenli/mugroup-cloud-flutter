import 'package:cloud/models/supply/quote.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SupplyQuoteCard extends HookConsumerWidget {
  final Quote quote;
  const SupplyQuoteCard({
    super.key,
    required this.quote,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 供应商名称
            if (quote.supplier?.name != null) ...[
              Text(
                '供应商: ${quote.supplier?.name}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
                maxLines: 2, // 限制最多一行
                overflow: TextOverflow.ellipsis, // 超出一行时显示省略号
              ),
              const SizedBox(height: 8),
            ],

            // 包装
            if (quote.packing != null) ...[
              Text(
                '包装: ${quote.packing!}',
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
            ],

            // 样品位置
            if (quote.sampleLocation != null) ...[
              Text(
                '样品位置: ${quote.sampleLocation!}',
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
            ],

            // 税率
            if (quote.taxRate != null) ...[
              Text(
                '税率: ${quote.taxRate!}',
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
            ],

            // 采购成本
            if (quote.purchaseCost != null) ...[
              Text(
                '采购成本: ¥${quote.purchaseCost!}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}
