import 'package:cloud/services/openai.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TextArea extends HookConsumerWidget {
  final String label;
  final int maxLines;
  final String? hintText;
  final String? value;
  final ValueChanged<String?>? onChanged;

  final bool showTranslate;
  final String? sourceText;
  final String fromLanguage;
  final String toLanguage;
  final ValueChanged<String>? onTranslateChanged;

  const TextArea({
    super.key,
    required this.label,
    this.maxLines = 5,
    this.hintText,
    this.value,
    this.onChanged,
    this.showTranslate = false,
    this.sourceText,
    this.fromLanguage = 'zh',
    this.toLanguage = 'en',
    this.onTranslateChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = useState(false);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final controller = useTextEditingController(text: value);
    final hasText = useState(value?.isNotEmpty ?? false);

    // 监听 controller 变化，控制清除按钮显示
    useEffect(() {
      void listener() {
        hasText.value = controller.text.isNotEmpty;
      }

      controller.addListener(listener);
      return () => controller.removeListener(listener);
    }, [controller]);

    // 监听外部 value 变化同步给 controller
    useEffect(() {
      if (controller.text != value) {
        controller.text = value ?? "";
        // 保持光标在末尾
        if (controller.text.isNotEmpty) {
          controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length),
          );
        }
      }
      return null;
    }, [value]);

    Future<void> handleTranslate() async {
      if (sourceText == null || sourceText!.isEmpty) {
        EasyLoading.showInfo('请输入中文描述');
        return;
      }

      try {
        loading.value = true;
        final res = await translate({
          'from': fromLanguage,
          'to': toLanguage,
          'text': sourceText!,
        });

        onTranslateChanged?.call(res);
      } finally {
        loading.value = false;
      }
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
        Stack(
          children: [
            TextFormField(
              controller: controller,
              maxLines: maxLines,
              keyboardType: TextInputType.multiline,
              onChanged: onChanged,
              enabled: !loading.value,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              decoration: InputDecoration(
                hintText: hintText ?? "请输入$label",
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                alignLabelWithHint: true,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.only(
                    left: 16, top: 14, right: 16, bottom: 14),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: colorScheme.primary, width: 1.5),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                suffixIcon: hasText.value && !loading.value
                    ? IconButton(
                        icon: const Icon(Icons.cancel,
                            color: Colors.grey, size: 20),
                        onPressed: () {
                          controller.clear();
                          onChanged?.call('');
                        },
                      )
                    : null,
              ),
            ),
            if (showTranslate)
              Positioned(
                bottom: 6,
                right: 6,
                child: loading.value
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CupertinoActivityIndicator(radius: 8),
                      )
                    : InkWell(
                        onTap: handleTranslate,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.translate,
                                  size: 14, color: colorScheme.primary),
                              const SizedBox(width: 4),
                              Text(
                                '点击翻译',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
          ],
        ),
      ],
    );
  }
}
