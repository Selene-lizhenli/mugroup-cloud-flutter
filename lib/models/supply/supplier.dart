import 'package:cloud/models/supply/contact.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'supplier.freezed.dart';
part 'supplier.g.dart';

@freezed
class Supplier with _$Supplier {
  factory Supplier(
    int? id,
    String? name,
    String? city,
    String? province,
    @JsonKey(name: 'supplier_no') String? supplierNo,
    @JsonKey(name: 'is_core') bool? isCore,
    @JsonKey(name: 'can_bill') bool? canBill,
    @JsonKey(name: 'business_scope') String? businessScope,
    @JsonKey(name: 'export_market') String? exportMarket,
    @JsonKey(name: 'shipping_amount') String? shippingAmount,
    @JsonKey(name: 'short_name') String? shortName,
    List<Contact>? contacts,
  ) = _Supplier;

  factory Supplier.fromJson(Map<String, dynamic> json) =>
      _$SupplierFromJson(json);
}
