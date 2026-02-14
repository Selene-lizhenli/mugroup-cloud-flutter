// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advice_collect_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdviceCollectBookUserImpl _$$AdviceCollectBookUserImplFromJson(
        Map<String, dynamic> json) =>
    _$AdviceCollectBookUserImpl(
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

_$AdviceCollectBookImpl _$$AdviceCollectBookImplFromJson(
        Map<String, dynamic> json) =>
    _$AdviceCollectBookImpl(
      id: (json['id'] as num?)?.toInt(),
      content: json['content'] as String?,
      status: json['status'] as String?,
      message: json['message'] as String?,
      handledAt: json['handled_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      user: json['user'] == null
          ? null
          : AdviceCollectBookUser.fromJson(
              json['user'] as Map<String, dynamic>),
      handler: json['handler'] == null
          ? null
          : AdviceCollectBookUser.fromJson(
              json['handler'] as Map<String, dynamic>),
    );
