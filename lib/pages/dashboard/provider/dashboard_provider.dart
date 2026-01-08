import 'package:cloud/services/dashboard.dart';
import 'package:cloud/pages/dashboard/provider/dashboard_stats_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_provider.g.dart';

/// 构建日期范围参数
/// 返回包含 start_date 和 end_date 的参数字典
Map<String, String> _buildDateRangeParams() {
  final now = DateTime.now();
  final startDate = DateTime(now.year, now.month - 7, 1); // 获取最近8个月
  final endDate = DateTime(now.year, now.month + 1, 0); // 当前月的最后一天
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

  Future<DashboardStatsState> _fetch() async {
    // 获取统计数据（默认获取最近几个月的数据）
    final params = _buildDateRangeParams();
    final summary = await getStatsSummary(params: params);

    if (summary?.data == null || summary!.data!.isEmpty) {
      // 返回空数据
      return const DashboardStatsState(
        timeLabels: [],
        productData: [],
        customerData: [],
        serviceProviderData: [],
        inspectionData: [],
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

    return DashboardStatsState(
      timeLabels: timeLabels,
      productData: productData,
      customerData: customerData,
      serviceProviderData: serviceProviderData,
      inspectionData: inspectionData,
    );
  }



}
