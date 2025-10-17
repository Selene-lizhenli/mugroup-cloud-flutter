// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CartSelectImpl _$$CartSelectImplFromJson(Map<String, dynamic> json) =>
    _$CartSelectImpl(
      $enumDecode(_$CartTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$$CartSelectImplToJson(_$CartSelectImpl instance) =>
    <String, dynamic>{
      'type': _$CartTypeEnumMap[instance.type]!,
    };

const _$CartTypeEnumMap = {
  CartType.stockIn: 'stockIn',
  CartType.borrowOut: 'borrowOut',
  CartType.borrowIn: 'borrowIn',
  CartType.transferOut: 'transferOut',
  CartType.transferIn: 'transferIn',
  CartType.inout: 'inout',
  CartType.quotation: 'quotation',
  CartType.deliveryOut: 'deliveryOut',
};

_$QuotationInfoImpl _$$QuotationInfoImplFromJson(Map<String, dynamic> json) =>
    _$QuotationInfoImpl(
      json['showPrice'] as bool?,
      json['curreny'] as String?,
      (json['exchange'] as num?)?.toDouble(),
      (json['commissionRate'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$QuotationInfoImplToJson(_$QuotationInfoImpl instance) =>
    <String, dynamic>{
      'showPrice': instance.showPrice,
      'curreny': instance.curreny,
      'exchange': instance.exchange,
      'commissionRate': instance.commissionRate,
    };

_$CartItemImpl _$$CartItemImplFromJson(Map<String, dynamic> json) =>
    _$CartItemImpl(
      sample: Sample.fromJson(json['sample'] as Map<String, dynamic>),
      count: (json['count'] as num).toInt(),
      price: json['price'] as String?,
    );

Map<String, dynamic> _$$CartItemImplToJson(_$CartItemImpl instance) =>
    <String, dynamic>{
      'sample': instance.sample,
      'count': instance.count,
      'price': instance.price,
    };

_$StateImpl _$$StateImplFromJson(Map<String, dynamic> json) => _$StateImpl(
      items: (json['items'] as List<dynamic>)
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      carts: (json['carts'] as List<dynamic>)
          .map((e) => CartSelect.fromJson(e as Map<String, dynamic>))
          .toList(),
      stockInOption: json['stockInOption'] as String?,
      warehouse: json['warehouse'] == null
          ? null
          : Warehouse.fromJson(json['warehouse'] as Map<String, dynamic>),
      borrow: json['borrow'] == null
          ? null
          : Borrow.fromJson(json['borrow'] as Map<String, dynamic>),
      transfer: json['transfer'] == null
          ? null
          : Transfer.fromJson(json['transfer'] as Map<String, dynamic>),
      delivery: json['delivery'] == null
          ? null
          : Delivery.fromJson(json['delivery'] as Map<String, dynamic>),
      type: $enumDecodeNullable(_$CartTypeEnumMap, json['type']),
      cartName: json['cartName'] as String?,
      quotationInfo: json['quotationInfo'] == null
          ? null
          : QuotationInfo.fromJson(
              json['quotationInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$StateImplToJson(_$StateImpl instance) =>
    <String, dynamic>{
      'items': instance.items,
      'carts': instance.carts,
      'stockInOption': instance.stockInOption,
      'warehouse': instance.warehouse,
      'borrow': instance.borrow,
      'transfer': instance.transfer,
      'delivery': instance.delivery,
      'type': _$CartTypeEnumMap[instance.type],
      'cartName': instance.cartName,
      'quotationInfo': instance.quotationInfo,
    };
