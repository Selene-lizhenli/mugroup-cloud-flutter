/// 单个 feature 定义（id + 展示标题），与后端 app_features 对应
class EntryFeature {
  final String id;
  final String title;
  const EntryFeature(this.id, this.title);
}

/// 入口/仪表盘模块 feature，id 与 title 统一在此定义
class EntryFeatures {
  static const showroomSample = EntryFeature('showroom_sample', '样品间');
  static const crmCompany = EntryFeature('crm_company', '客户');
  static const supplySupplier = EntryFeature('supply_supplier', '供应商');
  static const ecommerceProductComparison =
      EntryFeature('ecommerce_product_comparison', '采购助手');
  static const marketPurchase = EntryFeature('market_purchase', '市场带客');
  static const independentSite = EntryFeature('showroom_station', '独立站'); 
  static const inspection = EntryFeature('inspection', '验货');

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
}
