import 'package:cloud/models/dashboard/exchange.dart';
import 'package:cloud/pages/quote/quote_create/provider/quote_create_provider.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/providers/exchange.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SelectCurrencySheet extends HookConsumerWidget {
  const SelectCurrencySheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(quoteCreateProvider.notifier);
    final state = ref.watch(quoteCreateProvider);
    final halfHeight = MediaQuery.of(context).size.height * 0.6;
    final exchangeAsync = ref.watch(exchangeProvider);

    // 构建显示文本：name (shortName)，如 "美元 (USD)"
    String buildDisplayText(ExchangeRate rate) {
      final name = rate.name ?? '';
      final shortName = rate.shortName ?? '';
      if (name.isEmpty && shortName.isEmpty) {
        return '';
      }
      if (shortName.isEmpty) {
        return name;
      }
      if (name.isEmpty) {
        return shortName;
      }
      return '$name ($shortName)';
    }

    // 判断是否选中：比较 shortName 或完整的显示文本
    bool isSelected(ExchangeRate rate) {
      final shortName = rate.shortName ?? '';
      final displayText = buildDisplayText(rate);
      // 兼容旧数据：可能是 code 格式（如 "USD"）或 display 格式（如 "人民币 (CNY)"）
      return state.currency == shortName || state.currency == displayText;
    }

    // 获取存储值：优先使用 shortName，如果没有则使用显示文本
    String getStorageValue(ExchangeRate rate) {
      return rate.shortName ?? buildDisplayText(rate);
    }

    // 获取汇率字符串：exchangeRate 表示 100 单位该货币 = 多少人民币，需要除以 100
    String getRateValue(ExchangeRate rate) {
      final rateStr = rate.exchangeRate ?? '0';
      final rateValue = double.tryParse(rateStr) ?? 0.0;
      if (rateValue == 0.0) {
        return '0';
      }
      // 除以100并格式化为5位小数
      final convertedRate = rateValue / 100.0;
      return convertedRate.toStringAsFixed(4);
    }

    return Container(
      height: halfHeight,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ================= Header =================
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      "选择货币",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      '关闭',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),

            // ================= Content =================
            Flexible(
              child: exchangeAsync.when(
                data: (exchangeRates) {
                  if (exchangeRates.isEmpty) {
                    return const Center(
                      child: Text(
                        '暂无货币数据',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: exchangeRates.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, indent: 10),
                    itemBuilder: (context, index) {
                      final rate = exchangeRates[index];
                    final displayText = buildDisplayText(rate);
                    final selected = isSelected(rate);
                    final rateValue = getRateValue(rate);

                    return ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      title: Row(
                        children: [
                          Text(displayText),
                        const SizedBox(width: 8),
                          Text(
                            rateValue,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      trailing: selected
                          ? const Icon(Icons.check, color: Colors.blue)
                          : null,
                      onTap: () {
                        final currencyValue = getStorageValue(rate);
                        notifier.setCurrencyWithRate(currencyValue, rateValue);
                        Navigator.pop(context);
                      },
                    );
                  },
                );
                },
                loading: () => const Center(
                  child: MuProgressIndicator(),
                ),
                error: (error, stack) => Center(
                  child: Text(
                    '加载货币数据失败: $error',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
