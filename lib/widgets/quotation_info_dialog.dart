import 'package:cloud/l10n/l10n_extension.dart';
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
    final l10n = context.l10n;
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
        description: l10n.quotationSelectCurrency,
        cancelText: l10n.quotationThinkAgain,
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
          text: TextSpan(
            text: l10n.quotationCommissionRateLabel,
            style: settingLabelStyle,
          ),
          textDirection: Directionality.of(context),
        )..layout())
            .width +
        5;

    // 价格设置弹窗
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 标题
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Text(
              l10n.quotationPriceSettings,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: colorScheme.onPrimary,
              ),
            ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
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
              l10n.quotationSettingsApplyToAll,
              style: TextStyle(
                fontSize: 13,
                color: colorScheme.outline,
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
                      // 是否显示价格
                      Text(
                        l10n.quotationShowPrice,
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
                        l10n.yes,
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
                        l10n.no,
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
                          l10n.quotationPurchasePriceIncludesTax,
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
                          l10n.yes,
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
                          l10n.no,
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
                            l10n.quotationCurrencyLabel,
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
                                      currency.value ??
                                          l10n.quotationSelectCurrency,
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
                            l10n.quotationExchangeLabel,
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
                                hintText: l10n.quotationExchangeHint,
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
                            l10n.quotationCommissionRateLabel,
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
                                hintText: l10n.quotationCommissionRateHint,
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
                    const SizedBox(height: 14),
                  ],
                ],
              ),
            ),
          ),

          // 取消 确定按钮组
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
                    l10n.cancel,
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
                    l10n.submit,
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
