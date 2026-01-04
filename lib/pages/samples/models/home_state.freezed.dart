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
  int? get currentMediaId => throw _privateConstructorUsedError; // 当前选中的媒体id
// ----------  样品 ----------
  List<Sample> get samples => throw _privateConstructorUsedError;
  List<FacetCount> get facetCounts => throw _privateConstructorUsedError;
  int get samplePages => throw _privateConstructorUsedError;
  bool get sampleNoMore =>
      throw _privateConstructorUsedError; // ----------  服务商 ----------
  List<Supplier> get suppliers => throw _privateConstructorUsedError;
  int get supplierPages => throw _privateConstructorUsedError;
  bool get supplierNoMore =>
      throw _privateConstructorUsedError; // ----------  样品间 ----------
  List<Warehouse> get warehouses => throw _privateConstructorUsedError;
  bool get isLoadingWarehouses => throw _privateConstructorUsedError;
  Warehouse? get currentSelectedWarehouse => throw _privateConstructorUsedError;

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
      int? currentMediaId,
      List<Sample> samples,
      List<FacetCount> facetCounts,
      int samplePages,
      bool sampleNoMore,
      List<Supplier> suppliers,
      int supplierPages,
      bool supplierNoMore,
      List<Warehouse> warehouses,
      bool isLoadingWarehouses,
      Warehouse? currentSelectedWarehouse});

  $WarehouseCopyWith<$Res>? get currentSelectedWarehouse;
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
    Object? samples = null,
    Object? facetCounts = null,
    Object? samplePages = null,
    Object? sampleNoMore = null,
    Object? suppliers = null,
    Object? supplierPages = null,
    Object? supplierNoMore = null,
    Object? warehouses = null,
    Object? isLoadingWarehouses = null,
    Object? currentSelectedWarehouse = freezed,
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
      samples: null == samples
          ? _value.samples
          : samples // ignore: cast_nullable_to_non_nullable
              as List<Sample>,
      facetCounts: null == facetCounts
          ? _value.facetCounts
          : facetCounts // ignore: cast_nullable_to_non_nullable
              as List<FacetCount>,
      samplePages: null == samplePages
          ? _value.samplePages
          : samplePages // ignore: cast_nullable_to_non_nullable
              as int,
      sampleNoMore: null == sampleNoMore
          ? _value.sampleNoMore
          : sampleNoMore // ignore: cast_nullable_to_non_nullable
              as bool,
      suppliers: null == suppliers
          ? _value.suppliers
          : suppliers // ignore: cast_nullable_to_non_nullable
              as List<Supplier>,
      supplierPages: null == supplierPages
          ? _value.supplierPages
          : supplierPages // ignore: cast_nullable_to_non_nullable
              as int,
      supplierNoMore: null == supplierNoMore
          ? _value.supplierNoMore
          : supplierNoMore // ignore: cast_nullable_to_non_nullable
              as bool,
      warehouses: null == warehouses
          ? _value.warehouses
          : warehouses // ignore: cast_nullable_to_non_nullable
              as List<Warehouse>,
      isLoadingWarehouses: null == isLoadingWarehouses
          ? _value.isLoadingWarehouses
          : isLoadingWarehouses // ignore: cast_nullable_to_non_nullable
              as bool,
      currentSelectedWarehouse: freezed == currentSelectedWarehouse
          ? _value.currentSelectedWarehouse
          : currentSelectedWarehouse // ignore: cast_nullable_to_non_nullable
              as Warehouse?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $WarehouseCopyWith<$Res>? get currentSelectedWarehouse {
    if (_value.currentSelectedWarehouse == null) {
      return null;
    }

    return $WarehouseCopyWith<$Res>(_value.currentSelectedWarehouse!, (value) {
      return _then(_value.copyWith(currentSelectedWarehouse: value) as $Val);
    });
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
      int? currentMediaId,
      List<Sample> samples,
      List<FacetCount> facetCounts,
      int samplePages,
      bool sampleNoMore,
      List<Supplier> suppliers,
      int supplierPages,
      bool supplierNoMore,
      List<Warehouse> warehouses,
      bool isLoadingWarehouses,
      Warehouse? currentSelectedWarehouse});

  @override
  $WarehouseCopyWith<$Res>? get currentSelectedWarehouse;
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
    Object? samples = null,
    Object? facetCounts = null,
    Object? samplePages = null,
    Object? sampleNoMore = null,
    Object? suppliers = null,
    Object? supplierPages = null,
    Object? supplierNoMore = null,
    Object? warehouses = null,
    Object? isLoadingWarehouses = null,
    Object? currentSelectedWarehouse = freezed,
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
      samples: null == samples
          ? _value._samples
          : samples // ignore: cast_nullable_to_non_nullable
              as List<Sample>,
      facetCounts: null == facetCounts
          ? _value._facetCounts
          : facetCounts // ignore: cast_nullable_to_non_nullable
              as List<FacetCount>,
      samplePages: null == samplePages
          ? _value.samplePages
          : samplePages // ignore: cast_nullable_to_non_nullable
              as int,
      sampleNoMore: null == sampleNoMore
          ? _value.sampleNoMore
          : sampleNoMore // ignore: cast_nullable_to_non_nullable
              as bool,
      suppliers: null == suppliers
          ? _value._suppliers
          : suppliers // ignore: cast_nullable_to_non_nullable
              as List<Supplier>,
      supplierPages: null == supplierPages
          ? _value.supplierPages
          : supplierPages // ignore: cast_nullable_to_non_nullable
              as int,
      supplierNoMore: null == supplierNoMore
          ? _value.supplierNoMore
          : supplierNoMore // ignore: cast_nullable_to_non_nullable
              as bool,
      warehouses: null == warehouses
          ? _value._warehouses
          : warehouses // ignore: cast_nullable_to_non_nullable
              as List<Warehouse>,
      isLoadingWarehouses: null == isLoadingWarehouses
          ? _value.isLoadingWarehouses
          : isLoadingWarehouses // ignore: cast_nullable_to_non_nullable
              as bool,
      currentSelectedWarehouse: freezed == currentSelectedWarehouse
          ? _value.currentSelectedWarehouse
          : currentSelectedWarehouse // ignore: cast_nullable_to_non_nullable
              as Warehouse?,
    ));
  }
}

