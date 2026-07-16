import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 现在该组件默认就是数字输入框（支持小数），
//如果某个地方仍然需要文本输入，可以在使用时手动传入 keyboardType: TextInputType.text 覆盖。

class HorizontalInput extends HookConsumerWidget {
  final String label;
  final value;
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
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 100, // 固定宽度，以"供应商报价 (CNY)"为准
          child: Text(
            label,
            textAlign: TextAlign.start,
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
            // 默认使用数字输入框，外部如需文本可自行传入 keyboardType
            keyboardType: keyboardType ??
                const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              // 仅允许输入数字和小数点
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: inputFontSize,
              color: Colors.black87,
              height: 1,
            ),
            cursorColor: colorScheme.primary,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: contentPaddingHorizontalValue,
                vertical: contentPaddingVerticalValue,
              ),
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
