import 'package:freezed_annotation/freezed_annotation.dart';

part 'cx.inventory.freezed.dart';
part 'cx.inventory.g.dart';

/// 建议收集列表项中的 user / handler 嵌套结构
@Freezed(toJson: false)
class CxInventoryType with _$CxInventoryType {
  const factory CxInventoryType({
    int? id,
    @JsonKey(name: 'CartonQty') int? cartonQty,
    @JsonKey(name: 'zb') String? zb,
    @JsonKey(name: 'PurchasingAgent') String? purchasingAgent,
    @JsonKey(name: 'PurchaseOrderNo') String? purchaseOrderNo,
    @JsonKey(name: 'WarehouseName') String? warehouseName,
    @JsonKey(name: 'ItemNo') String? itemNo,
    @JsonKey(name: 'StorageDate') String? storageDate,
    @JsonKey(name: 'Exporter') String? exporter,
    @JsonKey(name: 'purchaser_id') int? purchaserId,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    @JsonKey(name: 'remind_count') int? remindCount,
    @JsonKey(name: 'remind_logs') List<dynamic>? remindLogs,
  }) = _CxInventoryType;

  factory CxInventoryType.fromJson(Map<String, dynamic> json) =>
      _$CxInventoryTypeFromJson(json);
}