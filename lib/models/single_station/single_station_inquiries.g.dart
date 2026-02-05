// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'single_station_inquiries.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SingleStationInquiriesImpl _$$SingleStationInquiriesImplFromJson(
        Map<String, dynamic> json) =>
    _$SingleStationInquiriesImpl(
      id: (json['id'] as num?)?.toInt(),
      stationId: (json['station_id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      ip: json['ip'] as String?,
      ua: json['ua'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      station: json['station'] == null
          ? null
          : SingleStationItem.fromJson(json['station'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$SingleStationInquiriesImplToJson(
        _$SingleStationInquiriesImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'station_id': instance.stationId,
      'user_id': instance.userId,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'ip': instance.ip,
      'ua': instance.ua,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'user': instance.user,
      'station': instance.station,
    };
