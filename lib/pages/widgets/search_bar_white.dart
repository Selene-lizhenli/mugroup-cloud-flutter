import 'package:flutter/material.dart';

class MuSearchBarWhite extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String buttonText;
  final bool showButton;

  /// 搜索回调，透出当前输入的文本
  final ValueChanged<String?> onSearch;
  final EdgeInsetsGeometry? padding;
  final Color? fillColor;
  final double? left;
  final double? right;
  final Color? hintTextColor;
  const MuSearchBarWhite({
    super.key,
    required this.controller,
    this.hintText = '搜索',
    this.buttonText = '搜索',
    this.showButton = true,
    required this.onSearch,
    this.padding,
    this.fillColor,
    this.left = 5,
    this.right = 5,
    this.hintTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveFillColor = fillColor ?? Colors.transparent;
    final effectiveHintTextColor =
        hintTextColor ?? colorScheme.outline.withOpacity(0.8);

    return Padding(
      padding: padding ?? EdgeInsets.fromLTRB(left ?? 5, 0, right ?? 5, 0),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.search,
                onSubmitted: onSearch,
                cursorColor: colorScheme.primary,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 14, height: 1),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(color: effectiveHintTextColor),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 18,
                    color: effectiveHintTextColor,
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  suffixIcon: Opacity(
                    opacity: 0,
                    child: Icon(
                      Icons.search,
                      size: 18,
                      color: effectiveHintTextColor,
                    ),
                  ),
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  isDense: true,
                  filled: true,
                  focusColor: colorScheme.primary,
                  fillColor: effectiveFillColor,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10.5,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    borderSide:
                        BorderSide(color: colorScheme.surfaceTint, width: 1),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
