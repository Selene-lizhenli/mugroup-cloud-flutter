import 'package:cloud/pages/dashboard/widgets/exchange/exchange_calculator.dart';
import 'package:cloud/pages/dashboard/widgets/exchange/exchange_header.dart';
import 'package:cloud/pages/dashboard/widgets/exchange/exchange_list.dart';
import 'package:cloud/pages/dashboard/widgets/exchange/min_max_labels.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/pages/widgets/empty.dart';
import 'package:cloud/pages/widgets/show_error.dart';
import 'package:cloud/providers/exchange.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud/models/dashboard/exchange.dart';
import 'package:cloud/services/dashboard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LineChartDemo extends ConsumerStatefulWidget {
  const LineChartDemo({super.key});

  @override
  ConsumerState<LineChartDemo> createState() => _LineChartDemoState();
}

class _LineChartDemoState extends ConsumerState<LineChartDemo> {
  int? _touchedIndex; 
  ExchangeRate? _selectedDimension; // 选中的维度，默认选中美元
  bool _isLoading = false;
  String? _errorMessage;
  bool _isListLoading = false;

  // 存储当前货币的历史数据
  ExchangeRateHistory? _exchangeData; //波动图的数据
  List<ExchangeRate>? _currencyList; //列表的数据


 
  // /// 将货币代码转换为中文名称
  // String _getCurrencyChineseName(String? currencyCode) {
  //   if (currencyCode == null || currencyCode.isEmpty) {
  //     return '汇率波动';
  //   }
  //   return '${_currencyToChineseMap[currencyCode.toUpperCase()]} ${currencyCode.isNotEmpty ? '($currencyCode)' : ''}';
  // }

