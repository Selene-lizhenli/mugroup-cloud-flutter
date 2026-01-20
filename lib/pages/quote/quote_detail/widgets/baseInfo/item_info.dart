 
import 'package:flutter/material.dart';
 

class InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final bool showArrow;
  final VoidCallback? onTap;

  const InfoItem({
    super.key, 
    required this.label,
    required this.value,
    this.showArrow = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    Widget content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.surfaceContainerHighest,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
            child: Row(
          children: [
            Text(
              value,
              style: textTheme.bodyMedium?.copyWith( 
                color: onTap != null?colorScheme.primary:colorScheme.onSurface.withOpacity(0.87),
                fontSize: 12, 
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
