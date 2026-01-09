import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud/models/dashboard/exchange.dart';
import 'package:cloud/services/dashboard.dart';

class LineChartDemo extends StatefulWidget {
  const LineChartDemo({super.key});

  @override
  State<LineChartDemo> createState() => _LineChartDemoState();
}

class _LineChartDemoState extends State<LineChartDemo> {
  // 固定的颜色列表，用于为货币分配颜色
  static const List<Color> _colorPalette = [
    Color(0xFF4A90E2), // 蓝色
    Color(0xFF2E7D32), // 深绿色
    Color(0xFFFF9800), // 橙色
    Color(0xFF2196F3), // 浅蓝色
    Color(0xFF9C27B0), // 紫色
    Color(0xFFE91E63), // 粉色
    Color(0xFFFFC107), // 黄色
    Color(0xFF00BCD4), // 青色
    Color(0xFF795548), // 棕色
    Color(0xFF607D8B), // 蓝灰色
    Color(0xFFF44336), // 红色
    Color(0xFF8BC34A), // 浅绿色
    Color(0xFF3F51B5), // 靛蓝色
  ];

  List<ExchangeRate>? _exchangeRates;
  bool _isLoading = true;
  String? _error;
  int? _touchedIndex; // 当前点击的柱子索引，默认选中美元

  @override
  void initState() {
    super.initState();
    _loadExchangeRates();
  }

  /// 加载汇率数据
  Future<void> _loadExchangeRates() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final response = await getExchangesList();
      final rates = response ?? [];

      if (rates.isEmpty) {
        setState(() {
          _isLoading = false;
          _error = '暂无汇率数据';
        });
        return;
      }

      // 找到美元的索引作为默认选中
      int? usdIndex;
      for (int i = 0; i < rates.length; i++) {
        if (rates[i].name == '美元') {
          usdIndex = i;
          break;
        }
      }

