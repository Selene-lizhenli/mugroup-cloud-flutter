import 'package:cloud/models/quote/quotation_list.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/export/export_pick_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExportActionBar extends StatelessWidget {
  final QuotationList? item;

  const ExportActionBar({
    super.key, 
    required this.item,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Future<void> showEmployeePicker() {
      return showDialog(
        context: context,
        builder: (_) => EmployeePickerSheet(item?.id),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal:12, vertical: 15),
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
                item?.sumQty ?? "-",
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
                '分享至',
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                borderRadius: BorderRadius.circular(4),
                onTap: () {
                  showEmployeePicker();
                },
                child: SvgPicture.asset(
                  'assets/icons/wxwork.svg',
                  width: 17,
                  height: 17,
                ),
              ),
              const SizedBox(width: 12),
              InkWell(
                borderRadius: BorderRadius.circular(4),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => EmailExportSheet(item?.id),
                  );
                },
                child: SvgPicture.asset(
                  'assets/icons/email.svg',
                  width: 18,
                  height: 18,
                  colorFilter: ColorFilter.mode(
                    colorScheme.secondary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
