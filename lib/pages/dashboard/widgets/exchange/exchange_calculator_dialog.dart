// 汇率计算器弹窗
import 'package:cloud/models/dashboard/exchange.dart';
import 'package:flutter/material.dart';

class ExchangeCalculatorDialog extends StatefulWidget {
  final List<ExchangeRate> exchangeRates;
  final int defaultCurrencyIndex;

  const ExchangeCalculatorDialog({
    super.key,
    required this.exchangeRates,
    required this.defaultCurrencyIndex,
  });

  @override
  State<ExchangeCalculatorDialog> createState() =>
      _ExchangeCalculatorDialogState();
}

class _ExchangeCalculatorDialogState extends State<ExchangeCalculatorDialog> {
  late int _selectedCurrencyIndex;
  final TextEditingController _currencyAmountController =
      TextEditingController();
  final TextEditingController _cnyAmountController = TextEditingController();

  bool _isUpdating = false;

  final Color _primaryColor = const Color(0xFF1677FF);
  final Color _backgroundColor = const Color(0xFFF7F8FA);
  final Color _textColor = const Color(0xFF1F1F1F);
  final BorderRadius _containerRadius = BorderRadius.circular(16);

  @override
  void initState() {
    super.initState();
    _selectedCurrencyIndex = widget.defaultCurrencyIndex;

    _currencyAmountController.addListener(() {
      if (!_isUpdating) _calculateFromCurrency();
    });
    _cnyAmountController.addListener(() {
      if (!_isUpdating) _calculateFromCNY();
    });
  }

  @override
  void dispose() {
    _currencyAmountController.dispose();
    _cnyAmountController.dispose();
    super.dispose();
  }

  String _formatNumber(double value) {
    final rounded = (value * 10000).round() / 10000.0;
    final formatted = rounded.toStringAsFixed(4);
    final parts = formatted.split('.');
    if (parts.length == 2) {
      final decimalPart = parts[1].replaceAll(RegExp(r'0+$'), '');
      return decimalPart.isEmpty ? parts[0] : '${parts[0]}.$decimalPart';
    }
    return formatted;
  }

  void _calculateFromCurrency() {
    final text = _currencyAmountController.text;
    if (text.isEmpty) {
      _updateController(_cnyAmountController, '');
      return;
    }
    final amount = double.tryParse(text);
    if (amount != null) {
      final rate = widget.exchangeRates[_selectedCurrencyIndex];
      final reverseRate =
          double.tryParse(rate.reverseExchangeRate?.toString() ?? '0') ?? 0.0;
      if (reverseRate > 0) {
        _updateController(
            _cnyAmountController, _formatNumber(amount / reverseRate));
      }
    }
  }

  void _calculateFromCNY() {
    final text = _cnyAmountController.text;
    if (text.isEmpty) {
      _updateController(_currencyAmountController, '');
      return;
    }
    final amount = double.tryParse(text);
    if (amount != null) {
      final rate = widget.exchangeRates[_selectedCurrencyIndex];
      final reverseRate =
          double.tryParse(rate.reverseExchangeRate?.toString() ?? '0') ?? 0.0;
      _updateController(
          _currencyAmountController, _formatNumber(amount * reverseRate));
    }
  }

  void _updateController(TextEditingController controller, String value) {
    _isUpdating = true;
    controller.text = value;
    _isUpdating = false;
  }

