import 'package:flutter/material.dart';

class ActionPillButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final VoidCallback onTap;
  final double? horizontal;
  final double? vertical;
  final double? fontSize;

  const ActionPillButton({
    super.key,
    required this.label,
    this.icon,
    this.backgroundColor,
    required this.textColor,
    this.borderColor,
    required this.onTap,
    this.horizontal,
    this.vertical,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: horizontal ?? 12, vertical: vertical ?? 6),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: borderColor != null
                ? Border.all(color: borderColor!, width: 1)
                : null,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 17, color: textColor),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: fontSize ?? 15,
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
