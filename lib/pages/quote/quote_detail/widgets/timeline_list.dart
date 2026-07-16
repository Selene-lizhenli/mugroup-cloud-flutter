import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/quote/quotation_list.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/timeline_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TimelineList extends StatelessWidget {
  final List<QuotationList> items;
  final int currentIndex;
  final ScrollController controller;
  final ValueChanged<int> onTap;

  const TimelineList({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListView.builder(
      controller: controller,
      itemCount: items.length,
      itemBuilder: (_, index) {
        final isCurrent = index == currentIndex;
        final isLast = index == items.length - 1;

        return InkWell(
          onTap: () => onTap(index),
          child: SizedBox(
            height: 72,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 左侧时间轴
                SizedBox(
                  child: Column(
                    children: [
                      _TimelineNode(
                        isCurrent: isCurrent,
                        colorScheme: colorScheme,
                      ),
                      Text(
                        items[index].createdAt.toString().substring(0, 10),
                        style: TextStyle(
                            fontSize: 7,
                            color: isCurrent
                                ? colorScheme.primary
                                : colorScheme.onSurface),
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 2,
                            color: colorScheme.outlineVariant,
                          ),
                        ),
                    ],
                  ),
                ),

                // const SizedBox(width: 8),

                // 右侧内容
                // Expanded(
                //   child: Padding(
                //     padding: const EdgeInsets.only(top: 4),
                //     child: _TimelineContent(
                //       item: items[index],
                //       isCurrent: isCurrent,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TimelineNode extends StatelessWidget {
  final bool isCurrent;
  final ColorScheme colorScheme;

  const _TimelineNode({
    required this.isCurrent,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final double size = isCurrent ? 8 : 10;

    return const SizedBox(
      height: 0,
    );

    // return Container(
    //   width: size,
    //   height: size,
    //   padding: const EdgeInsets.all(2),
    //   margin: const EdgeInsets.only(top: 4),
    //   decoration: BoxDecoration(
    //     shape: BoxShape.circle,
    //     color: isCurrent
    //         ? colorScheme.outline
    //         : colorScheme.surface.withOpacity(0.9),
    //     border: Border.all(
    //       color: isCurrent ? colorScheme.outline : colorScheme.outline,
    //       width: 2,
    //     ),
    //     boxShadow: isCurrent
    //         ? [
    //             BoxShadow(
    //               color: colorScheme.primary.withOpacity(0.35),
    //               blurRadius: 8,
    //               spreadRadius: 1,
    //             )
    //           ]
    //         : null,
    //   ),
    // );
  }
}

class _TimelineContent extends StatelessWidget {
  final QuotationList item;
  final bool isCurrent;

  const _TimelineContent({
    required this.item,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Text('');
    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Text(
    //       item.createdAt.toString(),
    //       maxLines: 2,
    //       overflow: TextOverflow.ellipsis,

    //       style: isCurrent ? textTheme.titleMedium : textTheme.bodyMedium,
    //       // style: isCurrent
    //       //     ? textTheme.titleMedium?.copyWith(color: colorScheme.onSurface)
    //       //     : textTheme.bodyMedium
    //       //         ?.copyWith(color: colorScheme.onSurfaceVariant),
    //     ),
    //   ],
    // );
  }
}
