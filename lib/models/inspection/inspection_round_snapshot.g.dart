// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_round_snapshot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InspectionRoundSnapshotImpl _$$InspectionRoundSnapshotImplFromJson(
        Map<String, dynamic> json) =>
    _$InspectionRoundSnapshotImpl(
      round: (json['round'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      remark: json['remark'] as String?,
      mediaSnapshot: (json['media_snapshot'] as List<dynamic>?)
          ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at'] as String?,
      inspectorName: json['inspector_name'] as String?,
    );

Map<String, dynamic> _$$InspectionRoundSnapshotImplToJson(
        _$InspectionRoundSnapshotImpl instance) =>
    <String, dynamic>{
      'round': instance.round,
      'status': instance.status,
      'remark': instance.remark,
      'media_snapshot': instance.mediaSnapshot,
      'created_at': instance.createdAt,
      'inspector_name': instance.inspectorName,
    };
