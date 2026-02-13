// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meta.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PurchaseAssistMeta _$PurchaseAssistMetaFromJson(Map<String, dynamic> json) {
  return _PurchaseAssistMeta.fromJson(json);
}

/// @nodoc
mixin _$PurchaseAssistMeta {
  String? get platform => throw _privateConstructorUsedError;
  PurchaseAssistPagination? get pagination =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PurchaseAssistMetaCopyWith<PurchaseAssistMeta> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseAssistMetaCopyWith<$Res> {
  factory $PurchaseAssistMetaCopyWith(
          PurchaseAssistMeta value, $Res Function(PurchaseAssistMeta) then) =
      _$PurchaseAssistMetaCopyWithImpl<$Res, PurchaseAssistMeta>;
  @useResult
  $Res call({String? platform, PurchaseAssistPagination? pagination});

  $PurchaseAssistPaginationCopyWith<$Res>? get pagination;
}

/// @nodoc
class _$PurchaseAssistMetaCopyWithImpl<$Res, $Val extends PurchaseAssistMeta>
    implements $PurchaseAssistMetaCopyWith<$Res> {
  _$PurchaseAssistMetaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? platform = freezed,
    Object? pagination = freezed,
  }) {
    return _then(_value.copyWith(
      platform: freezed == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String?,
      pagination: freezed == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as PurchaseAssistPagination?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PurchaseAssistPaginationCopyWith<$Res>? get pagination {
    if (_value.pagination == null) {
      return null;
    }

    return $PurchaseAssistPaginationCopyWith<$Res>(_value.pagination!, (value) {
      return _then(_value.copyWith(pagination: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PurchaseAssistMetaImplCopyWith<$Res>
    implements $PurchaseAssistMetaCopyWith<$Res> {
  factory _$$PurchaseAssistMetaImplCopyWith(_$PurchaseAssistMetaImpl value,
          $Res Function(_$PurchaseAssistMetaImpl) then) =
      __$$PurchaseAssistMetaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? platform, PurchaseAssistPagination? pagination});

  @override
  $PurchaseAssistPaginationCopyWith<$Res>? get pagination;
}

/// @nodoc
class __$$PurchaseAssistMetaImplCopyWithImpl<$Res>
    extends _$PurchaseAssistMetaCopyWithImpl<$Res, _$PurchaseAssistMetaImpl>
    implements _$$PurchaseAssistMetaImplCopyWith<$Res> {
  __$$PurchaseAssistMetaImplCopyWithImpl(_$PurchaseAssistMetaImpl _value,
      $Res Function(_$PurchaseAssistMetaImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? platform = freezed,
    Object? pagination = freezed,
  }) {
    return _then(_$PurchaseAssistMetaImpl(
      platform: freezed == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String?,
      pagination: freezed == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as PurchaseAssistPagination?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PurchaseAssistMetaImpl implements _PurchaseAssistMeta {
  const _$PurchaseAssistMetaImpl({this.platform, this.pagination});

  factory _$PurchaseAssistMetaImpl.fromJson(Map<String, dynamic> json) =>
      _$$PurchaseAssistMetaImplFromJson(json);

  @override
  final String? platform;
  @override
  final PurchaseAssistPagination? pagination;

  @override
  String toString() {
    return 'PurchaseAssistMeta(platform: $platform, pagination: $pagination)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseAssistMetaImpl &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.pagination, pagination) ||
                other.pagination == pagination));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, platform, pagination);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseAssistMetaImplCopyWith<_$PurchaseAssistMetaImpl> get copyWith =>
      __$$PurchaseAssistMetaImplCopyWithImpl<_$PurchaseAssistMetaImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PurchaseAssistMetaImplToJson(
      this,
    );
  }
}

abstract class _PurchaseAssistMeta implements PurchaseAssistMeta {
  const factory _PurchaseAssistMeta(
      {final String? platform,
      final PurchaseAssistPagination? pagination}) = _$PurchaseAssistMetaImpl;

  factory _PurchaseAssistMeta.fromJson(Map<String, dynamic> json) =
      _$PurchaseAssistMetaImpl.fromJson;

  @override
  String? get platform;
  @override
  PurchaseAssistPagination? get pagination;
  @override
  @JsonKey(ignore: true)
  _$$PurchaseAssistMetaImplCopyWith<_$PurchaseAssistMetaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PurchaseAssistPagination _$PurchaseAssistPaginationFromJson(
    Map<String, dynamic> json) {
  return _PurchaseAssistPagination.fromJson(json);
}

/// @nodoc
mixin _$PurchaseAssistPagination {
  int get total => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  @JsonKey(name: 'per_page')
  int? get perPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_page')
  int? get currentPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_pages')
  int get totalPages => throw _privateConstructorUsedError;
  Map<String, dynamic>? get links => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PurchaseAssistPaginationCopyWith<PurchaseAssistPagination> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseAssistPaginationCopyWith<$Res> {
  factory $PurchaseAssistPaginationCopyWith(PurchaseAssistPagination value,
          $Res Function(PurchaseAssistPagination) then) =
      _$PurchaseAssistPaginationCopyWithImpl<$Res, PurchaseAssistPagination>;
  @useResult
  $Res call(
      {int total,
      int count,
      @JsonKey(name: 'per_page') int? perPage,
      @JsonKey(name: 'current_page') int? currentPage,
      @JsonKey(name: 'total_pages') int totalPages,
      Map<String, dynamic>? links});
}

/// @nodoc
class _$PurchaseAssistPaginationCopyWithImpl<$Res,
        $Val extends PurchaseAssistPagination>
    implements $PurchaseAssistPaginationCopyWith<$Res> {
  _$PurchaseAssistPaginationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? count = null,
    Object? perPage = freezed,
    Object? currentPage = freezed,
    Object? totalPages = null,
    Object? links = freezed,
  }) {
    return _then(_value.copyWith(
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      perPage: freezed == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int?,
      currentPage: freezed == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int?,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      links: freezed == links
          ? _value.links
          : links // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PurchaseAssistPaginationImplCopyWith<$Res>
    implements $PurchaseAssistPaginationCopyWith<$Res> {
  factory _$$PurchaseAssistPaginationImplCopyWith(
          _$PurchaseAssistPaginationImpl value,
          $Res Function(_$PurchaseAssistPaginationImpl) then) =
      __$$PurchaseAssistPaginationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int total,
      int count,
      @JsonKey(name: 'per_page') int? perPage,
      @JsonKey(name: 'current_page') int? currentPage,
      @JsonKey(name: 'total_pages') int totalPages,
      Map<String, dynamic>? links});
}

/// @nodoc
class __$$PurchaseAssistPaginationImplCopyWithImpl<$Res>
    extends _$PurchaseAssistPaginationCopyWithImpl<$Res,
        _$PurchaseAssistPaginationImpl>
    implements _$$PurchaseAssistPaginationImplCopyWith<$Res> {
  __$$PurchaseAssistPaginationImplCopyWithImpl(
      _$PurchaseAssistPaginationImpl _value,
      $Res Function(_$PurchaseAssistPaginationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? count = null,
    Object? perPage = freezed,
    Object? currentPage = freezed,
    Object? totalPages = null,
    Object? links = freezed,
  }) {
    return _then(_$PurchaseAssistPaginationImpl(
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      perPage: freezed == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int?,
      currentPage: freezed == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int?,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      links: freezed == links
          ? _value._links
          : links // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PurchaseAssistPaginationImpl implements _PurchaseAssistPagination {
  const _$PurchaseAssistPaginationImpl(
      {required this.total,
      required this.count,
      @JsonKey(name: 'per_page') this.perPage,
      @JsonKey(name: 'current_page') this.currentPage,
      @JsonKey(name: 'total_pages') required this.totalPages,
      final Map<String, dynamic>? links})
      : _links = links;

  factory _$PurchaseAssistPaginationImpl.fromJson(Map<String, dynamic> json) =>
      _$$PurchaseAssistPaginationImplFromJson(json);

  @override
  final int total;
  @override
  final int count;
  @override
  @JsonKey(name: 'per_page')
  final int? perPage;
  @override
  @JsonKey(name: 'current_page')
  final int? currentPage;
  @override
  @JsonKey(name: 'total_pages')
  final int totalPages;
  final Map<String, dynamic>? _links;
  @override
  Map<String, dynamic>? get links {
    final value = _links;
    if (value == null) return null;
    if (_links is EqualUnmodifiableMapView) return _links;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'PurchaseAssistPagination(total: $total, count: $count, perPage: $perPage, currentPage: $currentPage, totalPages: $totalPages, links: $links)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseAssistPaginationImpl &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.perPage, perPage) || other.perPage == perPage) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            const DeepCollectionEquality().equals(other._links, _links));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, total, count, perPage,
      currentPage, totalPages, const DeepCollectionEquality().hash(_links));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseAssistPaginationImplCopyWith<_$PurchaseAssistPaginationImpl>
      get copyWith => __$$PurchaseAssistPaginationImplCopyWithImpl<
          _$PurchaseAssistPaginationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PurchaseAssistPaginationImplToJson(
      this,
    );
  }
}

abstract class _PurchaseAssistPagination implements PurchaseAssistPagination {
  const factory _PurchaseAssistPagination(
      {required final int total,
      required final int count,
      @JsonKey(name: 'per_page') final int? perPage,
      @JsonKey(name: 'current_page') final int? currentPage,
      @JsonKey(name: 'total_pages') required final int totalPages,
      final Map<String, dynamic>? links}) = _$PurchaseAssistPaginationImpl;

  factory _PurchaseAssistPagination.fromJson(Map<String, dynamic> json) =
      _$PurchaseAssistPaginationImpl.fromJson;

  @override
  int get total;
  @override
  int get count;
  @override
  @JsonKey(name: 'per_page')
  int? get perPage;
  @override
  @JsonKey(name: 'current_page')
  int? get currentPage;
  @override
  @JsonKey(name: 'total_pages')
  int get totalPages;
  @override
  Map<String, dynamic>? get links;
  @override
  @JsonKey(ignore: true)
  _$$PurchaseAssistPaginationImplCopyWith<_$PurchaseAssistPaginationImpl>
      get copyWith => throw _privateConstructorUsedError;
}
