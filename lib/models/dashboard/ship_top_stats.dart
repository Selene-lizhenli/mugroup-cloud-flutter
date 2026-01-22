import 'package:freezed_annotation/freezed_annotation.dart';

part 'ship_top_stats.freezed.dart';
part 'ship_top_stats.g.dart';

/// 出货排名列表数据模型
@freezed
class ShipTopStats with _$ShipTopStats {
  const factory ShipTopStats({ 
    int? id, // 样品ID，用于跳转详情页
    @JsonKey(name: 'category_name') String? categoryName,
    @JsonKey(name: 'thumb_url') String? thumbUrl, // 样品缩略图
    @JsonKey(name: 'sample_no') String? sampleNo, 
    @JsonKey(name: 'sample_name') String? sampleName,
    @JsonKey(name: 'shipping_amount') int? shippingAmount, 
  }) = _ShipTopStats;

  factory ShipTopStats.fromJson(Map<String, dynamic> json) =>
      _$ShipTopStatsFromJson(json);
}
