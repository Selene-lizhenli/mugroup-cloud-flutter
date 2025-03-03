// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'borrow.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Borrow _$BorrowFromJson(Map<String, dynamic> json) {
  return _Borrow.fromJson(json);
}

/// @nodoc
mixin _$Borrow {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_no')
  String? get orderNo => throw _privateConstructorUsedError;
  User? get user => throw _privateConstructorUsedError;
  User? get borrower => throw _privateConstructorUsedError;
  Warehouse? get warehouse => throw _privateConstructorUsedError;
  @JsonKey(name: 'borrow_at')
  DateTime? get borrowAt => throw _privateConstructorUsedError;
  String? get remark => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BorrowCopyWith<Borrow> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BorrowCopyWith<$Res> {
  factory $BorrowCopyWith(Borrow value, $Res Function(Borrow) then) =
      _$BorrowCopyWithImpl<$Res, Borrow>;
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'order_no') String? orderNo,
      User? user,
      User? borrower,
      Warehouse? warehouse,
      @JsonKey(name: 'borrow_at') DateTime? borrowAt,
      String? remark});

  $UserCopyWith<$Res>? get user;
  $UserCopyWith<$Res>? get borrower;
  $WarehouseCopyWith<$Res>? get warehouse;
}

/// @nodoc
class _$BorrowCopyWithImpl<$Res, $Val extends Borrow>
    implements $BorrowCopyWith<$Res> {
  _$BorrowCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? orderNo = freezed,
    Object? user = freezed,
    Object? borrower = freezed,
    Object? warehouse = freezed,
    Object? borrowAt = freezed,
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
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      borrower: freezed == borrower
          ? _value.borrower
          : borrower // ignore: cast_nullable_to_non_nullable
              as User?,
      warehouse: freezed == warehouse
          ? _value.warehouse
          : warehouse // ignore: cast_nullable_to_non_nullable
              as Warehouse?,
      borrowAt: freezed == borrowAt
          ? _value.borrowAt
          : borrowAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      remark: freezed == remark
          ? _value.remark
          : remark // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get borrower {
    if (_value.borrower == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.borrower!, (value) {
      return _then(_value.copyWith(borrower: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $WarehouseCopyWith<$Res>? get warehouse {
    if (_value.warehouse == null) {
      return null;
    }

    return $WarehouseCopyWith<$Res>(_value.warehouse!, (value) {
      return _then(_value.copyWith(warehouse: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BorrowImplCopyWith<$Res> implements $BorrowCopyWith<$Res> {
  factory _$$BorrowImplCopyWith(
          _$BorrowImpl value, $Res Function(_$BorrowImpl) then) =
      __$$BorrowImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'order_no') String? orderNo,
      User? user,
      User? borrower,
      Warehouse? warehouse,
      @JsonKey(name: 'borrow_at') DateTime? borrowAt,
      String? remark});

  @override
  $UserCopyWith<$Res>? get user;
  @override
  $UserCopyWith<$Res>? get borrower;
  @override
  $WarehouseCopyWith<$Res>? get warehouse;
}

/// @nodoc
class __$$BorrowImplCopyWithImpl<$Res>
    extends _$BorrowCopyWithImpl<$Res, _$BorrowImpl>
    implements _$$BorrowImplCopyWith<$Res> {
  __$$BorrowImplCopyWithImpl(
      _$BorrowImpl _value, $Res Function(_$BorrowImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? orderNo = freezed,
    Object? user = freezed,
    Object? borrower = freezed,
    Object? warehouse = freezed,
    Object? borrowAt = freezed,
    Object? remark = freezed,
  }) {
    return _then(_$BorrowImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      orderNo: freezed == orderNo
          ? _value.orderNo
          : orderNo // ignore: cast_nullable_to_non_nullable
              as String?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      borrower: freezed == borrower
          ? _value.borrower
          : borrower // ignore: cast_nullable_to_non_nullable
              as User?,
      warehouse: freezed == warehouse
          ? _value.warehouse
          : warehouse // ignore: cast_nullable_to_non_nullable
              as Warehouse?,
      borrowAt: freezed == borrowAt
          ? _value.borrowAt
          : borrowAt // ignore: cast_nullable_to_non_nullable
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
class _$BorrowImpl implements _Borrow {
  _$BorrowImpl(
      {this.id,
      @JsonKey(name: 'order_no') this.orderNo,
      this.user,
      this.borrower,
      this.warehouse,
      @JsonKey(name: 'borrow_at') this.borrowAt,
      this.remark});

  factory _$BorrowImpl.fromJson(Map<String, dynamic> json) =>
      _$$BorrowImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: 'order_no')
  final String? orderNo;
  @override
  final User? user;
  @override
  final User? borrower;
  @override
  final Warehouse? warehouse;
  @override
  @JsonKey(name: 'borrow_at')
  final DateTime? borrowAt;
  @override
  final String? remark;

  @override
  String toString() {
    return 'Borrow(id: $id, orderNo: $orderNo, user: $user, borrower: $borrower, warehouse: $warehouse, borrowAt: $borrowAt, remark: $remark)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BorrowImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderNo, orderNo) || other.orderNo == orderNo) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.borrower, borrower) ||
                other.borrower == borrower) &&
            (identical(other.warehouse, warehouse) ||
                other.warehouse == warehouse) &&
            (identical(other.borrowAt, borrowAt) ||
                other.borrowAt == borrowAt) &&
            (identical(other.remark, remark) || other.remark == remark));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, orderNo, user, borrower, warehouse, borrowAt, remark);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BorrowImplCopyWith<_$BorrowImpl> get copyWith =>
      __$$BorrowImplCopyWithImpl<_$BorrowImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BorrowImplToJson(
      this,
    );
  }
}

abstract class _Borrow implements Borrow {
  factory _Borrow(
      {final int? id,
      @JsonKey(name: 'order_no') final String? orderNo,
      final User? user,
      final User? borrower,
      final Warehouse? warehouse,
      @JsonKey(name: 'borrow_at') final DateTime? borrowAt,
      final String? remark}) = _$BorrowImpl;

  factory _Borrow.fromJson(Map<String, dynamic> json) = _$BorrowImpl.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: 'order_no')
  String? get orderNo;
  @override
  User? get user;
  @override
  User? get borrower;
  @override
  Warehouse? get warehouse;
  @override
  @JsonKey(name: 'borrow_at')
  DateTime? get borrowAt;
  @override
  String? get remark;
  @override
  @JsonKey(ignore: true)
  _$$BorrowImplCopyWith<_$BorrowImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
