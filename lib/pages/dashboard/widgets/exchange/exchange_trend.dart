import 'package:cloud/models/dashboard/exchange.dart';
import 'package:cloud/pages/dashboard/widgets/chart_dimen_tips.dart';
import 'package:cloud/pages/dashboard/widgets/date_select.dart';
import 'package:cloud/pages/dashboard/widgets/exchange/min_max_labels.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/pages/widgets/empty.dart';
import 'package:cloud/pages/widgets/show_error.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// 汇率趋势图 + 时间范围选择
class ExchangeTrend extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final ExchangeRateHistory? exchangeData;
  final ExchangeRate? selectedDimension;
  final DateRange selectedRange;
  final VoidCallback onRetry;
  final void Function(DateRange range, Map<String, String> params) onRangeChanged;

  const ExchangeTrend({
    super.key,
    required this.isLoading,
    this.errorMessage,
    this.exchangeData,
    this.selectedDimension,
    required this.selectedRange,
    required this.onRetry,
    required this.onRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final data = exchangeData?.data ?? [];
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

    final maxRate =
        rates.isNotEmpty ? rates.reduce((a, b) => a > b ? a : b) : 0.0;
    final minRate =
        rates.isNotEmpty ? rates.reduce((a, b) => a < b ? a : b) : 0.0;
    final maxY = maxRate * 1.015;
    final minY = minRate * 0.99;

    int maxIndex = 0;
    int minIndex = 0;
    if (rates.isNotEmpty) {
      for (int i = 0; i < rates.length; i++) {
        if (rates[i] == maxRate) maxIndex = i;
        if (rates[i] == minRate) minIndex = i;
      }
    }

    return Column(
      children: [
        Column(
          children: [
            if (isLoading)
              const SizedBox(
                height: 150,
                child: Center(
                  child: MuProgressIndicator(
                    showText: true,
                    text: '加载中...',
                  ),
                ),
              )
            else if (errorMessage != null && exchangeData == null)
              SizedBox(
                height: 150,
                child: Center(
                  child: ShowError(
                    errorMessage: errorMessage!,
                    onRetry: onRetry,
                    height: 150,
                  ),
                ),
              )
            else if (exchangeData == null ||
                (exchangeData!.data?.isEmpty ?? true))
              const SizedBox(
                height: 150,
                child: Center(
                  child: Empty(),
                ),
              )
            else
              SizedBox(
                height: 150,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
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
                        LineChart(
                          LineChartData(
                            gridData: FlGridData(show: false),
                            titlesData: FlTitlesData(
                              leftTitles: SideTitles(
                                showTitles: false,
                                reservedSize: 25,
                                getTextStyles: (_) => TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              bottomTitles: SideTitles(
                                showTitles: false,
                                reservedSize: 25,
                                getTitles: (value) {
                                  final index = value.toInt();
                                  if (index >= 0 && index < dates.length) {
                                    final dateStr = dates[index];
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
                              getTouchedSpotIndicator: (LineChartBarData barData,
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
                                      getDotPainter: (spot, percent, barData,
                                          index) {
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

                                      String dateDisplay = dates[index];
                                      try {
                                        final parts = dateDisplay.split('-');
                                        if (parts.length >= 3) {
                                          dateDisplay =
                                              '${parts[0]}年${int.parse(parts[1])}月${int.parse(parts[2])}日';
                                        }
                                      } catch (e) {}

                                      String label = dateDisplay;
                                      label +=
                                          '\n汇率: ${rates[index].toStringAsFixed(4)}';
                                      if (isMax) label += '\n 最高点';
                                      if (isMin) label += '\n 最低点';

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
                        if (selectedDimension != null)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IgnorePointer(
                              child: ChartDimenTips(
                                label:
                                    '${selectedDimension!.name} ${selectedDimension!.shortName}',
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        TimeRangeSelect(
          initialRange: selectedRange,
          onRangeChanged: onRangeChanged,
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}
