// 汇率计算器弹窗
import 'package:cloud/l10n/l10n_extension.dart';
import 'package:cloud/models/dashboard/exchange.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

ExchangeRate _buildCnyRate(String name) => ExchangeRate(
      name: name,
      shortName: 'CNY',
      exchangeRate: '1',
      reverseExchangeRate: '1',
    );

bool _isCny(ExchangeRate r) => r.shortName == 'CNY';

double _getReverse(ExchangeRate r) =>
    double.tryParse(r.reverseExchangeRate ?? '0') ?? 0.0;

final _rateInputFormatter = TextInputFormatter.withFunction((
  oldValue,
  newValue,
) {
  final text = newValue.text;
  if (text.isEmpty || RegExp(r'^\d*\.?\d{0,4}$').hasMatch(text)) {
    return newValue;
  }
  return oldValue;
});

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
    final l10n = context.l10n;
    final cnyRate = _buildCnyRate(l10n.dashboardCny);
    // 两个换算币种：默认人民币 + 默认维度币种；用 ExchangeRate 作为选中值
    final selectedFrom = useState<ExchangeRate?>(null);
    final selectedTo = useState<ExchangeRate?>(null);
    final fromAmountController = useTextEditingController();
    final toAmountController = useTextEditingController();
    final rateController = useTextEditingController();
    final isUpdating = useState<bool>(false);
    final isCustomRate = useState<bool>(false);

    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = colorScheme.primary;
    final secondaryColor = colorScheme.secondary;
    final isChinese =
        Localizations.localeOf(context).languageCode.startsWith('zh');

    const textColor = Color(0xFF1F1F1F);
    final containerRadius = BorderRadius.circular(16);

    // 处理 list 数据，过滤掉 null 值
    final rates = useMemoized(() {
      if (list == null) return <ExchangeRate>[];
      return list!.whereType<ExchangeRate>().toList();
    }, [list]);

    /// 供选择的币种列表：人民币 + 接口返回的列表（若接口含人民币则不再重复）
    final choiceList = useMemoized(() {
      final rest = rates.where((r) => !_isCny(r)).toList();
      return [cnyRate, ...rest];
    }, [rates, cnyRate]);

    /// 在 rates 中按 shortName 查找与 target 相同的项
    ExchangeRate? findInRates(ExchangeRate? target) {
      if (target == null || rates.isEmpty) return null;
      for (final r in rates) {
        if (r.shortName == target.shortName) return r;
      }
      return null;
    }

    /// 换算率：1 [from] = ? [to]
    double calcaToRate(ExchangeRate from, ExchangeRate to) {
      if (_isCny(from) && _isCny(to)) return 1.0;
      if (_isCny(from) && !_isCny(to)) return _getReverse(to);
      if (!_isCny(from) && _isCny(to)) {
        final r = _getReverse(from);
        return r > 0 ? 1.0 / r : 0;
      }
      final rf = _getReverse(from);
      final rt = _getReverse(to);
      return rf > 0 ? rt / rf : 0;
    }

    double getDefaultRate() {
      final from = selectedFrom.value;
      final to = selectedTo.value;
      if (from == null || to == null) return 0;
      return calcaToRate(from, to);
    }

    double getCurrentRate() {
      if (isCustomRate.value) {
        final customRate = double.tryParse(rateController.text);
        if (customRate != null && customRate > 0) return customRate;
        return 0;
      }
      return getDefaultRate();
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

    void updateDefaultRateText() {
      final rate = getDefaultRate();
      updateController(rateController, rate > 0 ? formatNumber(rate) : '');
    }

    void calculateFromLeft() {
      final from = selectedFrom.value;
      final to = selectedTo.value;
      if (from == null || to == null) return;

      final text = fromAmountController.text;
      if (text.isEmpty) {
        updateController(toAmountController, '');
        return;
      }
      final amount = double.tryParse(text);
      if (amount != null) {
        final rate = getCurrentRate();
        if (rate > 0) {
          updateController(toAmountController, formatNumber(amount * rate));
        } else {
          updateController(toAmountController, '');
        }
      }
    }

    void calculateFromRight() {
      final from = selectedFrom.value;
      final to = selectedTo.value;
      if (from == null || to == null) return;

      final text = toAmountController.text;
      if (text.isEmpty) {
        updateController(fromAmountController, '');
        return;
      }
      final amount = double.tryParse(text);
      if (amount != null) {
        final rate = getCurrentRate();
        if (rate > 0) {
          updateController(fromAmountController, formatNumber(amount / rate));
        } else {
          updateController(fromAmountController, '');
        }
      }
    }

    // 设置监听器
    useEffect(() {
      void onFromChanged() {
        if (!isUpdating.value) calculateFromLeft();
      }

      void onToChanged() {
        if (!isUpdating.value) calculateFromRight();
      }

      void onRateChanged() {
        if (isUpdating.value) return;
        if (rateController.text.trim().isEmpty) {
          isCustomRate.value = true;
          // updateController(rateController, '0');
        } else {
          isCustomRate.value = true;
        }
        if (fromAmountController.text.isNotEmpty) {
          calculateFromLeft();
        } else if (toAmountController.text.isNotEmpty) {
          calculateFromRight();
        }
      }

      fromAmountController.addListener(onFromChanged);
      toAmountController.addListener(onToChanged);
      rateController.addListener(onRateChanged);

      return () {
        fromAmountController.removeListener(onFromChanged);
        toAmountController.removeListener(onToChanged);
        rateController.removeListener(onRateChanged);
      };
    }, [fromAmountController, toAmountController, rateController]);

    // 初始化：默认人民币 + 维度币种，用 ExchangeRate 作为选中值
    useEffect(() {
      selectedFrom.value ??= cnyRate;
      if (selectedTo.value == null && choiceList.isNotEmpty) {
        selectedTo.value = findInRates(selectedDimension) ??
            selectedDimension ??
            (choiceList.length > 1 ? choiceList[1] : choiceList.first);
      }
      return null;
    }, [choiceList, selectedDimension]);

    useEffect(() {
      if (!isCustomRate.value) {
        updateDefaultRateText();
      }
      return null;
    }, [selectedFrom.value, selectedTo.value, isCustomRate.value]);

    // 如果没有可选的除人民币外的币种，显示空状态
    if (choiceList.length <= 1) {
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
                Text(
                  l10n.dashboardExchangeCalculator,
                  style: const TextStyle(
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
            Center(
              child: Text(l10n.dashboardNoExchangeData),
            ),
          ],
        ),
      );
    }

    final from = selectedFrom.value ?? cnyRate;
    final to = selectedTo.value;

    String getRateText() {
      if (to == null) return '';
      final r = getDefaultRate();
      if (r <= 0) return '';
      return '${l10n.dashboardExchangeRateDefaultHint}\n'
          '1${from.name} ≈ ${formatNumber(r)}${to.name}';
    }

    void showCurrencySelector(
      BuildContext ctx,
      List<ExchangeRate> options, {
      required ExchangeRate? selectedValue,
      required ValueChanged<ExchangeRate> onSelect,
    }) {
      showModalBottomSheet(
        context: ctx,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width, // 底部抽屉宽度占满屏幕
        ),
        builder: (ctx2) => DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (ctx2, scrollController) {
            return _CurrencySearchList(
              options: options,
              selectedValue: selectedValue,
              scrollController: scrollController,
              onSelect: (r) {
                onSelect(r);
                Navigator.pop(ctx);
              },
            );
          },
        ),
      );
    }

    void showSelectorForFrom() =>
        showCurrencySelector(context, choiceList, selectedValue: from,
            onSelect: (r) {
          selectedFrom.value = r;
          isCustomRate.value = false;
          if (fromAmountController.text.isNotEmpty) {
            calculateFromLeft();
          } else {
            toAmountController.clear();
          }
        });

    void showSelectorForTo() =>
        showCurrencySelector(context, choiceList, selectedValue: to,
            onSelect: (r) {
          selectedTo.value = r;
          isCustomRate.value = false;
          if (toAmountController.text.isNotEmpty) {
            calculateFromRight();
          } else {
            fromAmountController.clear();
          }
        });

    Widget buildInputRow({
      required ExchangeRate currency,
      required TextEditingController controller,
      required bool isPrimary,
      bool autofocus = false,
      VoidCallback? onTapSelector,
    }) {
      final currencyName =
          isChinese ? (currency.name ?? '') : (currency.shortName ?? '');
      return Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: containerRadius,
          border: Border.all(
            color: colorScheme.primary.withOpacity(0.45),
            width: 0.5,
          ),
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
                autofocus: autofocus,
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

    Widget buildRateRow() {
      return FractionallySizedBox(
        widthFactor: 0.70,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${l10n.current} ${l10n.quoteExchangeRate}',
                style: const TextStyle(
                  fontSize: 16,
                  color: textColor,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: 62,
                      child: TextField(
                        controller: rateController,
                        inputFormatters: [_rateInputFormatter],
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                          height: 1.2,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: l10n.quotationExchangeHint,
                          hintStyle: const TextStyle(
                            color: Color(0xFFC7C7CC),
                            fontSize: 13,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 55,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.dashboardExchangeCalculator,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimary),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close,
                        size: 22, color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                buildRateRow(),
                const SizedBox(height: 4),
                buildInputRow(
                  currency: from,
                  controller: fromAmountController,
                  isPrimary: true,
                  autofocus: true,
                  onTapSelector: showSelectorForFrom,
                ),
                const SizedBox(height: 2),
                Icon(Icons.swap_vert, size: 24, color: colorScheme.primary),
                const SizedBox(height: 2),
                buildInputRow(
                  currency: to ?? cnyRate,
                  controller: toAmountController,
                  isPrimary: false,
                  onTapSelector: showSelectorForTo,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                getRateText(),
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _CurrencySearchList extends HookWidget {
  final List<ExchangeRate> options;
  final ExchangeRate? selectedValue;
  final ScrollController scrollController;
  final ValueChanged<ExchangeRate> onSelect;

  const _CurrencySearchList({
    required this.options,
    required this.selectedValue,
    required this.scrollController,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final keyword = useState<String>('');
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = colorScheme.primary;

    final filteredList = useMemoized(() {
      if (keyword.value.isEmpty) return options;
      return options
          .where((r) => (r.name ?? '').contains(keyword.value))
          .toList();
    }, [keyword.value, options]);

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
              hintText: l10n.dashboardSearchCurrency,
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFFF7F8FA),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
            ),
            onChanged: (value) => keyword.value = value,
          ),
        ),
        const Divider(height: 1, color: Color(0xFFEEEEEE)),
        Expanded(
          child: filteredList.isEmpty
              ? Center(
                  child: Text(l10n.dashboardCurrencyNotFound,
                      style: const TextStyle(color: Colors.grey)))
              : ListView.separated(
                  controller: scrollController,
                  itemCount: filteredList.length,
                  separatorBuilder: (_, __) => const Divider(
                      height: 1, indent: 16, color: Color(0xFFEEEEEE)),
                  itemBuilder: (context, index) {
                    final item = filteredList[index];
                    final isSelected =
                        selectedValue?.shortName == item.shortName;

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
                        '${item.name ?? ''} ${item.shortName ?? ''}',
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? primaryColor : Colors.black87,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(Icons.check_circle, color: primaryColor)
                          : null,
                      onTap: () => onSelect(item),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
