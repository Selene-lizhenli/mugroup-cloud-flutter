// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cx.inventory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CxInventoryTypeImpl _$$CxInventoryTypeImplFromJson(
        Map<String, dynamic> json) =>
    _$CxInventoryTypeImpl(
      id: (json['id'] as num?)?.toInt(),
      cartonQty: (json['CartonQty'] as num?)?.toInt(),
      zb: json['zb'] as String?,
      purchasingAgent: json['PurchasingAgent'] as String?,
      purchaseOrderNo: json['PurchaseOrderNo'] as String?,
      warehouseName: json['WarehouseName'] as String?,
      itemNo: json['ItemNo'] as String?,
      storageDate: json['StorageDate'] as String?,
      exporter: json['Exporter'] as String?,
      purchaserId: (json['purchaser_id'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      remindCount: (json['remind_count'] as num?)?.toInt(),
      remindLogs: json['remind_logs'] as List<dynamic>?,
    );
