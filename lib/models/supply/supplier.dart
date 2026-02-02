import 'package:cloud/models/media.dart';
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
    String? address,
    String? annual,
    List<dynamic>? advantages,
    @JsonKey(name: 'supplier_no') String? supplierNo,
    @JsonKey(name: 'usci_code') String? usciCode,
    @JsonKey(name: 'is_core') bool? isCore,
    @JsonKey(name: 'can_bill') bool? canBill,
    @JsonKey(name: 'business_scope') String? businessScope,
    @JsonKey(name: 'export_market') String? exportMarket,
    @JsonKey(name: 'shipping_amount') String? shippingAmount,
    @JsonKey(name: 'short_name') String? shortName,
    @JsonKey(name: 'bank_name') String? bankName,
    @JsonKey(name: 'bank_account') String? bankAccount,
    @JsonKey(name: 'business_title') String? businessTitle,
    @JsonKey(name: 'stall_address') String? stallAddress,
    @JsonKey(name: 'bill_type') String? billType,
    @JsonKey(name: 'type_id') int? typeId,
    @JsonKey(name: 'is_corporate') String? isCorporate,
    @JsonKey(name: 'supplier_type') String? supplierType,
    @JsonKey(name: 'corp_customer') String? corpCustomer,
    @JsonKey(name: 'corp_company') String? corpCompany,
    @JsonKey(name: 'showroom_area') String? showroomArea,
    @JsonKey(name: 'corp_skuid') String? corpSkuid,
    @JsonKey(name: 'market_rate') String? marketRate,
    @JsonKey(name: 'land_type') String? landType,
    @JsonKey(name: 'factory_area') String? factoryArea,
    @JsonKey(name: 'employee_count') String? employeeCount,
    @JsonKey(name: 'developed_at') String? developedAt,
    @JsonKey(name: 'site_photos') List<Media>? sitePhotos,
    @JsonKey(name: 'showroom_photos') List<Media>? showroomPhotos,
    @JsonKey(name: 'device_photos') List<Media>? devicePhotos,
    List<Contact>? contacts,
    List<Media>? media,
  ) = _Supplier;

  factory Supplier.fromJson(Map<String, dynamic> json) =>
      _$SupplierFromJson(json);
}
