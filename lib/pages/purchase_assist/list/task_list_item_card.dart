import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud/constants/core.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/purchase_assist/purchase_assist.dart';
import 'package:cloud/pages/widgets/progress.dart';
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
    // 源图列表：遍历 media，每一项取 thumbUrl（优先）或 url
    final sourceImageUrls = item.media
            ?.map((m) => m.thumbUrl ?? m.url)
            .whereType<String>()
            .where((u) => u.isNotEmpty)
            .toList() ??
        const <String>[];

    final total = item.summary?.total ?? item.total ?? 0;
    final success = item.summary?.success ?? item.successCount ?? 0;
    final progressText = total > 0 ? '$success/$total' : '—';
    final createdTime = formatDateTimeFull(item.createdAt);
    final creator = item.user?.name ?? '—';
    final platform = searchPlatform
        .firstWhere(
          (element) => element.value == item.platform,
        )
        .label;
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: colorScheme.surface,
        ),
        padding: const EdgeInsets.all(10),
        child: InkWell(
          onTap: onTap,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 72,
                  height: 72,
                  child: _SourceImage(urls: sourceImageUrls),
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
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('进度：',
                            style: TextStyle(
                                fontSize: 12,
                                color: colorScheme.onSurfaceVariant)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: MuProgressBar(
                            progress: total > 0 ? success / total : 0,
                            progressText: progressText,
                            height: 2,
                            valueColor: Colors.green,
                            trackColor: colorScheme.outlineVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
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
        ),
        children: [
          TextSpan(
            text: '$label：',
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
  const _SourceImage({required this.urls});

  final List<String> urls;

  @override
  Widget build(BuildContext context) {
    if (urls.isEmpty) {
      return Image.asset(
        'assets/icons/no_image.png',
        fit: BoxFit.cover,
      );
    }

    // 列数规则：
    final length = urls.length;
    int crossAxisCount = length % 2 == 0 && length % 3 != 0 ? 2 : 3;

    final displayUrls = urls.take(20).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final count = displayUrls.length;

        if (count == 1) {
          // 单张图：铺满整个区域
          return CachedNetworkImage(
            imageUrl: displayUrls.first,
            fit: BoxFit.cover,
            placeholder: (_, __) => ColoredBox(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            errorWidget: (_, __, ___) => Image.asset(
              'assets/icons/no_image.png',
              fit: BoxFit.cover,
            ),
          );
        }

        // 多图：按 crossAxisCount 列数拼接在固定高度内
        final cellWidth = size.width / crossAxisCount;
        final cellHeight = size.height / 2;

        return Wrap(
          // spacing: 2, // 每张图之间留一点横向间隙
          // runSpacing: 2, // 每行之间留一点纵向间隙
          children: List.generate(displayUrls.length, (index) {
            final imageUrl = displayUrls[index];
            return SizedBox(
              width: cellWidth,
              height: cellHeight,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => ColoredBox(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                errorWidget: (_, __, ___) => Image.asset(
                  'assets/icons/no_image.png',
                  fit: BoxFit.cover,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
