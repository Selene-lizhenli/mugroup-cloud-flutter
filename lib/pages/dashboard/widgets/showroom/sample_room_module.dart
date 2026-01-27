import 'package:cloud/constants/dashboard_configs.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/dashboard/ship_top_stats.dart';
import 'package:cloud/models/dashboard/quote_top_stats.dart';
import 'package:cloud/pages/dashboard/widgets/showroom/ship_cart.dart';
import 'package:cloud/pages/dashboard/widgets/showroom/date_select.dart'
    show shipDateRangeToParams;
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/services/dashboard.dart';
import 'package:cloud/pages/dashboard/widgets/showroom/quote_cart.dart';
import 'package:cloud/pages/dashboard/provider/dashboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 统计结果：一级目录信息 + 该一级目录下累计数量
/// 需要在其他文件中使用，所以保持 public
class Level1CategoryStat {
  final int id;
  final String name;
  final int totalProductsCount;
  final Color color;

  Level1CategoryStat({
    required this.id,
    required this.name,
    required this.totalProductsCount,
    required this.color,
  });

  @override
  String toString() =>
      'Level1CategoryStat(id: $id, name: $name, total: $totalProductsCount)';
}

/// 样品间模块 - 圆饼图
class SampleRoomChart extends ConsumerStatefulWidget {
  final String moduleTitle; // 模块标题，如"样品间"

  const SampleRoomChart({
    super.key,
    this.moduleTitle = '报价次数排行', // 默认值
  });

  @override
  ConsumerState<SampleRoomChart> createState() => _SampleRoomChartState();
}

class _SampleRoomChartState extends ConsumerState<SampleRoomChart> {
  List<QuoteTopStats> _quoteTopDimensionData = []; //  数据 报价排行
  List<ShipTopStats> _shipTopDimensionData = []; //  数据 出货排行
  ShipDateRange _shipDateRange = ShipDateRange.lastYear; // 出货排行时间范围
  ShipDateRange _quoteDateRange = ShipDateRange.lastYear; // 报价次数排行时间范围

  bool _isLoading = false; // 数据加载状态

  String? _lastLoadedDimension;

  @override
  void initState() {
    super.initState();
    // 初始化时强制将维度设置为「报价次数排行」，并根据该维度加载数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sampleRoomDimension =
          ref.read(dashboardStatsProvider).sampleRoomDimension;
      _loadDimensionData(sampleRoomDimension);
    });
  }

  handleQuoteRankData() async {
    setState(() {
      _isLoading = true;
      _quoteTopDimensionData = [];
    });
    try {
      final params = shipDateRangeToParams(_quoteDateRange);
      logger.d('handleQuoteRankData params: $params');
      final resp = await getQuoteStatsSummary(params: params);
      if (mounted) {
        setState(() {
          _quoteTopDimensionData = resp ?? [];
        });
      }
    } catch (e) {
      logger.d('Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  handleShipRankData() async {
    setState(() {
      _isLoading = true;
      _shipTopDimensionData = [];
    });
    try {
      final params = shipDateRangeToParams(_shipDateRange);
      final resp = await getShipStatsSummary(params: params);
      if (mounted) {
        setState(() { 
          _shipTopDimensionData = resp ?? [];
        });
      }
    } catch (e) {
      logger.d('Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// 根据维度加载数据
  Future<void> _loadDimensionData(String dimension) async {
    setState(() {
      _isLoading = true;
    });
    logger.d('dimension: $dimension');
    try {
      if (dimension == sampleDimensionConfigs[1]['value']) {
        handleQuoteRankData();
      } else if (dimension == sampleDimensionConfigs[0]['value']) {
        handleShipRankData();
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 监听维度变化并重新加载数据
    ref.listen<String>(
      dashboardStatsProvider.select((state) => state.sampleRoomDimension),
      (previous, next) {
        if (previous != next && next != _lastLoadedDimension) {
          _lastLoadedDimension = next;
          _loadDimensionData(next);
        }
      },
    );

    // 获取当前维度
    final currentDimension = ref.watch(
      dashboardStatsProvider.select((state) => state.sampleRoomDimension),
    );
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // 模块标题和维度选择器
        Padding(
          padding: const EdgeInsets.only(bottom: 4, left: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 模块标题
              Text(
                'Top榜单',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontSize: 16),
              ),
              // 维度选择器
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.tune,
                  size: 20,
                  color: Colors.grey.shade600,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                offset: const Offset(-10, 45),
                itemBuilder: (BuildContext context) =>
                    sampleDimensionConfigs.map((config) {
                  return PopupMenuItem<String>(
                    value: config['value'],
                    child: Row(
                      children: [
                        Icon(
                          config['icon'],
                          size: 18,
                          color: currentDimension == config['value']
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          config['label'],
                          style: TextStyle(
                            color: currentDimension == config['value']
                                ? Theme.of(context).colorScheme.primary
                                : null,
                            fontWeight: currentDimension == config['value']
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onSelected: (String value) {
                  ref
                      .read(dashboardStatsProvider.notifier)
                      .setSampleRoomDimension(value);
                },
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: colorScheme.surface),
          clipBehavior: Clip.none, // 使用 ClipRect 在内部裁剪
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 根据数据状态显示内容
              if (currentDimension == sampleDimensionConfigs[0]['value'])
                ShipTopChartContent(
                  isLoading: _isLoading,
                  data: _shipTopDimensionData,
                  selectedRange: _shipDateRange,
                  onRangeChanged: (ShipDateRange range) {
                    setState(() {
                      _shipDateRange = range;
                    });
                    handleShipRankData();
                  },
                )
              else if (currentDimension == sampleDimensionConfigs[1]['value'])
                QuoteTopChartContent(
                  isLoading: _isLoading,
                  data: _quoteTopDimensionData,
                  selectedRange: _quoteDateRange,
                  onRangeChanged: (ShipDateRange range) {
                    setState(() {
                      _quoteDateRange = range;
                    });
                    handleQuoteRankData();
                  },
                )
              else
                _isLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40.0),
                          child: MuProgressIndicator(),
                        ),
                      )
                    : const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40.0),
                          child: Text("暂无数据"),
                        ),
                      )
            ],
          ),
        )
      ],
    );
  }
}
