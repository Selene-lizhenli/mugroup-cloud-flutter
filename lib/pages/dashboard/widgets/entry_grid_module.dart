import 'package:auto_route/auto_route.dart';
import 'package:cloud/providers/theme_provider.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EntryGridModule extends ConsumerWidget {
  const EntryGridModule({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    const int crossAxisCount = 5;
    const double spacing = 6.0;
    final themeType = ref.watch(appThemeProvider);
    final isPinkTheme = themeType == ThemeType.pink ? true : false;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 18, 12, 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double itemWidth =
              ((constraints.maxWidth - ((crossAxisCount - 1) * spacing)) /
                      crossAxisCount)
                  .floorToDouble();

          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            alignment: WrapAlignment.center,
            children: [
              _EntryItem(
                width: itemWidth,
                iconSize: 35,
                icon:
                    'assets/mu/warehouse_${isPinkTheme ? "pink" : "blue"}.png',
                label: '样品间',
                route: const SamplesListRoute(),
                color: colorScheme.primary,
              ),
              _EntryItem(
                width: itemWidth,
                icon:
                    'assets/mu/warehouse_${isPinkTheme ? "pink" : "blue"}.png',
                label: '市场带客',
                route: const QuoteRoute(),
                color: colorScheme.primary,
              ),
              _EntryItem(
                width: itemWidth,
                icon: 'assets/mu/cust_${isPinkTheme ? "pink" : "blue"}.png',
                label: '客户',
                iconSize: 26,
                route: const CrmCompanyRoute(),
                color: colorScheme.primary,
              ),
              _EntryItem(
                width: itemWidth,
                iconSize: 35,
                icon: 'assets/mu/factory_${isPinkTheme ? "pink" : "blue"}.png',
                label: '供应商',
                route: const SupplySupplierRoute(),
                color: colorScheme.primary,
              ),
              _EntryItem(
                width: itemWidth,
                iconSize: 31,
                icon: 'assets/mu/insp_${isPinkTheme ? "pink" : "blue"}.png',
                label: '验货',
                route: const InspectionRoute(),
                color: colorScheme.primary,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EntryItem extends StatelessWidget {
  final String icon;
  final String label;
  final Color color;
  final dynamic route;
  final double width;
  final double? iconSize;

  const _EntryItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.width,
    this.iconSize = 28,
    this.route,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: () {
          if (route != null) {
            context.router.push(route);
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.031),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(
                icon,
                width: iconSize,
                fit: BoxFit.contain,
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
