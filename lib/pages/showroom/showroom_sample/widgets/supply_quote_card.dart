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

            // 外箱容量
            if (quote.outerCapacity != null) ...[
              Text(
                '外箱容量: ${quote.outerCapacity!}',
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
            ],

            // 外箱体积
            if (quote.outerVolume != null) ...[
              Text(
                '外箱体积: ${quote.outerVolume!}',
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
            ],

            // 发货时间
            if (quote.chuhuoAt != null) ...[
              Text(
                '发货时间: ${quote.chuhuoAt!.toLocal().toString()}',
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

            const SizedBox(height: 8),

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
