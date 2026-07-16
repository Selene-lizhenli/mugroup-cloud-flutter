import 'package:flutter/material.dart';

class MuSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String buttonText;
  final bool showButton;

  /// 搜索回调，透出当前输入的文本
  final ValueChanged<String?> onSearch;
  final EdgeInsetsGeometry? padding;
  final Color? themeColor;
  final Color? fillColor;
  final double? left;
  final double? right;
  final Color? hintTextColor;
  final bool showPrefixIcon;
  const MuSearchBar({
    super.key,
    required this.controller,
    this.hintText = '搜索',
    this.buttonText = '搜索',
    this.showButton = true,
    required this.onSearch,
    this.padding,
    this.themeColor,
    this.fillColor,
    this.left = 5,
    this.right = 5,
    this.hintTextColor,
    this.showPrefixIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveThemeColor = themeColor ?? colorScheme.primary;
    final effectiveFillColor = fillColor ?? Colors.transparent;
    final effectiveHintTextColor =
        hintTextColor ?? colorScheme.outline.withOpacity(0.8);
    // 计算对比色：根据主题颜色亮度选择白色或黑色
    final onThemeColor = _getContrastColor(effectiveThemeColor);

    return Padding(
      padding: padding ?? EdgeInsets.fromLTRB(left ?? 5, 0, right ?? 5, 0),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.search,
                // 回车搜索时透出当前文本
                onSubmitted: onSearch,
                cursorColor: effectiveThemeColor,
                style: const TextStyle(fontSize: 14, height: 1),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(color: effectiveHintTextColor),
                  prefixIcon: showPrefixIcon
                      ? Icon(
                          Icons.search,
                          size: 18,
                          color: effectiveHintTextColor,
                        )
                      : null,
                  prefixIconConstraints: showPrefixIcon
                      ? const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        )
                      : null,
                  isDense: true,
                  filled: true,
                  focusColor: effectiveThemeColor,
                  fillColor: effectiveFillColor,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10.5,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        bottomLeft: Radius.circular(4)),
                    borderSide:
                        BorderSide(color: effectiveThemeColor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        bottomLeft: Radius.circular(4)),
                    borderSide:
                        BorderSide(color: effectiveThemeColor, width: 1),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        bottomLeft: Radius.circular(4)),
                    borderSide:
                        BorderSide(color: effectiveThemeColor, width: 1),
                  ),
                ),
              ),
            ),
          ),
          if (showButton == true)
            SizedBox(
              height: 36,
              child: FilledButton(
                // 点击按钮时也透出当前输入框内容
                onPressed: () => onSearch(controller.text),
                style: FilledButton.styleFrom(
                  backgroundColor: effectiveThemeColor,
                  foregroundColor: onThemeColor,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(2),
                        bottomRight: Radius.circular(2)),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 根据背景颜色计算对比色（白色或黑色）
  Color _getContrastColor(Color color) {
    // 计算颜色的相对亮度
    final luminance = color.computeLuminance();
    // 如果亮度大于0.5，使用黑色，否则使用白色
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
