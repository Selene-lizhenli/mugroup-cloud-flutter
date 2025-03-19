// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CartSelect _$CartSelectFromJson(Map<String, dynamic> json) {
  return _CartSelect.fromJson(json);
}

/// @nodoc
mixin _$CartSelect {
  CartType get type => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CartSelectCopyWith<CartSelect> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartSelectCopyWith<$Res> {
  factory $CartSelectCopyWith(
          CartSelect value, $Res Function(CartSelect) then) =
      _$CartSelectCopyWithImpl<$Res, CartSelect>;
  @useResult
  $Res call({CartType type});
}

/// @nodoc
class _$CartSelectCopyWithImpl<$Res, $Val extends CartSelect>
    implements $CartSelectCopyWith<$Res> {
  _$CartSelectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as CartType,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CartSelectImplCopyWith<$Res>
    implements $CartSelectCopyWith<$Res> {
  factory _$$CartSelectImplCopyWith(
          _$CartSelectImpl value, $Res Function(_$CartSelectImpl) then) =
      __$$CartSelectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({CartType type});
}

/// @nodoc
class __$$CartSelectImplCopyWithImpl<$Res>
    extends _$CartSelectCopyWithImpl<$Res, _$CartSelectImpl>
    implements _$$CartSelectImplCopyWith<$Res> {
  __$$CartSelectImplCopyWithImpl(
      _$CartSelectImpl _value, $Res Function(_$CartSelectImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
  }) {
    return _then(_$CartSelectImpl(
      null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as CartType,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CartSelectImpl extends _CartSelect {
  const _$CartSelectImpl(this.type) : super._();

  factory _$CartSelectImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartSelectImplFromJson(json);

  @override
  final CartType type;

  @override
  String toString() {
    return 'CartSelect(type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartSelectImpl &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, type);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CartSelectImplCopyWith<_$CartSelectImpl> get copyWith =>
      __$$CartSelectImplCopyWithImpl<_$CartSelectImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CartSelectImplToJson(
      this,
    );
  }
}

abstract class _CartSelect extends CartSelect {
  const factory _CartSelect(final CartType type) = _$CartSelectImpl;
  const _CartSelect._() : super._();

  factory _CartSelect.fromJson(Map<String, dynamic> json) =
      _$CartSelectImpl.fromJson;

  @override
  CartType get type;
  @override
  @JsonKey(ignore: true)
  _$$CartSelectImplCopyWith<_$CartSelectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuotationInfo _$QuotationInfoFromJson(Map<String, dynamic> json) {
  return _QuotationInfo.fromJson(json);
}

/// @nodoc
mixin _$QuotationInfo {
  String? get curreny => throw _privateConstructorUsedError;
  double? get exchange => throw _privateConstructorUsedError;
  double? get commissionRate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuotationInfoCopyWith<QuotationInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuotationInfoCopyWith<$Res> {
  factory $QuotationInfoCopyWith(
          QuotationInfo value, $Res Function(QuotationInfo) then) =
      _$QuotationInfoCopyWithImpl<$Res, QuotationInfo>;
  @useResult
  $Res call({String? curreny, double? exchange, double? commissionRate});
}

/// @nodoc
class _$QuotationInfoCopyWithImpl<$Res, $Val extends QuotationInfo>
    implements $QuotationInfoCopyWith<$Res> {
  _$QuotationInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? curreny = freezed,
    Object? exchange = freezed,
    Object? commissionRate = freezed,
  }) {
    return _then(_value.copyWith(
      curreny: freezed == curreny
          ? _value.curreny
          : curreny // ignore: cast_nullable_to_non_nullable
              as String?,
      exchange: freezed == exchange
          ? _value.exchange
          : exchange // ignore: cast_nullable_to_non_nullable
              as double?,
      commissionRate: freezed == commissionRate
          ? _value.commissionRate
          : commissionRate // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuotationInfoImplCopyWith<$Res>
    implements $QuotationInfoCopyWith<$Res> {
  factory _$$QuotationInfoImplCopyWith(
          _$QuotationInfoImpl value, $Res Function(_$QuotationInfoImpl) then) =
      __$$QuotationInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? curreny, double? exchange, double? commissionRate});
}

/// @nodoc
class __$$QuotationInfoImplCopyWithImpl<$Res>
    extends _$QuotationInfoCopyWithImpl<$Res, _$QuotationInfoImpl>
    implements _$$QuotationInfoImplCopyWith<$Res> {
  __$$QuotationInfoImplCopyWithImpl(
      _$QuotationInfoImpl _value, $Res Function(_$QuotationInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? curreny = freezed,
    Object? exchange = freezed,
    Object? commissionRate = freezed,
  }) {
    return _then(_$QuotationInfoImpl(
      freezed == curreny
          ? _value.curreny
          : curreny // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == exchange
          ? _value.exchange
          : exchange // ignore: cast_nullable_to_non_nullable
              as double?,
      freezed == commissionRate
          ? _value.commissionRate
          : commissionRate // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuotationInfoImpl extends _QuotationInfo {
  const _$QuotationInfoImpl(this.curreny, this.exchange, this.commissionRate)
      : super._();

  factory _$QuotationInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuotationInfoImplFromJson(json);

  @override
  final String? curreny;
  @override
  final double? exchange;
  @override
  final double? commissionRate;

  @override
  String toString() {
    return 'QuotationInfo(curreny: $curreny, exchange: $exchange, commissionRate: $commissionRate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuotationInfoImpl &&
            (identical(other.curreny, curreny) || other.curreny == curreny) &&
            (identical(other.exchange, exchange) ||
                other.exchange == exchange) &&
            (identical(other.commissionRate, commissionRate) ||
                other.commissionRate == commissionRate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, curreny, exchange, commissionRate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuotationInfoImplCopyWith<_$QuotationInfoImpl> get copyWith =>
      __$$QuotationInfoImplCopyWithImpl<_$QuotationInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuotationInfoImplToJson(
      this,
    );
  }
}

abstract class _QuotationInfo extends QuotationInfo {
  const factory _QuotationInfo(final String? curreny, final double? exchange,
      final double? commissionRate) = _$QuotationInfoImpl;
  const _QuotationInfo._() : super._();

  factory _QuotationInfo.fromJson(Map<String, dynamic> json) =
      _$QuotationInfoImpl.fromJson;

  @override
  String? get curreny;
  @override
  double? get exchange;
  @override
  double? get commissionRate;
  @override
  @JsonKey(ignore: true)
  _$$QuotationInfoImplCopyWith<_$QuotationInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CartItem _$CartItemFromJson(Map<String, dynamic> json) {
  return _CartItem.fromJson(json);
}

/// @nodoc
mixin _$CartItem {
  Sample get sample => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  set count(int value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CartItemCopyWith<CartItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartItemCopyWith<$Res> {
  factory $CartItemCopyWith(CartItem value, $Res Function(CartItem) then) =
      _$CartItemCopyWithImpl<$Res, CartItem>;
  @useResult
  $Res call({Sample sample, int count});

  $SampleCopyWith<$Res> get sample;
}

/// @nodoc
class _$CartItemCopyWithImpl<$Res, $Val extends CartItem>
    implements $CartItemCopyWith<$Res> {
  _$CartItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sample = null,
    Object? count = null,
  }) {
    return _then(_value.copyWith(
      sample: null == sample
          ? _value.sample
          : sample // ignore: cast_nullable_to_non_nullable
              as Sample,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SampleCopyWith<$Res> get sample {
    return $SampleCopyWith<$Res>(_value.sample, (value) {
      return _then(_value.copyWith(sample: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CartItemImplCopyWith<$Res>
    implements $CartItemCopyWith<$Res> {
  factory _$$CartItemImplCopyWith(
          _$CartItemImpl value, $Res Function(_$CartItemImpl) then) =
      __$$CartItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Sample sample, int count});

  @override
  $SampleCopyWith<$Res> get sample;
}

/// @nodoc
class __$$CartItemImplCopyWithImpl<$Res>
    extends _$CartItemCopyWithImpl<$Res, _$CartItemImpl>
    implements _$$CartItemImplCopyWith<$Res> {
  __$$CartItemImplCopyWithImpl(
      _$CartItemImpl _value, $Res Function(_$CartItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sample = null,
    Object? count = null,
  }) {
    return _then(_$CartItemImpl(
      sample: null == sample
          ? _value.sample
          : sample // ignore: cast_nullable_to_non_nullable
              as Sample,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CartItemImpl implements _CartItem {
  _$CartItemImpl({required this.sample, required this.count});

  factory _$CartItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartItemImplFromJson(json);

  @override
  final Sample sample;
  @override
  int count;

  @override
  String toString() {
    return 'CartItem(sample: $sample, count: $count)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CartItemImplCopyWith<_$CartItemImpl> get copyWith =>
      __$$CartItemImplCopyWithImpl<_$CartItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CartItemImplToJson(
      this,
    );
  }
}

abstract class _CartItem implements CartItem {
  factory _CartItem({required final Sample sample, required int count}) =
      _$CartItemImpl;

  factory _CartItem.fromJson(Map<String, dynamic> json) =
      _$CartItemImpl.fromJson;

  @override
  Sample get sample;
  @override
  int get count;
  set count(int value);
  @override
  @JsonKey(ignore: true)
  _$$CartItemImplCopyWith<_$CartItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

State _$StateFromJson(Map<String, dynamic> json) {
  return _State.fromJson(json);
}

/// @nodoc
mixin _$State {
  List<CartItem> get items => throw _privateConstructorUsedError;
  List<CartSelect> get carts => throw _privateConstructorUsedError;
  Warehouse? get warehouse => throw _privateConstructorUsedError;
  Borrow? get borrow => throw _privateConstructorUsedError;
  Transfer? get transfer => throw _privateConstructorUsedError;
  CartType? get type => throw _privateConstructorUsedError;
  String? get cartName => throw _privateConstructorUsedError;
  QuotationInfo? get quotationInfo => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StateCopyWith<State> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StateCopyWith<$Res> {
  factory $StateCopyWith(State value, $Res Function(State) then) =
      _$StateCopyWithImpl<$Res, State>;
  @useResult
  $Res call(
      {List<CartItem> items,
      List<CartSelect> carts,
      Warehouse? warehouse,
      Borrow? borrow,
      Transfer? transfer,
      CartType? type,
      String? cartName,
      QuotationInfo? quotationInfo});

  $WarehouseCopyWith<$Res>? get warehouse;
  $BorrowCopyWith<$Res>? get borrow;
  $TransferCopyWith<$Res>? get transfer;
  $QuotationInfoCopyWith<$Res>? get quotationInfo;
}

/// @nodoc
class _$StateCopyWithImpl<$Res, $Val extends State>
    implements $StateCopyWith<$Res> {
  _$StateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? carts = null,
    Object? warehouse = freezed,
    Object? borrow = freezed,
    Object? transfer = freezed,
    Object? type = freezed,
    Object? cartName = freezed,
    Object? quotationInfo = freezed,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<CartItem>,
      carts: null == carts
          ? _value.carts
          : carts // ignore: cast_nullable_to_non_nullable
              as List<CartSelect>,
      warehouse: freezed == warehouse
          ? _value.warehouse
          : warehouse // ignore: cast_nullable_to_non_nullable
              as Warehouse?,
      borrow: freezed == borrow
          ? _value.borrow
          : borrow // ignore: cast_nullable_to_non_nullable
              as Borrow?,
      transfer: freezed == transfer
          ? _value.transfer
          : transfer // ignore: cast_nullable_to_non_nullable
              as Transfer?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as CartType?,
      cartName: freezed == cartName
          ? _value.cartName
          : cartName // ignore: cast_nullable_to_non_nullable
              as String?,
      quotationInfo: freezed == quotationInfo
          ? _value.quotationInfo
          : quotationInfo // ignore: cast_nullable_to_non_nullable
              as QuotationInfo?,
    ) as $Val);
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

  @override
  @pragma('vm:prefer-inline')
  $BorrowCopyWith<$Res>? get borrow {
    if (_value.borrow == null) {
      return null;
    }

    return $BorrowCopyWith<$Res>(_value.borrow!, (value) {
      return _then(_value.copyWith(borrow: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $TransferCopyWith<$Res>? get transfer {
    if (_value.transfer == null) {
      return null;
    }

    return $TransferCopyWith<$Res>(_value.transfer!, (value) {
      return _then(_value.copyWith(transfer: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $QuotationInfoCopyWith<$Res>? get quotationInfo {
    if (_value.quotationInfo == null) {
      return null;
    }

    return $QuotationInfoCopyWith<$Res>(_value.quotationInfo!, (value) {
      return _then(_value.copyWith(quotationInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StateImplCopyWith<$Res> implements $StateCopyWith<$Res> {
  factory _$$StateImplCopyWith(
          _$StateImpl value, $Res Function(_$StateImpl) then) =
      __$$StateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<CartItem> items,
      List<CartSelect> carts,
      Warehouse? warehouse,
      Borrow? borrow,
      Transfer? transfer,
      CartType? type,
      String? cartName,
      QuotationInfo? quotationInfo});

  @override
  $WarehouseCopyWith<$Res>? get warehouse;
  @override
  $BorrowCopyWith<$Res>? get borrow;
  @override
  $TransferCopyWith<$Res>? get transfer;
  @override
  $QuotationInfoCopyWith<$Res>? get quotationInfo;
}

/// @nodoc
class __$$StateImplCopyWithImpl<$Res>
    extends _$StateCopyWithImpl<$Res, _$StateImpl>
    implements _$$StateImplCopyWith<$Res> {
  __$$StateImplCopyWithImpl(
      _$StateImpl _value, $Res Function(_$StateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? carts = null,
    Object? warehouse = freezed,
    Object? borrow = freezed,
    Object? transfer = freezed,
    Object? type = freezed,
    Object? cartName = freezed,
    Object? quotationInfo = freezed,
  }) {
    return _then(_$StateImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<CartItem>,
      carts: null == carts
          ? _value._carts
          : carts // ignore: cast_nullable_to_non_nullable
              as List<CartSelect>,
      warehouse: freezed == warehouse
          ? _value.warehouse
          : warehouse // ignore: cast_nullable_to_non_nullable
              as Warehouse?,
      borrow: freezed == borrow
          ? _value.borrow
          : borrow // ignore: cast_nullable_to_non_nullable
              as Borrow?,
      transfer: freezed == transfer
          ? _value.transfer
          : transfer // ignore: cast_nullable_to_non_nullable
              as Transfer?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as CartType?,
      cartName: freezed == cartName
          ? _value.cartName
          : cartName // ignore: cast_nullable_to_non_nullable
              as String?,
      quotationInfo: freezed == quotationInfo
          ? _value.quotationInfo
          : quotationInfo // ignore: cast_nullable_to_non_nullable
              as QuotationInfo?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StateImpl implements _State {
  const _$StateImpl(
      {required final List<CartItem> items,
      required final List<CartSelect> carts,
      this.warehouse,
      this.borrow,
      this.transfer,
      this.type,
      this.cartName,
      this.quotationInfo})
      : _items = items,
        _carts = carts;

  factory _$StateImpl.fromJson(Map<String, dynamic> json) =>
      _$$StateImplFromJson(json);

  final List<CartItem> _items;
  @override
  List<CartItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final List<CartSelect> _carts;
  @override
  List<CartSelect> get carts {
    if (_carts is EqualUnmodifiableListView) return _carts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_carts);
  }

  @override
  final Warehouse? warehouse;
  @override
  final Borrow? borrow;
  @override
  final Transfer? transfer;
  @override
  final CartType? type;
  @override
  final String? cartName;
  @override
  final QuotationInfo? quotationInfo;

  @override
  String toString() {
    return 'State(items: $items, carts: $carts, warehouse: $warehouse, borrow: $borrow, transfer: $transfer, type: $type, cartName: $cartName, quotationInfo: $quotationInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StateImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality().equals(other._carts, _carts) &&
            (identical(other.warehouse, warehouse) ||
                other.warehouse == warehouse) &&
            (identical(other.borrow, borrow) || other.borrow == borrow) &&
            (identical(other.transfer, transfer) ||
                other.transfer == transfer) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.cartName, cartName) ||
                other.cartName == cartName) &&
            (identical(other.quotationInfo, quotationInfo) ||
                other.quotationInfo == quotationInfo));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_items),
      const DeepCollectionEquality().hash(_carts),
      warehouse,
      borrow,
      transfer,
      type,
      cartName,
      quotationInfo);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StateImplCopyWith<_$StateImpl> get copyWith =>
      __$$StateImplCopyWithImpl<_$StateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StateImplToJson(
      this,
    );
  }
}

abstract class _State implements State {
  const factory _State(
      {required final List<CartItem> items,
      required final List<CartSelect> carts,
      final Warehouse? warehouse,
      final Borrow? borrow,
      final Transfer? transfer,
      final CartType? type,
      final String? cartName,
      final QuotationInfo? quotationInfo}) = _$StateImpl;

  factory _State.fromJson(Map<String, dynamic> json) = _$StateImpl.fromJson;

  @override
  List<CartItem> get items;
  @override
  List<CartSelect> get carts;
  @override
  Warehouse? get warehouse;
  @override
  Borrow? get borrow;
  @override
  Transfer? get transfer;
  @override
  CartType? get type;
  @override
  String? get cartName;
  @override
  QuotationInfo? get quotationInfo;
  @override
  @JsonKey(ignore: true)
  _$$StateImplCopyWith<_$StateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
