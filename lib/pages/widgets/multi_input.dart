import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MultiInput extends StatelessWidget {
  final String label;
  final List<String> values;
  final ValueChanged<List<String>>? onChanged;
  final String btnText;

  const MultiInput({
    super.key,
    this.label = '',
    required this.values,
    this.onChanged,
    this.btnText = '添加',
  });

  @override
  Widget build(BuildContext context) {
    final List<String> effectiveValues = values.isEmpty ? [''] : values;

    void updateItem(int index, String val) {
      final newList = List<String>.from(effectiveValues);
      newList[index] = val;
      onChanged?.call(newList);
    }

    void addItem() {
      final newList = List<String>.from(effectiveValues);
      newList.add('');
      onChanged?.call(newList);
    }

    void removeItem(int index) {
      if (effectiveValues.length <= 1) return;
      final newList = List<String>.from(effectiveValues);
      newList.removeAt(index);
      onChanged?.call(newList);
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
        ...effectiveValues.asMap().entries.map((entry) {
          final index = entry.key;
          final value = entry.value;
          final isLast = index == effectiveValues.length - 1;
          final isOnlyOne = effectiveValues.length == 1;

          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Expanded(
                  child: _MultiInputItem(
                    key: ValueKey(
                        'multi_input_${index}_${effectiveValues.length}'),
                    value: value,
                    hintText: '请输入$label',
                    onChanged: (v) => updateItem(index, v),
                  ),
                ),
                const SizedBox(width: 8),
                if (isOnlyOne)
                  _AddButton(onTap: addItem)
                else ...[
                  _DeleteButton(onTap: () => removeItem(index)),
                  if (isLast) ...[
                    const SizedBox(width: 8),
                    _AddButton(onTap: addItem),
                  ],
                ],
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.primary.withOpacity(0.3),
          ),
        ),
        child: Icon(Icons.add, size: 20, color: colorScheme.primary),
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  final VoidCallback onTap;
  const _DeleteButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
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
    useListenable(controller);

    useEffect(() {
      if (controller.text != value) {
        controller.text = value;
        controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length),
        );
      }
      return null;
    }, [value]);

    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1),
      cursorColor: colorScheme.primary,
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        filled: true,
        fillColor: Colors.white,
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
        suffixIconConstraints:
            const BoxConstraints(maxHeight: 30, minWidth: 40),
        suffixIcon: controller.text.isNotEmpty
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
