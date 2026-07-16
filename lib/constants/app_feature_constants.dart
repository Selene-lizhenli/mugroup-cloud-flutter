/// 单个 feature 定义（id + 权限 key），与后端 app_features、 permissions对应

class EntryFeature {
  final String id;

  /// 后端 permissions 中对应的权限字符串

  final String permissionKey;

  const EntryFeature(this.id, this.permissionKey);
}

/// 入口/仪表盘模块 feature，id 与权限 key 统一在此定义

class EntryFeatures {
  static const showroomSample =
      EntryFeature('showroom_sample', 'showroom.sample.show');

  static const crmCompany = EntryFeature('crm_company', 'crm.company.show');

  static const supplySupplier =
      EntryFeature('supply_supplier', 'supply.suppliers.show');

  static const ecommerceProductComparison = EntryFeature(
      'ecommerce_product_comparison', 'showroom.product_comparison.show');

  static const marketPurchase =
      EntryFeature('market_purchase', 'showroom.market_product.show');

  static const independentWebsite =
      EntryFeature('showroom_station', 'showroom.station.show');

  static const inspection = EntryFeature('inspection', 'inspection.task.show');

  static const adviceCollect = EntryFeature('advice_collect', 'advice.collect');

  static const changxiangInventory =
      EntryFeature('changxiang_inventory', 'changxiang.inventory.show');

  static const warehouseReceipts =
      EntryFeature('warehouse_receipts', 'warehouse.receipt.show');

  static const values = [
    showroomSample,
    crmCompany,
    supplySupplier,
    ecommerceProductComparison,
    marketPurchase,
    independentWebsite,
    inspection,
    changxiangInventory,
    warehouseReceipts,
  ];

  /// 按 id 查权限 key：EntryFeature.id -> permissionKey

  static final Map<String, String> permissionKeys = {
    for (var e in values) e.id: e.permissionKey,
  };
}
