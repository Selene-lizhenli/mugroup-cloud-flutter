import 'package:cloud/constants/app_feature_constants.dart';
import 'package:cloud/pages/dashboard/widgets/exchange/exchange_chart_main.dart';
import 'package:cloud/pages/dashboard/widgets/showroom/sample_room.main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 仪表盘统计模块的基础定义（id + 标题 + 内容 + 分组）
class ModuleInfo {
  final String id;
  final String title;
  final Widget Function() contentBuilder;
  final String group;
  bool selected; // 是否是用户选中（可变）
  bool visible; // 是否可展示（权限，可变）

  ModuleInfo({
    required this.id,
    required this.title,
    required this.contentBuilder,
    required this.group,
    required this.selected,
    required this.visible,
  });
}

/// 仪表盘可用模块集合 & 选中模块读取逻辑
class DashboardModules {
  static const String storageKey = 'selected_module_ids';
  static const String orderKey = 'module_order_ids';

  /// 所有可用模块的静态配置（在这里统一维护）
  ///
  /// [permissionBools]：EntryFeatures.xxx.id -> bool，用于计算 visible。
  /// [selectedIds]：从本地读取的已选模块 id，用于计算 selected。
  static List<ModuleInfo> getAllModulesByAuth({
    Map<String, bool>? permissionBools,
    List<String>? localSelectedIds,
  }) {
    final selected = localSelectedIds ?? const <String>[];

    return [
      ModuleInfo(
        id: EntryFeatures.showroomSample.id,
        title: EntryFeatures.showroomSample.id,
        contentBuilder: () => const SampleRoomChart(),
        group: '数据统计',
        selected: selected.contains(EntryFeatures.showroomSample.id),
        visible: permissionBools?[EntryFeatures.showroomSample.id] ?? false,
      ),
      // ModuleInfo(
      //   id: EntryFeatures.inspection.id,
      //   title: EntryFeatures.inspection.title,
      //   contentBuilder: () => const InspectionChart(),
      //   group: '数据统计',
      // ),
      // ModuleInfo(
      //   id: 'market_purchase',
      //   title: '市场带客',
      //   contentBuilder: () => const MarketPurchaseChart(),
      //   group: '数据统计',
      // ),
      // ModuleInfo(
      //   id: EntryFeatures.crmCompany.id,
      //   title: EntryFeatures.crmCompany.title,
      //   contentBuilder: () => const CustomerChart(),
      //   group: '数据统计',
      // ),
      // ModuleInfo(
      //   id: EntryFeatures.supplySupplier.id,
      //   title: EntryFeatures.supplySupplier.title,
      //   contentBuilder: () => const SupplierChart(),
      //   group: '数据统计',
      // ),
      // ModuleInfo(
      //   id: 'news',
      //   title: '集团资讯',
      //   contentBuilder: () => const NewsBoard(),
      //   group: '应用',
      // ),
      ModuleInfo(
        id: 'rate',
        title: 'rate',
        contentBuilder: () => const LineChartDemo(),
        group: '应用',
        selected: selected.contains('rate'),
        visible: true,
      ),
    ];
  }

  /// 拍好序的、有权限的所有模块
  static Future<List<ModuleInfo>> getOrderedModules(
      Map<String, bool>? permissionBools,
      {bool isSelected = false}) async {

    // app初始化时默认展示模块：公开模块 （rate） + 有权限的应用
    final initAppDefaultModules = <String>['rate'];
    if (permissionBools != null) {
      for (final e in permissionBools.entries) {
        if (e.value == true) {
          initAppDefaultModules.add(e.key);
        }
      }
    }
    // app初始化时，storageKeyList orderKeyList的值是null，
    // 用户设置选中0个模块时，storageKeyList orderKeyList的值是 list empty
    final prefs = await SharedPreferences.getInstance();
    final storageKeyList = prefs.getStringList(storageKey);
    final storageOrderKeyList = prefs.getStringList(orderKey);
    final localSelectedIds = storageKeyList ?? initAppDefaultModules;
    final orderIds = storageOrderKeyList ?? initAppDefaultModules;

    if (isSelected && localSelectedIds.isEmpty) {
      //只返回选中的情况：本地没有。就直接返回空吧~~
      return [];
    }

    final allModules = getAllModulesByAuth(
      permissionBools: permissionBools,
      localSelectedIds: localSelectedIds,
    );

    // 根据 isSelected 决定过滤条件
    final bool Function(ModuleInfo) condition = isSelected
        ? (module) => module.selected && module.visible
        : (module) => module.visible;

    final selectedModules = allModules.where(condition).toList();

    // 如果存在排序顺序，按照保存的顺序排列
    if (orderIds.isNotEmpty) {
      return _orderModulesByIds(selectedModules, orderIds);
    } else {
      // 没有排序信息时，直接返回过滤后的顺序
      return selectedModules;
    }
  }

  /// 根据 orderIds 的顺序对模块进行排序，并补充不在 orderIds 中的模块（按原顺序追加）
  /// 仅在类内部使用，不对外暴露。
  static List<ModuleInfo> _orderModulesByIds(
    List<ModuleInfo> modules,
    List<String> orderIds,
  ) {
    final moduleMap = {for (var m in modules) m.id: m};
    final orderedModules = <ModuleInfo>[];

    // 先按照排序顺序添加已选中的模块
    for (final id in orderIds) {
      final module = moduleMap[id];
      if (module != null) {
        orderedModules.add(module);
      }
    }

    // 再补充那些不在 orderIds 里的模块（兼容新加模块）
    for (final module in modules) {
      if (!orderIds.contains(module.id)) {
        orderedModules.add(module);
      }
    }

    return orderedModules;
  }
}
