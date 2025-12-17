// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_supplier_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuoteSupplierGroupImpl _$$QuoteSupplierGroupImplFromJson(
        Map<String, dynamic> json) =>
    _$QuoteSupplierGroupImpl(
      count: (json['count'] as num?)?.toInt(),
      qty: (json['qty'] as num?)?.toInt(),
      supplier: json['supplier'] == null
          ? null
          : QuoteSupplier.fromJson(json['supplier'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$QuoteSupplierGroupImplToJson(
        _$QuoteSupplierGroupImpl instance) =>
    <String, dynamic>{
      'count': instance.count,
      'qty': instance.qty,
      'supplier': instance.supplier,
    };

_$QuoteSupplierImpl _$$QuoteSupplierImplFromJson(Map<String, dynamic> json) =>
    _$QuoteSupplierImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      city: json['city'] as String?,
      province: json['province'] as String?,
      address: json['address'] as String?,
      annual: json['annual'] as String?,
      advantages: json['advantages'] as List<dynamic>?,
      supplierNo: json['supplier_no'] as String?,
      usciCode: json['usci_code'] as String?,
      isCore: json['is_core'] as bool?,
      canBill: json['can_bill'] as bool?,
      businessScope: json['business_scope'] as String?,
      exportMarket: json['export_market'] as String?,
      shippingAmount: json['shipping_amount'] as String?,
      shortName: json['short_name'] as String?,
      bankName: json['bank_name'] as String?,
      bankAccount: json['bank_account'] as String?,
      businessTitle: json['business_title'] as String?,
      billType: json['bill_type'] as String?,
      typeId: (json['type_id'] as num?)?.toInt(),
      isCorporate: json['is_corporate'] as String?,
      supplierType: json['supplier_type'] as String?,
      corpCustomer: json['corp_customer'] as String?,
      corpCompany: json['corp_company'] as String?,
      showroomArea: json['showroom_area'] as String?,
      corpSkuid: json['corp_skuid'] as String?,
      marketRate: json['market_rate'] as String?,
      landType: json['land_type'] as String?,
      factoryArea: json['factory_area'] as String?,
      employeeCount: json['employee_count'] as String?,
      developedAt: json['developed_at'] as String?,
      sitePhotos: (json['site_photos'] as List<dynamic>?)
          ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
          .toList(),
      showroomPhotos: (json['showroom_photos'] as List<dynamic>?)
          ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
          .toList(),
      devicePhotos: (json['device_photos'] as List<dynamic>?)
          ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
          .toList(),
      contacts: (json['contacts'] as List<dynamic>?)
          ?.map((e) => Contact.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$QuoteSupplierImplToJson(_$QuoteSupplierImpl instance) =>
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
