import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_stats_state.freezed.dart';

/// 时间维度枚举
enum TimeDimension {
  last6Months('最近半年'),
  last12Months('最近一年'),
  allTime('所有时间');

  const TimeDimension(this.label);
  final String label;
}

/// Dashboard  State
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
    @Default(TimeDimension.last6Months) TimeDimension timeDimension, // 时间维度 
    @Default('挑样次数') String sampleRoomDimension, // 样品间模块的维度选择
  }) = _DashboardStatsState;
}

