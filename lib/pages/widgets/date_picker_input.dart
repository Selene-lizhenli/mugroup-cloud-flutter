import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DatePickerInput extends HookWidget {
  final String label;
  final bool isRequired;
  final String? value;
  final String? minDate;
  final String? maxDate;
  final ValueChanged<String?>? onChanged;

  const DatePickerInput({
    super.key,
    required this.label,
    this.isRequired = false,
    this.value,
    this.minDate,
    this.maxDate,
    this.onChanged,
  });

  DateTime _parse(String dateStr) => DateTime.parse(dateStr);

  String _format(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: value ?? '');
    final focusNode = useFocusNode();

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
            DateTime initialDate =
                value != null ? _parse(value!) : DateTime.now();
            final pickedDate = await showDialog<DateTime>(
              context: context,
              builder: (context) {
                DateTime selectedDate = initialDate;
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
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: CalendarDatePicker(
                            initialDate: initialDate,
                            firstDate: minDate != null
                                ? _parse(minDate!)
                                : DateTime(1900),
                            lastDate: maxDate != null
                                ? _parse(maxDate!)
                                : DateTime(2100),
                            onDateChanged: (date) {
                              selectedDate = date;
                            },
                            currentDate: DateTime.now(),
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
              final dateStr = _format(pickedDate);
              controller.text = dateStr;
              if (onChanged != null) onChanged!(dateStr);
            }
          },
          child: AbsorbPointer(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: const Color(0xFFF7F8FA),
                hintText: "请输入$label",
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary, width: 1.5),
                ),
                suffixIcon: value != null && focusNode.hasFocus
                    ? IconButton(
                        icon: const Icon(Icons.cancel,
                            size: 20, color: Colors.grey),
                        onPressed: () {
                          controller.clear();
                          if (onChanged != null) onChanged!(null);
                        },
                      )
                    : null,
              ),
              style: const TextStyle(
                  fontSize: 16, color: Colors.black87, height: 1),
            ),
          ),
        ),
      ],
    );
  }
}
