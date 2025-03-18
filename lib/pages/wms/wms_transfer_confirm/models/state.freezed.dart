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

TransferConfirmItem _$TransferConfirmItemFromJson(Map<String, dynamic> json) {
  return _TransferConfirmItem.fromJson(json);
}

/// @nodoc
mixin _$TransferConfirmItem {
  int? get id => throw _privateConstructorUsedError;
  set id(int? value) => throw _privateConstructorUsedError;
  Sample get product => throw _privateConstructorUsedError;
  set product(Sample value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'in_qty')
  int? get inQty => throw _privateConstructorUsedError;
  @JsonKey(name: 'in_qty')
  set inQty(int? value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'out_qty')
  int? get outQty => throw _privateConstructorUsedError;
  @JsonKey(name: 'out_qty')
  set outQty(int? value) => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  set count(int value) => throw _privateConstructorUsedError;
  bool? get checked => throw _privateConstructorUsedError;
  set checked(bool? value) => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  set notes(String? value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransferConfirmItemCopyWith<TransferConfirmItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferConfirmItemCopyWith<$Res> {
  factory $TransferConfirmItemCopyWith(
          TransferConfirmItem value, $Res Function(TransferConfirmItem) then) =
      _$TransferConfirmItemCopyWithImpl<$Res, TransferConfirmItem>;
  @useResult
  $Res call(
      {int? id,
      Sample product,
      @JsonKey(name: 'in_qty') int? inQty,
      @JsonKey(name: 'out_qty') int? outQty,
      int count,
      bool? checked,
      String? notes});

  $SampleCopyWith<$Res> get product;
}

/// @nodoc
class _$TransferConfirmItemCopyWithImpl<$Res, $Val extends TransferConfirmItem>
    implements $TransferConfirmItemCopyWith<$Res> {
  _$TransferConfirmItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? product = null,
    Object? inQty = freezed,
    Object? outQty = freezed,
    Object? count = null,
    Object? checked = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      product: null == product
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as Sample,
      inQty: freezed == inQty
          ? _value.inQty
          : inQty // ignore: cast_nullable_to_non_nullable
              as int?,
      outQty: freezed == outQty
          ? _value.outQty
          : outQty // ignore: cast_nullable_to_non_nullable
              as int?,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      checked: freezed == checked
          ? _value.checked
          : checked // ignore: cast_nullable_to_non_nullable
              as bool?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SampleCopyWith<$Res> get product {
    return $SampleCopyWith<$Res>(_value.product, (value) {
      return _then(_value.copyWith(product: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TransferConfirmItemImplCopyWith<$Res>
    implements $TransferConfirmItemCopyWith<$Res> {
  factory _$$TransferConfirmItemImplCopyWith(_$TransferConfirmItemImpl value,
          $Res Function(_$TransferConfirmItemImpl) then) =
      __$$TransferConfirmItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      Sample product,
      @JsonKey(name: 'in_qty') int? inQty,
      @JsonKey(name: 'out_qty') int? outQty,
      int count,
      bool? checked,
      String? notes});

  @override
  $SampleCopyWith<$Res> get product;
}

/// @nodoc
class __$$TransferConfirmItemImplCopyWithImpl<$Res>
    extends _$TransferConfirmItemCopyWithImpl<$Res, _$TransferConfirmItemImpl>
    implements _$$TransferConfirmItemImplCopyWith<$Res> {
  __$$TransferConfirmItemImplCopyWithImpl(_$TransferConfirmItemImpl _value,
      $Res Function(_$TransferConfirmItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? product = null,
    Object? inQty = freezed,
    Object? outQty = freezed,
    Object? count = null,
    Object? checked = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$TransferConfirmItemImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      product: null == product
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as Sample,
      inQty: freezed == inQty
          ? _value.inQty
          : inQty // ignore: cast_nullable_to_non_nullable
              as int?,
      outQty: freezed == outQty
          ? _value.outQty
          : outQty // ignore: cast_nullable_to_non_nullable
              as int?,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      checked: freezed == checked
          ? _value.checked
          : checked // ignore: cast_nullable_to_non_nullable
              as bool?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransferConfirmItemImpl implements _TransferConfirmItem {
  _$TransferConfirmItemImpl(
      {this.id,
      required this.product,
      @JsonKey(name: 'in_qty') this.inQty,
      @JsonKey(name: 'out_qty') this.outQty,
      required this.count,
      this.checked,
      this.notes});

  factory _$TransferConfirmItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransferConfirmItemImplFromJson(json);

  @override
  int? id;
  @override
  Sample product;
  @override
  @JsonKey(name: 'in_qty')
  int? inQty;
  @override
  @JsonKey(name: 'out_qty')
  int? outQty;
  @override
  int count;
  @override
  bool? checked;
  @override
  String? notes;

  @override
  String toString() {
    return 'TransferConfirmItem(id: $id, product: $product, inQty: $inQty, outQty: $outQty, count: $count, checked: $checked, notes: $notes)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferConfirmItemImplCopyWith<_$TransferConfirmItemImpl> get copyWith =>
      __$$TransferConfirmItemImplCopyWithImpl<_$TransferConfirmItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransferConfirmItemImplToJson(
      this,
    );
  }
}

abstract class _TransferConfirmItem implements TransferConfirmItem {
  factory _TransferConfirmItem(
      {int? id,
      required Sample product,
      @JsonKey(name: 'in_qty') int? inQty,
      @JsonKey(name: 'out_qty') int? outQty,
      required int count,
      bool? checked,
      String? notes}) = _$TransferConfirmItemImpl;

  factory _TransferConfirmItem.fromJson(Map<String, dynamic> json) =
      _$TransferConfirmItemImpl.fromJson;

  @override
  int? get id;
  set id(int? value);
  @override
  Sample get product;
  set product(Sample value);
  @override
  @JsonKey(name: 'in_qty')
  int? get inQty;
  @JsonKey(name: 'in_qty')
  set inQty(int? value);
  @override
  @JsonKey(name: 'out_qty')
  int? get outQty;
  @JsonKey(name: 'out_qty')
  set outQty(int? value);
  @override
  int get count;
  set count(int value);
  @override
  bool? get checked;
  set checked(bool? value);
  @override
  String? get notes;
  set notes(String? value);
  @override
  @JsonKey(ignore: true)
  _$$TransferConfirmItemImplCopyWith<_$TransferConfirmItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

State _$StateFromJson(Map<String, dynamic> json) {
  return _State.fromJson(json);
}

/// @nodoc
mixin _$State {
  List<TransferConfirmItem> get items => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StateCopyWith<State> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StateCopyWith<$Res> {
  factory $StateCopyWith(State value, $Res Function(State) then) =
      _$StateCopyWithImpl<$Res, State>;
  @useResult
  $Res call({List<TransferConfirmItem> items});
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
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<TransferConfirmItem>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StateImplCopyWith<$Res> implements $StateCopyWith<$Res> {
  factory _$$StateImplCopyWith(
          _$StateImpl value, $Res Function(_$StateImpl) then) =
      __$$StateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<TransferConfirmItem> items});
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
  }) {
    return _then(_$StateImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<TransferConfirmItem>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StateImpl implements _State {
  const _$StateImpl({required final List<TransferConfirmItem> items})
      : _items = items;

  factory _$StateImpl.fromJson(Map<String, dynamic> json) =>
      _$$StateImplFromJson(json);

  final List<TransferConfirmItem> _items;
  @override
  List<TransferConfirmItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'State(items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StateImpl &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_items));

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
  const factory _State({required final List<TransferConfirmItem> items}) =
      _$StateImpl;

  factory _State.fromJson(Map<String, dynamic> json) = _$StateImpl.fromJson;

  @override
  List<TransferConfirmItem> get items;
  @override
  @JsonKey(ignore: true)
  _$$StateImplCopyWith<_$StateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
