import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/purchase_assist.dart';
import 'package:flutter/material.dart';

/// 比价助手任务列表项卡片：源图片、目标平台、进度、创建时间、创建人
class TaskListItemCard extends StatelessWidget {
  const TaskListItemCard({
    super.key,
    required this.item,
    this.onTap,
  });

  final PurchaseAssistTaskListItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final sourceImageUrl = item.media?.isNotEmpty == true
        ? (item.media!.first.thumbUrl ?? item.media!.first.url)
        : null;
    final total = item.summary?.total ?? item.total ?? 0;
    final success = item.summary?.success ?? item.successCount ?? 0;
    final progressText = total > 0 ? '$success/$total' : '—';
    final createdTime = formatDateTimeFull(item.createdAt);
    final creator = item.user?.name ?? '—';
    final platform = item.platform ?? '—';

    return Material(
      color: colorScheme.surface.withOpacity(0.85),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(19, 0, 0, 0),
                blurRadius: 6,
                spreadRadius: 0,
                offset: Offset.zero,
              ),
            ],
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 72,
                  height: 72,
                  child: _SourceImage(url: sourceImageUrl),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _MetaLine(
                      label: '目标平台',
                      value: platform,
                      colorScheme: colorScheme,
                    ),
                    const SizedBox(height: 4),
                    _MetaLine(
                      label: '进度',
                      value: progressText,
                      colorScheme: colorScheme,
                    ),
                    const SizedBox(height: 4),
                    _MetaLine(
                      label: '创建时间',
                      value: createdTime,
                      colorScheme: colorScheme,
                    ),
                    const SizedBox(height: 4),
                    _MetaLine(
                      label: '创建人',
                      value: creator,
                      colorScheme: colorScheme,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaLine extends StatelessWidget {
  const _MetaLine({
    required this.label,
    required this.value,
    required this.colorScheme,
  });

  final String label;
  final String value;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 12,
          color: colorScheme.onSurfaceVariant,
          height: 1.25,
        ),
        children: [
          TextSpan(
            text: '$label: ',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
          TextSpan(
            text: value,
            style: TextStyle(color: colorScheme.onSurface),
          ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _SourceImage extends StatelessWidget {
  const _SourceImage({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return Image.asset(
        'assets/noImage.png',
        fit: BoxFit.cover,
      );
    }
    return CachedNetworkImage(
      imageUrl: url!,
      fit: BoxFit.cover,
      placeholder: (_, __) => ColoredBox(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      errorWidget: (_, __, ___) => Image.asset(
        'assets/noImage.png',
        fit: BoxFit.cover,
      ),
    );
  }
}
