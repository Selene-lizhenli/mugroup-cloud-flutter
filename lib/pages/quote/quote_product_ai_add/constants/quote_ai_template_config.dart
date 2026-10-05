class ColumnConfig {
  final String key;
  final String label;
  final double width;
  const ColumnConfig(this.key, this.label, {this.width = 80.0});
}

class AppColumns {
  static const productNo = ColumnConfig('product_no', '货号', width: 80);
  static const purchaseCost = ColumnConfig('purchase_cost', '供应商报价', width: 80);
  static const outCapacity = ColumnConfig('outer_capacity', '外装箱量', width: 70);
  static const innerCapacity =
      ColumnConfig('inner_capacity', '内装箱量', width: 70);
  static const spec = ColumnConfig('spec', '产品规格', width: 90);
  static const weight = ColumnConfig('product_weight', '重量(g)', width: 60);
  static const packing = ColumnConfig('packing', '包装方式', width: 70);
  static const unit = ColumnConfig('unit', '单位', width: 50);
  static const volume = ColumnConfig('outer_volume', '体积', width: 60);
  static const moq = ColumnConfig('moq', '起订量', width: 60);
  static const description = ColumnConfig('description_cn', '描述', width: 120);
  static const remark = ColumnConfig('remark', '备注', width: 120);
  static const customerPrice =
      ColumnConfig('customer_price', '客户报价', width: 120);
  static const material = ColumnConfig('material', '产品材质', width: 120);
  static const color = ColumnConfig('color', '产品颜色', width: 120);

  static const List<ColumnConfig> all = [
    productNo,
    purchaseCost,
    outCapacity,
    innerCapacity,
    spec,
    weight,
    packing,
    unit,
    volume,
    moq,
    description,
    remark,
    customerPrice,
    material,
    color
  ];
}

class TemplateOption {
  final String id;
  final String name;
  final String previewImageUrl;
  final String iconUrl;
  final List<ColumnConfig> columns;

  const TemplateOption({
    required this.id,
    required this.name,
    required this.previewImageUrl,
    this.iconUrl = '',
    required this.columns,
  });
}

const List<TemplateOption> kQuoteAiTemplates = [
  TemplateOption(
    id: '001',
    name: '通用模板',
    previewImageUrl: 'assets/aiTemplets/floor_001.jpg',
    columns: [
      AppColumns.productNo,
      AppColumns.purchaseCost,
      AppColumns.outCapacity,
      AppColumns.innerCapacity,
      AppColumns.spec,
      AppColumns.packing,
      AppColumns.unit,
      AppColumns.volume,
      AppColumns.moq,
      AppColumns.description,
      AppColumns.weight,
      AppColumns.customerPrice,
      AppColumns.material,
      AppColumns.color,
      AppColumns.remark,
    ],
  ),
];

const List<TemplateOption> kQuoteAiNotePadTemplates = [
  TemplateOption(
    id: '001',
    name: '通用模板',
    previewImageUrl: 'assets/aiTemplets/notepad_001.jpg',
    columns: [
      AppColumns.productNo,
      AppColumns.purchaseCost,
      AppColumns.outCapacity,
      AppColumns.innerCapacity,
      AppColumns.spec,
      AppColumns.packing,
      AppColumns.unit,
      AppColumns.volume,
      AppColumns.moq,
      AppColumns.description,
      AppColumns.weight,
      AppColumns.customerPrice,
      AppColumns.material,
      AppColumns.color,
      AppColumns.remark,
    ],
  ),
];
String get kDefaultTemplateId => kQuoteAiTemplates.first.id;

String get kDefaultNotePadTemplateId => kQuoteAiNotePadTemplates.first.id;

TemplateOption getTemplateById(String id) {
  return kQuoteAiTemplates.firstWhere((t) => t.id == id,
      orElse: () => kQuoteAiTemplates.first);
}

TemplateOption getTemplateNotePadById(String id) {
  return kQuoteAiNotePadTemplates.firstWhere((t) => t.id == id,
      orElse: () => kQuoteAiNotePadTemplates.first);
}
