// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SupplierImpl _$$SupplierImplFromJson(Map<String, dynamic> json) =>
    _$SupplierImpl(
      (json['id'] as num?)?.toInt(),
      json['supplier_no'] as String?,
      json['short_name'] as String?,
      json['name'] as String?,
    );

Map<String, dynamic> _$$SupplierImplToJson(_$SupplierImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'supplier_no': instance.supplierNo,
      'short_name': instance.shortName,
      'name': instance.name,
    };