      setState(() {
        _exchangeRates = rates;
        _touchedIndex = usdIndex ?? 0;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = '加载汇率数据失败: $e';
      });
    }
  }

  /// 获取货币名称列表
  List<String> get _currencies {
    return _exchangeRates?.map((e) => e.name ?? '').toList() ?? [];
  }

  /// 获取汇率列表（1单位该货币 = 多少人民币）
  List<double> get _exchangeRatesList {
    if (_exchangeRates == null) return [];
    return _exchangeRates!.map((e) {
      // exchange_rate 是字符串，表示 100 单位该货币 = 多少人民币（元）
      // 需要除以 100 转换为 1 单位该货币 = 多少人民币（元）
      final rateStr = e.exchangeRate ?? '0';
      final rate = double.tryParse(rateStr) ?? 0.0;
      // 除以100并四舍五入到4位小数，避免浮点数精度问题
      return double.parse((rate / 100.0).toStringAsFixed(4));
    }).toList();
  }

  /// 获取货币颜色列表
  List<Color> get _currencyColors {
    if (_exchangeRates == null) return [];
    return List.generate(
      _exchangeRates!.length,
      (index) => _colorPalette[index % _colorPalette.length],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        padding: const EdgeInsets.all(16),
        height: 300,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _error!,
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _loadExchangeRates,
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      );
    }

    if (_exchangeRates == null || _exchangeRates!.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: const Center(
          child: Text('暂无汇率数据'),
        ),
      );
    }

    final currencies = _currencies;
    final exchangeRates = _exchangeRatesList;
    final currencyColors = _currencyColors;

    // 计算最大汇率用于设置Y轴范围
    final maxY = exchangeRates.isNotEmpty
        ? exchangeRates.reduce((a, b) => a > b ? a : b) * 1.2
        : 10.0;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 图例
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: List.generate(
              currencies.length,
              (index) => _buildLegendItem(
                currencies[index],
                currencyColors[index],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 柱状图
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 20,
                    getTitles: (value) {
                      // 纵轴：显示汇率（保留2位小数）
                      if (value % 2 == 0 && value >= 0) {
                        return value.toStringAsFixed(1);
                      }
                      return '';
                    },
                    getTextStyles: (value) => TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  bottomTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitles: (value) {
                      // 横轴：显示货币名称（简化显示，只显示前几个字符）
                      final index = value.toInt();
                      if (index >= 0 && index < currencies.length) {
                        final name = currencies[index];
                        // 如果名称较长，只显示前2-3个字符
                        if (name.length > 3) {
                          return name.substring(0, 2);
                        }
                        return name;
                      }
                      return '';
                    },
                    getTextStyles: (value) => TextStyle(
                      fontSize: 9,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  topTitles: SideTitles(showTitles: false),
                  rightTitles: SideTitles(showTitles: false),
                ),
                minY: 0,
                maxY: maxY,
                borderData: FlBorderData(show: false),
                barGroups: List.generate(
                  currencies.length,
                  (index) => BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        y: exchangeRates[index],
                        colors: _touchedIndex == index
                            ? [currencyColors[index].withOpacity(0.8)]
                            : [currencyColors[index]],
                        width: 20,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                barTouchData: BarTouchData(
                  touchCallback: (BarTouchResponse? response) {
                    setState(() {
                      // 只在用户真正点击了柱状图时才更新选中状态
                      // 如果 response 或 spot 为 null，不重置选中状态，保持当前选中
                      if (response != null && response.spot != null) {
                        _touchedIndex = response.spot!.touchedBarGroupIndex;
                      }
                      // 移除重置逻辑，这样滚动时不会清除选中状态
                    });
                  },
                ),
              ),
            ),
          ),
          // 显示选中的货币信息
          if (_touchedIndex != null && _touchedIndex! < currencies.length) ...[
            const SizedBox(height: 16),
            _buildSelectedCurrencyInfo(_touchedIndex!),
          ],
        ],
      ),
    );
  }

  /// 构建图例项
  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  /// 构建选中的货币信息显示
  Widget _buildSelectedCurrencyInfo(int index) {
    final currencies = _currencies;
    final exchangeRates = _exchangeRatesList;
    final colorScheme = Theme.of(context).colorScheme;
    if (index >= currencies.length || index >= exchangeRates.length) {
      return const SizedBox.shrink();
    }

    final currencyName = currencies[index];
    final rate = exchangeRates[index];
    final cnyAmount = (100 * rate).toStringAsFixed(2); // 100单位该货币 = 多少人民币

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        // border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '100 $currencyName = $cnyAmount 元',
            style: TextStyle(
              fontSize: 13,
              color:  colorScheme.onSurface,
              // fontWeight: FontWeight.w500,
            ),
          ),
          TextButton(
            onPressed: () => _showExchangeCalculator(context, index),
            child: const Text(
              '汇率计算器',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 显示汇率计算器弹窗
  void _showExchangeCalculator(BuildContext context, int defaultCurrencyIndex) {
    if (_exchangeRates == null || _exchangeRates!.isEmpty) {
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: _ExchangeCalculatorDialog(
            exchangeRates: _exchangeRates!,
            defaultCurrencyIndex: defaultCurrencyIndex,
          ),
        );
      },
    );
  }
}

/// 汇率计算器弹窗
class _ExchangeCalculatorDialog extends StatefulWidget {
  final List<ExchangeRate> exchangeRates;
  final int defaultCurrencyIndex;

  const _ExchangeCalculatorDialog({
    required this.exchangeRates,
    required this.defaultCurrencyIndex,
  });

  @override
  State<_ExchangeCalculatorDialog> createState() => _ExchangeCalculatorDialogState();
}

class _ExchangeCalculatorDialogState extends State<_ExchangeCalculatorDialog> {
  late int _selectedCurrencyIndex;
  final TextEditingController _currencyAmountController = TextEditingController();
  final TextEditingController _cnyAmountController = TextEditingController();
  bool _isUpdating = false; // 标记是否正在更新，防止循环触发

  // 保存监听器引用以便正确移除
  late VoidCallback _currencyListener;
  late VoidCallback _cnyListener;

  @override
  void initState() {
    super.initState();
    _selectedCurrencyIndex = widget.defaultCurrencyIndex;
    
    // 创建监听器函数
    _currencyListener = () {
      if (!_isUpdating) {
        _calculateFromCurrency();
      }
    };
    _cnyListener = () {
      if (!_isUpdating) {
        _calculateFromCNY();
      }
    };
    
    _currencyAmountController.addListener(_currencyListener);
    _cnyAmountController.addListener(_cnyListener);
  }

