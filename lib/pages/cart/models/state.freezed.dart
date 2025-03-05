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

/// @nodoc
mixin _$CartItem {
  Sample get sample => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  set count(int value) => throw _privateConstructorUsedError;

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

class _$CartItemImpl implements _CartItem {
  _$CartItemImpl({required this.sample, required this.count});

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
}

abstract class _CartItem implements CartItem {
  factory _CartItem({required final Sample sample, required int count}) =
      _$CartItemImpl;

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

/// @nodoc
mixin _$State {
  List<CartItem> get items => throw _privateConstructorUsedError;
  CartType? get type => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $StateCopyWith<State> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StateCopyWith<$Res> {
  factory $StateCopyWith(State value, $Res Function(State) then) =
      _$StateCopyWithImpl<$Res, State>;
  @useResult
  $Res call({List<CartItem> items, CartType? type});
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
    Object? type = freezed,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<CartItem>,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as CartType?,
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
  $Res call({List<CartItem> items, CartType? type});
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
    Object? type = freezed,
  }) {
    return _then(_$StateImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<CartItem>,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as CartType?,
    ));
  }
}

/// @nodoc

class _$StateImpl implements _State {
  const _$StateImpl({required final List<CartItem> items, this.type})
      : _items = items;

  final List<CartItem> _items;
  @override
  List<CartItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final CartType? type;

  @override
  String toString() {
    return 'State(items: $items, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StateImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_items), type);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StateImplCopyWith<_$StateImpl> get copyWith =>
      __$$StateImplCopyWithImpl<_$StateImpl>(this, _$identity);
}

abstract class _State implements State {
  const factory _State(
      {required final List<CartItem> items,
      final CartType? type}) = _$StateImpl;

  @override
  List<CartItem> get items;
  @override
  CartType? get type;
  @override
  @JsonKey(ignore: true)
  _$$StateImplCopyWith<_$StateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
