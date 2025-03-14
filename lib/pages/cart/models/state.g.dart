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
  CartType.borrowOut: 'borrowOut',
  CartType.borrowIn: 'borrowIn',
  CartType.transferOut: 'transferOut',
  CartType.transferIn: 'transferIn',
  CartType.inout: 'inout',
  CartType.quotation: 'quotation',
};

_$CartItemImpl _$$CartItemImplFromJson(Map<String, dynamic> json) =>
    _$CartItemImpl(
      sample: Sample.fromJson(json['sample'] as Map<String, dynamic>),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$$CartItemImplToJson(_$CartItemImpl instance) =>
    <String, dynamic>{
      'sample': instance.sample,
      'count': instance.count,
    };

_$StateImpl _$$StateImplFromJson(Map<String, dynamic> json) => _$StateImpl(
      items: (json['items'] as List<dynamic>)
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      carts: (json['carts'] as List<dynamic>)
          .map((e) => CartSelect.fromJson(e as Map<String, dynamic>))
          .toList(),
      warehouse: json['warehouse'] == null
          ? null
          : Warehouse.fromJson(json['warehouse'] as Map<String, dynamic>),
      borrow: json['borrow'] == null
          ? null
          : Borrow.fromJson(json['borrow'] as Map<String, dynamic>),
      transfer: json['transfer'] == null
          ? null
          : Transfer.fromJson(json['transfer'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      type: $enumDecodeNullable(_$CartTypeEnumMap, json['type']),
      cartName: json['cartName'] as String?,
      selectedDate: (json['selectedDate'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$$StateImplToJson(_$StateImpl instance) =>
    <String, dynamic>{
      'items': instance.items,
      'carts': instance.carts,
      'warehouse': instance.warehouse,
      'borrow': instance.borrow,
      'transfer': instance.transfer,
      'user': instance.user,
      'type': _$CartTypeEnumMap[instance.type],
      'cartName': instance.cartName,
      'selectedDate': instance.selectedDate,
    };
