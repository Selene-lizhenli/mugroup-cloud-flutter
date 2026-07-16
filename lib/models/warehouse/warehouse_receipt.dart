import 'package:cloud/models/department.dart';
import 'package:cloud/models/user.dart';
import 'package:cloud/models/warehouse/warehouse_receipt_item.dart';
import 'package:cloud/models/warehouse/warehouse_zone.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'warehouse_receipt.freezed.dart';
part 'warehouse_receipt.g.dart';

@freezed
abstract class WarehouseReceipt with _$WarehouseReceipt {
  const factory WarehouseReceipt({
    int? id,
    String? hashid,
    @JsonKey(name: 'user') User? user,
    @JsonKey(name: 'seller') User? seller,
    @JsonKey(name: 'purchaser') User? purchaser,
    @JsonKey(name: 'merchandiser') User? merchandiser,
    @JsonKey(name: 'department') Department? department,
    @JsonKey(name: 'order_no') String? orderNo,
    @JsonKey(name: 'supplier_no') String? supplierNo,
    @JsonKey(name: 'supplier_short_name') String? supplierShortName,
    @JsonKey(name: 'delivery_zone') String? deliveryZone,
    @JsonKey(name: 'zone_id') int? zoneId,
    WarehouseZone? zone,
    @JsonKey(name: 'raw') Object? raw,
    @JsonKey(name: 'items') List<WarehouseReceiptItem>? items,
    @JsonKey(name: 'shipped_at') DateTime? shippedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _WarehouseReceipt;

  factory WarehouseReceipt.fromJson(Map<String, Object?> json) =>
      _$WarehouseReceiptFromJson(json);
}
