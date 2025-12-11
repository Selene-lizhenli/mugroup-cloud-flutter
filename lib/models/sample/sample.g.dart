// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SampleImpl _$$SampleImplFromJson(Map<String, dynamic> json) => _$SampleImpl(
      id: (json['id'] as num?)?.toInt(),
      barcode: json['barcode'] as String?,
      packing: json['packing'] as String?,
      construction: json['construction'] as String?,
      remark: json['remark'] as String?,
      series: json['series'] as String?,
      unit: json['unit'] as String?,
      categoryId: (json['category_id'] as num?)?.toInt(),
      nameCn: json['name_cn'] as String?,
      nameEn: json['name_en'] as String?,
      productNo: json['product_no'] as String?,
      taxRate: json['tax_rate'] as String?,
      purchaseCost: json['purchase_cost'] as String?,
      pageNo: json['page_no'] as String?,
      tradeCountry: json['trade_country'] as String?,
      developedAt: json['developed_at'] as String?,
      descriptionCn: json['description_cn'] as String?,
      descriptionEn: json['description_en'] as String?,
      supplyQuotes: (json['supplyQuotes'] as List<dynamic>?)
          ?.map((e) => Quote.fromJson(e as Map<String, dynamic>))
          .toList(),
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
      'packing': instance.packing,
      'construction': instance.construction,
      'remark': instance.remark,
      'series': instance.series,
      'unit': instance.unit,
      'category_id': instance.categoryId,
      'name_cn': instance.nameCn,
      'name_en': instance.nameEn,
      'product_no': instance.productNo,
      'tax_rate': instance.taxRate,
      'purchase_cost': instance.purchaseCost,
      'page_no': instance.pageNo,
      'trade_country': instance.tradeCountry,
      'developed_at': instance.developedAt,
      'description_cn': instance.descriptionCn,
      'description_en': instance.descriptionEn,
      'supplyQuotes': instance.supplyQuotes,
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
