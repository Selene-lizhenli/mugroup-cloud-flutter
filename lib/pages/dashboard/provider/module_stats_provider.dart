import 'package:cloud/helper/helper.dart';
import 'package:cloud/services/dashboard.dart';
import 'package:cloud/pages/dashboard/modal/module_stats_state.dart';
import 'package:cloud/pages/dashboard/modal/dashboard_stats_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'module_stats_provider.g.dart';

/// 格式化月份标签，将 "2026-01" 转换为 "1月"
String _formatMonthLabel(String monthKey) {
  try {
    final parts = monthKey.split('-');
    if (parts.length >= 2) {
      final month = int.parse(parts[1]);
      return '${month}月';
    }
    return monthKey;
  } catch (e) {
    return monthKey;
  }
}

/// 根据模块ID获取对应的数据字段
int? _getModuleData(String moduleId, dynamic monthlyStats) {
  switch (moduleId) {
    case 'inspection':
      return monthlyStats.inspectionTask;
    case 'customer':
      return monthlyStats.crmCompany;
    case 'supplier':
      return monthlyStats.supplySupplier;
    case 'market_purchase':
      return monthlyStats.marketProduct;
    default:
      return null;
  }
}

/// 模块统计数据 Provider（按模块ID区分）
@riverpod
class ModuleStats extends _$ModuleStats {
  @override
  ModuleStatsState build(String moduleId) {
    return ModuleStatsState(
      moduleId: moduleId,
      timeLabels: [],
      data: [],
      isLoading: false,
      timeDimension: TimeDimension.last6Months, 
    );
  }

  /// 加载数据
  Future<void> load() async {
    state = state.copyWith(isLoading: true);
    final data = await _fetch();
    state = data.copyWith(isLoading: false);
  }

  /// 刷新数据
  Future<void> refresh() async {
    await load();
    // await ref.read(dashboardStatsProvider.notifier).refresh();
  }

  /// 设置时间维度并重新加载数据
  Future<void> setTimeDimension(TimeDimension dimension) async {
    state = state.copyWith(timeDimension: dimension);
    await load();
  }

  Future<ModuleStatsState> _fetch() async {
    // 获取统计数据（根据当前时间维度）
    final params = _buildDateRangeParams(state.timeDimension);
    final summary = await getStatsSummary(params: params); 
    
    if (summary?.data == null || summary!.data!.isEmpty) {
      return state.copyWith(
        moduleId: state.moduleId,
        timeLabels: [],
        data: [],
        timeDimension: state.timeDimension,
      );
    }

    // 转换数据格式为图表需要的格式
    final sortedEntries = summary.data!.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key)); // 按月份排序

    final timeLabels = <String>[];
    final moduleData = <int>[];

    for (final entry in sortedEntries) {
      // 将 "2026-01" 格式转换为 "1月" 格式
      final monthStr = _formatMonthLabel(entry.key);
      timeLabels.add(monthStr);
      
      // 根据模块ID获取对应的数据
      final dataValue = _getModuleData(state.moduleId, entry.value);
      moduleData.add(dataValue ?? 0);
    }
    
    final result = ModuleStatsState(
      moduleId: state.moduleId,
      timeLabels: timeLabels,
      data: moduleData,
      timeDimension: state.timeDimension,
    );
    logger.d('Module ${state.moduleId} data: ${result.toString()}');
    return result;
  }

  /// 构建日期范围参数
  Map<String, String> _buildDateRangeParams(TimeDimension timeDimension) {
    final now = DateTime.now();
    late DateTime startDate;
    final endDate = DateTime(now.year, now.month + 1, 0); // 当前月的最后一天

    switch (timeDimension) {
      case TimeDimension.last6Months:
        // 最近半年（6个月）
        startDate = DateTime(now.year, now.month - 5, 1);
        break;
      case TimeDimension.last12Months:
        // 最近一年（12个月）
        startDate = DateTime(now.year, now.month - 11, 1);
        break;
      case TimeDimension.allTime:
        // 所有时间（从很久以前开始，比如2023年）
        startDate = DateTime(2023, 1, 1);
        break;
    }

    return {
      'start_date':
          '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}',
      'end_date':
          '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}',
    };
  }
}

