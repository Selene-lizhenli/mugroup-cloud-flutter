// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SampleImpl _$$SampleImplFromJson(Map<String, dynamic> json) => _$SampleImpl(
      id: (json['id'] as num?)?.toInt(),
      barcode: json['barcode'] as String?,
      nameCn: json['name_cn'] as String?,
      productNo: json['product_no'] as String?,
      purchaseCost: json['purchase_cost'] as String?,
      pageNo: json['page_no'] as String?,
      spec: json['spec'] as String?,
      category: json['category'] == null
          ? null
          : SampleCategory.fromJson(json['category'] as Map<String, dynamic>),
      image: (json['image'] as List<dynamic>?)
          ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SampleImplToJson(_$SampleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'barcode': instance.barcode,
      'name_cn': instance.nameCn,
      'product_no': instance.productNo,
      'purchase_cost': instance.purchaseCost,
      'page_no': instance.pageNo,
      'spec': instance.spec,
      'category': instance.category,
      'image': instance.image,
    };

_$SampleCategoryImpl _$$SampleCategoryImplFromJson(Map<String, dynamic> json) =>
    _$SampleCategoryImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$$SampleCategoryImplToJson(
        _$SampleCategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
