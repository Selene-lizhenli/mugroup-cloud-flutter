import 'package:cloud/models/user.dart';
import 'package:cloud/models/wms/delivery_item.dart';
import 'package:cloud/models/wms/warehouse.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'delivery.freezed.dart';
part 'delivery.g.dart';

enum DeliveryStatus { pending, finished }

@freezed
class Delivery with _$Delivery {
  factory Delivery({
    int? id,
    @JsonKey(name: "order_no") String? orderNo,
    String? remark,
    DeliveryStatus? status,
    Warehouse? warehouse,
    User? user,
    @JsonKey(name: "item_sum_qty") int? itemSumQty,
    @JsonKey(name: "item_count_qty") int? itemCountQty,
    @JsonKey(name: 'items') List<DeliveryItem>? items,
  }) = _Delivery;

  factory Delivery.fromJson(Map<String, dynamic> json) =>
      _$DeliveryFromJson(json);
}
