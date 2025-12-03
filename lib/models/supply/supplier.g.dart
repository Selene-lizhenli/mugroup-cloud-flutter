// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SupplierImpl _$$SupplierImplFromJson(Map<String, dynamic> json) =>
    _$SupplierImpl(
      (json['id'] as num?)?.toInt(),
      json['name'] as String?,
      json['city'] as String?,
      json['province'] as String?,
      json['supplier_no'] as String?,
      json['usci_code'] as String?,
      json['is_core'] as bool?,
      json['can_bill'] as bool?,
      json['business_scope'] as String?,
      json['export_market'] as String?,
      json['shipping_amount'] as String?,
      json['short_name'] as String?,
      json['bank_name'] as String?,
      json['bank_account'] as String?,
      json['business_title'] as String?,
      json['bill_type'] as String?,
      (json['contacts'] as List<dynamic>?)
          ?.map((e) => Contact.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SupplierImplToJson(_$SupplierImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'city': instance.city,
      'province': instance.province,
      'supplier_no': instance.supplierNo,
      'usci_code': instance.usciCode,
      'is_core': instance.isCore,
      'can_bill': instance.canBill,
      'business_scope': instance.businessScope,
      'export_market': instance.exportMarket,
      'shipping_amount': instance.shippingAmount,
      'short_name': instance.shortName,
      'bank_name': instance.bankName,
      'bank_account': instance.bankAccount,
      'business_title': instance.businessTitle,
      'bill_type': instance.billType,
      'contacts': instance.contacts,
    };
