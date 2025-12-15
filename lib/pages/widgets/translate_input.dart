import 'package:cloud/services/openai.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TranslatableInput extends HookConsumerWidget {
  final String label;
  final String value;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;

  final String fromLanguage;
  final String toLanguage;
  final String? sourceText;

  const TranslatableInput({
    super.key,
    this.label = '',
    this.value = '',
    this.onChanged,
    this.textInputAction = TextInputAction.next,
    this.keyboardType,
    this.hintText,
    this.inputFormatters,
    this.fromLanguage = 'zh',
    this.toLanguage = 'en',
    this.sourceText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(text: value);
    final focusNode = useFocusNode();

    final loading = useState(false);

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

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 翻译处理函数
    Future<void> handleTranslate() async {
      if (sourceText == null || sourceText!.trim().isEmpty) {
        EasyLoading.showInfo('请先输入中文名称');
        return;
      }

      try {
        loading.value = true;

        String result;

        result = await translate({
          'from': fromLanguage,
          'to': toLanguage,
          'text': sourceText,
        });

        onChanged?.call(result);
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
        TextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          textInputAction: textInputAction,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
          cursorColor: colorScheme.primary,
          enabled: !loading.value,
          decoration: InputDecoration(
            hintText: hintText ?? "请输入$label",
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
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
            disabledBorder: OutlineInputBorder(
              // loading 时的边框
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            suffixIcon: _buildSuffixIcon(
              context: context,
              loading: loading.value,
              onTranslate: handleTranslate,
              onClear: () {
                controller.clear();
                onChanged?.call('');
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon({
    required BuildContext context,
    required bool loading,
    required VoidCallback onTranslate,
    required VoidCallback onClear,
  }) {
    if (loading) {
      return Container(
        margin: const EdgeInsets.all(12),
        width: 20,
        height: 20,
        child: const CupertinoActivityIndicator(radius: 8),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: onTranslate,
          style: TextButton.styleFrom(
            minimumSize: const Size(0, 36),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            '翻译',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}
