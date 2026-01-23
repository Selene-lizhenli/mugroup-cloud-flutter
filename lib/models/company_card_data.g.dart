// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_card_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CompanyCardDataImpl _$$CompanyCardDataImplFromJson(
        Map<String, dynamic> json) =>
    _$CompanyCardDataImpl(
      name: json['name'] as String?,
      address: json['address'] as String?,
      location: json['location'] as String?,
      industry: json['industry'] as String?,
      domain: (json['domain'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      email:
          (json['email'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      linkedin: (json['linkedin'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      whatsapp: (json['whatsapp'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      facebook: (json['facebook'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      contact: (json['contact'] as List<dynamic>?)
              ?.map((e) => Contact.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CompanyCardDataImplToJson(
        _$CompanyCardDataImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'address': instance.address,
      'location': instance.location,
      'industry': instance.industry,
      'domain': instance.domain,
      'email': instance.email,
      'linkedin': instance.linkedin,
      'whatsapp': instance.whatsapp,
      'facebook': instance.facebook,
      'contact': instance.contact,
    };

_$ContactImpl _$$ContactImplFromJson(Map<String, dynamic> json) =>
    _$ContactImpl(
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      mobile: json['mobile'] as String?,
      position: json['position'] as String?,
    );

Map<String, dynamic> _$$ContactImplToJson(_$ContactImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'phone': instance.phone,
      'mobile': instance.mobile,
      'position': instance.position,
    };
