// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HomeState {
  RxBus get bus => throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;
  PageController get pageController => throw _privateConstructorUsedError;
  TextEditingController get searchTextController =>
      throw _privateConstructorUsedError;
  String? get search => throw _privateConstructorUsedError;
  List<TemporaryMedia> get media => throw _privateConstructorUsedError;
  int? get currentMediaId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HomeStateCopyWith<HomeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) then) =
      _$HomeStateCopyWithImpl<$Res, HomeState>;
  @useResult
  $Res call(
      {RxBus bus,
      int currentPage,
      PageController pageController,
      TextEditingController searchTextController,
      String? search,
      List<TemporaryMedia> media,
      int? currentMediaId});
}

/// @nodoc
class _$HomeStateCopyWithImpl<$Res, $Val extends HomeState>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bus = null,
    Object? currentPage = null,
    Object? pageController = null,
    Object? searchTextController = null,
    Object? search = freezed,
    Object? media = null,
    Object? currentMediaId = freezed,
  }) {
    return _then(_value.copyWith(
      bus: null == bus
          ? _value.bus
          : bus // ignore: cast_nullable_to_non_nullable
              as RxBus,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      pageController: null == pageController
          ? _value.pageController
          : pageController // ignore: cast_nullable_to_non_nullable
              as PageController,
      searchTextController: null == searchTextController
          ? _value.searchTextController
          : searchTextController // ignore: cast_nullable_to_non_nullable
              as TextEditingController,
      search: freezed == search
          ? _value.search
          : search // ignore: cast_nullable_to_non_nullable
              as String?,
      media: null == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as List<TemporaryMedia>,
      currentMediaId: freezed == currentMediaId
          ? _value.currentMediaId
          : currentMediaId // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HomeStateImplCopyWith<$Res>
    implements $HomeStateCopyWith<$Res> {
  factory _$$HomeStateImplCopyWith(
          _$HomeStateImpl value, $Res Function(_$HomeStateImpl) then) =
      __$$HomeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {RxBus bus,
      int currentPage,
      PageController pageController,
      TextEditingController searchTextController,
      String? search,
      List<TemporaryMedia> media,
      int? currentMediaId});
}

/// @nodoc
class __$$HomeStateImplCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$HomeStateImpl>
    implements _$$HomeStateImplCopyWith<$Res> {
  __$$HomeStateImplCopyWithImpl(
      _$HomeStateImpl _value, $Res Function(_$HomeStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bus = null,
    Object? currentPage = null,
    Object? pageController = null,
    Object? searchTextController = null,
    Object? search = freezed,
    Object? media = null,
    Object? currentMediaId = freezed,
  }) {
    return _then(_$HomeStateImpl(
      bus: null == bus
          ? _value.bus
          : bus // ignore: cast_nullable_to_non_nullable
              as RxBus,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      pageController: null == pageController
          ? _value.pageController
          : pageController // ignore: cast_nullable_to_non_nullable
              as PageController,
      searchTextController: null == searchTextController
          ? _value.searchTextController
          : searchTextController // ignore: cast_nullable_to_non_nullable
              as TextEditingController,
      search: freezed == search
          ? _value.search
          : search // ignore: cast_nullable_to_non_nullable
              as String?,
      media: null == media
          ? _value._media
          : media // ignore: cast_nullable_to_non_nullable
              as List<TemporaryMedia>,
      currentMediaId: freezed == currentMediaId
          ? _value.currentMediaId
          : currentMediaId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$HomeStateImpl implements _HomeState {
  const _$HomeStateImpl(
      {required this.bus,
      required this.currentPage,
      required this.pageController,
      required this.searchTextController,
      this.search,
      required final List<TemporaryMedia> media,
      this.currentMediaId})
      : _media = media;

  @override
  final RxBus bus;
  @override
  final int currentPage;
  @override
  final PageController pageController;
  @override
  final TextEditingController searchTextController;
  @override
  final String? search;
  final List<TemporaryMedia> _media;
  @override
  List<TemporaryMedia> get media {
    if (_media is EqualUnmodifiableListView) return _media;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_media);
  }

  @override
  final int? currentMediaId;

  @override
  String toString() {
    return 'HomeState(bus: $bus, currentPage: $currentPage, pageController: $pageController, searchTextController: $searchTextController, search: $search, media: $media, currentMediaId: $currentMediaId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeStateImpl &&
            (identical(other.bus, bus) || other.bus == bus) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.pageController, pageController) ||
                other.pageController == pageController) &&
            (identical(other.searchTextController, searchTextController) ||
                other.searchTextController == searchTextController) &&
            (identical(other.search, search) || other.search == search) &&
            const DeepCollectionEquality().equals(other._media, _media) &&
            (identical(other.currentMediaId, currentMediaId) ||
                other.currentMediaId == currentMediaId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      bus,
      currentPage,
      pageController,
      searchTextController,
      search,
      const DeepCollectionEquality().hash(_media),
      currentMediaId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      __$$HomeStateImplCopyWithImpl<_$HomeStateImpl>(this, _$identity);
}

abstract class _HomeState implements HomeState {
  const factory _HomeState(
      {required final RxBus bus,
      required final int currentPage,
      required final PageController pageController,
      required final TextEditingController searchTextController,
      final String? search,
      required final List<TemporaryMedia> media,
      final int? currentMediaId}) = _$HomeStateImpl;

  @override
  RxBus get bus;
  @override
  int get currentPage;
  @override
  PageController get pageController;
  @override
  TextEditingController get searchTextController;
  @override
  String? get search;
  @override
  List<TemporaryMedia> get media;
  @override
  int? get currentMediaId;
  @override
  @JsonKey(ignore: true)
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
