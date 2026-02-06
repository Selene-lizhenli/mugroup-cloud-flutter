import 'package:cloud/models/field_config.dart';

final List<FieldConfig> sampleDefaultFields = [
  const FieldConfig(label: '产品货号', name: 'product_no', isVisible: true),
  const FieldConfig(label: '价格', name: 'purchase_cost', isVisible: true),
  const FieldConfig(label: '中文名称', name: 'name_cn', isVisible: true),
  const FieldConfig(label: '英文名称', name: 'name_en', isVisible: true),
  const FieldConfig(label: '单位', name: 'unit', isVisible: true),
  const FieldConfig(label: '包装方式', name: 'packing', isVisible: true),
  const FieldConfig(label: '系列', name: 'series', isVisible: true),
  const FieldConfig(label: '尺寸', name: 'spec', isVisible: true),
  const FieldConfig(label: '中文描述', name: 'description_cn', isVisible: true),
  const FieldConfig(label: '英文描述', name: 'description_en', isVisible: true),
];

final List<FieldConfig> quoteSampleDefaultFields = [
  const FieldConfig(label: '产品货号', name: 'product_no', isVisible: true),
  const FieldConfig(label: '品牌', name: 'product_brand', isVisible: true),
  const FieldConfig(label: '供应商货号', name: 'supplier_sku', isVisible: true),
  const FieldConfig(label: '客户货号', name: 'customer_sku', isVisible: true),
  const FieldConfig(label: '供应商报价', name: 'purchase_cost', isVisible: true),
  const FieldConfig(label: '发货天数', name: 'deliver_day', isVisible: true),
  const FieldConfig(label: '供应商MOQ', name: 'supplier_moq', isVisible: true),
  const FieldConfig(label: '客户报价', name: 'customer_price', isVisible: true),
  const FieldConfig(label: '客户采购数量', name: 'customer_qty', isVisible: true),
  const FieldConfig(label: '单位', name: 'unit', isVisible: true),
  const FieldConfig(label: '中文名称', name: 'name_cn', isVisible: true),
  const FieldConfig(label: '英文名称', name: 'name_en', isVisible: true),
  const FieldConfig(label: '材质', name: 'material', isVisible: true),
  const FieldConfig(label: '内箱数量', name: 'inner_capacity', isVisible: true),
  const FieldConfig(label: '重量', name: 'weight', isVisible: true),
  const FieldConfig(label: '包装方式', name: 'packing', isVisible: true),
  const FieldConfig(label: '外箱数量', name: 'outer_capacity', isVisible: true),
  const FieldConfig(label: '体积', name: 'outer_volume', isVisible: true),
  const FieldConfig(label: '尺寸', name: 'spec', isVisible: true),
  const FieldConfig(label: '中文描述', name: 'description_cn', isVisible: true),
  const FieldConfig(label: '英文描述', name: 'description_en', isVisible: true),
];

final List<FieldConfig> inspectionDefaultFields = [
  const FieldConfig(label: '正唛', name: 'shipping_mark_front', isVisible: true),
  const FieldConfig(label: '侧唛', name: 'shipping_mark_side', isVisible: true),
  const FieldConfig(label: '开箱', name: 'unboxing', isVisible: true),
  const FieldConfig(label: '条码标签', name: 'barcode_label', isVisible: true),
  const FieldConfig(label: '产品重量', name: 'weight_proof', isVisible: true),
  const FieldConfig(label: '产品主图', name: 'cover', isVisible: true),
];

final List<FieldConfig> quoteAIFloorDefaultFields = [
  const FieldConfig(label: '产品货号', name: 'product_no', isVisible: true),
  const FieldConfig(label: '供应商报价', name: 'purchase_cost', isVisible: true),
  const FieldConfig(label: '客户货号', name: 'customer_sku', isVisible: true),
  const FieldConfig(label: '重量', name: 'weight', isVisible: true),
  const FieldConfig(label: '单位', name: 'unit', isVisible: true),
  const FieldConfig(label: '材质', name: 'material', isVisible: true),
  const FieldConfig(label: '内箱数量', name: 'inner_capacity', isVisible: true),
  const FieldConfig(label: '外箱数量', name: 'outer_capacity', isVisible: true),
  const FieldConfig(label: '体积', name: 'outer_volume', isVisible: true),
  const FieldConfig(label: '容积', name: '??', isVisible: true),
  const FieldConfig(label: '尺寸', name: 'spec', isVisible: true),
  const FieldConfig(label: '颜色', name: 'color', isVisible: true),
  const FieldConfig(label: '品牌', name: 'product_brand', isVisible: true),
  const FieldConfig(label: '包装方式', name: 'packing', isVisible: true),
  const FieldConfig(label: '客户采购数量', name: 'customer_qty', isVisible: true),
  const FieldConfig(label: '中文描述', name: 'description_cn', isVisible: true),
  const FieldConfig(label: '备注', name: 'remark', isVisible: true),
];
