import 'package:flutter/material.dart';

class QuoteSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const QuoteSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      height: 57,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(fontSize: 14, color: colorScheme.onSurface),
        textAlign: TextAlign.left,
        decoration: InputDecoration(
          hintText: '搜索带客记录',
          hintStyle: TextStyle(
              fontSize: 14, color: colorScheme.onSurface.withOpacity(0.6)),
          suffixIcon: const Icon(Icons.search, size: 20),
         
          filled: true,
          focusColor: colorScheme.surface.withOpacity(0.99),
          fillColor: colorScheme.surface,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: colorScheme.outline, // 标准紫色
              width: 0.8,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: colorScheme.primary, // 主色边框（你也可以自定义颜色）
              width: 1, // 边框粗细
            ),
          ),
        ),
      ),
    );
  }
}
