// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuoteImpl _$$QuoteImplFromJson(Map<String, dynamic> json) => _$QuoteImpl(
      (json['id'] as num?)?.toInt(),
      (json['moq'] as num?)?.toInt(),
      json['supplier'] == null
          ? null
          : Supplier.fromJson(json['supplier'] as Map<String, dynamic>),
      json['packing'] as String?,
      json['material'] as String?,
      json['color'] as String?,
      json['remark'] as String?,
      (json['supplier_id'] as num?)?.toInt(),
      json['outer_capacity'] as String?,
      json['inner_capacity'] as String?,
      json['outer_volume'] as String?,
      json['outer_gross_weight'] as String?,
      json['chuhuo_at'] == null
          ? null
          : DateTime.parse(json['chuhuo_at'] as String),
      json['sample_location'] as String?,
      json['record_user'] as String?,
      json['can_bill'] as bool?,
      json['tax_rate'] as String?,
      json['product_weight'] as String?,
      json['purchase_cost'] as String?,
      json['currency'] as String?,
      json['supplier_product_no'] as String?,
      (json['shipping_qty'] as num?)?.toInt(),
      json['customer_price'] as String?,
      json['supplier_price'] as String?,
      json['internal_sku'] as String?,
      json['supplier_sku'] as String?,
      json['customer_sku'] as String?,
    );

Map<String, dynamic> _$$QuoteImplToJson(_$QuoteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'moq': instance.moq,
      'supplier': instance.supplier,
      'packing': instance.packing,
      'material': instance.material,
      'color': instance.color,
      'remark': instance.remark,
      'supplier_id': instance.supplierId,
      'outer_capacity': instance.outerCapacity,
      'inner_capacity': instance.innerCapacity,
      'outer_volume': instance.outerVolume,
      'outer_gross_weight': instance.outerGrossWeight,
      'chuhuo_at': instance.chuhuoAt?.toIso8601String(),
      'sample_location': instance.sampleLocation,
      'record_user': instance.recordUser,
      'can_bill': instance.canBill,
      'tax_rate': instance.taxRate,
      'product_weight': instance.productWeight,
      'purchase_cost': instance.purchaseCost,
      'currency': instance.currency,
      'supplier_product_no': instance.supplierProductNo,
      'shipping_qty': instance.shippingQty,
      'customer_price': instance.customerPrice,
      'supplier_price': instance.supplierPrice,
      'internal_sku': instance.internalSku,
      'supplier_sku': instance.supplierSku,
      'customer_sku': instance.customerSku,
    };
