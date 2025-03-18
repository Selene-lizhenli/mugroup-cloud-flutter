// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TransferItem _$TransferItemFromJson(Map<String, dynamic> json) {
  return _TransferItem.fromJson(json);
}

/// @nodoc
mixin _$TransferItem {
  int? get id => throw _privateConstructorUsedError;
  Sample? get product => throw _privateConstructorUsedError;
  @JsonKey(name: 'in_qty')
  int? get inQty => throw _privateConstructorUsedError;
  @JsonKey(name: 'out_qty')
  int? get outQty => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransferItemCopyWith<TransferItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferItemCopyWith<$Res> {
  factory $TransferItemCopyWith(
          TransferItem value, $Res Function(TransferItem) then) =
      _$TransferItemCopyWithImpl<$Res, TransferItem>;
  @useResult
  $Res call(
      {int? id,
      Sample? product,
      @JsonKey(name: 'in_qty') int? inQty,
      @JsonKey(name: 'out_qty') int? outQty,
      String? notes});

  $SampleCopyWith<$Res>? get product;
}

/// @nodoc
class _$TransferItemCopyWithImpl<$Res, $Val extends TransferItem>
    implements $TransferItemCopyWith<$Res> {
  _$TransferItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? product = freezed,
    Object? inQty = freezed,
    Object? outQty = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      product: freezed == product
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as Sample?,
      inQty: freezed == inQty
          ? _value.inQty
          : inQty // ignore: cast_nullable_to_non_nullable
              as int?,
      outQty: freezed == outQty
          ? _value.outQty
          : outQty // ignore: cast_nullable_to_non_nullable
              as int?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SampleCopyWith<$Res>? get product {
    if (_value.product == null) {
      return null;
    }

    return $SampleCopyWith<$Res>(_value.product!, (value) {
      return _then(_value.copyWith(product: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TransferItemImplCopyWith<$Res>
    implements $TransferItemCopyWith<$Res> {
  factory _$$TransferItemImplCopyWith(
          _$TransferItemImpl value, $Res Function(_$TransferItemImpl) then) =
      __$$TransferItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      Sample? product,
      @JsonKey(name: 'in_qty') int? inQty,
      @JsonKey(name: 'out_qty') int? outQty,
      String? notes});

  @override
  $SampleCopyWith<$Res>? get product;
}

/// @nodoc
class __$$TransferItemImplCopyWithImpl<$Res>
    extends _$TransferItemCopyWithImpl<$Res, _$TransferItemImpl>
    implements _$$TransferItemImplCopyWith<$Res> {
  __$$TransferItemImplCopyWithImpl(
      _$TransferItemImpl _value, $Res Function(_$TransferItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? product = freezed,
    Object? inQty = freezed,
    Object? outQty = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$TransferItemImpl(
      freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      freezed == product
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as Sample?,
      freezed == inQty
          ? _value.inQty
          : inQty // ignore: cast_nullable_to_non_nullable
              as int?,
      freezed == outQty
          ? _value.outQty
          : outQty // ignore: cast_nullable_to_non_nullable
              as int?,
      freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransferItemImpl implements _TransferItem {
  _$TransferItemImpl(this.id, this.product, @JsonKey(name: 'in_qty') this.inQty,
      @JsonKey(name: 'out_qty') this.outQty, this.notes);

  factory _$TransferItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransferItemImplFromJson(json);

  @override
  final int? id;
  @override
  final Sample? product;
  @override
  @JsonKey(name: 'in_qty')
  final int? inQty;
  @override
  @JsonKey(name: 'out_qty')
  final int? outQty;
  @override
  final String? notes;

  @override
  String toString() {
    return 'TransferItem(id: $id, product: $product, inQty: $inQty, outQty: $outQty, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.product, product) || other.product == product) &&
            (identical(other.inQty, inQty) || other.inQty == inQty) &&
            (identical(other.outQty, outQty) || other.outQty == outQty) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, product, inQty, outQty, notes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferItemImplCopyWith<_$TransferItemImpl> get copyWith =>
      __$$TransferItemImplCopyWithImpl<_$TransferItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransferItemImplToJson(
      this,
    );
  }
}

abstract class _TransferItem implements TransferItem {
  factory _TransferItem(
      final int? id,
      final Sample? product,
      @JsonKey(name: 'in_qty') final int? inQty,
      @JsonKey(name: 'out_qty') final int? outQty,
      final String? notes) = _$TransferItemImpl;

  factory _TransferItem.fromJson(Map<String, dynamic> json) =
      _$TransferItemImpl.fromJson;

  @override
  int? get id;
  @override
  Sample? get product;
  @override
  @JsonKey(name: 'in_qty')
  int? get inQty;
  @override
  @JsonKey(name: 'out_qty')
  int? get outQty;
  @override
  String? get notes;
  @override
  @JsonKey(ignore: true)
  _$$TransferItemImplCopyWith<_$TransferItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
