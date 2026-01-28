import 'package:cloud/helper/helper.dart';
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
  DateRange selectedRange = DateRange.lastYear; // 选中的时间范围
  // 存储当前货币的历史数据
  ExchangeRateHistory? _exchangeData; //波动图的数据
  List<ExchangeRate>? _currencyList; //列表的数据

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
            _errorMessage = '无效的货币维度';
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
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: colorScheme.surface),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 未选择维度：展示汇率列表 
            if (_selectedDimension == null)
              ExchangeRatesValueList(
                list: _currencyList,
                loading: _isListLoading,
              )
            else
              ExchangeTrend(
                isLoading: _isLoading,
                errorMessage: _errorMessage,
                exchangeData: _exchangeData,
                selectedDimension: _selectedDimension,
                selectedRange: selectedRange,
                onRetry: () => _loadExchangeData(),
                onRangeChanged: (DateRange range, Map<String, String> params) {
                  setState(() => selectedRange = range);
                  _loadExchangeData(params);
                },
              )
          ],
        ),
      )
    ]);
  }
}
