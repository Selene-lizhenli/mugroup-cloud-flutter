// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Transfer _$TransferFromJson(Map<String, dynamic> json) {
  return _Transfer.fromJson(json);
}

/// @nodoc
mixin _$Transfer {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_no')
  String? get orderNo => throw _privateConstructorUsedError;
  @JsonKey(name: 'out_warehouse')
  String? get outWarehouse => throw _privateConstructorUsedError;
  @JsonKey(name: 'in_warehouse')
  String? get inWarehouse => throw _privateConstructorUsedError;
  User? get creator => throw _privateConstructorUsedError;
  TransferStatus? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'transfer_at')
  DateTime? get transferAt => throw _privateConstructorUsedError;
  String? get remark => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransferCopyWith<Transfer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferCopyWith<$Res> {
  factory $TransferCopyWith(Transfer value, $Res Function(Transfer) then) =
      _$TransferCopyWithImpl<$Res, Transfer>;
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'order_no') String? orderNo,
      @JsonKey(name: 'out_warehouse') String? outWarehouse,
      @JsonKey(name: 'in_warehouse') String? inWarehouse,
      User? creator,
      TransferStatus? status,
      @JsonKey(name: 'transfer_at') DateTime? transferAt,
      String? remark});

  $UserCopyWith<$Res>? get creator;
}

/// @nodoc
class _$TransferCopyWithImpl<$Res, $Val extends Transfer>
    implements $TransferCopyWith<$Res> {
  _$TransferCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? orderNo = freezed,
    Object? outWarehouse = freezed,
    Object? inWarehouse = freezed,
    Object? creator = freezed,
    Object? status = freezed,
    Object? transferAt = freezed,
    Object? remark = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      orderNo: freezed == orderNo
          ? _value.orderNo
          : orderNo // ignore: cast_nullable_to_non_nullable
              as String?,
      outWarehouse: freezed == outWarehouse
          ? _value.outWarehouse
          : outWarehouse // ignore: cast_nullable_to_non_nullable
              as String?,
      inWarehouse: freezed == inWarehouse
          ? _value.inWarehouse
          : inWarehouse // ignore: cast_nullable_to_non_nullable
              as String?,
      creator: freezed == creator
          ? _value.creator
          : creator // ignore: cast_nullable_to_non_nullable
              as User?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TransferStatus?,
      transferAt: freezed == transferAt
          ? _value.transferAt
          : transferAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      remark: freezed == remark
          ? _value.remark
          : remark // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get creator {
    if (_value.creator == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.creator!, (value) {
      return _then(_value.copyWith(creator: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TransferImplCopyWith<$Res>
    implements $TransferCopyWith<$Res> {
  factory _$$TransferImplCopyWith(
          _$TransferImpl value, $Res Function(_$TransferImpl) then) =
      __$$TransferImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'order_no') String? orderNo,
      @JsonKey(name: 'out_warehouse') String? outWarehouse,
      @JsonKey(name: 'in_warehouse') String? inWarehouse,
      User? creator,
      TransferStatus? status,
      @JsonKey(name: 'transfer_at') DateTime? transferAt,
      String? remark});

  @override
  $UserCopyWith<$Res>? get creator;
}

/// @nodoc
class __$$TransferImplCopyWithImpl<$Res>
    extends _$TransferCopyWithImpl<$Res, _$TransferImpl>
    implements _$$TransferImplCopyWith<$Res> {
  __$$TransferImplCopyWithImpl(
      _$TransferImpl _value, $Res Function(_$TransferImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? orderNo = freezed,
    Object? outWarehouse = freezed,
    Object? inWarehouse = freezed,
    Object? creator = freezed,
    Object? status = freezed,
    Object? transferAt = freezed,
    Object? remark = freezed,
  }) {
    return _then(_$TransferImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      orderNo: freezed == orderNo
          ? _value.orderNo
          : orderNo // ignore: cast_nullable_to_non_nullable
              as String?,
      outWarehouse: freezed == outWarehouse
          ? _value.outWarehouse
          : outWarehouse // ignore: cast_nullable_to_non_nullable
              as String?,
      inWarehouse: freezed == inWarehouse
          ? _value.inWarehouse
          : inWarehouse // ignore: cast_nullable_to_non_nullable
              as String?,
      creator: freezed == creator
          ? _value.creator
          : creator // ignore: cast_nullable_to_non_nullable
              as User?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TransferStatus?,
      transferAt: freezed == transferAt
          ? _value.transferAt
          : transferAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      remark: freezed == remark
          ? _value.remark
          : remark // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransferImpl implements _Transfer {
  _$TransferImpl(
      {this.id,
      @JsonKey(name: 'order_no') this.orderNo,
      @JsonKey(name: 'out_warehouse') this.outWarehouse,
      @JsonKey(name: 'in_warehouse') this.inWarehouse,
      this.creator,
      this.status,
      @JsonKey(name: 'transfer_at') this.transferAt,
      this.remark});

  factory _$TransferImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransferImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: 'order_no')
  final String? orderNo;
  @override
  @JsonKey(name: 'out_warehouse')
  final String? outWarehouse;
  @override
  @JsonKey(name: 'in_warehouse')
  final String? inWarehouse;
  @override
  final User? creator;
  @override
  final TransferStatus? status;
  @override
  @JsonKey(name: 'transfer_at')
  final DateTime? transferAt;
  @override
  final String? remark;

  @override
  String toString() {
    return 'Transfer(id: $id, orderNo: $orderNo, outWarehouse: $outWarehouse, inWarehouse: $inWarehouse, creator: $creator, status: $status, transferAt: $transferAt, remark: $remark)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderNo, orderNo) || other.orderNo == orderNo) &&
            (identical(other.outWarehouse, outWarehouse) ||
                other.outWarehouse == outWarehouse) &&
            (identical(other.inWarehouse, inWarehouse) ||
                other.inWarehouse == inWarehouse) &&
            (identical(other.creator, creator) || other.creator == creator) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.transferAt, transferAt) ||
                other.transferAt == transferAt) &&
            (identical(other.remark, remark) || other.remark == remark));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, orderNo, outWarehouse,
      inWarehouse, creator, status, transferAt, remark);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferImplCopyWith<_$TransferImpl> get copyWith =>
      __$$TransferImplCopyWithImpl<_$TransferImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransferImplToJson(
      this,
    );
  }
}

abstract class _Transfer implements Transfer {
  factory _Transfer(
      {final int? id,
      @JsonKey(name: 'order_no') final String? orderNo,
      @JsonKey(name: 'out_warehouse') final String? outWarehouse,
      @JsonKey(name: 'in_warehouse') final String? inWarehouse,
      final User? creator,
      final TransferStatus? status,
      @JsonKey(name: 'transfer_at') final DateTime? transferAt,
      final String? remark}) = _$TransferImpl;

  factory _Transfer.fromJson(Map<String, dynamic> json) =
      _$TransferImpl.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: 'order_no')
  String? get orderNo;
  @override
  @JsonKey(name: 'out_warehouse')
  String? get outWarehouse;
  @override
  @JsonKey(name: 'in_warehouse')
  String? get inWarehouse;
  @override
  User? get creator;
  @override
  TransferStatus? get status;
  @override
  @JsonKey(name: 'transfer_at')
  DateTime? get transferAt;
  @override
  String? get remark;
  @override
  @JsonKey(ignore: true)
  _$$TransferImplCopyWith<_$TransferImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
