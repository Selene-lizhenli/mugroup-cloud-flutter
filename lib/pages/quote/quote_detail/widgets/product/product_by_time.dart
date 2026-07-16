import 'package:auto_route/auto_route.dart';
import 'package:cloud/constants/theme_config.dart';
import 'package:cloud/models/sample/quotation_sample.dart';
import 'package:cloud/models/supply/supplier.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/action_pill_button.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/product/products_with_supplie_card.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/sheet/new_supplier.dart';
import 'package:cloud/pages/widgets/empty.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:cloud/pages/quote/quote_detail/providers/quote_detail_provider.dart';

class _SupplierSectionEntry {
  const _SupplierSectionEntry({
    required this.supplierKey,
    required this.supplierId,
    required this.supplier,
    required this.products,
  });

  final int supplierKey;
  final int? supplierId;
  final Supplier? supplier;
  final List<QuotationSample> products;
}

class _TimePeriodSection {
  const _TimePeriodSection({
    required this.key,
    required this.label,
    required this.products,
    required this.suppliers,
  });

  final String key;
  final String label;
  final List<QuotationSample> products;
  final List<_SupplierSectionEntry> suppliers;

  int get supplierCount => suppliers.length;
  int get productCount => products.length;
}

String _productTimePeriodKey(QuotationSample product) {
  final createdAt = DateTime.tryParse(product.createdAt ?? '');
  if (createdAt == null) return 'unknown';
  final y = createdAt.year;
  final m = createdAt.month.toString().padLeft(2, '0');
  final d = createdAt.day.toString().padLeft(2, '0');
  // 0=上午(<12点), 1=下午(>=12点)，用于排序
  final period = createdAt.hour < 12 ? '0' : '1';
  return '$y-$m-$d-$period';
}

String _formatTimePeriodLabel(String key) {
  if (key == 'unknown') return '未知日期';
  final parts = key.split('-');
  if (parts.length != 4) return key;
  final date = '${parts[0]}-${parts[1]}-${parts[2]}';
  final period = parts[3] == '0' ? '上午' : '下午';
  return '$date $period';
}

List<_TimePeriodSection> _buildTimePeriodSections(
    List<QuotationSample> products) {
  final productsByPeriod = <String, List<QuotationSample>>{};
  for (final product in products) {
    productsByPeriod
        .putIfAbsent(_productTimePeriodKey(product), () => [])
        .add(product);
  }

  final periodKeys = productsByPeriod.keys.toList()
    ..sort((a, b) {
      if (a == 'unknown') return 1;
      if (b == 'unknown') return -1;
      return b.compareTo(a);
    });

  return periodKeys.map((key) {
    final periodProducts = productsByPeriod[key]!;
    final supplierGroup = _groupProductsBySupplier(periodProducts);
    final suppliers = [
      for (final supplierKey in supplierGroup.supplierOrder)
        _SupplierSectionEntry(
          supplierKey: supplierKey,
          supplierId: supplierKey > 0 ? supplierKey : null,
          supplier: supplierKey > 0 ? supplierGroup.supplierInfo[supplierKey] : null,
          products: supplierGroup.grouped[supplierKey] ?? const [],
        ),
    ];
    return _TimePeriodSection(
      key: key,
      label: _formatTimePeriodLabel(key),
      products: periodProducts,
      suppliers: suppliers,
    );
  }).toList(growable: false);
}

({
  Map<int, List<QuotationSample>> grouped,
  List<int> supplierOrder,
  Map<int, Supplier?> supplierInfo,
}) _groupProductsBySupplier(List<QuotationSample> products) {
  final Map<int, List<QuotationSample>> grouped = {};
  final List<int> supplierOrder = [];
  final Map<int, Supplier?> supplierInfo = {};
  int unknownKeySeed = -1;

  for (final p in products) {
    final id = p.supplyQuote?.supplierId;
    final key = id ?? (unknownKeySeed--);

    grouped.putIfAbsent(key, () {
      supplierOrder.add(key);
      return <QuotationSample>[];
    }).add(p);

    if (id != null) {
      final supplier = p.supplyQuote?.supplier;
      if (supplier != null) {
        supplierInfo[id] = supplier;
      }
    }
  }

  return (
    grouped: grouped,
    supplierOrder: supplierOrder,
    supplierInfo: supplierInfo,
  );
}

