import 'package:cloud/constants/theme_config.dart';
import 'package:cloud/l10n/l10n_extension.dart';
import 'package:cloud/pages/dashboard/widgets/date_select.dart';
import 'package:cloud/pages/dashboard/widgets/exchange/exchange_header.dart';
import 'package:cloud/pages/dashboard/widgets/exchange/exchange_list.dart';
import 'package:cloud/pages/dashboard/widgets/exchange/exchange_trend.dart';
import 'package:flutter/material.dart';
import 'package:cloud/models/dashboard/exchange.dart';
import 'package:cloud/services/dashboard.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// main
class LineChartDemo extends ConsumerStatefulWidget {
  const LineChartDemo({
    super.key,
  });

  @override
  ConsumerState<LineChartDemo> createState() => _LineChartDemoState();
}

class _LineChartDemoState extends ConsumerState<LineChartDemo> {
  ExchangeRate? _selectedDimension; // 选中的维度，默认选中美元
  bool _isLoading = false;
  String? _errorMessage;
  bool _isListLoading = false;
  DateRange selectedRange = DateRange.lastTwoYear; // 选中的时间范围
  // 存储当前货币的历史数据
  ExchangeRateHistory? _exchangeData; //波动图的数据
  List<ExchangeRate>? _currencyList; //列表的数据
  bool _showTrendView = false; // true 表示显示趋势图，false 表示显示列表

  /// 加载汇率数据
  /// [params] 有值时使用其 start/end 请求接口，否则用 [selectedRange] 换算
  Future<void> _loadExchangeData([Map<String, String>? params]) async {
    if (_selectedDimension == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final currency = _selectedDimension!.shortName;

      if (currency == null) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = context.l10n.dashboardInvalidCurrency;
          });
        }
        return;
      }
      final dateParams = params ?? trnasDateRangeToParams(selectedRange);
      final Map<String, String> paramsData = {
        'currency': currency,
        'start': dateParams['start']!,
        'end': dateParams['end']!,
      };
      final data = await getExchangeRateHistory(params: paramsData);

      if (mounted) {
        setState(() {
          _exchangeData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = context.l10n.dashboardExchangeLoadFailed('$e');
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
          _errorMessage = context.l10n.dashboardDataLoadFailed('$e');
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
        onViewToggle: (bool val) {
          setState(() {
            _showTrendView = val;
          });
        },
        showTrendView: _showTrendView,
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: colorScheme.surface.withOpacity(0.93),
          boxShadow: const [
            BoxShadow(
              color: pageShadowColor,
              blurRadius: 10,
              offset: Offset(0, 0), // 上下左右均匀阴影
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 根据切换状态和维度选择状态决定显示哪个视图
            if (_showTrendView && _selectedDimension != null)
              ExchangeTrend(
                isLoading: _isLoading,
                errorMessage: _errorMessage,
                exchangeData: _exchangeData,
                selectedDimension: _selectedDimension,
                selectedRange: selectedRange,
                onRetry: () => _loadExchangeData(),
                onRangeChanged: (DateRange range, Map<String, String> params) {
                  setState(() {
                    selectedRange = range;
                  });
                  _loadExchangeData(params);
                },
              )
            else
              ExchangeRatesValueList(
                list: _currencyList,
                loading: _isListLoading,
                onCurrencyTap: (ExchangeRate item) {
                  setState(() {
                    _selectedDimension = item;
                    _showTrendView = true;
                    _exchangeData = null;
                  });
                  _loadExchangeData();
                },
              )
          ],
        ),
      )
    ]);
  }
}
