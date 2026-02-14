import 'package:freezed_annotation/freezed_annotation.dart';

part 'advice_collect_item.freezed.dart';
part 'advice_collect_item.g.dart';

/// 建议收集列表项中的 user / handler 嵌套结构
@Freezed(toJson: false)
class AdviceCollectBookUser with _$AdviceCollectBookUser {
  const factory AdviceCollectBookUser({
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
  }) = _AdviceCollectBookUser;

  factory AdviceCollectBookUser.fromJson(Map<String, dynamic> json) =>
      _$AdviceCollectBookUserFromJson(json);
}

/// 建议收集列表项（接口 api/tenant/feedback/books 单项）
@Freezed(toJson: false)
class AdviceCollectBook with _$AdviceCollectBook {
  const factory AdviceCollectBook({
    int? id,
    String? content,
    String? status,
    String? message,
    @JsonKey(name: 'handled_at') String? handledAt,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    AdviceCollectBookUser? user,
    AdviceCollectBookUser? handler,
  }) = _AdviceCollectBook;

  factory AdviceCollectBook.fromJson(Map<String, dynamic> json) =>
      _$AdviceCollectBookFromJson(json);
}
