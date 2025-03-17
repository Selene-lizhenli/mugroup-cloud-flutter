import 'package:cloud/models/sample/sample.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';
part 'state.g.dart';

@unfreezed
abstract class TransferConfirmItem with _$TransferConfirmItem {
  factory TransferConfirmItem({
    int? id,
    required Sample product,
    @JsonKey(name: 'in_qty') int? inQty,
    @JsonKey(name: 'out_qty') int? outQty,
    required int count,
  }) = _TransferConfirmItem;

  factory TransferConfirmItem.fromJson(Map<String, Object?> json) =>
      _$TransferConfirmItemFromJson(json);
}

@freezed
abstract class State with _$State {
  const factory State({
    required List<TransferConfirmItem> items,
  }) = _State;

  factory State.fromJson(Map<String, Object?> json) => _$StateFromJson(json);
}