/// @nodoc

class _$HomeStateImpl extends _HomeState {
  const _$HomeStateImpl(
      {required this.bus,
      required this.currentPage,
      required this.pageController,
      required this.searchTextController,
      this.search,
      required final List<TemporaryMedia> media,
      this.currentMediaId,
      final List<Sample> samples = const [],
      final List<FacetCount> facetCounts = const [],
      this.samplePages = 1,
      this.sampleNoMore = false,
      final List<Supplier> suppliers = const [],
      this.supplierPages = 1,
      this.supplierNoMore = false,
      final List<Warehouse> warehouses = const [],
      this.isLoadingWarehouses = false,
      this.currentSelectedWarehouse})
      : _media = media,
        _samples = samples,
        _facetCounts = facetCounts,
        _suppliers = suppliers,
        _warehouses = warehouses,
        super._();

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
// 当前选中的媒体id
// ----------  样品 ----------
  final List<Sample> _samples;
// 当前选中的媒体id
// ----------  样品 ----------
  @override
  @JsonKey()
  List<Sample> get samples {
    if (_samples is EqualUnmodifiableListView) return _samples;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_samples);
  }

  final List<FacetCount> _facetCounts;
  @override
  @JsonKey()
  List<FacetCount> get facetCounts {
    if (_facetCounts is EqualUnmodifiableListView) return _facetCounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_facetCounts);
  }

  @override
  @JsonKey()
  final int samplePages;
  @override
  @JsonKey()
  final bool sampleNoMore;
// ----------  服务商 ----------
  final List<Supplier> _suppliers;
// ----------  服务商 ----------
  @override
  @JsonKey()
  List<Supplier> get suppliers {
    if (_suppliers is EqualUnmodifiableListView) return _suppliers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_suppliers);
  }

  @override
  @JsonKey()
  final int supplierPages;
  @override
  @JsonKey()
  final bool supplierNoMore;
