import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HorizontalInput extends HookConsumerWidget {
  final String label;
  final String value;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final double? inputWidth;
  final double? fontSize;
  final Color? labelColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final double? contentPaddingHorizontal;
  final double? contentPaddingVertical;

  const HorizontalInput({
    super.key,
    required this.label,
    required this.value,
    this.onChanged,
    this.keyboardType,
    this.inputWidth,
    this.fontSize,
    this.labelColor,
    this.borderColor,
    this.backgroundColor,
    this.contentPaddingHorizontal,
    this.contentPaddingVertical,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(text: value);
    final colorScheme = Theme.of(context).colorScheme;

    // 监听外部 value 变化同步给 controller
    useEffect(() {
      if (controller.text != value) {
        controller.text = value;
        controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length),
        );
      }
      return null;
    }, [value]);

    final inputWidthValue = inputWidth ?? 65;
    final inputFontSize = fontSize ?? 16;
    final labelTextColor = labelColor ?? Colors.grey.shade700;
    final inputBorderColor = borderColor ?? Colors.grey.shade300;
    final inputBgColor = backgroundColor ?? Colors.white;
    final contentPaddingHorizontalValue = contentPaddingHorizontal ?? 16;
    final contentPaddingVerticalValue = contentPaddingVertical ?? 10;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 100, // 固定宽度，以"供应商报价 (CNY)"为准
          child: Text(
            label,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: labelTextColor,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: inputWidthValue,
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            keyboardType: keyboardType,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: inputFontSize,
              color: Colors.black87,
              height: 1,
            ),
            cursorColor: colorScheme.primary,
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
                    EdgeInsets.symmetric(horizontal: contentPaddingHorizontalValue, vertical: contentPaddingVerticalValue),
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              filled: true,
              fillColor: inputBgColor,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: inputBorderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
