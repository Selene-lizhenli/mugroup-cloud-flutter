// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_cert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SupplierCertImpl _$$SupplierCertImplFromJson(Map<String, dynamic> json) =>
    _$SupplierCertImpl(
      (json['id'] as num?)?.toInt(),
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      json['cert'] == null
          ? null
          : Cert.fromJson(json['cert'] as Map<String, dynamic>),
      json['supplier'] == null
          ? null
          : Supplier.fromJson(json['supplier'] as Map<String, dynamic>),
      json['expired_at'] == null
          ? null
          : DateTime.parse(json['expired_at'] as String),
      (json['media'] as List<dynamic>?)
          ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['remark'] as String?,
      json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$SupplierCertImplToJson(_$SupplierCertImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'cert': instance.cert,
      'supplier': instance.supplier,
      'expired_at': instance.expiredAt?.toIso8601String(),
      'media': instance.media,
      'remark': instance.remark,
      'created_at': instance.createdAt?.toIso8601String(),
    };
