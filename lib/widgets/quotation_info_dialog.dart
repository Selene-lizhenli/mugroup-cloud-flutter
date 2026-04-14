import 'package:cloud/pages/cart/models/state.dart' as cart_state;
import 'package:cloud/pages/samples/providers/home_provider.dart';
import 'package:flant/components/action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class QuotationInfoDialog extends HookConsumerWidget {
  const QuotationInfoDialog({
    super.key,
    this.initialValue,
    this.openedFrom,
    this.currencies = const ['CNY', 'USD', 'EUR', 'GBP'],
  });

  final cart_state.QuotationInfo? initialValue;
  final List<String> currencies;
  final String? openedFrom;

  static Future<cart_state.QuotationInfo?> show(
    BuildContext context, {
    cart_state.QuotationInfo? initialValue,
    List<String> currencies = const ['CNY', 'USD', 'EUR', 'GBP'],
  }) {
    return showDialog<cart_state.QuotationInfo>(
      context: context,
      builder: (context) => QuotationInfoDialog(
        initialValue: initialValue,
        currencies: currencies,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initial = initialValue;
    final showPrice = useState<bool?>(initial?.showPrice);
    final showTaxRatePrice = useState<bool?>(initial?.showTaxRatePrice);
    final currency = useState<String?>(initial?.curreny);
    final homeNotifier = ref.read(homeProvider.notifier);

    final exchangeController = useTextEditingController(
      text: initial?.exchange?.toString() ?? '',
    );
    final commissionRateController = useTextEditingController(
      text: initial?.commissionRate?.toString() ?? '',
    );

    final exchangeFieldKey = useMemoized(GlobalKey.new);
    final commissionRateFieldKey = useMemoized(GlobalKey.new);

    void scrollToField(GlobalKey key) {
      Future.delayed(const Duration(milliseconds: 300), () {
        final fieldContext = key.currentContext;
        if (fieldContext == null) return;
        Scrollable.ensureVisible(
          fieldContext,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: 0.8,
        );
      });
    }

    final currencyActions = useMemoized(
      () => currencies
          .map((c) => FlanActionSheetAction(name: c))
          .toList(growable: false),
      [currencies],
    );

    void pickCurrency() {
      showFlanActionSheet(
        context,
        description: "请选择报价币种",
        cancelText: "我再想想",
        actions: currencyActions,
        closeOnClickAction: true,
        onSelect: (action, index) {
          currency.value = currencyActions[index].name;
        },
      );
    }

    final colorScheme = Theme.of(context).colorScheme;
    final settingLabelStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: colorScheme.onSurface,
    );

    final fixedSettingLabelWidth = (TextPainter(
          text: TextSpan(text: "佣金比率(%)：", style: settingLabelStyle),
          textDirection: Directionality.of(context),
        )..layout())
            .width +
        5;

    return Dialog(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            decoration: BoxDecoration(color: colorScheme.primary),
            child: Text(
              "价格设置",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: colorScheme.onPrimary,
              ),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "是否显示价格",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Radio<bool>(
                        value: true,
                        groupValue: showPrice.value,
                        fillColor: WidgetStateProperty.all(
                          colorScheme.secondary,
                        ),
                        onChanged: (value) {
                          showPrice.value = value;
                        },
                      ),
                      Text(
                        '是',
                        style: TextStyle(
                          fontSize: 14,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Radio<bool>(
                        value: false,
                        groupValue: showPrice.value,
                        fillColor: WidgetStateProperty.all(
                          colorScheme.secondary,
                        ),
                        onChanged: (value) {
                          showPrice.value = value;
                        },
                      ),
                      Text(
                        '否',
                        style: TextStyle(
                          fontSize: 14,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  if (showPrice.value == true) ...[
                    Divider(height: 1, color: colorScheme.surfaceTint),
                    Row(
                      children: [
                        Text(
                          '采购价是否含税',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Radio<bool>(
                          value: true,
                          groupValue: showTaxRatePrice.value,
                          fillColor: WidgetStateProperty.all(
                            colorScheme.secondary,
                          ),
                          onChanged: (value) {
                            showTaxRatePrice.value = value;
                          },
                        ),
                        Text(
                          '是',
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Radio<bool>(
                          value: false,
                          groupValue: showTaxRatePrice.value,
                          fillColor: WidgetStateProperty.all(
                            colorScheme.secondary,
                          ),
                          onChanged: (value) {
                            showTaxRatePrice.value = value;
                          },
                        ),
                        Text(
                          '否',
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 1, color: colorScheme.surfaceTint),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(
                          width: fixedSettingLabelWidth,
                          child: Text(
                            "报价币种：",
                            textAlign: TextAlign.right,
                            style: settingLabelStyle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: GestureDetector(
                            onTap: pickCurrency,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: colorScheme.outline.withOpacity(0.135),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      currency.value ?? "请选择报价币种",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: currency.value == null
                                            ? colorScheme.onSurface
                                                .withOpacity(0.5)
                                            : colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_right,
                                    color:
                                        colorScheme.onSurface.withOpacity(0.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 20, color: colorScheme.surfaceTint),
                    Row(
                      children: [
                        SizedBox(
                          width: fixedSettingLabelWidth,
                          child: Text(
                            "汇率：",
                            textAlign: TextAlign.right,
                            style: settingLabelStyle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Container(
                            key: exchangeFieldKey,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: colorScheme.outline.withOpacity(0.135),
                            ),
                            child: TextField(
                              controller: exchangeController,
                              cursorColor: colorScheme.secondary,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}'),
                                ),
                              ],
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "请输入汇率",
                                hintStyle: TextStyle(
                                  color: colorScheme.onSurface.withOpacity(0.5),
                                ),
                              ),
                              onTap: () => scrollToField(exchangeFieldKey),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 20, color: colorScheme.surfaceTint),
                    Row(
                      children: [
                        SizedBox(
                          width: fixedSettingLabelWidth,
                          child: Text(
                            "佣金比率(%)：",
                            textAlign: TextAlign.right,
                            style: settingLabelStyle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Container(
                            key: commissionRateFieldKey,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: colorScheme.outline.withOpacity(0.135),
                            ),
                            child: TextField(
                              controller: commissionRateController,
                              cursorColor: colorScheme.secondary,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}'),
                                ),
                              ],
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "请输入佣金比率",
                                hintStyle: TextStyle(
                                  color: colorScheme.onSurface.withOpacity(0.5),
                                ),
                              ),
                              onTap: () =>
                                  scrollToField(commissionRateFieldKey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            decoration: BoxDecoration(
              color: colorScheme.tertiary.withOpacity(0.3),
              border: Border(
                top: BorderSide(
                  color: colorScheme.tertiary.withOpacity(0.5),
                  width: 1,
                ),
                bottom: BorderSide(
                  color: colorScheme.tertiary.withOpacity(0.5),
                  width: 1,
                ),
                left: BorderSide(
                  color: colorScheme.tertiary.withOpacity(0.5),
                  width: 1,
                ),
                right: BorderSide(
                  color: colorScheme.tertiary.withOpacity(0.5),
                  width: 1,
                ),
              ),
            ),
            child: Text(
              "⚠️以上设置将对所有样品生效!",
              style: TextStyle(
                fontSize: 13,
                color: colorScheme.outline,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 5, 24, 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    "取消",
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    if (showPrice.value == true) {
                      homeNotifier.setViewMode(true);
                    }
                    final exchange = double.tryParse(exchangeController.text);
                    final commissionRate =
                        double.tryParse(commissionRateController.text);
                    Navigator.of(context).pop(
                      cart_state.QuotationInfo(
                        showPrice.value,
                        showTaxRatePrice.value,
                        currency.value,
                        exchange,
                        commissionRate,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "提交",
                    style: TextStyle(
                      color: colorScheme.onSecondary,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
