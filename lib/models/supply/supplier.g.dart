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
      json['address'] as String?,
      json['annual'] as String?,
      json['advantages'] as List<dynamic>?,
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
      json['stall_address'] as String?,
      json['bill_type'] as String?,
      (json['type_id'] as num?)?.toInt(),
      json['is_corporate'] as String?,
      json['supplier_type'] as String?,
      json['corp_customer'] as String?,
      json['corp_company'] as String?,
      json['showroom_area'] as String?,
      json['corp_skuid'] as String?,
      json['market_rate'] as String?,
      json['land_type'] as String?,
      json['factory_area'] as String?,
      json['employee_count'] as String?,
      json['developed_at'] as String?,
      (json['site_photos'] as List<dynamic>?)
          ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['showroom_photos'] as List<dynamic>?)
          ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['device_photos'] as List<dynamic>?)
          ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
          .toList(),
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
      'address': instance.address,
      'annual': instance.annual,
      'advantages': instance.advantages,
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
      'stall_address': instance.stallAddress,
      'bill_type': instance.billType,
      'type_id': instance.typeId,
      'is_corporate': instance.isCorporate,
      'supplier_type': instance.supplierType,
      'corp_customer': instance.corpCustomer,
      'corp_company': instance.corpCompany,
      'showroom_area': instance.showroomArea,
      'corp_skuid': instance.corpSkuid,
      'market_rate': instance.marketRate,
      'land_type': instance.landType,
      'factory_area': instance.factoryArea,
      'employee_count': instance.employeeCount,
      'developed_at': instance.developedAt,
      'site_photos': instance.sitePhotos,
      'showroom_photos': instance.showroomPhotos,
      'device_photos': instance.devicePhotos,
      'contacts': instance.contacts,
    };
