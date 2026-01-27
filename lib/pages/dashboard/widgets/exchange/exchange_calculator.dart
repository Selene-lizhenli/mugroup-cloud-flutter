// 汇率计算器弹窗
import 'package:cloud/models/dashboard/exchange.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ExchangeCalculatorDialog extends HookConsumerWidget {
  final ExchangeRate? selectedDimension; // 维度选择的币种
  final List<ExchangeRate?>? list;

  const ExchangeCalculatorDialog({
    super.key,
    this.selectedDimension,
    this.list,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCurrencyIndex = useState<int?>(null); //选中的货币索引
    final currencyAmountController = useTextEditingController();
    final cnyAmountController = useTextEditingController();
    final isUpdating = useState<bool>(false);

    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = colorScheme.primary;
    final secondaryColor = colorScheme.secondary;

    const backgroundColor = Color(0xFFF7F8FA);
    const textColor = Color(0xFF1F1F1F);
    final containerRadius = BorderRadius.circular(16);

    // 处理 list 数据，过滤掉 null 值
    final rates = useMemoized(() {
      if (list == null) return <ExchangeRate>[];
      return list!.whereType<ExchangeRate>().toList();
    }, [list]);

    // 从 list 动态构建币种名称到代码的映射
    final dimensionCurrencyMap = useMemoized(() {
      final map = <String, String>{};
      for (final rate in rates) {
        if (rate.name != null && rate.shortName != null) {
          map[rate.name!] = rate.shortName!;
        }
      }
      return map;
    }, [rates]);

    /// 根据维度选择的币种查找对应的索引
    int? findCurrencyIndex(List<ExchangeRate> rates, String? dimension) {
      if (dimension == null || rates.isEmpty) return null;

      // 先尝试通过名称查找
      for (int i = 0; i < rates.length; i++) {
        if (rates[i].name?.contains(dimension) == true) {
          return i;
        }
      }

      // 如果找不到，尝试通过货币代码查找
      final currency = dimensionCurrencyMap[dimension];
      if (currency != null) {
        for (int i = 0; i < rates.length; i++) {
          if (rates[i].shortName?.toUpperCase() == currency.toUpperCase()) {
            return i;
          }
        }
      }

      return null;
    }

    String formatNumber(double value) {
      final rounded = (value * 10000).round() / 10000.0;
      final formatted = rounded.toStringAsFixed(4);
      final parts = formatted.split('.');
      if (parts.length == 2) {
        final decimalPart = parts[1].replaceAll(RegExp(r'0+$'), '');
        return decimalPart.isEmpty ? parts[0] : '${parts[0]}.$decimalPart';
      }
      return formatted;
    }

    void updateController(TextEditingController controller, String value) {
      isUpdating.value = true;
      controller.text = value;
      isUpdating.value = false;
    }

    void calculateFromCurrency() {
      if (selectedCurrencyIndex.value == null || rates.isEmpty) return;
      if (selectedCurrencyIndex.value! >= rates.length) return;

      final text = currencyAmountController.text;
      if (text.isEmpty) {
        updateController(cnyAmountController, '');
        return;
      }
      final amount = double.tryParse(text);
      if (amount != null) {
        final rate = rates[selectedCurrencyIndex.value!];
        final reverseRate =
            double.tryParse(rate.reverseExchangeRate?.toString() ?? '0') ?? 0.0;
        if (reverseRate > 0) {
          updateController(
              cnyAmountController, formatNumber(amount / reverseRate));
        }
      }
    }

    void calculateFromCNY() {
      if (selectedCurrencyIndex.value == null || rates.isEmpty) return;
      if (selectedCurrencyIndex.value! >= rates.length) return;

      final text = cnyAmountController.text;
      if (text.isEmpty) {
        updateController(currencyAmountController, '');
        return;
      }
      final amount = double.tryParse(text);
      if (amount != null) {
        final rate = rates[selectedCurrencyIndex.value!];
        final reverseRate =
            double.tryParse(rate.reverseExchangeRate?.toString() ?? '0') ?? 0.0;
        updateController(
            currencyAmountController, formatNumber(amount * reverseRate));
      }
    }

    // 设置监听器
    useEffect(() {
      void onCurrencyAmountChanged() {
        if (!isUpdating.value) calculateFromCurrency();
      }

      void onCnyAmountChanged() {
        if (!isUpdating.value) calculateFromCNY();
      }

      currencyAmountController.addListener(onCurrencyAmountChanged);
      cnyAmountController.addListener(onCnyAmountChanged);

      return () {
        currencyAmountController.removeListener(onCurrencyAmountChanged);
        cnyAmountController.removeListener(onCnyAmountChanged);
      };
    }, [currencyAmountController, cnyAmountController]);

    // 初始化选中的币种索引（只在第一次时设置）
    useEffect(() {
      if (selectedCurrencyIndex.value == null && rates.isNotEmpty) {
        final index = findCurrencyIndex(rates, selectedDimension?.name);
        selectedCurrencyIndex.value = index ?? 0;
      }
      return null;
    }, [rates]);

    // 确保索引有效
    if (selectedCurrencyIndex.value != null &&
        selectedCurrencyIndex.value! >= rates.length) {
      selectedCurrencyIndex.value = rates.isEmpty ? null : 0;
    }

    // 如果没有数据，显示空状态
    if (rates.isEmpty) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(20),
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
                    child:
                        const Icon(Icons.close, size: 20, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Center(
              child: Text('暂无汇率数据'),
            ),
          ],
        ),
      );
    }

    final currentCurrency = rates[selectedCurrencyIndex.value ?? 0];
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    String getRateText() {
      if (selectedCurrencyIndex.value == null ||
          selectedCurrencyIndex.value! >= rates.length) {
        return '';
      }
      final rate = rates[selectedCurrencyIndex.value!];
      final reverseRate =
          double.tryParse(rate.reverseExchangeRate?.toString() ?? '0') ?? 0.0;
      return '1 CNY ≈ ${reverseRate.toStringAsFixed(4)} ${rate.name}';
    }

    Widget buildInputRow({
      required String currencyName,
      required TextEditingController controller,
      required bool isPrimary,
      VoidCallback? onTapSelector,
    }) {
      return Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: containerRadius,
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
                      color: isPrimary
                          ? primaryColor.withOpacity(0.1)
                          : secondaryColor.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      currencyName.isNotEmpty
                          ? currencyName.substring(0, 1)
                          : '?',
                      style: TextStyle(
                        color: isPrimary ? primaryColor : secondaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    currencyName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
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
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: textColor,
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

    void showCurrencySelector() {
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
              exchangeRates: rates,
              selectedIndex: selectedCurrencyIndex.value ?? 0,
              scrollController: scrollController,
              onSelect: (index) {
                selectedCurrencyIndex.value = index;
                if (cnyAmountController.text.isNotEmpty) {
                  calculateFromCNY();
                } else {
                  currencyAmountController.clear();
                }
                Navigator.pop(context);
              },
            );
          },
        ),
      );
    }

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
                  buildInputRow(
                    currencyName: '人民币',
                    controller: cnyAmountController,
                    isPrimary: true,
                    onTapSelector: showCurrencySelector,
                  ),
                  const SizedBox(height: 4),
                  buildInputRow(
                    currencyName: currentCurrency.name ?? '',
                    controller: currencyAmountController,
                    isPrimary: true,
                    onTapSelector: showCurrencySelector,
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: backgroundColor, width: 4),
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
                  child: Icon(Icons.swap_vert, size: 20, color: primaryColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              getRateText(),
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrencySearchList extends HookWidget {
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
  Widget build(BuildContext context) {
    final keyword = useState<String>('');
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = colorScheme.primary;
    final secondaryColor = colorScheme.secondary;

    final filteredIndices = useMemoized(() {
      if (keyword.value.isEmpty) {
        return List.generate(exchangeRates.length, (i) => i);
      } else {
        final indices = <int>[];
        for (int i = 0; i < exchangeRates.length; i++) {
          if ((exchangeRates[i].name ?? '').contains(keyword.value)) {
            indices.add(i);
          }
        }
        return indices;
      }
    }, [keyword.value, exchangeRates]);

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
              keyword.value = value;
            },
          ),
        ),
        const Divider(height: 1, color: Color(0xFFEEEEEE)),
        Expanded(
          child: filteredIndices.isEmpty
              ? const Center(
                  child: Text('未找到相关货币', style: TextStyle(color: Colors.grey)))
              : ListView.separated(
                  controller: scrollController,
                  itemCount: filteredIndices.length,
                  separatorBuilder: (_, __) => const Divider(
                      height: 1, indent: 16, color: Color(0xFFEEEEEE)),
                  itemBuilder: (context, index) {
                    final realIndex = filteredIndices[index];
                    final item = exchangeRates[realIndex];
                    final isSelected = realIndex == selectedIndex;

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
                          style: TextStyle(
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
                          ? Icon(Icons.check_circle, color: primaryColor)
                          : null,
                      onTap: () => onSelect(realIndex),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
