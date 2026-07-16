import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Input extends HookConsumerWidget {
  final String label;
  final String value;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final String? hintText;

  final String? errorText;
  final FocusNode? focusNode;
  final bool showClearButton;
  final bool isRequired;

  final List<TextInputFormatter>? inputFormatters;
  final double fontSize;

  const Input({
    super.key,
    this.label = '',
    this.value = '',
    this.onChanged,
    this.textInputAction = TextInputAction.next,
    this.keyboardType,
    this.hintText,
    this.errorText,
    this.focusNode,
    this.inputFormatters,
    this.showClearButton = true,
    this.isRequired = false,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(text: value);

    // 监听 controller 变化以刷新 UI (主要用于控制清除按钮的显示)
    useListenable(controller);

    // 监听外部 value 变化同步给 controller
    useEffect(() {
      if (controller.text != value) {
        controller.text = value;
      }
      return null;
    }, [value]);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '* ',
                  style: TextStyle(
                    color: isRequired ? Colors.red : Colors.transparent,
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    height: 1.0,
                  ),
                ),
                TextSpan(
                  text: label,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],

        // 2. 输入框实体
        TextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          textInputAction: textInputAction,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style:
              const TextStyle(fontSize: 16, color: Colors.black87, height: 1),
          cursorColor: colorScheme.primary,
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            hintText: hintText ?? "请输入$label",
            errorText: errorText,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12), // 更圆润的圆角
              borderSide:
                  BorderSide(color: Colors.grey.shade300), // 平时无边框(配合背景色)
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
            ),
            suffixIconConstraints: const BoxConstraints(
              maxHeight: 30,
              minWidth: 40,
            ),
            suffixIcon: showClearButton && controller.text.isNotEmpty
                ? IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon:
                        const Icon(Icons.cancel, color: Colors.grey, size: 20),
                    onPressed: () {
                      controller.clear();
                      onChanged?.call('');
                    },
                  )
                : null,
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}
