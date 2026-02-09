import 'package:cloud/pages/quote/quote_create/provider/quote_create_provider.dart';
import 'package:cloud/models/dashboard/exchange.dart';
import 'package:cloud/pages/quote/quote_create/quote_country_defaults.dart';
import 'package:cloud/pages/quote/quote_create/widgets/select_contact_sheet.dart';
import 'package:cloud/pages/quote/quote_create/widgets/select_currency_sheet.dart';
import 'package:cloud/pages/quote/quote_create/widgets/select_customer_sheet.dart';
import 'package:cloud/pages/quote/quote_create/widgets/select_language_sheet.dart';
import 'package:cloud/providers/exchange.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class QuoteBaseInfoStep extends HookConsumerWidget {
  const QuoteBaseInfoStep({
    super.key,
  });

  /// 根据选中客户 & 汇率数据，自动设置语言、币别、汇率
  void _applyAutoSettings({
    required WidgetRef ref,
    required QuoteCreateState state,
    required AsyncValue<List<ExchangeRate>> exchangeAsync,
  }) {
    final notifier = ref.read(quoteCreateProvider.notifier);
    final company = state.selectedCustomers;
    final rates = exchangeAsync.value;
    if (company == null ||
        company.location == null ||
        company.location!.trim().isEmpty) {
      // 没有可用的客户位置信息时，使用默认：英语 + 美金
      ExchangeRate? usdRate;
      if (rates != null && rates.isNotEmpty) {
        for (final r in rates) {
          if ((r.shortName ?? '').toUpperCase() == 'USD') {
            usdRate = r;
            break;
          }
        }
      }
      final usdExchangeRate = usdRate?.exchangeRate ?? '';
      notifier.setCurrencyWithRate('USD', usdExchangeRate);
      notifier.setLanguage(const LanguageItem(name: '英语', code: 'EN'));
      return;
    }

    if (rates == null || rates.isEmpty) return;

    final data = findRateByCustomerLocation(company.location, rates);
    final rate = data?['rate'] as ExchangeRate?;
    final language = data?['language']
        as Map<String, String?>?; // {"value": "en", "lable": "英语"}

    if (rate != null) {
      notifier.setCurrencyWithRate(
        rate.shortName ?? '',
        rate.exchangeRate ?? '',
      );
    }

    if (language != null) {
      final name = language['lable'] ?? '';
      final code = (language['value'] ?? '').toUpperCase();
      if (name.isNotEmpty && code.isNotEmpty) {
        notifier.setLanguage(LanguageItem(name: name, code: code));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quoteCreateProvider);
    final exchangeAsync = ref.watch(exchangeProvider);

    // 监听客户选择变化，自动匹配语言 & 货币 & 汇率
    ref.listen<QuoteCreateState>(quoteCreateProvider, (previous, next) {
      final prevCompany = previous?.selectedCustomers;
      final nextCompany = next.selectedCustomers;

      // 只有当选中客户（id 或 location）发生变化时才自动匹配，避免死循环
      final sameId = prevCompany?.id == nextCompany?.id;
      if (sameId) {
        return;
      }

      _applyAutoSettings(
        ref: ref,
        state: next,
        exchangeAsync: exchangeAsync,
      );
    });

    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            elevation: 0,
            margin: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('基本设置'),
                  FormSelectField(
                    label: '选择客户',
                    required: true,
                    value: state.selectedCustomers?.name ?? '请选择客户',
                    onTap: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const SelectCustomerSheet(),
                    ),
                  ),
                  // TODO 添加外销员 字段: user_id
                  FormSelectField(
                    label: '选择联系人',
                    value: state.selectedContact?.name ?? '请选择联系人',
                    onTap: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => SelectContactSheet(
                        companyId: state.selectedCustomers?.id,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: FormSelectField(
                          label: '选择语言',
                          required: false,
                          value: state.language?.name ?? '请选择语言',
                          onTap: () => {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => const SelectLanguageSheet(),
                            ),
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: FormSelectField(
                          label: '选择货币',
                          required: false,
                          value: state.currency ?? '请选择货币',
                          onTap: () => showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => const SelectCurrencySheet(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FormInputField(
                          label: '汇率',
                          value: state.rate ?? '请选择汇率',
                          requiredField: false,
                          onChanged: (value) => ref
                              .read(quoteCreateProvider.notifier)
                              .setRate(value),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          const InfoTip(),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 14,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

//  ================= 提示信息 =================
class InfoTip extends StatelessWidget {
  const InfoTip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: colorScheme.primary.withOpacity(0.68),
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '创建报价单后，可通过详情页添加商品',
              style: TextStyle(color: colorScheme.primary, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class FormSelectField extends StatelessWidget {
  final String label;
  final bool required;
  final String value;
  final VoidCallback onTap;

  const FormSelectField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    final isPlaceholder = value.contains('请选择');

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (required)
                const Text('* ', style: TextStyle(color: Colors.red)),
              Text(label, style: const TextStyle(fontSize: 13)),
            ],
          ),
          const SizedBox(height: 6),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      value,
                      style: TextStyle(
                        color:
                            isPlaceholder ? Colors.grey.shade500 : Colors.black,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FormInputField extends ConsumerStatefulWidget {
  final String label;
  final bool requiredField;
  final String value;
  final ValueChanged<String>? onChanged;

  const FormInputField({
    super.key,
    required this.label,
    required this.value,
    this.requiredField = false,
    this.onChanged,
  });

  @override
  ConsumerState<FormInputField> createState() => _FormInputFieldState();
}

class _FormInputFieldState extends ConsumerState<FormInputField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant FormInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== Label =====
          Row(
            children: [
              if (widget.requiredField)
                const Text('* ', style: TextStyle(color: Colors.red)),
              Text(
                widget.label,
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // ===== Input =====
          TextFormField(
            controller: _controller,
            keyboardType: TextInputType.number,
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FormDateTimeField extends ConsumerWidget {
  final String label;
  final bool requiredField;

  const FormDateTimeField({
    super.key,
    required this.label,
    this.requiredField = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quoteCreateProvider);
    final notifier = ref.read(quoteCreateProvider.notifier);

    final dateTime = state.quoteDate;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (requiredField)
                const Text('* ', style: TextStyle(color: Colors.red)),
              Text(label, style: const TextStyle(fontSize: 13)),
            ],
          ),
          const SizedBox(height: 6),
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () async {
              final picked = await showOmniDateTimePicker(
                context: context,

                isShowSeconds: true, // 👈 关键：显示秒
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                constraints: const BoxConstraints(
                  maxWidth: 420,
                ),
                initialDate: state.quoteDate,
                is24HourMode: true,
                secondsInterval: 1,
              );

              if (picked != null) {
                notifier.setQuoteDate(picked);
              }
              // DatePicker.showDateTimePicker(
              //   context,
              //   showTitleActions: true,
              //   currentTime: dateTime,
              //   minTime: DateTime(2020),
              //   maxTime: DateTime(2100),
              //   locale: LocaleType.zh,
              //   onConfirm: (picked) {
              //     notifier.setQuoteDate(picked);
              //   },
              // );
            },
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 18),
                  const SizedBox(width: 8),
                  Text(_format(dateTime)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _format(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${dt.year}-${two(dt.month)}-${two(dt.day)} '
        '${two(dt.hour)}:${two(dt.minute)}:${two(dt.second)}';
  }
}
