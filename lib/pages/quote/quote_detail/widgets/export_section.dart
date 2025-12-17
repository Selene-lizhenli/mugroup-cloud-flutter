import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/quote/quotation_list.dart';
import 'package:cloud/models/user.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/export_pick_drawer.dart';
import 'package:cloud/services/quotation_list.dart';
import 'package:flutter/material.dart';

class ExportActionBar extends StatelessWidget {
  final QuotationList? item;

  const ExportActionBar({
    required this.item,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Future<User?> showEmployeePicker() {
      return showModalBottomSheet<User>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => EmployeePickerSheet(item?.id),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // ===== 左侧：统计信息 =====
          Row(
            children: [
              Text(
                '共计',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  color: colorScheme.surfaceContainerHighest,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 3),
              Text(
                '${item?.sumQty ?? "-"}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '种类',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  color: colorScheme.surfaceContainerHighest,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 3),
              Text(
                '${item?.productCount ?? "-"}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          // ===== 中间撑开 =====
          const Spacer(),

          Row(
            children: [
              Text(
                '导出到：',
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurface,
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  showEmployeePicker();
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '企微',
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
