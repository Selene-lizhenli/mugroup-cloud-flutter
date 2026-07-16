import 'package:freezed_annotation/freezed_annotation.dart';

part 'stats.freezed.dart';
part 'stats.g.dart';

/// 月度统计数据模型
@freezed
class MonthlyStats with _$MonthlyStats {
  const factory MonthlyStats({
    @JsonKey(name: 'crm_company') int? crmCompany, // 客户数量
    @JsonKey(name: 'market_product') int? marketProduct, // 产品数量
    @JsonKey(name: 'supply_supplier') int? supplySupplier, // 供应商数量
    @JsonKey(name: 'inspection_task') int? inspectionTask, // 验货任务数量
  }) = _MonthlyStats;

  factory MonthlyStats.fromJson(Map<String, dynamic> json) =>
      _$MonthlyStatsFromJson(json);
}

/// 统计数据汇总模型
class StatsSummary {
  final Map<String, MonthlyStats>? data; // 按月份分组的统计数据

  const StatsSummary({this.data});

  factory StatsSummary.fromJson(Map<String, dynamic> json) {
    // 处理 data 字段，将其中的值转换为 MonthlyStats
    final dataMap = json['data'] as Map<String, dynamic>?;
    final convertedData = <String, MonthlyStats>{};
    
    if (dataMap != null) {
      dataMap.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          convertedData[key] = MonthlyStats.fromJson(value);
        }
      });
    }
    
    return StatsSummary(data: convertedData);
  }
}
