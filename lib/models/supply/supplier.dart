import 'package:freezed_annotation/freezed_annotation.dart';

part 'supplier.freezed.dart';
part 'supplier.g.dart';

@freezed
class Supplier with _$Supplier {
  factory Supplier(
    int? id,
    @JsonKey(name: 'supplier_no') String? supplierNo,
    @JsonKey(name: 'short_name') String? shortName,
    String? name,
  ) = _Supplier;

  factory Supplier.fromJson(Map<String, dynamic> json) =>
      _$SupplierFromJson(json);
}
