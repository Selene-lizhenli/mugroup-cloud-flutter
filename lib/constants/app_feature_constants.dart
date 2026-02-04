/// 单个 feature 定义（id + 展示标题 + 权限 key），与后端 app_features、 permissions对应
class EntryFeature {
  final String id;
  final String title;

  /// 后端 permissions 中对应的权限字符串
  final String permissionKey;

  const EntryFeature(this.id, this.title, this.permissionKey);
}

/// 入口/仪表盘模块 feature，id 与 title 统一在此定义
class EntryFeatures {
  static const showroomSample =
      EntryFeature('showroom_sample', '样品间', 'showroom.sample.show');
  static const crmCompany =
      EntryFeature('crm_company', '客户', 'crm.company.show');
  static const supplySupplier =
      EntryFeature('supply_supplier', '供应商', 'supply.suppliers.show');
  static const ecommerceProductComparison =
      EntryFeature('ecommerce_product_comparison', '采购助手',
          'showroom.product_comparison.show');
  static const marketPurchase =
      EntryFeature('market_purchase', '市场带客', 'market_product.show');
  static const independentSite =
      EntryFeature('showroom_station', '独立站', 'showroom.station.show');
  static const inspection =
      EntryFeature('inspection', '验货', 'inspection.task.show');

  static const values = [
    showroomSample,
    crmCompany,
    supplySupplier,
    ecommerceProductComparison,
    marketPurchase,
    independentSite, 
    inspection,
  ];

  /// 按 id 查 title（兼容原有 entryFeatureTitles 用法）
  static final Map<String, String> titles = {
    for (var e in values) e.id: e.title
  };

  /// 按 id 查权限 key：EntryFeature.id -> permissionKey
  static final Map<String, String> permissionKeys = {
    for (var e in values) e.id: e.permissionKey,
  };
}