  /// 获取日期范围（最近30天）
  Map<String, String> _getDateRange() {
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 30));

    return {
      'start':
          '${start.year}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')}',
      'end':
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
    };
  }

  /// 加载汇率数据
  Future<void> _loadExchangeData() async {
    if (_selectedDimension == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final dateRange = _getDateRange();
      final currency = _selectedDimension!.shortName;

      if (currency == null) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = '无效的货币维度';
          });
        }
        return;
      }

      final data = await getExchangeRateHistory(
        currency: currency,
        start: dateRange['start']!,
        end: dateRange['end']!,
      );

      if (mounted) {
        setState(() {
          _exchangeData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = '汇率数据加载失败! $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadCurrencyList() async {
    try {
      if (mounted) {
        setState(() {
          _isListLoading = true;
        });
      }
      final data = await getExchangesList();
      if (mounted) {
        setState(() {
          _currencyList = data;
          _isListLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = '数据加载失败! $e';
          _isListLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // 页面加载后：若已选择维度，则调用趋势接口；否则展示汇率列表（exchangeProvider）
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedDimension != null) {
        _loadExchangeData();
      } else {
        _loadCurrencyList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // 转换数据格式为图表需要的格式
    // 使用所有数据点绘制折线图
    final data = _exchangeData?.data ?? [];

    // 解析所有数据点
    final spots = <FlSpot>[];
    final dates = <String>[];
    final rates = <double>[];

    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      final rate = double.tryParse(item.rate ?? '0') ?? 0.0;
      rates.add(rate);
      dates.add(item.date ?? '');
      spots.add(FlSpot(i.toDouble(), rate));
    }

    // 计算Y轴范围
    final maxRate =
        rates.isNotEmpty ? rates.reduce((a, b) => a > b ? a : b) : 0.0;
    final minRate =
        rates.isNotEmpty ? rates.reduce((a, b) => a < b ? a : b) : 0.0;
    final maxY = maxRate * 1.015;
    final minY = minRate * 0.99;

    // 找到最高点和最低点的索引
    int maxIndex = 0;
    int minIndex = 0;
    if (rates.isNotEmpty) {
      for (int i = 0; i < rates.length; i++) {
        if (rates[i] == maxRate) {
          maxIndex = i;
        }
        if (rates[i] == minRate) {
          minIndex = i;
        }
      }
    }

    _touchedIndex ??= 0;
    void onDimensionSelected(ExchangeRate? value) async {
      if (_selectedDimension?.shortName != value?.shortName) {
        setState(() {
          _selectedDimension = value;
          _exchangeData = null; // 清除旧数据
        });
        if (_selectedDimension != null) {
          await _loadExchangeData();
        }
      } else {
        setState(() {
          _selectedDimension = null;
        });
      }
    }

    return Column(children: [
      ExchangeChartHeader(  
        selectedDimension: _selectedDimension,
        onDimensionSelected: onDimensionSelected,
        currencyList: _currencyList,
      ),
      // 未选择维度：展示 exchangeProvider 的汇率列表（表格）
      if (_selectedDimension == null)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: colorScheme.surface,
          ),
          child: ExchangeRatesValueList(
            list: _currencyList,
            loading: _isListLoading,
          ),
        )
      else if (_isLoading)
        Container(
          padding: const EdgeInsets.all(16),
          height: 150,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: colorScheme.surface),
          child: const Center(
              child: MuProgressIndicator(
            text: '加载中...',
          )),
        )
      else if (_errorMessage != null && _exchangeData == null)
        Container(
            padding: const EdgeInsets.all(16),
            height: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: colorScheme.surface),
            child: Center(
              child: ShowError(
                errorMessage: _errorMessage!,
                onRetry: () => _loadExchangeData(),
                height: 150,
              ),
            ))
      else if (_exchangeData == null || (_exchangeData!.data?.isEmpty ?? true))
        Container(
          padding: const EdgeInsets.all(16),
          height: 110,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: colorScheme.surface),
          child: const Center(
            child: Empty(),
          ),
        )
      else
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: colorScheme.surface),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 折线图
              SizedBox(
                height: 150,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        // 显示最高点和最低点的数值标签（放在底层）
                        Positioned.fill(
                          child: IgnorePointer(
                            child: MinMaxLabels(
                              maxIndex: maxIndex,
                              minIndex: minIndex,
                              maxValue: maxRate,
                              minValue: minRate,
                              spots: spots,
                              constraints: constraints,
                              minY: minY,
                              maxY: maxY,
                              leftReservedSize: 30,
                              bottomReservedSize: 30,
                            ),
                          ),
                        ),
                        // 折线图（放在上层，确保触摸交互的 tooltip 显示在最上层）
                        LineChart(
                          LineChartData(
                            gridData: FlGridData(show: false),
                            titlesData: FlTitlesData(
                              leftTitles: SideTitles(
                                showTitles: false,
                                reservedSize: 30,
                                getTitles: (value) {
                                  // 格式化Y轴标签，保留4位小数
                                  return value.toStringAsFixed(4);
                                },
                                getTextStyles: (_) => TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              bottomTitles: SideTitles(
                                showTitles: false,
                                reservedSize: 30,
                                getTitles: (value) {
                                  final index = value.toInt();
                                  if (index >= 0 && index < dates.length) {
                                    final dateStr = dates[index];
                                    // 格式化日期：从 "2026-01-01" 转换为 "01-01" 或 "1/1"
                                    if (dateStr.isNotEmpty) {
                                      try {
                                        final parts = dateStr.split('-');
                                        if (parts.length >= 3) {
                                          return '${parts[1]}-${parts[2]}';
                                        }
                                        return dateStr;
                                      } catch (e) {
                                        return dateStr;
                                      }
                                    }
                                  }
                                  return '';
                                },
                                getTextStyles: (_) => TextStyle(
                                  fontSize: 9,
                                  color: Colors.grey.shade600,
                                ),
                                interval: dates.length > 10
                                    ? (dates.length / 5).ceil().toDouble()
                                    : 1,
                              ),
                              topTitles: SideTitles(showTitles: false),
                              rightTitles: SideTitles(showTitles: false),
                            ),
                            minY: minY,
                            maxY: maxY,
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                spots: spots,
                                isCurved: true,
                                colors: [colorScheme.primary],
                                barWidth: 2,
                                dotData: FlDotData(
                                  show: true,
                                  getDotPainter:
                                      (spot, percent, barData, index) {
                                    // 为最高点和最低点显示特殊标记
                                    if (index == maxIndex ||
                                        index == minIndex) {
                                      return FlDotCirclePainter(
                                        radius: 5,
                                        color: index == maxIndex
                                            ? colorScheme.primary
                                            : colorScheme.secondary,
                                        strokeWidth: 2,
                                        strokeColor: Colors.white,
                                      );
                                    }
                                    return FlDotCirclePainter(
                                      radius: 0,
                                      color: Colors.transparent,
                                    );
                                  },
                                ),
                                belowBarData: BarAreaData(
                                  show: true,
                                  colors: [
                                    colorScheme.primary.withOpacity(0.1),
                                  ],
                                ),
                              ),
                            ],
                            lineTouchData: LineTouchData(
                              enabled: true,
                              touchSpotThreshold: 20,
                              getTouchedSpotIndicator:
                                  (LineChartBarData barData,
                                      List<int> spotIndexes) {
                                return spotIndexes.map((index) {
                                  final isMax = index == maxIndex;
                                  final isMin = index == minIndex;
                                  final color = isMax
                                      ? Colors.red
                                      : (isMin
                                          ? Colors.green
                                          : colorScheme.primary);
                                  return TouchedSpotIndicatorData(
                                    FlLine(
                                      color: color,
                                      strokeWidth: 2,
                                      dashArray: [5, 5],
                                    ),
                                    FlDotData(
                                      getDotPainter:
                                          (spot, percent, barData, index) {
                                        return FlDotCirclePainter(
                                          radius: 6,
                                          color: color,
                                          strokeWidth: 3,
                                          strokeColor: Colors.white,
                                        );
                                      },
                                    ),
                                  );
                                }).toList();
                              },
                              touchTooltipData: LineTouchTooltipData(
                                getTooltipItems:
                                    (List<LineBarSpot> touchedSpots) {
                                  return touchedSpots
                                      .map((LineBarSpot touchedSpot) {
                                    final index = touchedSpot.x.toInt();
                                    if (index >= 0 &&
                                        index < dates.length &&
                                        index < rates.length) {
                                      final isMax = index == maxIndex;
                                      final isMin = index == minIndex;

                                      // 格式化日期显示
                                      String dateDisplay = dates[index];
                                      try {
                                        final parts = dateDisplay.split('-');
                                        if (parts.length >= 3) {
                                          dateDisplay =
                                              '${parts[0]}年${int.parse(parts[1])}月${int.parse(parts[2])}日';
                                        }
                                      } catch (e) {
                                        // 如果解析失败，使用原始日期
                                      }

                                      // 构建标签文本
                                      String label = dateDisplay;
                                      label +=
                                          '\n汇率: ${rates[index].toStringAsFixed(4)}';

                                      // 添加最高点/最低点标注
                                      if (isMax) {
                                        label += '\n 最高点';
                                      } else if (isMin) {
                                        label += '\n 最低点';
                                      }

                                      return LineTooltipItem(
                                        label,
                                        const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                      );
                                    }
                                    return null;
                                  }).toList();
                                },
                                tooltipBgColor: Colors.grey.shade800,
                                tooltipRoundedRadius: 8,
                                tooltipPadding: const EdgeInsets.all(12),
                                tooltipMargin: 8,
                                fitInsideHorizontally: true,
                                fitInsideVertically: true,
                              ),
                            ),
                          ),
                        ),
                        // 显示当前选择的维度注释（右上角）

                        if (_selectedDimension != null)
                          Positioned(
                            top: 0,
                            left: 0,
                            child: IgnorePointer(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${_selectedDimension!.name} ${_selectedDimension!.shortName}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              // const SizedBox(height: 10),
              // 汇率标题和折叠按钮
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 5),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Expanded(
              //         child: Text(
              //           _getCurrencyChineseName(_exchangeData!.currency),
              //           style: TextStyle(
              //               fontSize: 12, color: colorScheme.onSurface),
              //         ),
              //       ),
              //       // InkWell(
              //       //   borderRadius: BorderRadius.circular(8),
              //       //   onTap: () => setState(() => _isExpanded = !_isExpanded),
              //       //   child: Padding(
              //       //     padding: const EdgeInsets.symmetric(
              //       //         horizontal: 6, vertical: 4),
              //       //     child: Row(
              //       //       mainAxisSize: MainAxisSize.min,
              //       //       children: [
              //       //         Text(
              //       //           _isExpanded ? '收起' : '展开',
              //       //           style: TextStyle(
              //       //             fontSize: 12,
              //       //             color: colorScheme.secondary,
              //       //           ),
              //       //         ),
              //       //         const SizedBox(width: 2),
              //       //         Icon(
              //       //           _isExpanded
              //       //               ? Icons.keyboard_arrow_up
              //       //               : Icons.keyboard_arrow_down,
              //       //           size: 18,
              //       //           color: colorScheme.secondary,
              //       //         ),
              //       //       ],
              //       //     ),
              //       //   ),
              //       // ),
              //       // TextButton(
              //       //   onPressed: () =>
              //       //       _showExchangeCalculator(context, _touchedIndex ?? 0),
              //       //   style: TextButton.styleFrom(
              //       //     padding: const EdgeInsets.symmetric(
              //       //         horizontal: 12, vertical: 6),
              //       //     textStyle: const TextStyle(fontSize: 14),
              //       //   ),
              //       //   child: Row(
              //       //     mainAxisSize: MainAxisSize.min,
              //       //     children: [
              //       //       Icon(
              //       //         FontAwesomeIcons.calculator,
              //       //         size: 14,
              //       //         color: colorScheme.primary,
              //       //       ),
              //       //       const SizedBox(width: 6),
              //       //       const Text(
              //       //         '汇率计算器',
              //       //         style: TextStyle(fontSize: 12),
              //       //       ),
              //       //     ],
              //       //   ),
              //       // ),
              //     ],
              //   ),
              // ),

              // AnimatedSize(
              //   duration: const Duration(milliseconds: 300),
              //   curve: Curves.easeInOut,
              //   child: Visibility(
              //     visible: _isExpanded,
              //     child: GridView.builder(
              //       shrinkWrap: true,
              //       physics: const NeverScrollableScrollPhysics(),
              //       itemCount: data.length,
              //       gridDelegate:
              //           const SliverGridDelegateWithFixedCrossAxisCount(
              //         crossAxisCount: 2, // 每行两个
              //         crossAxisSpacing: 0,
              //         mainAxisSpacing: 0,
              //         childAspectRatio: 5.5, // 调整宽高比以适应内容
              //       ),
              //       itemBuilder: (context, index) {
              //         final rate = rates[index];
              //         final displayRate = rate.toStringAsFixed(4);
              //         final dateStr = dates[index];
              //         return Container(
              //           padding: const EdgeInsets.symmetric(
              //               horizontal: 6, vertical: 0),
              //           decoration: BoxDecoration(
              //             color: Theme.of(context).colorScheme.surface,
              //             borderRadius: BorderRadius.circular(8),
              //           ),
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               const SizedBox(
              //                 height: 4,
              //               ),
              //               Row(
              //                 children: [
              //                   Text(
              //                     dateStr.isNotEmpty ? '$dateStr  ' : '',
              //                     style: TextStyle(
              //                         fontSize: 11,
              //                         height: 1,
              //                         color: Theme.of(context)
              //                             .colorScheme
              //                             .outline),
              //                     maxLines: 1,
              //                     overflow: TextOverflow.ellipsis,
              //                   ),
              //                   Text(
              //                     displayRate,
              //                     style: TextStyle(
              //                         fontSize: 11,
              //                         fontWeight: FontWeight.w500,
              //                         height: 1,
              //                         color: Theme.of(context)
              //                             .colorScheme
              //                             .onSurface),
              //                     maxLines: 1,
              //                     overflow: TextOverflow.ellipsis,
              //                   ),
              //                 ],
              //               )
              //             ],
              //           ),
              //         );
              //       },
              //     ),
              //   ), // End of Visibility
              // ), // End of AnimatedSize
            ],
          ),
        )
    ]);
  }

  
}
