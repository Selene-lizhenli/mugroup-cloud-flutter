import 'package:freezed_annotation/freezed_annotation.dart';

part 'meta.freezed.dart';
part 'meta.g.dart';

/// 任务详情接口返回的 meta 结构
@freezed
class PurchaseAssistMeta with _$PurchaseAssistMeta {
  const factory PurchaseAssistMeta({
    String? platform,
    PurchaseAssistPagination? pagination,
  }) = _PurchaseAssistMeta;

  factory PurchaseAssistMeta.fromJson(Map<String, dynamic> json) =>
      _$PurchaseAssistMetaFromJson(json);
}

@freezed
class PurchaseAssistPagination with _$PurchaseAssistPagination {
  const factory PurchaseAssistPagination({
    required int total,
    required int count,
    @JsonKey(name: 'per_page') int? perPage,
    @JsonKey(name: 'current_page') int? currentPage,
    @JsonKey(name: 'total_pages') required int totalPages,
    Map<String, dynamic>? links,
  }) = _PurchaseAssistPagination;

  factory PurchaseAssistPagination.fromJson(Map<String, dynamic> json) =>
      _$PurchaseAssistPaginationFromJson(json);
}