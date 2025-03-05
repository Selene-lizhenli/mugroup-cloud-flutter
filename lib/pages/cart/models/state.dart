import 'package:cloud/models/sample/sample.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

enum CartType {
  /// 借样
  borrowOut,

  /// 还样
  borrowIn,

  /// 调拨出库
  transferOut,

  /// 调拨入库
  transferIn,

  /// 手动盘点
  inout,
}

@unfreezed
abstract class CartItem with _$CartItem {
  factory CartItem({
    required final Sample sample,
    required int count,
  }) = _CartItem;
}

@freezed
abstract class State with _$State {
  const factory State({
    required List<CartItem> items,
    CartType? type,
  }) = _State;
}
