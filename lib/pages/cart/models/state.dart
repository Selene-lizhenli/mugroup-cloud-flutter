import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/models/user.dart';
import 'package:cloud/models/wms.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';
part 'state.g.dart';

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

  /// 报价单
  quotation,
}

Map<CartType, String> cartNames = {
  CartType.borrowOut: "借样选样车",
  CartType.borrowIn: "还样选样车",
  CartType.transferOut: "调拨出库选样车",
  CartType.transferIn: "调拨入库选样车",
  CartType.inout: "手动盘点选样车",
  CartType.quotation: "报价单选样车",
};

// class CartSelect {
//   final CartType type;

//   CartSelect(this.type);

//   String get cartName {
//     return cartNames[type] ?? "选样车";
//   }
// }

@freezed
abstract class CartSelect with _$CartSelect {
  const CartSelect._();

  const factory CartSelect(CartType type) = _CartSelect;

  factory CartSelect.fromJson(Map<String, Object?> json) =>
      _$CartSelectFromJson(json);

  String get cartName {
    return cartNames[type] ?? "选样车";
  }
}

@unfreezed
abstract class CartItem with _$CartItem {
  factory CartItem({
    required final Sample sample,
    required int count,
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, Object?> json) =>
      _$CartItemFromJson(json);
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
    List<int>? selectedDate,
  }) = _State;

  factory State.fromJson(Map<String, Object?> json) => _$StateFromJson(json);
}
