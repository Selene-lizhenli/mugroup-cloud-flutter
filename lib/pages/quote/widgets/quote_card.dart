import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/quote/quotation_list.dart';
import 'package:flutter/material.dart';

class QuoteCard extends StatelessWidget {
  final QuotationList item;
  final VoidCallback? onTap;
  final int? tabIndex;

  const QuoteCard({
    super.key,
    required this.item,
    this.onTap,
    this.tabIndex,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        elevation: 0.5,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(colorScheme),
                // const SizedBox(height: 4),
                // _buildFooter(colorScheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // /// 顶部：日期 + 客户 + 编号
  // Widget _buildHeader(ColorScheme colorScheme) {
  //   return Row(
  //     children: [
  //       Text(
  //         item.user?.name ?? "",
  //         style: TextStyle(
  //           fontSize: 14,
  //           fontWeight: FontWeight.w600,
  //           color: colorScheme.primary,
  //         ),
  //         maxLines: 1,
  //         overflow: TextOverflow.ellipsis,
  //       ),
  //       const SizedBox(
  //         width: 4,
  //       ),
  //       Text(
  //         item.quoteAt ?? '',
  //         style: TextStyle(
  //           color: colorScheme.surfaceContainerHighest,
  //           fontWeight: FontWeight.w500,
  //           fontSize: 11,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 左侧原有内容
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(
                  item.user?.name ?? "",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  width: 4,
                ),
                // Text(
                //   item.quoteAt ?? '',
                //   style: TextStyle(
                //     color: colorScheme.surfaceContainerHighest,
                //     fontWeight: FontWeight.w500,
                //     fontSize: 11,
                //   ),
                // ),
              ]),
              const SizedBox(
                height: 2,
              ),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  item.quoteNo ?? '',
                  style: TextStyle(
                    color: colorScheme.surfaceContainerHighest,
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(
                  width: 14,
                ),
                Text(
                  item.quoteAt ?? '',
                  style: TextStyle(
                    color: colorScheme.surfaceContainerHighest,
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                  ),
                ),
              ]),
            ],
          ),
        ),
        // 👉 右侧箭头
        Icon(
          Icons.chevron_right,
          size: 20,
          color: colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }

  /// 底部：数量 & 金额
  Widget _buildFooter(ColorScheme colorScheme) {
    return Row(
      children: [
        _buildTag('${item.productCount} 种产品', colorScheme),
        const SizedBox(width: 12),
        _buildTag('总数: ${item.sumQty ?? ""}', colorScheme),
      ],
    );
  }

  Widget _buildTag(String text, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style:
            TextStyle(fontSize: 11, color: colorScheme.surfaceContainerHighest),
      ),
    );
  }
}
