import 'package:auto_route/auto_route.dart';
import 'package:cloud/app/app.dart';
import 'package:cloud/constants/app_feature_constants.dart';
import 'package:cloud/constants/theme_config.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/pages/widgets/empty.dart';
import 'package:cloud/providers/app_provider.dart';
import 'package:cloud/providers/core_provider.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/pages/widgets/theme_icon.dart';
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

  static List<_EntryConfig> _buildEntryConfigs() {
    return [
      _EntryConfig(
        id: EntryFeatures.showroomSample.id,
        label: EntryFeatures.showroomSample.title,
        iconAsset: 'warehouse',
        iconSize: 35,
        route: const SamplesListRoute(),
      ),
      _EntryConfig(
        id: EntryFeatures.marketPurchase.id,
        label: EntryFeatures.marketPurchase.title,
        iconAsset: 'market',
        iconSize: 25,
        route: const QuoteRoute(),
      ),
      _EntryConfig(
        id: EntryFeatures.crmCompany.id,
        label: EntryFeatures.crmCompany.title,
        iconAsset: 'customer',
        iconSize: 25,
        route: const CrmCompanyRoute(),
      ),
      _EntryConfig(
        id: EntryFeatures.supplySupplier.id,
        label: EntryFeatures.supplySupplier.title,
        iconAsset: 'factory',
        iconSize: 40,
        route: const SupplySupplierRoute(),
      ),
      _EntryConfig(
        id: EntryFeatures.inspection.id,
        label: EntryFeatures.inspection.title,
        iconAsset: 'insp',
        iconSize: 30,
        route: const InspectionRoute(),
      ),
      _EntryConfig(
        id: EntryFeatures.independentWebsite.id,
        label: EntryFeatures.independentWebsite.title,
        iconAsset: 'computer',
        iconSize: 27,
        route: const SingleStationRoute(),
      ),
      _EntryConfig(
        id: EntryFeatures.ecommerceProductComparison.id,
        label: EntryFeatures.ecommerceProductComparison.title,
        iconAsset: 'cart',
        iconSize: 26,
        route: const PurchaseAssistRoute(),
      ),
      // _EntryConfig(
      //   id: EntryFeatures.changxiangInventory.id,
      //   label: EntryFeatures.changxiangInventory.title,
      //   iconAsset: 'whs_mag',
      //   iconSize: 24,
      //   route: const ChangexiangInventoryRoute(),
      // ),
    ];
  }

  static List<_EntryConfig> openedEntry = [
    _EntryConfig(
      id: EntryFeatures.adviceCollect.id,
      label: EntryFeatures.adviceCollect.title,
      iconAsset: 'xinyuan_list',
      iconSize: 25,
      route: const AdviceCollectRoute(),
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final core = app.container.read(coreProvider).value;
    final tenant = core?.currentTenant;
    logger.d(tenant);
    final colorScheme = Theme.of(context).colorScheme;
    const int crossAxisCount = 5;
    const double spacing = 6.0;
    // 读取「应用入口权限布尔表」：EntryFeatures.xxx.id -> bool
    final permissionBools = ref.watch(entryFeaturePermissionBoolsProvider);

    // 所有入口配置
    final allEntries = _buildEntryConfigs();

    // 只保留当前有权限的入口
    final visibleEntries =
        allEntries.where((e) => permissionBools[e.id] ?? false).toList();

    // 留言板模块 自由云链才有
    if (tenant?.id == 6) {
      visibleEntries.addAll(openedEntry);
    }

    if (visibleEntries.isEmpty) {
      return Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
            child: Empty(
          text: '暂无可用模块',
          height: 28,
        )),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.93),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        boxShadow: const [
          BoxShadow(
            color: pageShadowColor,
            blurRadius: 10,
            offset: Offset(0, 0), // 上下左右均匀阴影
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double itemWidth =
              ((constraints.maxWidth - ((crossAxisCount - 1) * spacing)) /
                      crossAxisCount)
                  .floorToDouble();

          return SizedBox(
            width: constraints.maxWidth,
            child: Wrap(
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
            ),
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
            try {
              context.router.push(route);
            } catch (e) {
              logger.e('点击入口失败: ${route.runtimeType}', error: e);
            }
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: 40,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.038),
                  borderRadius: BorderRadius.circular(80),
                ),
                child: MuThemeIcon(
                  iconType: icon,
                  iconSize: iconSize,
                )),
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
