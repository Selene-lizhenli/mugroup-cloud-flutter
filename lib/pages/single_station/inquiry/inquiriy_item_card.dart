import 'package:cloud/constants/theme_config.dart';
import 'package:cloud/models/single_station/single_station_inquiries.dart';
import 'package:cloud/pages/widgets/icon.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// 询盘列表 Item 卡片
class InquiriesItemCard extends StatelessWidget {
  const InquiriesItemCard({
    super.key,
    required this.item,
    this.onTap,
  });

  final SingleStationInquiries item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 客户名称
              Row( 
                children: [ 
                  Expanded(
                    child: Text(
                      item.name!,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                        height: 1.3
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              if ((item.email ?? '').isNotEmpty)
                Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: _InfoRow(
                      iconType: FontAwesomeIcons.envelope,
                      value: item.email!,
                      color: Color.fromARGB(255, 215, 184, 12),
                      colorScheme: colorScheme,
                    )),

              // 独立站（名称或链接） - 第二行
              if (item.station != null &&
                  ((item.station!.nameCn ?? '').isNotEmpty))
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: _InfoRow(
                    iconType: FontAwesomeIcons.store,
                    value: (item.station!.nameCn?.isNotEmpty ?? false)
                        ? item.station!.nameCn!
                        : (''),
                    color: primaryColorPink,
                    colorScheme: colorScheme,
                    maxLines: 1,
                  ),
                ),
              if (item.message != null)
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: _InfoRow(
                    iconType: FontAwesomeIcons.commentDots,
                    value: item.message!,
                    color: primaryColorBlue,
                    colorScheme: colorScheme,
                    maxLines: 1,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.iconType,
    required this.value,
    required this.colorScheme,
    this.maxLines = 2,
    required this.color,
  });

  final IconData iconType;
  final String value;
  final ColorScheme colorScheme;
  final int maxLines;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // MuIcon(iconType: iconType, iconSize: 15),
          Icon(
            iconType,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface,
              ),
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