String _supplierLabel(Supplier? supplier) {
  final shortName = supplier?.shortName;
  final name = supplier?.name;
  if (shortName != null && shortName.isNotEmpty) return shortName;
  if (name != null && name.isNotEmpty) return name;
  return '未知供应商';
}

void _openSupplierProducts(
  BuildContext context, {
  required int? quoteId,
  required int? supplierId,
  required Supplier? supplier,
}) {
  if (quoteId == null || supplierId == null) return;
  context.router.push(
    SupplierProductsRoute(
      quotationId: quoteId,
      supplierId: supplierId,
      supplierNo: supplier?.supplierNo ?? '',
      supplierName: supplier?.name ?? '',
    ),
  );
}

// 折叠后的 供应商卡片
class _CollapsedSupplierChip extends StatelessWidget {
  final Supplier? supplier;
  final int? supplierId;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final VoidCallback? onTap;

  const _CollapsedSupplierChip({
    required this.supplier,
    required this.supplierId,
    required this.colorScheme,
    required this.textTheme,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 68,
        height: 68,
        decoration: BoxDecoration(
          color: colorScheme.outline.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.35),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            child: Text(
              _supplierLabel(supplier),
              style: textTheme.bodySmall?.copyWith(
                fontSize: 12,
                color: colorScheme.onSurface,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

// 折叠后的 供应商列表
class _CollapsedSupplierList extends StatelessWidget {
  final List<_SupplierSectionEntry> suppliers;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final int? quoteId;

  const _CollapsedSupplierList({
    required this.suppliers,
    required this.colorScheme,
    required this.textTheme,
    this.quoteId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < suppliers.length; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                _CollapsedSupplierChip(
                  supplier: suppliers[i].supplier,
                  supplierId: suppliers[i].supplierId,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                  onTap: () => _openSupplierProducts(
                    context,
                    quoteId: quoteId,
                    supplierId: suppliers[i].supplierId,
                    supplier: suppliers[i].supplier,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// 时间轴 圆点
class _TimelineDot extends StatelessWidget {
  final ColorScheme colorScheme;
  final bool? isFirst;
  final bool? isLast;

  const _TimelineDot({
    this.isFirst,
    this.isLast,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    if (isLast == true) {
      return Container(
        width: 10,
        height: 10,
        margin: const EdgeInsets.fromLTRB(0, 4, 0, 0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorScheme.primary.withOpacity(0.88),
        ),
      );
    }

    double size = 15.0;
    double borderWidth = 5;
    Color color = colorScheme.primary;

    if (isFirst == true) {
      size = 25.0;
      borderWidth = 3;
    }

    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.all(2),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScheme.surface,
        border: Border.all(
            color: color, width: borderWidth, style: BorderStyle.solid),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}

// 时间轴 竖线
class _DayTimelineRail extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final ColorScheme colorScheme;

  const _DayTimelineRail({
    required this.isFirst,
    required this.isLast,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      child: Column(
        children: [
          _TimelineDot(isFirst: isFirst, colorScheme: colorScheme),
          Expanded(
            child: Center(
              child: Container(
                // color: timelinePurpleColor.withOpacity(0.25),
                color: colorScheme.primary,
                width: 1,
              ),
            ),
          ),
          if (isLast) _TimelineDot(isLast: true, colorScheme: colorScheme),
        ],
      ),
    );
  }
}

class _TimePeriodSectionTile extends StatelessWidget {
  final _TimePeriodSection section;
  final int index;
  final int totalCount;
  final bool isExpanded;
  final ColorScheme colorScheme;
  final ThemeData theme;
  final int? quoteId;
  final VoidCallback onToggle;

  const _TimePeriodSectionTile({
    required this.section,
    required this.index,
    required this.totalCount,
    required this.isExpanded,
    required this.colorScheme,
    required this.theme,
    required this.quoteId,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isFirst = index == 0;
    final isLast = index == totalCount - 1;

    return Container(
      padding: EdgeInsets.only(
        top: isFirst ? 0 : 4,
        bottom: isLast ? 0 : 4,
        left: 2,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DayTimelineRail(
              isFirst: isFirst,
              isLast: isLast,
              colorScheme: colorScheme,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(6, 2, 5, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 4),
                        Text(
                          section.label,
                          style: theme.textTheme.titleSmall?.copyWith(),
                        ),
                        const Spacer(),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: onToggle,
                          child: Row(
                            children: [
                              const SizedBox(width: 20),
                              if (isExpanded) ...[
                                Text(
                                  '   收起',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.outline,
                                    fontSize: 13,
                                  ),
                                ),
                                AnimatedRotation(
                                  turns: 0.5,
                                  duration: const Duration(milliseconds: 200),
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: colorScheme.outline,
                                    size: 22,
                                  ),
                                ),
                              ] else
                                Text(
                                  '  展开 >  ',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.outline,
                                    fontSize: 13,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isExpanded)
                    _ExpandedSupplierSection(
                      section: section,
                      colorScheme: colorScheme,
                      theme: theme,
                      quoteId: quoteId,
                    )
                  else
                    _CollapsedSupplierSection(
                      section: section,
                      colorScheme: colorScheme,
                      theme: theme,
                      quoteId: quoteId,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpandedSupplierSection extends StatelessWidget {
  final _TimePeriodSection section;
  final ColorScheme colorScheme;
  final ThemeData theme;
  final int? quoteId;

  const _ExpandedSupplierSection({
    required this.section,
    required this.colorScheme,
    required this.theme,
    required this.quoteId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.fromLTRB(12, 6, 0, 0),
          decoration: BoxDecoration(
            color: colorScheme.outline.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              for (var i = 0; i < section.suppliers.length; i++) ...[
                SupplierWithProductsCard(
                  supplier: section.suppliers[i].supplier,
                  supplierId: section.suppliers[i].supplierId,
                  products: section.suppliers[i].products,
                  supplierIndex: i + 1,
                  colorScheme: colorScheme,
                  theme: theme,
                  quoteId: quoteId,
                  onSupplierTap: () => _openSupplierProducts(
                    context,
                    quoteId: quoteId,
                    supplierId: section.suppliers[i].supplierId,
                    supplier: section.suppliers[i].supplier,
                  ),
                ),
                if (i < section.suppliers.length - 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(
                      height: 1,
                      color: colorScheme.outlineVariant.withOpacity(0.6),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _CollapsedSupplierSection extends StatelessWidget {
  final _TimePeriodSection section;
  final ColorScheme colorScheme;
  final ThemeData theme;
  final int? quoteId;

  const _CollapsedSupplierSection({
    required this.section,
    required this.colorScheme,
    required this.theme,
    required this.quoteId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: colorScheme.outline.withOpacity(0.1),
      ),
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      padding: const EdgeInsets.fromLTRB(3, 10, 10, 15),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 14, 0),
            child: Row(
              children: [
                Icon(
                  Icons.bar_chart,
                  size: 18,
                  color: accentPurpleDeepColor.withOpacity(0.5),
                ),
                const SizedBox(width: 5),
                Text.rich(
                  TextSpan(
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                    children: [
                      const TextSpan(text: '共计 '),
                      TextSpan(
                        text: '${section.supplierCount}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: accentPurpleDeepColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const TextSpan(text: ' 个供应商，'),
                      TextSpan(
                        text: '${section.productCount}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: accentPurpleDeepColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const TextSpan(text: ' 个产品'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _CollapsedSupplierList(
            suppliers: section.suppliers,
            colorScheme: colorScheme,
            textTheme: theme.textTheme,
            quoteId: quoteId,
          ),
        ],
      ),
    );
  }
}


//  主组件Class
class ProductSectionByTime extends HookConsumerWidget {
  final int? quoteId;
  const ProductSectionByTime({super.key, this.quoteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quoteDetailProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final sections = useMemoized(
      () => _buildTimePeriodSections(state.products),
      [state.products],
    );
    final expandedPeriods = useState<Map<String, bool>>({});

    return Container(
        padding: const EdgeInsets.fromLTRB(10, 12, 12, 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: colorScheme.surface,
        ),
        child: SizedBox(
          child: Column(children: [
            // ===== 标题头部  操作按钮=====
            Container(
                padding: const EdgeInsets.fromLTRB(4, 0, 0, 10),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.format_list_bulleted,
                        color: colorScheme.primary, size: 24),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        '产品列表',
                        style: TextStyle(
                          fontSize: 16,
                          // fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(6),
                      onTap: () {
                        context.router.push(
                          ProductBatchImportRoute(
                            quotationId: quoteId,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          border: Border.all(
                              color: colorScheme.outline.withOpacity(0.3),
                              width: 1),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.download_outlined,
                                size: 17, color: colorScheme.outline),
                            const SizedBox(width: 4),
                            Text(
                              '导入',
                              style: TextStyle(
                                fontSize: 14,
                                color: colorScheme.outline,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ActionPillButton(
                      label: '供应商',
                      icon: Icons.add,
                      backgroundColor: colorScheme.primary,
                      textColor: colorScheme.onPrimary,
                      vertical: 4,
                      fontSize: 14,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          constraints: BoxConstraints(
                            maxWidth:
                                MediaQuery.of(context).size.width, // 底部抽屉宽度占满屏幕
                          ),
                          builder: (context) =>
                              AddSupplierSheet(quotationId: quoteId!),
                        );
                      },
                    ),
                  ],
                )),

            Divider(
              height: 1,
              color: colorScheme.outlineVariant.withOpacity(0.6),
            ),
            const SizedBox(height: 12),
            if (state.isProductLoading) ...[
              const SizedBox(
                height: 200,
                child: Center(
                  child: MuProgressIndicator(
                    showText: true,
                  ),
                ),
              ),
            ] else if (state.products.isEmpty) ...[
              Empty(
                // icon: Icons.search,
                padding: 100,
                textSpans: [
                  WidgetSpan(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '暂无产品，',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.outline,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              useSafeArea: true,
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context)
                                    .size
                                    .width, // 底部抽屉宽度占满屏幕
                              ),
                              builder: (context) =>
                                  AddSupplierSheet(quotationId: quoteId),
                            );
                          },
                          child: Text(
                            '去添加供应商？',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ] else ...[
              // 时间轴 + 供应商卡片及产品列表
              Column(
                children: [
                  const SizedBox(height: 2),
                  for (var d = 0; d < sections.length; d++)
                    _TimePeriodSectionTile(
                      section: sections[d],
                      index: d,
                      totalCount: sections.length,
                      isExpanded: expandedPeriods.value[sections[d].key] ??
                          (d == 0 || d == 1),
                      colorScheme: colorScheme,
                      theme: theme,
                      quoteId: quoteId,
                      onToggle: () {
                        final key = sections[d].key;
                        final expanded =
                            expandedPeriods.value[key] ?? (d == 0 || d == 1);
                        expandedPeriods.value = {
                          ...expandedPeriods.value,
                          key: !expanded,
                        };
                      },
                    ),
                ],
              ),
              const SizedBox(height: 50),
            ],
          ]),
        ));
  }
}
