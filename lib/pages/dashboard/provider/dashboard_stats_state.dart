import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_stats_state.freezed.dart';

/// Dashboard 统计数据 State
@freezed
class DashboardStatsState with _$DashboardStatsState {
  const DashboardStatsState._();
  
  const factory DashboardStatsState({
    @Default([]) List<String> timeLabels, // 时间轴标签（月份）
    @Default([]) List<int> productData, // 产品数量
    @Default([]) List<int> customerData, // 客户数量
    @Default([]) List<int> serviceProviderData, // 服务商数量
    @Default([]) List<int> inspectionData, // 验货任务数量
    @Default(false) bool isLoading, // 是否正在加载
  }) = _DashboardStatsState;
}

