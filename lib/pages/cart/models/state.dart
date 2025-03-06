import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/models/user.dart';
import 'package:cloud/models/wms.dart';
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

class CartSelect {
  final CartType type;

  CartSelect(this.type);

  String get name {
    if (type == CartType.borrowOut) {
      return "借样选样车";
    }

    if (type == CartType.borrowIn) {
      return "还样选样车";
    }

    if (type == CartType.transferOut) {
      return "调拨出库选样车";
    }

    if (type == CartType.transferIn) {
      return "调拨入库选样车";
    }

    if (type == CartType.inout) {
      return "手动盘点";
    }

    return "选样车";
  }
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
    required List<CartSelect> carts,
    Warehouse? warehouse,
    Borrow? borrow,
    Transfer? transfer,
    User? user,
    CartType? type,
    String? cartName,
  }) = _State;
}
