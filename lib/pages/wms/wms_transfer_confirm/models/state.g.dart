// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransferConfirmItemImpl _$$TransferConfirmItemImplFromJson(
        Map<String, dynamic> json) =>
    _$TransferConfirmItemImpl(
      id: (json['id'] as num?)?.toInt(),
      product: Sample.fromJson(json['product'] as Map<String, dynamic>),
      inQty: (json['in_qty'] as num?)?.toInt(),
      outQty: (json['out_qty'] as num?)?.toInt(),
      count: (json['count'] as num).toInt(),
      checked: json['checked'] as bool?,
    );

Map<String, dynamic> _$$TransferConfirmItemImplToJson(
        _$TransferConfirmItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product': instance.product,
      'in_qty': instance.inQty,
      'out_qty': instance.outQty,
      'count': instance.count,
      'checked': instance.checked,
    };

_$StateImpl _$$StateImplFromJson(Map<String, dynamic> json) => _$StateImpl(
      items: (json['items'] as List<dynamic>)
          .map((e) => TransferConfirmItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$StateImplToJson(_$StateImpl instance) =>
    <String, dynamic>{
      'items': instance.items,
    };
