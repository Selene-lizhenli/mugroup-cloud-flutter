import 'package:auto_route/auto_route.dart';
import 'package:cloud/constants/app_feature_constants.dart';
import 'package:cloud/pages/widgets/empty.dart';
import 'package:cloud/providers/app_provider.dart';
import 'package:cloud/providers/theme_provider.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 单个入口配置
class _EntryConfig {
  final String id;
  final String label;
  final String iconAsset;
  final double iconSize;
  final dynamic route;

  const _EntryConfig({
    required this.id,
    required this.label,
    required this.iconAsset,
    this.iconSize = 28,
    this.route,
  });
}

class EntryGridModule extends ConsumerWidget {
  const EntryGridModule({super.key});

  static List<_EntryConfig> _buildEntryConfigs(bool isPinkTheme) {
    final theme = isPinkTheme ? 'pink' : 'blue';
    return [
      _EntryConfig(
        id: EntryFeatures.showroomSample.id,
        label: EntryFeatures.showroomSample.title,
        iconAsset: 'assets/mu/warehouse_$theme.png',
        iconSize: 35,
        route: const SamplesListRoute(),
      ),
      _EntryConfig(
        id: EntryFeatures.marketPurchase.id,
        label: EntryFeatures.marketPurchase.title,
        iconAsset: 'assets/mu/market_$theme.png',
        iconSize: 38,
        route: const QuoteRoute(),
      ),
      _EntryConfig(
        id: EntryFeatures.crmCompany.id,
        label: EntryFeatures.crmCompany.title,
        iconAsset: 'assets/mu/customer_$theme.png',
        iconSize: 24,
        route: const CrmCompanyRoute(),
      ),
      _EntryConfig(
        id: EntryFeatures.supplySupplier.id,
        label: EntryFeatures.supplySupplier.title,
        iconAsset: 'assets/mu/factory_$theme.png',
        iconSize: 40,
        route: const SupplySupplierRoute(),
      ),
      _EntryConfig(
        id: EntryFeatures.inspection.id,
        label: EntryFeatures.inspection.title,
        iconAsset: 'assets/mu/insp_$theme.png',
        iconSize: 26,
        route: const InspectionRoute(),
      ),
      // _EntryConfig(
      //   featureKey: EntryFeatures.ecommerceProductComparison.id,
      //   label: EntryFeatures.ecommerceProductComparison.title,
      //   iconAsset: 'assets/mu/cart_$theme.png',
      //   iconSize: 30,
      //   route: const InspectionRoute(),
      // ),
      // _EntryConfig(
      //   id: EntryFeatures.independentWebsite.id,
      //   label: EntryFeatures.independentWebsite.title,
      //   iconAsset: 'assets/mu/station_$theme.png',
      //   iconSize: 25,
      //   route: const InspectionRoute(), 
      // ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    const int crossAxisCount = 5;
    const double spacing = 6.0;
    final themeType = ref.watch(appThemeProvider);
    final isPinkTheme = themeType == ThemeType.pink;

    // 读取「应用入口权限布尔表」：EntryFeatures.xxx.id -> bool
    final permissionBools = ref.watch(entryFeaturePermissionBoolsProvider);

    // 所有入口配置
    final allEntries = _buildEntryConfigs(isPinkTheme);

    // 只保留当前有权限的入口
    final visibleEntries = allEntries
        .where((e) => permissionBools[e.id] ?? false)
        .toList();

    if (visibleEntries.isEmpty) {
      return Container(
        padding: const EdgeInsets.fromLTRB(12, 18, 12, 12),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
            child: Empty(
          text: '暂无模块',
          height: 24,
        )),
      );
    }

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
            alignment: WrapAlignment.start,
            children: visibleEntries
                .map(
                  (config) => _EntryItem(
                    width: itemWidth,
                    iconSize: config.iconSize,
                    icon: config.iconAsset,
                    label: config.label,
                    route: config.route,
                    color: colorScheme.primary,
                  ),
                )
                .toList(),
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
                color: color.withOpacity(0.038),
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
