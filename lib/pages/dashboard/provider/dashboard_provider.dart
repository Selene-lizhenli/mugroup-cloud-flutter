import 'package:cloud/helper/helper.dart';
import 'package:cloud/services/dashboard.dart';
import 'package:cloud/pages/dashboard/modal/dashboard_stats_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_provider.g.dart';

/// 构建日期范围参数
/// 返回包含 start_date 和 end_date 的参数字典
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
      // 所有时间（从很久以前开始，比如2020年）
      startDate = DateTime(2020, 1, 1);
      break;
  }

  return {
    'start_date':
        '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}',
    'end_date':
        '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}',
  };
}

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

/// Dashboard 统计数据 Provider
@riverpod
class DashboardStats extends _$DashboardStats {
  @override
  DashboardStatsState build() {
    const dashboardStatsState = DashboardStatsState(
      timeLabels: [],
      productData: [],
      customerData: [],
      serviceProviderData: [],
      inspectionData: [],
      isLoading: false,
      timeDimension: TimeDimension.last6Months, 
      sampleRoomDimension: '样品间',
    );

    return dashboardStatsState;
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
  }

  /// 设置时间维度并重新加载数据
  Future<void> setTimeDimension(TimeDimension dimension) async {
    state = state.copyWith(timeDimension: dimension);
    await load();
  }

  /// 设置样品间维度
  void setSampleRoomDimension(String dimension) {
    state = state.copyWith(sampleRoomDimension: dimension);
  }

  Future<DashboardStatsState> _fetch() async {
    // 获取统计数据（根据当前时间维度）
    final params = _buildDateRangeParams(state.timeDimension);
    final summary = await getStatsSummary(params: params);
    logger.d('params${params}');
    if (summary?.data == null || summary!.data!.isEmpty) {
      return DashboardStatsState(
        timeLabels: [],
        productData: [],
        customerData: [],
        serviceProviderData: [],
        inspectionData: [],
        timeDimension: state.timeDimension,
        sampleRoomDimension: state.sampleRoomDimension,
      );
    }

    if (summary.data == null || summary.data!.isEmpty) {
      // 返回空数据
      return DashboardStatsState(
        timeLabels: [],
        productData: [],
        customerData: [],
        serviceProviderData: [],
        inspectionData: [],
        timeDimension: state.timeDimension,
        sampleRoomDimension: state.sampleRoomDimension,
      );
    }

    // 转换数据格式为图表需要的格式
    final sortedEntries = summary.data!.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key)); // 按月份排序

    final timeLabels = <String>[];
    final productData = <int>[];
    final customerData = <int>[];
    final serviceProviderData = <int>[];
    final inspectionData = <int>[];

    for (final entry in sortedEntries) {
      // 将 "2026-01" 格式转换为 "1月" 格式
      final monthStr = _formatMonthLabel(entry.key);
      timeLabels.add(monthStr);
      productData.add(entry.value.marketProduct ?? 0);
      customerData.add(entry.value.crmCompany ?? 0);
      serviceProviderData.add(entry.value.supplySupplier ?? 0);
      inspectionData.add(entry.value.inspectionTask ?? 0);
    }
    final sa = DashboardStatsState(
      timeLabels: timeLabels,
      productData: productData,
      customerData: customerData,
      serviceProviderData: serviceProviderData,
      inspectionData: inspectionData,
      timeDimension: state.timeDimension,
      sampleRoomDimension: state.sampleRoomDimension,
    );
    logger.d('sa${sa.toString()}');
    return sa;
  }
}
