// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warehouse_receipt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WarehouseReceiptImpl _$$WarehouseReceiptImplFromJson(
        Map<String, dynamic> json) =>
    _$WarehouseReceiptImpl(
      id: (json['id'] as num?)?.toInt(),
      hashid: json['hashid'] as String?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      seller: json['seller'] == null
          ? null
          : User.fromJson(json['seller'] as Map<String, dynamic>),
      purchaser: json['purchaser'] == null
          ? null
          : User.fromJson(json['purchaser'] as Map<String, dynamic>),
      merchandiser: json['merchandiser'] == null
          ? null
          : User.fromJson(json['merchandiser'] as Map<String, dynamic>),
      department: json['department'] == null
          ? null
          : Department.fromJson(json['department'] as Map<String, dynamic>),
      orderNo: json['order_no'] as String?,
      supplierNo: json['supplier_no'] as String?,
      supplierShortName: json['supplier_short_name'] as String?,
      deliveryZone: json['delivery_zone'] as String?,
      zoneId: (json['zone_id'] as num?)?.toInt(),
      zone: json['zone'] == null
          ? null
          : WarehouseZone.fromJson(json['zone'] as Map<String, dynamic>),
      raw: json['raw'],
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => WarehouseReceiptItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      shippedAt: json['shipped_at'] == null
          ? null
          : DateTime.parse(json['shipped_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$WarehouseReceiptImplToJson(
        _$WarehouseReceiptImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'hashid': instance.hashid,
      'user': instance.user,
      'seller': instance.seller,
      'purchaser': instance.purchaser,
      'merchandiser': instance.merchandiser,
      'department': instance.department,
      'order_no': instance.orderNo,
      'supplier_no': instance.supplierNo,
      'supplier_short_name': instance.supplierShortName,
      'delivery_zone': instance.deliveryZone,
      'zone_id': instance.zoneId,
      'zone': instance.zone,
      'raw': instance.raw,
      'items': instance.items,
      'shipped_at': instance.shippedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
