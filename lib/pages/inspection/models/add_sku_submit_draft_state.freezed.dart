// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_sku_submit_draft_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AddSkuSubmitDraftState {
  AddSkuSubmitData? get data => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AddSkuSubmitDraftStateCopyWith<AddSkuSubmitDraftState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddSkuSubmitDraftStateCopyWith<$Res> {
  factory $AddSkuSubmitDraftStateCopyWith(AddSkuSubmitDraftState value,
          $Res Function(AddSkuSubmitDraftState) then) =
      _$AddSkuSubmitDraftStateCopyWithImpl<$Res, AddSkuSubmitDraftState>;
  @useResult
  $Res call({AddSkuSubmitData? data});
}

/// @nodoc
class _$AddSkuSubmitDraftStateCopyWithImpl<$Res,
        $Val extends AddSkuSubmitDraftState>
    implements $AddSkuSubmitDraftStateCopyWith<$Res> {
  _$AddSkuSubmitDraftStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as AddSkuSubmitData?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AddSkuSubmitDraftStateImplCopyWith<$Res>
    implements $AddSkuSubmitDraftStateCopyWith<$Res> {
  factory _$$AddSkuSubmitDraftStateImplCopyWith(
          _$AddSkuSubmitDraftStateImpl value,
          $Res Function(_$AddSkuSubmitDraftStateImpl) then) =
      __$$AddSkuSubmitDraftStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({AddSkuSubmitData? data});
}

/// @nodoc
class __$$AddSkuSubmitDraftStateImplCopyWithImpl<$Res>
    extends _$AddSkuSubmitDraftStateCopyWithImpl<$Res,
        _$AddSkuSubmitDraftStateImpl>
    implements _$$AddSkuSubmitDraftStateImplCopyWith<$Res> {
  __$$AddSkuSubmitDraftStateImplCopyWithImpl(
      _$AddSkuSubmitDraftStateImpl _value,
      $Res Function(_$AddSkuSubmitDraftStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_$AddSkuSubmitDraftStateImpl(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as AddSkuSubmitData?,
    ));
  }
}

/// @nodoc

class _$AddSkuSubmitDraftStateImpl implements _AddSkuSubmitDraftState {
  const _$AddSkuSubmitDraftStateImpl({this.data});

  @override
  final AddSkuSubmitData? data;

  @override
  String toString() {
    return 'AddSkuSubmitDraftState(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddSkuSubmitDraftStateImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AddSkuSubmitDraftStateImplCopyWith<_$AddSkuSubmitDraftStateImpl>
      get copyWith => __$$AddSkuSubmitDraftStateImplCopyWithImpl<
          _$AddSkuSubmitDraftStateImpl>(this, _$identity);
}

abstract class _AddSkuSubmitDraftState implements AddSkuSubmitDraftState {
  const factory _AddSkuSubmitDraftState({final AddSkuSubmitData? data}) =
      _$AddSkuSubmitDraftStateImpl;

  @override
  AddSkuSubmitData? get data;
  @override
  @JsonKey(ignore: true)
  _$$AddSkuSubmitDraftStateImplCopyWith<_$AddSkuSubmitDraftStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
