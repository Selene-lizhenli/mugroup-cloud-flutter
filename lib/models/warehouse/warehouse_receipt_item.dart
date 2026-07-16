import 'package:cloud/models/warehouse/warehouse_receipt.dart';
import 'package:cloud/models/warehouse/warehouse_receipt_item_entry.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'warehouse_receipt_item.freezed.dart';
part 'warehouse_receipt_item.g.dart';

@freezed
abstract class WarehouseReceiptItem with _$WarehouseReceiptItem {
  const factory WarehouseReceiptItem({
    int? id,
    String? hashid,
    @JsonKey(name: 'receipt_id') int? receiptId,
    @JsonKey(name: 'record_id') String? recordId,
    @JsonKey(name: 'receipt') WarehouseReceipt? receipt,
    @JsonKey(name: 'item_no') String? itemNo,
    @JsonKey(name: 'customer_item_no') String? customerItemNo,
    @JsonKey(name: 'supplier_short_name') String? supplierShortName,
    @JsonKey(name: 'purchase_order_no') String? purchaseOrderNo,
    @JsonKey(name: 'shipping_qty') num? shippingQty,
    @JsonKey(name: 'unit') String? unit,
    @JsonKey(name: 'inner_capacity') int? innerCapacity,
    @JsonKey(name: 'outer_capacity') int? outerCapacity,
    @JsonKey(name: 'carton_qty') int? cartonQty,
    @JsonKey(name: 'outer_length') num? outerLength,
    @JsonKey(name: 'outer_width') num? outerWidth,
    @JsonKey(name: 'outer_height') num? outerHeight,
    @JsonKey(name: 'outer_volume') num? outerVolume,
    @JsonKey(name: 'volume') num? volume,
    @JsonKey(name: 'outer_gross_weight') num? outerGrossWeight,
    @JsonKey(name: 'gross_weight') num? grossWeight,
    @JsonKey(name: 'outer_net_weight') num? outerNetWeight,
    @JsonKey(name: 'net_weight') num? netWeight,
    @JsonKey(name: 'entries_count') int? entriesCount,
    @JsonKey(name: 'entries') List<WarehouseReceiptItemEntry>? entries,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _WarehouseReceiptItem;

  factory WarehouseReceiptItem.fromJson(Map<String, Object?> json) =>
      _$WarehouseReceiptItemFromJson(json);
}
