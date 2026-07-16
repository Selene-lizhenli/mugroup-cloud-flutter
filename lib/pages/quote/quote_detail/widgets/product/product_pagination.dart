import 'package:flutter/material.dart';

class PaginationBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const PaginationBar({
    super.key, 
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool canPrev = currentPage > 1;
    final bool canNext = currentPage < totalPages;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ===== 上一页 =====
          IconButton(
            icon: const Icon(Icons.chevron_left),
            iconSize: 16,
            color:
                canPrev ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
            onPressed: canPrev ? () => onPageChanged(currentPage - 1) : null,
          ),

          // ===== 页码 =====
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '$currentPage / $totalPages',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // ===== 下一页 =====
          IconButton(
            icon: const Icon(Icons.chevron_right),
            iconSize: 16,
            color:
                canNext ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
            onPressed: canNext ? () => onPageChanged(currentPage + 1) : null,
          ),
        ],
      ),
    );
  }
}
