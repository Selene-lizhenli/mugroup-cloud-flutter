import 'package:cloud/constants/dashboard_configs.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/dashboard/ship_top_stats.dart';
import 'package:cloud/models/dashboard/quote_top_stats.dart';
import 'package:cloud/pages/dashboard/widgets/showroom/ship_cart.dart';
import 'package:cloud/pages/dashboard/widgets/date_select.dart' show DateRange;
import 'package:cloud/services/dashboard.dart';
import 'package:cloud/pages/dashboard/widgets/showroom/sample_room_header.dart';
import 'package:cloud/pages/dashboard/widgets/showroom/sample_room_body.dart';
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
  final DateRange _shipDateRange = DateRange.lastYear; // 出货排行时间范围 初始值
  final DateRange _quoteDateRange = DateRange.lastYear; // 报价次数排行时间范围 初始值

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

  handleQuoteRankData(Map<String, String>? params) async {
    setState(() {
      _isLoading = true;
      _quoteTopDimensionData = [];
    });
    try {
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

  handleShipRankData(Map<String, String>? params) async {
    setState(() {
      _isLoading = true;
      _shipTopDimensionData = [];
    });
    try {
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
        handleQuoteRankData(null);
      } else if (dimension == sampleDimensionConfigs[0]['value'] ||
          dimension == sampleDimensionConfigs[2]['value']) {
        handleShipRankData(null);
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

  /// 点击展开时 自动上滚动，使得界面能出现在viewport
  void handleExpandScroll(expandedContentKey) {
    // 等待动画完成后再滚动，确保内容已渲染
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 等待 AnimatedSize 动画完成（300ms）
      Future.delayed(const Duration(milliseconds: 350), () {
        if (mounted) {
          final context = expandedContentKey.currentContext;
          if (context != null) {
            final scrollable = Scrollable.maybeOf(context);
            if (scrollable != null) {
              final scrollController = scrollable.widget.controller;
              if (scrollController != null && scrollController.hasClients) {
                // 获取展开内容的 RenderBox
                final renderBox = context.findRenderObject() as RenderBox?;
                if (renderBox != null && renderBox.attached) {
                  // 计算展开内容在全局坐标系中的位置
                  final position = renderBox.localToGlobal(Offset.zero);
                  // 获取 Scrollable 的 RenderBox（视口）
                  final scrollableRenderBox =
                      scrollable.context.findRenderObject() as RenderBox?;
                  if (scrollableRenderBox != null) {
                    final viewportPosition =
                        scrollableRenderBox.localToGlobal(Offset.zero);
                    // 计算展开内容相对于视口的位置
                    final relativeY = position.dy - viewportPosition.dy;
                    // 目标：让展开内容距离视口顶部200像素
                    // 需要滚动的距离 = 当前相对位置 - 200
                    final scrollDelta = relativeY - 300;
                    final newOffset =
                        (scrollController.offset + scrollDelta).clamp(
                      0.0,
                      scrollController.position.maxScrollExtent,
                    );
                    scrollController.animateTo(
                      newOffset,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                }
              }
            }
          }
        }
      });
    });
    return;
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

    return Column(
      children: [
        // 模块标题和维度选择器
        const SampleRoomHeader(),
        // 模块内容
        SampleRoomBody(
          isLoading: _isLoading,
          handleExpandScroll: handleExpandScroll,
          shipTopDimensionData: _shipTopDimensionData,
          shipDateRange: _shipDateRange,
          handleShipRankData: handleShipRankData,
          quoteTopDimensionData: _quoteTopDimensionData,
          quoteDateRange: _quoteDateRange,
          handleQuoteRankData: handleQuoteRankData,
        ),
      ],
    );
  }
}
