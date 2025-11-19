import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Input extends HookConsumerWidget {
  final String label;
  final String value;
  final ValueChanged<String>? onChanged;
  const Input({
    super.key,
    this.label = '',
    this.value = '',
    this.onChanged,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final focusNode = useFocusNode();
    useListenable(controller);
    useListenable(focusNode);

    final isFocused = focusNode.hasFocus;

    // 保证外部 value 更新时 controller 也更新
    useEffect(() {
      if (controller.text != value) {
        controller.text = value;
        controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length),
        );
      }
      return null;
    }, [value]);

    return GestureDetector(
      onTap: () => focusNode.requestFocus(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF646566))),
          const SizedBox(
            height: 8,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isFocused ? Colors.blue : Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: EditableText(
                    controller: controller,
                    focusNode: focusNode,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    cursorColor: Colors.blue,
                    backgroundCursorColor: Colors.grey,
                    onChanged: onChanged,
                  ),
                ),
                if (controller.text.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      controller.clear();
                      if (onChanged != null) onChanged!('');
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Color(0xFF8C8C8C), shape: BoxShape.circle),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Color(0xFFffffff),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