  @override
  void dispose() {
    _currencyAmountController.removeListener(_currencyListener);
    _cnyAmountController.removeListener(_cnyListener);
    _currencyAmountController.dispose();
    _cnyAmountController.dispose();
    super.dispose();
  }

  /// 格式化数字：精确到4位小数，如果没有小数部分就显示整数
  String _formatNumber(double value) {
    // 先四舍五入到4位小数，使用 round 方法避免浮点数精度问题
    final rounded = (value * 10000).round() / 10000.0;
    final formatted = rounded.toStringAsFixed(4);
    // 移除末尾的0和小数点（如果全部是0）
    final parts = formatted.split('.');
    if (parts.length == 2) {
      final decimalPart = parts[1].replaceAll(RegExp(r'0+$'), '');
      if (decimalPart.isEmpty) {
        return parts[0];
      }
      return '${parts[0]}.$decimalPart';
    }
    return formatted;
  }

  void _calculateFromCurrency() {
    final amount = double.tryParse(_currencyAmountController.text);
    if (amount != null && amount > 0) {
      _isUpdating = true;
      final exchangeRate = widget.exchangeRates[_selectedCurrencyIndex];
      // reverse_exchange_rate 表示 1 CNY = 多少该货币
      // 所以 1 单位该货币 = 1 / reverse_exchange_rate CNY
      // amount 单位该货币 = amount / reverse_exchange_rate CNY
      final reverseRate = exchangeRate.reverseExchangeRate ?? 0.0;
      if (reverseRate > 0) {
        // 使用更高精度计算，避免浮点数精度问题
        final cnyAmount = _formatNumber(amount / reverseRate);
        _cnyAmountController.text = cnyAmount;
      } else {
        _cnyAmountController.text = '';
      }
      _isUpdating = false;
    } else if (_currencyAmountController.text.isEmpty) {
      _isUpdating = true;
      _cnyAmountController.text = '';
      _isUpdating = false;
    }
  }

  void _calculateFromCNY() {
    final amount = double.tryParse(_cnyAmountController.text);
    if (amount != null && amount > 0) {
      _isUpdating = true;
      final exchangeRate = widget.exchangeRates[_selectedCurrencyIndex];
      // reverse_exchange_rate 表示 1 CNY = 多少该货币
      final reverseRate = exchangeRate.reverseExchangeRate ?? 0.0;
      final currencyAmount = _formatNumber(amount * reverseRate);
      _currencyAmountController.text = currencyAmount;
      _isUpdating = false;
    } else if (_cnyAmountController.text.isEmpty) {
      _isUpdating = true;
      _currencyAmountController.text = '';
      _isUpdating = false;
    }
  }

  /// 显示货币选择器
  void _showCurrencySelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext sheetContext) {
        return SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 标题栏
              Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '选择货币',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.of(sheetContext).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              // 货币列表
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: widget.exchangeRates.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: Colors.grey.shade200,
                  ),
                  itemBuilder: (context, index) {
                    final isSelected = _selectedCurrencyIndex == index;
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      title: Text(
                        widget.exchangeRates[index].name ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.black87,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check,
                              color: Theme.of(context).primaryColor,
                            )
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedCurrencyIndex = index;
                        });
                        Navigator.of(sheetContext).pop();
                        // 根据哪个输入框有值来重新计算
                        if (_currencyAmountController.text.isNotEmpty) {
                          _calculateFromCurrency();
                        } else if (_cnyAmountController.text.isNotEmpty) {
                          _calculateFromCNY();
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '汇率计算器',
                  style: TextStyle(
                    fontSize: 20,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          const SizedBox(height: 24),
          // 货币选择
          const Text(
              '选择货币',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _showCurrencySelector(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.exchangeRates[_selectedCurrencyIndex].name ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 24),
          // 一行显示：其他货币输入框 + 双向箭头 + 人民币输入框
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 其他货币输入框
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.exchangeRates[_selectedCurrencyIndex].name ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _currencyAmountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          hintText: '请输入金额',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                // 双向箭头图标
                Padding(
                  padding: const EdgeInsets.only(top: 32, left: 2, right: 2),
                  child: Icon(
                    Icons.swap_horiz,
                    color: Colors.grey.shade400,
                    size: 32,
                  ),
                ),
                // 人民币输入框
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '人民币',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _cnyAmountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          hintText: '请输入金额',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(height: 48),
          ],
        ),
      );
  }
}
