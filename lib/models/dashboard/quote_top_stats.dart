import 'package:freezed_annotation/freezed_annotation.dart';

part 'quote_top_stats.freezed.dart';
part 'quote_top_stats.g.dart';

/// 汇率列表数据模型
@freezed
class QuoteTopStats with _$QuoteTopStats {
  const factory QuoteTopStats({
    String? name,
    @JsonKey(name: 'sample_no') String? sampleNo, 
    @JsonKey(name: 'count') int? count, 
    @JsonKey(name: 'sample_name') String? sampleName,
    @JsonKey(name: 'id') int? id, // 样品ID，用于跳转详情页
  }) = _QuoteTopStats;

  factory QuoteTopStats.fromJson(Map<String, dynamic> json) =>
      _$QuoteTopStatsFromJson(json);
}
