import 'package:cloud/models/single_station/single_station_inquiries.dart';
import 'package:flutter/material.dart';

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
                  if ((item.name ?? '').isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: Text(
                        item.name!,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                ],
              ),

              if ((item.email ?? '').isNotEmpty)
                Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: _InfoRow(
                      label: '邮箱',
                      value: item.email!,
                      colorScheme: colorScheme,
                    )),

              // 独立站（名称或链接） - 第二行
              if (item.station != null &&
                  ((item.station!.nameCn ?? '').isNotEmpty))
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: _InfoRow(
                    label: '独立站',
                    value: (item.station!.nameCn?.isNotEmpty ?? false)
                        ? item.station!.nameCn!
                        : (''),
                    colorScheme: colorScheme,
                  ),
                ),

              // 电话：放在最下面一行
              // if ((item.phone ?? '').isNotEmpty)
              //   _InfoRow(
              //     label: '电话',
              //     value: item.phone!,
              //     colorScheme: colorScheme,
              //   ),

              // 消息：模型里没有 message 字段，这里暂用 ua 占位
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.colorScheme,
  });

  final String label;
  final String value;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label：',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