  @override
  Widget build(BuildContext context) {
    final currentCurrency = widget.exchangeRates[_selectedCurrencyIndex];

    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: bottomPadding + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '汇率换算',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 20, color: Colors.grey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  _buildInputRow(
                    context: context,
                    currencyName: currentCurrency.name ?? '',
                    controller: _currencyAmountController,
                    isSource: true,
                    onTapSelector: () => _showCurrencySelector(context),
                  ),
                  const SizedBox(height: 4),
                  _buildInputRow(
                    context: context,
                    currencyName: '人民币',
                    controller: _cnyAmountController,
                    isSource: false,
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: _backgroundColor, width: 4),
                ),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(Icons.arrow_downward_rounded,
                      size: 20, color: _primaryColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              _getRateText(),
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ),
        ],
      ),
    );
  }

  String _getRateText() {
    final rate = widget.exchangeRates[_selectedCurrencyIndex];
    final reverseRate =
        double.tryParse(rate.reverseExchangeRate?.toString() ?? '0') ?? 0.0;
    return '1 CNY ≈ ${reverseRate.toStringAsFixed(4)} ${rate.name}';
  }

  Widget _buildInputRow({
    required BuildContext context,
    required String currencyName,
    required TextEditingController controller,
    required bool isSource,
    VoidCallback? onTapSelector,
  }) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: _containerRadius,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onTapSelector,
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isSource
                        ? _primaryColor.withOpacity(0.1)
                        : Colors.red.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    currencyName.isNotEmpty
                        ? currencyName.substring(0, 1)
                        : '?',
                    style: TextStyle(
                      color: isSource ? _primaryColor : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  currencyName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _textColor,
                  ),
                ),
                if (onTapSelector != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Icon(Icons.keyboard_arrow_down_rounded,
                        size: 18, color: Colors.grey.shade600),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: _textColor,
                height: 1.2,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '0',
                hintStyle: TextStyle(color: Color(0xFFC7C7CC)),
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  void _showCurrencySelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return _CurrencySearchList(
            exchangeRates: widget.exchangeRates,
            selectedIndex: _selectedCurrencyIndex,
            scrollController: scrollController,
            onSelect: (index) {
              setState(() {
                _selectedCurrencyIndex = index;
                if (_cnyAmountController.text.isNotEmpty) {
                  _calculateFromCNY();
                } else {
                  _currencyAmountController.clear();
                }
              });
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}

class _CurrencySearchList extends StatefulWidget {
  final List<ExchangeRate> exchangeRates;
  final int selectedIndex;
  final ScrollController scrollController;
  final ValueChanged<int> onSelect;

  const _CurrencySearchList({
    required this.exchangeRates,
    required this.selectedIndex,
    required this.scrollController,
    required this.onSelect,
  });

  @override
  State<_CurrencySearchList> createState() => _CurrencySearchListState();
}

class _CurrencySearchListState extends State<_CurrencySearchList> {
  String _keyword = '';
  late List<int> _filteredIndices;

  @override
  void initState() {
    super.initState();
    _filterList();
  }

  void _filterList() {
    if (_keyword.isEmpty) {
      _filteredIndices = List.generate(widget.exchangeRates.length, (i) => i);
    } else {
      _filteredIndices = [];
      for (int i = 0; i < widget.exchangeRates.length; i++) {
        if ((widget.exchangeRates[i].name ?? '').contains(_keyword)) {
          _filteredIndices.add(i);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            decoration: InputDecoration(
              hintText: '搜索货币名称',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFFF7F8FA),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
            ),
            onChanged: (value) {
              setState(() {
                _keyword = value;
                _filterList();
              });
            },
          ),
        ),
        const Divider(height: 1, color: Color(0xFFEEEEEE)),
        Expanded(
          child: _filteredIndices.isEmpty
              ? const Center(
                  child: Text('未找到相关货币', style: TextStyle(color: Colors.grey)))
              : ListView.separated(
                  controller: widget.scrollController,
                  itemCount: _filteredIndices.length,
                  separatorBuilder: (_, __) => const Divider(
                      height: 1, indent: 16, color: Color(0xFFEEEEEE)),
                  itemBuilder: (context, index) {
                    final realIndex = _filteredIndices[index];
                    final item = widget.exchangeRates[realIndex];
                    final isSelected = realIndex == widget.selectedIndex;
                    const primaryColor = Color(0xFF1677FF);

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 4),
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle),
                        alignment: Alignment.center,
                        child: Text(
                          (item.name ?? '?').substring(0, 1),
                          style: const TextStyle(
                              color: primaryColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        item.name ?? '',
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? primaryColor : Colors.black87,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: primaryColor)
                          : null,
                      onTap: () => widget.onSelect(realIndex),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
