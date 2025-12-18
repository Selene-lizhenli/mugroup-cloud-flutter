import 'package:city_pickers/city_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DynamicCityPickers extends HookConsumerWidget {
  final String label;
  final String value;
  final ShowType? showType;
  final String? locationCode;
  final ValueChanged<Result?>? onChanged;

  const DynamicCityPickers({
    super.key,
    this.label = '',
    this.value = '',
    this.showType,
    this.locationCode,
    this.onChanged,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final controller = useTextEditingController(text: value);
    final focusNode = useFocusNode();

    useEffect(() {
      controller.text = value;
      return null;
    }, [value]);

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
          onTap: () async {
            Result? result = await CityPickers.showCityPicker(
              context: context,
              locationCode: locationCode ?? '110000',
              showType: showType,
            );

            onChanged?.call(result);
          },
          focusNode: focusNode,
          style:
              const TextStyle(fontSize: 16, color: Colors.black87, height: 1),
          cursorColor: colorScheme.primary,
          decoration: InputDecoration(
            isDense: true,
            hintText: "请输入$label",
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            filled: true,
            // 未选中时是极淡的灰色背景，选中时变白
            fillColor: colorScheme.surfaceContainer, // 浅灰背景，和 Input 保持一致
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
          ),
        ),
      ],
    );
  }
}
