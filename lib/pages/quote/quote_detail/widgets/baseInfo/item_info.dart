import 'package:cloud/helper/helper.dart';
import 'package:flutter/material.dart';

class InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final bool showArrow;
  final VoidCallback? onTap;
  final bool? useTrun;
  final double fontSize;

  const InfoItem({
    super.key,
    required this.label,
    required this.value,
    this.showArrow = false,
    this.onTap,
    this.useTrun = false,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    Widget content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            '$label：',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface,
            fontSize: fontSize,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
            child: Row(
          children: [
            Text(
              useTrun == true ? truncateText(value) : value,
              style: textTheme.bodyMedium?.copyWith(
                color: onTap != null
                    ? colorScheme.primary
                    : colorScheme.onSurface.withOpacity(0.8),
                fontSize: fontSize,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              width: 2,
            ),
            if (showArrow)
              Icon(
                Icons.chevron_right,
                size: 16,
                color: colorScheme.onSurface.withOpacity(0.4),
              ),
          ],
        )),
      ],
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: content,
        ),
      );
    }

    return content;
  }
}
