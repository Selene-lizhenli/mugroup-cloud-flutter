import 'package:cloud/pages/widgets/select.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MultiSelect extends HookConsumerWidget {
  final String label;
  final List<dynamic> value;
  final List<SelectOption> options;
  final ValueChanged<List<dynamic>>? onChanged;
  final String? hintText;

  const MultiSelect({
    super.key,
    this.label = '',
    this.value = const [],
    this.options = const [],
    this.onChanged,
    this.hintText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedValues = useState<List<dynamic>>(List.from(value));

    void showMultiSelectSheet() {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width, // 底部抽屉宽度占满屏幕
        ),
        builder: (context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: Colors.grey.shade200)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '请选择$label',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.6,
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      itemCount: options.length,
                      separatorBuilder: (_, __) => const Divider(
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                          color: Color(0xFFEEEEEE)),
                      itemBuilder: (context, index) {
                        final option = options[index];
                        final isSelected =
                            selectedValues.value.contains(option.value);

                        return Material(
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {
                              if (isSelected) {
                                selectedValues.value.remove(option.value);
                              } else {
                                selectedValues.value.add(option.value);
                              }
                              onChanged?.call(selectedValues.value);
                              (context as Element).markNeedsBuild();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14.0, horizontal: 16.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(option.label,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: isSelected
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Colors.black87,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        )),
                                  ),
                                  if (isSelected)
                                    Icon(Icons.check,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary)
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      );
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
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
        ],
        GestureDetector(
          onTap: showMultiSelectSheet,
          child: Container(
            width: double.infinity, // 占满父容器
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: selectedValues.value.isEmpty
                ? Text(
                    hintText ?? "请选择$label",
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  )
                : Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: selectedValues.value.map((val) {
                      final option = options.firstWhere(
                        (e) => e.value == val,
                        orElse: () => SelectOption(label: val, value: val),
                      );

                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E2E2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              option.label,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black87),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                selectedValues.value.remove(val);
                                onChanged?.call(selectedValues.value);
                              },
                              child: const Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ),
      ],
    );
  }
}
