import 'package:cloud/l10n/l10n_extension.dart';
import 'package:cloud/pages/cart/models/state.dart' as cart_state;
import 'package:cloud/pages/samples/providers/home_provider.dart';
import 'package:flant/components/action_sheet.dart';
import 'package:flant/components/stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

//   该弹窗的价格设置适用于：
//   1. 样品卡片支持
//   2. 样品详情
//   3. 购物车 且 类型是报价单选样车

const _defaultTaxRateMapping = <String, double>{'1': 1, '3': 3, '13': 10};
const _invoiceTaxRates = [1, 3, 13];

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

  /// 价格设置默认/重置值
  static cart_state.QuotationInfo resetValue() {
    return const cart_state.QuotationInfo(
      false,
      false,
      'CNY',
      null,
      null,
      taxRateMapping: _defaultTaxRateMapping,
    );
  }

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
    final taxRateMapping = useState<Map<String, double>>(
      Map<String, double>.from(
        initial?.taxRateMapping ?? _defaultTaxRateMapping,
      ),
    );
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
      insetPadding: const EdgeInsets.symmetric(horizontal: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 标题
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
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
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colorScheme.onPrimary,
              ),
            ),
          ),

          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 12, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 是否显示价格
                      Flexible(
                        child: Text(
                          l10n.quotationShowPrice,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.2,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurface,
                          ),
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
                          height: 1,
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
                          height: 1,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // const SizedBox(width: 25),
                      Flexible(
                        child: Text(
                          l10n.quotationShowPriceHint,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            height: 1.1,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.outline.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Divider(height: 1, color: colorScheme.surfaceTint),
                  const SizedBox(height: 7),
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
                      const SizedBox(width: 4),
                      Expanded(
                        child: GestureDetector(
                          onTap: pickCurrency,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
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
                                      fontSize: 13,
                                      color: currency.value == null
                                          ? colorScheme.onSurface
                                              .withOpacity(0.5)
                                          : colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: colorScheme.onSurface.withOpacity(0.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                  Divider(height: 16, color: colorScheme.surfaceTint),
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
                      const SizedBox(width: 4),
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
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}'),
                              ),
                            ],
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontSize: 13,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
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
                      const SizedBox(width: 12),
                    ],
                  ),
                  Divider(height: 16, color: colorScheme.surfaceTint),
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
                      const SizedBox(width: 4),
                      Expanded(
                        child: Container(
                          key: commissionRateFieldKey,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: colorScheme.outline.withOpacity(0.135),
                          ),
                          child: TextField(
                            controller: commissionRateController,
                            cursorColor: colorScheme.secondary,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}'),
                              ),
                            ],
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontSize: 13,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              hintText: l10n.quotationCommissionRateHint,
                              hintStyle: TextStyle(
                                color: colorScheme.onSurface.withOpacity(0.5),
                              ),
                            ),
                            onTap: () => scrollToField(commissionRateFieldKey),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                  Divider(height: 12, color: colorScheme.surfaceTint),
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
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        child: Text(
                          '${l10n.quotationInvoiceTaxRate}：',
                          textAlign: TextAlign.right,
                          style: settingLabelStyle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            for (var i = 0;
                                i < _invoiceTaxRates.length;
                                i++) ...[
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 6,
                                runSpacing: 8,
                                children: [
                                  Text(
                                    '${_invoiceTaxRates[i]}%',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    size: 14,
                                    color: colorScheme.outline,
                                  ),
                                  // Text(
                                  //   l10n.quotationActualTaxRate,
                                  //   style: TextStyle(
                                  //     fontSize: 14,
                                  //     color: colorScheme.onSurface,
                                  //   ),
                                  // ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FlanStepper(
                                        value: taxRateMapping.value[
                                                '${_invoiceTaxRates[i]}'] ??
                                            _invoiceTaxRates[i].toDouble(),
                                        min: 0,
                                        max: 100,
                                        step: 1,
                                        decimalLength: 2,
                                        buttonSize: 28,
                                        inputWidth: 60,
                                        onChange: (v, _) {
                                          final invoiceRateKey =
                                              '${_invoiceTaxRates[i]}';
                                          final current = taxRateMapping
                                                  .value[invoiceRateKey] ??
                                              _invoiceTaxRates[i].toDouble();
                                          final next = v is num
                                              ? v.toDouble()
                                              : double.tryParse(v.toString()) ??
                                                  current;
                                          taxRateMapping.value = {
                                            ...taxRateMapping.value,
                                            invoiceRateKey: next,
                                          };
                                        },
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '(%)',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              if (i < _invoiceTaxRates.length - 1)
                                Divider(
                                  height: 16,
                                  color: colorScheme.surfaceTint,
                                ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 6),
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            decoration: BoxDecoration(
              color: colorScheme.tertiary.withOpacity(0.2),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
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
                fontSize: 12,
                color: colorScheme.outline,
              ),
            ),
          ),
          // 取消 提交 按钮组
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 2, 24, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
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
                        taxRateMapping: Map<String, double>.from(
                          taxRateMapping.value,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    l10n.submit,
                    style: TextStyle(
                      color: colorScheme.onSecondary,
                      fontSize: 15,
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
