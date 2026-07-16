import 'package:cloud/models/media.dart';
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

@Freezed(toJson: false)
class AdviceCollectBookComment with _$AdviceCollectBookComment {
  const factory AdviceCollectBookComment({
    int? id,
    String? comment,
    @JsonKey(name: 'is_approved') bool? isApproved,
    @JsonKey(name: 'parent_id') int? parentId,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    AdviceCollectBookUser? user,
    List<Media>? attachments,
  }) = _AdviceCollectBookComment;

  factory AdviceCollectBookComment.fromJson(Map<String, dynamic> json) =>
      _$AdviceCollectBookCommentFromJson(json);
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
    List<AdviceCollectBookComment>? comments,
    List<Media>? attachments,
  }) = _AdviceCollectBook;

  factory AdviceCollectBook.fromJson(Map<String, dynamic> json) =>
      _$AdviceCollectBookFromJson(json);
}
