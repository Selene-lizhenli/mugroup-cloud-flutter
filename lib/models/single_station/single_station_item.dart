import 'package:freezed_annotation/freezed_annotation.dart';

part 'single_station_item.freezed.dart';
part 'single_station_item.g.dart';

/// 独立站站点项（列表/详情）
@freezed
class SingleStationItem with _$SingleStationItem {
  const factory SingleStationItem({
    int? id,
    @JsonKey(name: 'user_id') int? userId,
    String? hash,
    @JsonKey(name: 'name_cn') String? nameCn,
    @JsonKey(name: 'name_en') String? nameEn,
    @JsonKey(name: 'is_show_price') bool? isShowPrice,
    String? currency,
    @JsonKey(name: 'default_lang') String? defaultLang,
    @JsonKey(name: 'commission_rate') String? commissionRate,
    String? exchange,
    String? remark,
    @JsonKey(name: 'expire_time') String? expireTime,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    @JsonKey(name: 'allow_countries') dynamic allowCountries,
    String? address,
    @JsonKey(name: 'contact_person') String? contactPerson,
    String? email,
    String? phone,
    String? wechat,
    String? fax,
    dynamic status,
    @JsonKey(name: 'mul_currency_rate') dynamic mulCurrencyRate,
    String? linkedin,
    String? whatsapp,
    String? lindline,
    @JsonKey(name: 'department_id') int? departmentId,
    @JsonKey(name: 'creator_id') int? creatorId,
    String? theme,
    @JsonKey(name: 'is_tax_inclusive') bool? isTaxInclusive,
    @JsonKey(name: 'has_password') bool? hasPassword,
    @JsonKey(name: 'station_url') String? stationUrl,
    SingleStationUser? user,
    String? password,
  }) = _SingleStationItem;

  factory SingleStationItem.fromJson(Map<String, Object?> json) =>
      _$SingleStationItemFromJson(json);
}

/// 独立站关联用户信息
@freezed
class SingleStationUser with _$SingleStationUser {
  const factory SingleStationUser({
    int? id,
    String? name,
    @JsonKey(name: 'source_from') String? sourceFrom,
    @JsonKey(name: 'job_number') String? jobNumber,
    @JsonKey(name: 'last_login_at') String? lastLoginAt,
    @JsonKey(name: 'has_password') bool? hasPassword,
    String? phone,
    @JsonKey(name: 'contact_email') String? contactEmail,
    @JsonKey(name: 'contact_phone') String? contactPhone,
    @JsonKey(name: 'contact_wechat') String? contactWechat,
    @JsonKey(name: 'contact_fax') String? contactFax,
    @JsonKey(name: 'contact_address') String? contactAddress,
    @JsonKey(name: 'work_location') String? workLocation,
    String? job,
    String? position,
    @JsonKey(name: 'employ_status') int? employStatus,
  }) = _SingleStationUser;

  factory SingleStationUser.fromJson(Map<String, Object?> json) =>
      _$SingleStationUserFromJson(json);
}
