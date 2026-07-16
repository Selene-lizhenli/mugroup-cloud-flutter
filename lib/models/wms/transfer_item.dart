import 'package:cloud/models/sample/sample.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_item.freezed.dart';
part 'transfer_item.g.dart';

@freezed
class TransferItem with _$TransferItem {
  factory TransferItem(
    int? id,
    Sample? product,
    @JsonKey(name: 'in_qty') int? inQty,
    @JsonKey(name: 'out_qty') int? outQty,
    String? notes,
  ) = _TransferItem;

  factory TransferItem.fromJson(Map<String, dynamic> json) =>
      _$TransferItemFromJson(json);
}
