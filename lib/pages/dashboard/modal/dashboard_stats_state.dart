import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_stats_state.freezed.dart';

/// 时间维度枚举
enum TimeDimension {
  last6Months,
  last12Months,
  allTime,
}

/// Dashboard  State
@freezed
class DashboardStatsState with _$DashboardStatsState {
  const DashboardStatsState._();

  const factory DashboardStatsState({
    @Default([]) List<String> timeLabels,
    @Default([]) List<int> productData,
    @Default([]) List<int> customerData,
    @Default([]) List<int> serviceProviderData,
    @Default([]) List<int> inspectionData,
    @Default(false) bool isLoading,
    @Default(TimeDimension.last6Months) TimeDimension timeDimension,
    @Default('quote_rank') String sampleRoomDimension,
  }) = _DashboardStatsState;
}
