import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MultiInput extends StatelessWidget {
  final String label;
  final List<String> values;
  final ValueChanged<List<String>>? onChanged;
  final String btnText; // 添加按钮的文字

  const MultiInput({
    super.key,
    this.label = '',
    required this.values,
    this.onChanged,
    this.btnText = '添加',
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // 内部辅助函数：更新列表中的某一项
    void updateItem(int index, String val) {
      final newList = List<String>.from(values);
      newList[index] = val;
      onChanged?.call(newList);
    }

    // 内部辅助函数：添加一项
    void addItem() {
      final newList = List<String>.from(values);
      newList.add('');
      onChanged?.call(newList);
    }

    // 内部辅助函数：删除一项
    void removeItem(int index) {
      final newList = List<String>.from(values);
      newList.removeAt(index);
      onChanged?.call(newList);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. 标题 (只显示一次)
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

        // 2. 动态列表
        ...values.asMap().entries.map((entry) {
          final index = entry.key;
          final value = entry.value;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(
                  // 使用封装好的子组件处理单个输入逻辑
                  child: _MultiInputItem(
                    key: ValueKey('multi_input_$index'), // 确保列表更新时状态不乱
                    value: value,
                    hintText: '请输入$label',
                    onChanged: (v) => updateItem(index, v),
                  ),
                ),
                // 删除按钮 (如果允许多行，或者只要有一行都可以删除，看需求。这里设置为总是显示删除)
                const SizedBox(width: 8),
                _DeleteButton(onTap: () {
                  if (values.length <= 1) {
                    EasyLoading.showInfo("最后一个无法删除!");
                    return;
                  }
                  removeItem(index);
                }),
              ],
            ),
          );
        }),

        // 3. 添加按钮
        InkWell(
          onTap: addItem,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.08), // 浅色背景
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.primary.withOpacity(0.3),
                style: BorderStyle.solid,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, size: 18, color: colorScheme.primary),
                const SizedBox(width: 4),
                Text(
                  btnText,
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// 删除按钮组件
class _DeleteButton extends StatelessWidget {
  final VoidCallback onTap;
  const _DeleteButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withOpacity(0.1)),
        ),
        child: const Icon(Icons.remove, color: Colors.red, size: 20),
      ),
    );
  }
}

class _MultiInputItem extends HookConsumerWidget {
  final String value;
  final String? hintText;
  final ValueChanged<String>? onChanged;

  const _MultiInputItem({
    super.key,
    required this.value,
    this.hintText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(text: value);
    final focusNode = useFocusNode();
    useListenable(controller);
    useListenable(focusNode);

    // 同步父组件的值变化
    useEffect(() {
      if (controller.text != value) {
        controller.text = value;
        controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length),
        );
      }
      return null;
    }, [value]);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1),
      cursorColor: colorScheme.primary,
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        filled: true,
        fillColor: focusNode.hasFocus ? Colors.white : const Color(0xFFF7F8FA),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        suffixIconConstraints: const BoxConstraints(
          maxHeight: 30,
          minWidth: 40,
        ),
        // 这里的清除按钮只清除文本，不删除行
        suffixIcon: controller.text.isNotEmpty && focusNode.hasFocus
            ? IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.cancel, color: Colors.grey, size: 20),
                onPressed: () {
                  controller.clear();
                  onChanged?.call('');
                },
              )
            : null,
      ),
    );
  }
}
