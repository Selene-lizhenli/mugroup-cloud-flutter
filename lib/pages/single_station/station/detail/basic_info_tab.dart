import 'package:cloud/l10n/l10n_extension.dart';
import 'package:cloud/models/single_station/single_station_item.dart';
import 'package:cloud/pages/single_station/station/detail/single_station_detail_l10n_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 独立站详情 - 基本信息 Tab
class BasicInfoTab extends StatelessWidget {
  const BasicInfoTab({super.key, required this.item});

  final SingleStationItem? item;

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
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: GestureDetector(
                    onDoubleTap: canCopy
                        ? () {
                            _copyToClipboard(context, value, label);
                          }
                        : null,
                    child: Text(
                      displayValue,
                      style: const TextStyle(fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                if (canCopy) ...[
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      _copyToClipboard(context, value, label);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(
                        Icons.copy_outlined,
                        size: 15,
                        color: colorScheme.onSurfaceVariant.withOpacity(0.4),
                      ),
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

  Widget _row(
    BuildContext context,
    String label,
    String? value,
    ColorScheme colorScheme,
  ) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
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
              (value == null || value.isEmpty) ? l10n.quoteNone : value,
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
          l10n.stationDetailMissingInfo,
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            decoration: BoxDecoration(
              color: colorScheme.surface.withOpacity(0.86),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  spreadRadius: 0,
                  offset: Offset.zero,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                children: [
                  _row(
                    context,
                    l10n.stationDetailTitleLabel,
                    item!.nameCn ?? item!.nameEn,
                    colorScheme,
                  ),
                  _row(
                    context,
                    l10n.stationDetailEnglishTitle,
                    item!.nameEn,
                    colorScheme,
                  ),
                  _row(
                    context,
                    l10n.stationDetailTheme,
                    stationDetailThemeLabel(context, item!.theme),
                    colorScheme,
                  ),
                  _row(
                    context,
                    l10n.stationDetailExpireTime,
                    item!.expireTime,
                    colorScheme,
                  ),
                  _row(
                    context,
                    l10n.stationDetailContactPerson,
                    item!.contactPerson,
                    colorScheme,
                  ),
                  _rowWithCopy(
                    context,
                    l10n.stationDetailEmail,
                    item!.email,
                    colorScheme,
                  ),
                  _row(
                    context,
                    l10n.stationDetailAddress,
                    item!.address,
                    colorScheme,
                  ),
                  _rowWithCopy(
                    context,
                    l10n.stationDetailShareLink,
                    item!.stationUrl,
                    colorScheme,
                  ),
                  _row(
                    context,
                    l10n.quoteRemark,
                    item!.remark,
                    colorScheme,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
