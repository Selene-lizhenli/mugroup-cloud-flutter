import 'package:freezed_annotation/freezed_annotation.dart';

part 'market_stats.freezed.dart';
part 'market_stats.g.dart';

/// 市场带客统计数据模型
@freezed
class MarketPurchaseStats with _$MarketPurchaseStats {
  const factory MarketPurchaseStats({
    @JsonKey(name: 'time_labels') List<String>? timeLabels, // 时间轴标签（月份）
    @JsonKey(name: 'product_data') List<int>? productData, // 产品数量
    @JsonKey(name: 'customer_data') List<int>? customerData, // 客户数量
    @JsonKey(name: 'service_provider_data') List<int>? serviceProviderData, // 服务商数量
    @JsonKey(name: 'inspection_data') List<int>? inspectionData, // 验货任务数量
  }) = _MarketPurchaseStats;

  factory MarketPurchaseStats.fromJson(Map<String, dynamic> json) =>
      _$MarketPurchaseStatsFromJson(json);
}
