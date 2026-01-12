import 'package:flutter/material.dart';

class MuSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String buttonText;
  final VoidCallback onSearch;
  final EdgeInsetsGeometry? padding;
  final Color? themeColor;
  final Color? fillColor;

  const MuSearchBar({
    super.key,
    required this.controller,
    this.hintText = '搜索',
    this.buttonText = '搜索',
    required this.onSearch,
    this.padding,
    this.themeColor,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveThemeColor = themeColor ?? colorScheme.primary;
    final effectiveFillColor =
        fillColor ?? const Color.fromARGB(255, 247, 247, 247);
    
    // 计算对比色：根据主题颜色亮度选择白色或黑色
    final onThemeColor = _getContrastColor(effectiveThemeColor);

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40,
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => onSearch(),
                cursorColor: effectiveThemeColor,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: hintText,
                  isDense: true,
                  filled: true,
                  
                  focusColor: effectiveThemeColor,
                  fillColor: effectiveFillColor,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12)),
                    borderSide: BorderSide(
                        color: effectiveThemeColor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12)),
                    borderSide: BorderSide(
                        color: effectiveThemeColor, width: 1),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12)),
                    borderSide: BorderSide(
                        color: effectiveThemeColor, width: 1),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: FilledButton(
              onPressed: onSearch,
              style: FilledButton.styleFrom(
                backgroundColor: effectiveThemeColor,
                foregroundColor: onThemeColor,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12)),
                ),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(fontSize: 14),
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

