import 'package:freezed_annotation/freezed_annotation.dart';

part 'response.freezed.dart';
part 'response.g.dart';

@Freezed(genericArgumentFactories: true)
sealed class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse.data(T data, Meta? meta) = ApiResponseData;

  factory ApiResponse.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$ApiResponseFromJson(json, fromJsonT);
}

@freezed
class Meta with _$Meta {
  factory Meta({
    Pagination? pagination,
    @JsonKey(name: 'facet_counts') List<FacetCount>? facetCounts,
  }) = _Meta;

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);
}

@freezed
class Pagination with _$Pagination {
  factory Pagination({
    required int total,
    required int count,
    @JsonKey(name: 'total_pages') required int totalPages,
  }) = _Pagination;

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);
}

@freezed
class FacetCount with _$FacetCount {
  factory FacetCount({
    required List<FacetCountCount> counts,
    @JsonKey(name: 'field_name') required String fieldName,
  }) = _FacetCount;

  factory FacetCount.fromJson(Map<String, dynamic> json) =>
      _$FacetCountFromJson(json);
}

@freezed
class FacetCountCount with _$FacetCountCount {
  factory FacetCountCount({
    required int count,
    required String value,
  }) = _FacetCountCount;

  factory FacetCountCount.fromJson(Map<String, dynamic> json) =>
      _$FacetCountCountFromJson(json);
}
