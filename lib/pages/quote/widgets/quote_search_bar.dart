import 'package:flutter/material.dart';

class QuoteSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSearch;

  const QuoteSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      height: 63,
      child: TextField(
        controller: controller,
        textInputAction: TextInputAction.search,
        onSubmitted: onSearch,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(fontSize: 14, color: colorScheme.onSurface),
        textAlign: TextAlign.left,
        decoration: InputDecoration(
          hintText: '搜索带客记录',
          hintStyle: TextStyle(
              fontSize: 13, color: colorScheme.onSurface.withOpacity(0.4)),
          suffixIcon: const Icon(Icons.search, size: 20),
          filled: true,
          focusColor: colorScheme.primary.withOpacity(0.6),
          fillColor: colorScheme.surface.withOpacity(0.99),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: colorScheme.surface, // 标准紫色
              width: 0.8,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.transparent, // 主色边框（你也可以自定义颜色）
              width: 0, // 边框粗细
            ),
          ),
        ),
      ),
    );
  }
}
