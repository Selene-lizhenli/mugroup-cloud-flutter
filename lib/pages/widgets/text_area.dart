import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TextArea extends HookConsumerWidget {
  final String name;
  final String label;
  final int maxLines;
  final String? hintText;
  final String? value;
  final ValueChanged<String?>? onChanged;

  const TextArea({
    super.key,
    required this.name,
    required this.label,
    this.maxLines = 5,
    this.hintText,
    this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusNode = useFocusNode();
    useListenable(focusNode);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
        FormBuilderTextField(
          name: name,
          initialValue: value,
          maxLines: maxLines,
          keyboardType: TextInputType.multiline,
          focusNode: focusNode,
          onChanged: onChanged,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
          decoration: InputDecoration(
            hintText: hintText ?? "请输入$label",
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            alignLabelWithHint: true,
            filled: true,
            fillColor:
                focusNode.hasFocus ? Colors.white : const Color(0xFFF7F8FA),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
