// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SampleImpl _$$SampleImplFromJson(Map<String, dynamic> json) => _$SampleImpl(
      id: (json['id'] as num?)?.toInt(),
      nameCn: json['name_cn'] as String?,
      productNo: json['product_no'] as String?,
      purchaseCost: json['purchase_cost'] as String?,
      image: (json['image'] as List<dynamic>?)
          ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SampleImplToJson(_$SampleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name_cn': instance.nameCn,
      'product_no': instance.productNo,
      'purchase_cost': instance.purchaseCost,
      'image': instance.image,
    };
