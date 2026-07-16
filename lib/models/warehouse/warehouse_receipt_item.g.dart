// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warehouse_receipt_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WarehouseReceiptItemImpl _$$WarehouseReceiptItemImplFromJson(
        Map<String, dynamic> json) =>
    _$WarehouseReceiptItemImpl(
      id: (json['id'] as num?)?.toInt(),
      hashid: json['hashid'] as String?,
      receiptId: (json['receipt_id'] as num?)?.toInt(),
      recordId: json['record_id'] as String?,
      receipt: json['receipt'] == null
          ? null
          : WarehouseReceipt.fromJson(json['receipt'] as Map<String, dynamic>),
      itemNo: json['item_no'] as String?,
      customerItemNo: json['customer_item_no'] as String?,
      supplierShortName: json['supplier_short_name'] as String?,
      purchaseOrderNo: json['purchase_order_no'] as String?,
      shippingQty: json['shipping_qty'] as num?,
      unit: json['unit'] as String?,
      innerCapacity: (json['inner_capacity'] as num?)?.toInt(),
      outerCapacity: (json['outer_capacity'] as num?)?.toInt(),
      cartonQty: (json['carton_qty'] as num?)?.toInt(),
      outerLength: json['outer_length'] as num?,
      outerWidth: json['outer_width'] as num?,
      outerHeight: json['outer_height'] as num?,
      outerVolume: json['outer_volume'] as num?,
      volume: json['volume'] as num?,
      outerGrossWeight: json['outer_gross_weight'] as num?,
      grossWeight: json['gross_weight'] as num?,
      outerNetWeight: json['outer_net_weight'] as num?,
      netWeight: json['net_weight'] as num?,
      entriesCount: (json['entries_count'] as num?)?.toInt(),
      entries: (json['entries'] as List<dynamic>?)
          ?.map((e) =>
              WarehouseReceiptItemEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$WarehouseReceiptItemImplToJson(
        _$WarehouseReceiptItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'hashid': instance.hashid,
      'receipt_id': instance.receiptId,
      'record_id': instance.recordId,
      'receipt': instance.receipt,
      'item_no': instance.itemNo,
      'customer_item_no': instance.customerItemNo,
      'supplier_short_name': instance.supplierShortName,
      'purchase_order_no': instance.purchaseOrderNo,
      'shipping_qty': instance.shippingQty,
      'unit': instance.unit,
      'inner_capacity': instance.innerCapacity,
      'outer_capacity': instance.outerCapacity,
      'carton_qty': instance.cartonQty,
      'outer_length': instance.outerLength,
      'outer_width': instance.outerWidth,
      'outer_height': instance.outerHeight,
      'outer_volume': instance.outerVolume,
      'volume': instance.volume,
      'outer_gross_weight': instance.outerGrossWeight,
      'gross_weight': instance.grossWeight,
      'outer_net_weight': instance.outerNetWeight,
      'net_weight': instance.netWeight,
      'entries_count': instance.entriesCount,
      'entries': instance.entries,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