// ----------  样品间 ----------
  final List<Warehouse> _warehouses;
// ----------  样品间 ----------
  @override
  @JsonKey()
  List<Warehouse> get warehouses {
    if (_warehouses is EqualUnmodifiableListView) return _warehouses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_warehouses);
  }

  @override
  @JsonKey()
  final bool isLoadingWarehouses;
  @override
  final Warehouse? currentSelectedWarehouse;

  @override
  String toString() {
    return 'HomeState(bus: $bus, currentPage: $currentPage, pageController: $pageController, searchTextController: $searchTextController, search: $search, media: $media, currentMediaId: $currentMediaId, samples: $samples, facetCounts: $facetCounts, samplePages: $samplePages, sampleNoMore: $sampleNoMore, suppliers: $suppliers, supplierPages: $supplierPages, supplierNoMore: $supplierNoMore, warehouses: $warehouses, isLoadingWarehouses: $isLoadingWarehouses, currentSelectedWarehouse: $currentSelectedWarehouse)';
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
                other.currentMediaId == currentMediaId) &&
            const DeepCollectionEquality().equals(other._samples, _samples) &&
            const DeepCollectionEquality()
                .equals(other._facetCounts, _facetCounts) &&
            (identical(other.samplePages, samplePages) ||
                other.samplePages == samplePages) &&
            (identical(other.sampleNoMore, sampleNoMore) ||
                other.sampleNoMore == sampleNoMore) &&
            const DeepCollectionEquality()
                .equals(other._suppliers, _suppliers) &&
            (identical(other.supplierPages, supplierPages) ||
                other.supplierPages == supplierPages) &&
            (identical(other.supplierNoMore, supplierNoMore) ||
                other.supplierNoMore == supplierNoMore) &&
            const DeepCollectionEquality()
                .equals(other._warehouses, _warehouses) &&
            (identical(other.isLoadingWarehouses, isLoadingWarehouses) ||
                other.isLoadingWarehouses == isLoadingWarehouses) &&
            (identical(
                    other.currentSelectedWarehouse, currentSelectedWarehouse) ||
                other.currentSelectedWarehouse == currentSelectedWarehouse));
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
      currentMediaId,
      const DeepCollectionEquality().hash(_samples),
      const DeepCollectionEquality().hash(_facetCounts),
      samplePages,
      sampleNoMore,
      const DeepCollectionEquality().hash(_suppliers),
      supplierPages,
      supplierNoMore,
      const DeepCollectionEquality().hash(_warehouses),
      isLoadingWarehouses,
      currentSelectedWarehouse);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      __$$HomeStateImplCopyWithImpl<_$HomeStateImpl>(this, _$identity);
}

abstract class _HomeState extends HomeState {
  const factory _HomeState(
      {required final RxBus bus,
      required final int currentPage,
      required final PageController pageController,
      required final TextEditingController searchTextController,
      final String? search,
      required final List<TemporaryMedia> media,
      final int? currentMediaId,
      final List<Sample> samples,
      final List<FacetCount> facetCounts,
      final int samplePages,
      final bool sampleNoMore,
      final List<Supplier> suppliers,
      final int supplierPages,
      final bool supplierNoMore,
      final List<Warehouse> warehouses,
      final bool isLoadingWarehouses,
      final Warehouse? currentSelectedWarehouse}) = _$HomeStateImpl;
  const _HomeState._() : super._();

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
  @override // 当前选中的媒体id
// ----------  样品 ----------
  List<Sample> get samples;
  @override
  List<FacetCount> get facetCounts;
  @override
  int get samplePages;
  @override
  bool get sampleNoMore;
  @override // ----------  服务商 ----------
  List<Supplier> get suppliers;
  @override
  int get supplierPages;
  @override
  bool get supplierNoMore;
  @override // ----------  样品间 ----------
  List<Warehouse> get warehouses;
  @override
  bool get isLoadingWarehouses;
  @override
  Warehouse? get currentSelectedWarehouse;
  @override
  @JsonKey(ignore: true)
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
