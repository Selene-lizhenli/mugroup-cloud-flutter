import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class DatePickerInput extends HookWidget {
  final String name;
  final String label;
  final bool isRequired;
  final DateTime? value;
  final DateTime? minDate;
  final DateTime? maxDate;
  final ValueChanged<DateTime?>? onChanged;

  const DatePickerInput({
    super.key,
    required this.name,
    required this.label,
    this.isRequired = false,
    this.value,
    this.minDate,
    this.maxDate,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(
      text: value != null
          ? '${value!.year}-${value!.month.toString().padLeft(2, '0')}-${value!.day.toString().padLeft(2, '0')}'
          : '',
    );
    final focusNode = useFocusNode();

    return FormBuilderField<DateTime>(
      name: name,
      initialValue: value,
      validator: (val) => (isRequired && val == null) ? '必填' : null,
      builder: (field) {
        if (value != null && value != field.value) {
          field.didChange(value);
          controller.text =
              '${value!.year}-${value!.month.toString().padLeft(2, '0')}-${value!.day.toString().padLeft(2, '0')}';
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label.isNotEmpty) ...[
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
            ],
            GestureDetector(
              onTap: () async {
                final pickedDate = await showDialog<DateTime>(
                  context: context,
                  builder: (context) {
                    DateTime selectedDate = field.value ?? DateTime.now();
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        width: 320,
                        height: 360,
                        child: Column(
                          children: [
                            const Text(
                              '选择日期',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: CalendarDatePicker(
                                initialDate: field.value ?? DateTime.now(),
                                firstDate: minDate ?? DateTime(1900),
                                lastDate: maxDate ?? DateTime(2100),
                                onDateChanged: (date) {
                                  selectedDate = date;
                                },
                                currentDate: DateTime.now(),
                                // 可以加自定义样式
                                // 选中日期高亮颜色
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('取消'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(selectedDate),
                                  child: const Text('确定'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );

                if (pickedDate != null) {
                  field.didChange(pickedDate);
                  controller.text =
                      '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
                  if (onChanged != null) onChanged!(pickedDate);
                }
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: field.value != null
                        ? Colors.white
                        : const Color(0xFFF7F8FA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12), // 更圆润的圆角
                      borderSide: BorderSide(
                          color: Colors.grey.shade300), // 平时无边框(配合背景色)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1.5),
                    ),
                    suffixIcon: field.value != null && focusNode.hasFocus
                        ? IconButton(
                            icon: const Icon(Icons.cancel,
                                size: 20, color: Colors.grey),
                            onPressed: () {
                              field.didChange(null);
                              controller.clear();
                              if (onChanged != null) onChanged!(null);
                            },
                          )
                        : null,
                  ),
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
