import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud/pages/dashboard/modal/dashboard_stats_state.dart';

part 'module_stats_state.freezed.dart';

/// 模块统计数据 State（单个模块）
@freezed
class ModuleStatsState with _$ModuleStatsState {
  const ModuleStatsState._();
  
  const factory ModuleStatsState({
    required String moduleId, // 模块ID
    @Default([]) List<String> timeLabels, // 时间轴标签（月份）
    @Default([]) List<int> data, // 模块数据
    @Default(false) bool isLoading, // 是否正在加载
    @Default(TimeDimension.last6Months) TimeDimension timeDimension, // 时间维度 
  }) = _ModuleStatsState;
}

