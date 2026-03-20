import 'package:cloud/helper/helper.dart';
import 'package:cloud/pages/widgets/image_show.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

/// 排名列表项（用于 `ship_cart.dart` 等场景的复用）
class TopRankItemCard<T> extends StatelessWidget {
  final bool? showInpage;
  final List<T> displayData;
  final String? type;

  const TopRankItemCard({
    super.key,
    this.showInpage = false,
    this.displayData = const [],
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    onTapDefault(item) {
      if (item == null) return;
      // 只有是对象 且 包含 id 字段 且 id 不为空时才跳转
      try {
        final dynamic data = item;
        final dynamic id = data.id;
        if (id != null && id.toString().isNotEmpty) {
          if (context.mounted) {
            context.router.push(
              ShowroomSampleDetailRoute(id: id),
            );
          }
        }
      } catch (e) {
        // 没有 id 字段 → 不跳转
      }
    }

    Widget buildImage(item) {
      try {
        final dynamic data = item;
        return ImageShow(
          imageUrl: data.thumbUrl ?? '',
          fit: BoxFit.contain,
          enablePreview: false,
          showErrorText: true,
          errorIconSize: 18,
          errorTextSize: 7,
        );
      } catch (e) {
        return const SizedBox();
      }
    }

    Widget buildInfo(item) {
      try { 
        final data = item;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.sampleName ?? ' ',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(),
            ),
            const SizedBox(height: 4),
            Text(
              '样品编号: ${data.sampleNo ?? ' '}',
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.72),
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                if (type == 'ship') ...[
                  Text(
                    '出货金额(CNY)：',
                    style: TextStyle(
                      fontSize: 10,
                      color: colorScheme.onSurface.withOpacity(0.72),
                    ),
                  ),
                  Text(
                    formatCurrencyAmount(data.shippingAmount),
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 10,
                    ),
                  ),
                  const Text(
                    ' 万人民币',
                    style: TextStyle(fontSize: 10),
                  ),
                ] else if (type == 'quote') ...[
                  Text(
                    '报价次数：',
                    style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.72),
                        fontSize: 10),
                  ),
                  Text(
                    ' ${item.count ?? ' '}',
                    style: TextStyle(color: colorScheme.primary, fontSize: 10),
                  ),
                ] else
                  ...[],
              ],
            ),
          ],
        );
      } catch (e) {
        return const SizedBox();
      }
    }

    return Column(
      children: [
        ...displayData.asMap().entries.expand<Widget>((entry) {
          final index = entry.key;
          final item = entry.value;
          final isTopThree = index < 3;
          final medalColor = index == 0
              ? const Color(0xFFFFD700) // 金
              : index == 1
                  ? const Color(0xFFC0C0C0) // 银
                  : const Color(0xFFCD7F32); // 铜

          return [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                  ),
                  child: InkWell(
                    onTap: () => onTapDefault(item),
                    borderRadius: BorderRadius.circular(8),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: SizedBox(
                            width: 55,
                            height: 55,
                            child: buildImage(item),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: buildInfo(item)),
                        const SizedBox(width: 10),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: colorScheme.outline,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ),
                if (isTopThree)
                  Positioned(
                    left: 0,
                    top: 2,
                    child: Container(
                      width: showInpage == true ? 38 : 22,
                      height: showInpage == true ? 30 : 22,
                      decoration: BoxDecoration(
                        color: medalColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.emoji_events,
                            size: 15,
                            color: index == 1
                                ? Colors.grey.shade800
                                : Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                if (!isTopThree && showInpage == true) ...[
                  Positioned(
                    left: 5,
                    top: 4,
                    child: Container(
                      width: 23,
                      height: 23,
                      decoration: BoxDecoration(
                        color: colorScheme.error.withOpacity(0.1),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.error.withOpacity(0.1),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                        // border: Border.all(color: colorScheme.error, width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${index + 1}',
                            style: TextStyle(
                                color: colorScheme.error, fontSize: 11),
                          )
                        ],
                      ),
                    ),
                  )
                ]
              ],
            ),
            if (index < displayData.length - 1)
              Divider(
                height: 1,
                color: colorScheme.outline.withOpacity(0.15),
              ),
          ];
        }),
      ],
    );
  }
}
