import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Input extends HookConsumerWidget {
  final String label;
  final String value;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final String? hintText;

  const Input({
    super.key,
    this.label = '',
    this.value = '',
    this.onChanged,
    this.textInputAction = TextInputAction.next,
    this.keyboardType,
    this.hintText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(text: value);
    final focusNode = useFocusNode();
    // 监听 controller 变化以刷新 UI (主要用于控制清除按钮的显示)
    useListenable(controller);

    // 监听外部 value 变化同步给 controller
    useEffect(() {
      if (controller.text != value) {
        controller.text = value;
        // 保持光标在末尾
        controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length),
        );
      }
      return null;
    }, [value]);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. 标签优化：字号微调，颜色更柔和
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

        // 2. 输入框实体
        TextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          textInputAction: textInputAction,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
          cursorColor: colorScheme.primary,
          decoration: InputDecoration(
            hintText: hintText ?? "请输入$label",
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            filled: true,
            // 未选中时是极淡的灰色背景，选中时变白
            fillColor:
                focusNode.hasFocus ? Colors.white : const Color(0xFFF7F8FA),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

            // 边框设置
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12), // 更圆润的圆角
              borderSide:
                  BorderSide(color: Colors.grey.shade300), // 平时无边框(配合背景色)
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
            ),

            // 清除按钮 (使用 suffixIcon 更加标准)
            suffixIcon: controller.text.isNotEmpty && focusNode.hasFocus
                ? IconButton(
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
      ],
    );
  }
}
