import 'package:cloud/models/sample/sample.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'delivery_item.freezed.dart';
part 'delivery_item.g.dart';

@freezed
class DeliveryItem with _$DeliveryItem {
  factory DeliveryItem(
    int? id,
    Sample? product,
    @JsonKey(name: 'qty') int? qty,
  ) = _DeliveryItem;

  factory DeliveryItem.fromJson(Map<String, dynamic> json) =>
      _$DeliveryItemFromJson(json);
}
