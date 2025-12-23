import 'package:cloud/pages/quote/quote_create/provider/quote_create_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// ================= Currency =================

class CurrencyItem {
  final String display; // 美元 (USD)
  final String code; // USD
  final String rate; // 汇率字符串

  const CurrencyItem({
    required this.display,
    required this.code,
    required this.rate,
  });
}

/// ================= Currency List =================
/// 这里以后可以直接换成接口数据
const List<CurrencyItem> _currencies = [
  CurrencyItem(display: '人民币 (CNY)', code: 'CNY', rate: '1.00'),
  CurrencyItem(display: '美元 (USD)', code: 'USD', rate: '7.25'),
  CurrencyItem(display: '欧元 (EUR)', code: 'EUR', rate: '7.86'),
  CurrencyItem(display: '日元 (JPY)', code: 'JPY', rate: '0.048'),
  CurrencyItem(display: '英镑 (GBP)', code: 'GBP', rate: '9.15'),
  CurrencyItem(display: '澳元 (AUD)', code: 'AUD', rate: '4.78'),
  CurrencyItem(display: '港币 (HKD)', code: 'HKD', rate: '0.92'),
  CurrencyItem(display: '加币 (CAD)', code: 'CAD', rate: '0.92'),
  CurrencyItem(display: '新元 (SGD)', code: 'SGD', rate: '0.92'),
  CurrencyItem(display: '卢布 (RUB)', code: 'RUB', rate: '0.92'),
  CurrencyItem(display: '沙特里亚尔 (SAR)', code: 'SAR', rate: '1.92'),
];

class SelectCurrencySheet extends ConsumerWidget {
  const SelectCurrencySheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(quoteCreateProvider.notifier);
    final state = ref.watch(quoteCreateProvider);
    const currencies = _currencies;
    final halfHeight = MediaQuery.of(context).size.height * 0.6;

    return Container(
      height: halfHeight, // 👈 关键：固定为屏幕一半
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

            // ================= List =================
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: currencies.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, indent: 10),
                itemBuilder: (context, index) {
                  final item = currencies[index];
                  final selected = state.currency == item.code;

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    title: Text(item.display),
                    trailing: selected
                        ? const Icon(Icons.check, color: Colors.blue)
                        : null,
                    onTap: () {
                      notifier.setCurrency(item.code);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
