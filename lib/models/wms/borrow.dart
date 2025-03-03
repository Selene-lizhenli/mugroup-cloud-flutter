import 'package:cloud/models/user.dart';
import 'package:cloud/models/wms.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'borrow.freezed.dart';
part 'borrow.g.dart';

@freezed
class Borrow with _$Borrow {
  factory Borrow({
    int? id,
    @JsonKey(name: 'order_no') String? orderNo,
    User? user,
    User? borrower,
    Warehouse? warehouse,
    @JsonKey(name: 'borrow_at') DateTime? borrowAt,
    String? remark,
  }) = _Borrow;

  factory Borrow.fromJson(Map<String, dynamic> json) => _$BorrowFromJson(json);
}
