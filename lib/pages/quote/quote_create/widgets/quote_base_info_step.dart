import 'package:cloud/pages/quote/quote_create/provider/quote_create_provider.dart';
import 'package:cloud/pages/quote/quote_create/widgets/select_currency_sheet.dart';
import 'package:cloud/pages/quote/quote_create/widgets/select_customer_sheet.dart';
import 'package:cloud/pages/quote/quote_create/widgets/select_language_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class QuoteBaseInfoStep extends HookConsumerWidget {
  const QuoteBaseInfoStep({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final state = ref.watch(quoteCreateProvider);
    final notifier = ref.read(quoteCreateProvider.notifier);

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
                    value: state.selectedCustomers?.name ?? '请选择客户',
                    onTap: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const SelectCustomerSheet(),
                    ),
                  ),
                  // FormSelectField(
                  //   label: '选择联系人',
                  //   value: '请选择联系人',
                  //   onTap: () => showModalBottomSheet(
                  //     context: context,
                  //     isScrollControlled: true,
                  //     backgroundColor: Colors.transparent,
                  //     builder: (_) => const SelectCustomerSheet(),
                  //   ),
                  // ),
                  const FormDateTimeField(
                    requiredField: false,
                    label: '报价日期',
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: FormSelectField(
                          label: '选择语言',
                          required: false,
                          value: state.language?.name ?? '',
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
                      const SizedBox(width: 8),
                      Expanded(
                        child: FormSelectField(
                          label: '选择货币',
                          required: false,
                          value: state.currency,
                          onTap: () => showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => const SelectCurrencySheet(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: FormInputField(
                          label: '汇率',
                          value: state.rate,
                          requiredField: false,
                          onChanged: (value) => notifier.setRate(value),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FormInputField(
                          label: '报价单加点 (%)',
                          requiredField: false,
                          value: state.addPercentage ?? '0',
                          onChanged: (value) =>
                              notifier.setAddPercentage(value),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // const SizedBox(height: 12),
          // const InfoTip(),
        ],
      ),
    );
  }

  // ================= UI components =================

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

  Widget _fieldLabel(String text, bool required) {
    return Row(
      children: [
        if (required) const Text('* ', style: TextStyle(color: Colors.red)),
        Text(text, style: const TextStyle(fontSize: 13)),
      ],
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
        color: colorScheme.primary.withOpacity(0.03),
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
              '可稍后再补全基本信息',
              style: TextStyle(
                  color: colorScheme.primary.withOpacity(0.68), fontSize: 12),
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

// class FormDateTimeField extends ConsumerWidget {
//   final String label;
//   final bool requiredField;

//   const FormDateTimeField({
//     super.key,
//     required this.label,
//     this.requiredField = false,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final state = ref.watch(quoteCreateProvider);
//     final notifier = ref.read(quoteCreateProvider.notifier);

//     final dateTime = state.quoteDate;

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _FieldLabel(text: label, requiredField: requiredField),
//           const SizedBox(height: 6),
//           InkWell(
//             borderRadius: BorderRadius.circular(8),
//             onTap: () async {
//               // 1️⃣ 选日期
//               final pickedDate = await showDatePicker(
//                 context: context,
//                 initialDate: dateTime,
//                 firstDate: DateTime(2020),
//                 lastDate: DateTime(2100),
//               );
//               if (pickedDate == null) return;
//               // 2️⃣ 选时间（时分）
//               final pickedTime = await showTimePicker(
//                 context: context,
//                 initialTime: TimeOfDay.fromDateTime(dateTime),
//               );
//               if (pickedTime == null) return;

//               // 3️⃣ 合并成 DateTime（秒这里默认 0）
//               final newDateTime = DateTime(
//                 pickedDate.year,
//                 pickedDate.month,
//                 pickedDate.day,
//                 pickedTime.hour,
//                 pickedTime.minute,
//                 0, // 秒
//               );
//               notifier.setQuoteDate(newDateTime);
//             },
//             child: Container(
//               height: 44,
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade100,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Row(
//                 children: [
//                   const Icon(Icons.calendar_today, size: 18),
//                   const SizedBox(width: 8),
//                   Text(_formatDateTime(dateTime)),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatDateTime(DateTime dt) {
//     String two(int n) => n.toString().padLeft(2, '0');
//     return '${dt.year}-${two(dt.month)}-${two(dt.day)} '
//         '${two(dt.hour)}:${two(dt.minute)}:${two(dt.second)}';
//   }
// }

// class _FieldLabel extends StatelessWidget {
//   final String text;
//   final bool requiredField;
//   const _FieldLabel({
//     required this.text,
//     required this.requiredField,
//   });
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         if (requiredField)
//           const Text('* ', style: TextStyle(color: Colors.red)),
//         Text(text, style: const TextStyle(fontSize: 13)),
//       ],
//     );
//   }
// }
