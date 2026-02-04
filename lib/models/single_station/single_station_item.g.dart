// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'single_station_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SingleStationItemImpl _$$SingleStationItemImplFromJson(
        Map<String, dynamic> json) =>
    _$SingleStationItemImpl(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      hash: json['hash'] as String?,
      nameCn: json['name_cn'] as String?,
      nameEn: json['name_en'] as String?,
      isShowPrice: json['is_show_price'] as bool?,
      currency: json['currency'] as String?,
      defaultLang: json['default_lang'] as String?,
      commissionRate: json['commission_rate'] as String?,
      exchange: json['exchange'] as String?,
      remark: json['remark'] as String?,
      expireTime: json['expire_time'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      allowCountries: json['allow_countries'],
      address: json['address'] as String?,
      contactPerson: json['contact_person'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      wechat: json['wechat'] as String?,
      fax: json['fax'] as String?,
      status: json['status'],
      mulCurrencyRate: json['mul_currency_rate'],
      linkedin: json['linkedin'] as String?,
      whatsapp: json['whatsapp'] as String?,
      lindline: json['lindline'] as String?,
      departmentId: (json['department_id'] as num?)?.toInt(),
      creatorId: (json['creator_id'] as num?)?.toInt(),
      theme: json['theme'] as String?,
      isTaxInclusive: json['is_tax_inclusive'] as bool?,
      hasPassword: json['has_password'] as bool?,
      stationUrl: json['station_url'] as String?,
      user: json['user'] == null
          ? null
          : SingleStationUser.fromJson(json['user'] as Map<String, dynamic>),
      password: json['password'] as String?,
    );

Map<String, dynamic> _$$SingleStationItemImplToJson(
        _$SingleStationItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'hash': instance.hash,
      'name_cn': instance.nameCn,
      'name_en': instance.nameEn,
      'is_show_price': instance.isShowPrice,
      'currency': instance.currency,
      'default_lang': instance.defaultLang,
      'commission_rate': instance.commissionRate,
      'exchange': instance.exchange,
      'remark': instance.remark,
      'expire_time': instance.expireTime,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'allow_countries': instance.allowCountries,
      'address': instance.address,
      'contact_person': instance.contactPerson,
      'email': instance.email,
      'phone': instance.phone,
      'wechat': instance.wechat,
      'fax': instance.fax,
      'status': instance.status,
      'mul_currency_rate': instance.mulCurrencyRate,
      'linkedin': instance.linkedin,
      'whatsapp': instance.whatsapp,
      'lindline': instance.lindline,
      'department_id': instance.departmentId,
      'creator_id': instance.creatorId,
      'theme': instance.theme,
      'is_tax_inclusive': instance.isTaxInclusive,
      'has_password': instance.hasPassword,
      'station_url': instance.stationUrl,
      'user': instance.user,
      'password': instance.password,
    };

_$SingleStationUserImpl _$$SingleStationUserImplFromJson(
        Map<String, dynamic> json) =>
    _$SingleStationUserImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      sourceFrom: json['source_from'] as String?,
      jobNumber: json['job_number'] as String?,
      lastLoginAt: json['last_login_at'] as String?,
      hasPassword: json['has_password'] as bool?,
      phone: json['phone'] as String?,
      contactEmail: json['contact_email'] as String?,
      contactPhone: json['contact_phone'] as String?,
      contactWechat: json['contact_wechat'] as String?,
      contactFax: json['contact_fax'] as String?,
      contactAddress: json['contact_address'] as String?,
      workLocation: json['work_location'] as String?,
      job: json['job'] as String?,
      position: json['position'] as String?,
      employStatus: (json['employ_status'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$SingleStationUserImplToJson(
        _$SingleStationUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'source_from': instance.sourceFrom,
      'job_number': instance.jobNumber,
      'last_login_at': instance.lastLoginAt,
      'has_password': instance.hasPassword,
      'phone': instance.phone,
      'contact_email': instance.contactEmail,
      'contact_phone': instance.contactPhone,
      'contact_wechat': instance.contactWechat,
      'contact_fax': instance.contactFax,
      'contact_address': instance.contactAddress,
      'work_location': instance.workLocation,
      'job': instance.job,
      'position': instance.position,
      'employ_status': instance.employStatus,
    };
