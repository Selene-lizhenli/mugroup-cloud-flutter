// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'borrow.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BorrowImpl _$$BorrowImplFromJson(Map<String, dynamic> json) => _$BorrowImpl(
      id: (json['id'] as num?)?.toInt(),
      orderNo: json['order_no'] as String?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      borrower: json['borrower'] == null
          ? null
          : User.fromJson(json['borrower'] as Map<String, dynamic>),
      warehouse: json['warehouse'] == null
          ? null
          : Warehouse.fromJson(json['warehouse'] as Map<String, dynamic>),
      borrowAt: json['borrow_at'] == null
          ? null
          : DateTime.parse(json['borrow_at'] as String),
      remark: json['remark'] as String?,
    );

Map<String, dynamic> _$$BorrowImplToJson(_$BorrowImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_no': instance.orderNo,
      'user': instance.user,
      'borrower': instance.borrower,
      'warehouse': instance.warehouse,
      'borrow_at': instance.borrowAt?.toIso8601String(),
      'remark': instance.remark,
    };
