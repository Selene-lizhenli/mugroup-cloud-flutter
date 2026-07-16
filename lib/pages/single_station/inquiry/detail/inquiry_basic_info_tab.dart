import 'package:cloud/helper/helper.dart';
import 'package:cloud/l10n/l10n_extension.dart';
import 'package:cloud/models/single_station/single_station_inquiries.dart';
import 'package:cloud/pages/single_station/inquiry/inquiry_l10n_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 询盘详情 - 基本信息 Tab
class InquiryBasicInfoTab extends StatelessWidget {
  const InquiryBasicInfoTab({super.key, required this.item});

  final SingleStationInquiries? item;

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(context.l10n.quoteCopiedToClipboard(label)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _rowWithCopy(
    BuildContext context,
    String label,
    String? value,
    ColorScheme colorScheme,
  ) {
    final displayValue = (value == null || value.isEmpty) ? '—' : value;
    final canCopy = value != null && value.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 13,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    displayValue,
                    style: const TextStyle(fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (canCopy) ...[
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      _copyToClipboard(context, value, label);
                    },
                    child: Icon(
                      Icons.copy_outlined,
                      size: 15,
                      color: colorScheme.onSurfaceVariant.withOpacity(0.4),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String? value, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 13,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              (value == null || value.isEmpty) ? '—' : value,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    if (item == null) {
      return Center(
        child: Text(
          l10n.inquiryMissingInfo,
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      children: [
        Card(
          elevation: 0,
          color: colorScheme.surface.withOpacity(0.85),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              children: [
                _row(l10n.inquiryCustomerName, item!.name, colorScheme),
                _rowWithCopy(
                  context,
                  l10n.stationDetailEmail,
                  item!.email,
                  colorScheme,
                ),
                _row(l10n.inquiryPhone, item!.phone, colorScheme),
                _row(
                  l10n.inquiryCreatedAt,
                  formatDateTimeFull(item!.createdAt),
                  colorScheme,
                ),
                _row(
                  l10n.inquiryStationName,
                  item!.station?.nameCn ?? item!.station?.nameEn,
                  colorScheme,
                ),
                _row(l10n.inquiryIpAddress, item!.ip, colorScheme),
                _row(
                  l10n.inquirySource,
                  inquirySourceLabel(context, item!.ua),
                  colorScheme,
                ),
                _row(l10n.inquiryMessageContent, item!.message, colorScheme),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
