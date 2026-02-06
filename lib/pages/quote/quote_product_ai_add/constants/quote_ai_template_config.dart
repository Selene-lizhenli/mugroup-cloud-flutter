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
  static const spec = ColumnConfig('spec', '尺寸', width: 90);
  static const weight = ColumnConfig('weight', '重量(g)', width: 60);
  static const packaging = ColumnConfig('packing', '包装方式', width: 70);
  static const unit = ColumnConfig('unit', '单位', width: 50);
  static const volume = ColumnConfig('outer_volume', '体积', width: 60);
  static const moq = ColumnConfig('moq', '起订量', width: 60);
  static const description = ColumnConfig('description_cn', '描述', width: 120);

  static const List<ColumnConfig> all = [
    productNo,
    purchaseCost,
    outCapacity,
    innerCapacity,
    spec,
    weight,
    packaging,
    unit,
    volume,
    moq,
    description
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
    name: '模板1',
    previewImageUrl: 'assets/aiTemplets/floor_001.jpg',
    columns: [
      AppColumns.productNo,
      AppColumns.purchaseCost,
      AppColumns.outCapacity,
      AppColumns.innerCapacity,
      AppColumns.volume,
      AppColumns.packaging,
      AppColumns.description,
    ],
  ),
  TemplateOption(
    id: '002',
    name: '模板2',
    previewImageUrl: 'assets/aiTemplets/floor_002.jpg',
    columns: [
      AppColumns.productNo,
      AppColumns.purchaseCost,
      AppColumns.outCapacity,
      AppColumns.volume,
      AppColumns.packaging,
      AppColumns.description,
    ],
  ),
];

const List<TemplateOption> kQuoteAiNotePadTemplates = [
  TemplateOption(
    id: '001',
    name: '模板1',
    previewImageUrl: 'assets/aiTemplets/notepad_001.jpg',
    columns: [
      AppColumns.productNo,
      AppColumns.purchaseCost,
      AppColumns.outCapacity,
      AppColumns.volume,
      AppColumns.description,
    ],
  ),
];
String get kDefaultTemplateId => kQuoteAiTemplates.first.id;

String get kDefaultNotePadTemplateId => kQuoteAiNotePadTemplates.first.id;

TemplateOption getTemplateById(String id) {
  return kQuoteAiTemplates.firstWhere((t) => t.id == id,
      orElse: () => kQuoteAiTemplates.first);
}
