import 'package:cloud/models/quote/quotation_list.dart';
import 'package:cloud/pages/quote/widgets/collaboration_dialog.dart';
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
                _buildHeader(colorScheme, context, item),
                // const SizedBox(height: 3),
                // const Divider(height: 1, color: Color(0xFFF0F0F0)),
                const SizedBox(height: 6),
                _buildMiddleRow(colorScheme),
                const SizedBox(height: 8),
                _buildFooter(colorScheme),
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

  Widget _buildHeader(
      ColorScheme colorScheme, BuildContext context, QuotationList item) {
    // 格式化日期：从 "2025-12-23 11:23:15" 提取 "2025-12-23"
    String formatDate(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) return '';
      try {
        final parts = dateStr.split(' ');
        return parts.isNotEmpty ? parts[0] : '';
      } catch (e) {
        return dateStr;
      }
    }

    final formattedDate = formatDate(item.quoteAt);
    final customerName = item.company?.name ?? item.user?.name ?? '';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 左侧：日期 + 客户名
        Expanded(
          child: Row(
            children: [
              if (formattedDate.isNotEmpty) ...[
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  customerName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        // 右侧：协作按钮
        _buildCollaborateButton(colorScheme, context, item),
      ],
    );
  }

  Widget _buildCollaborateButton(
      ColorScheme colorScheme, BuildContext context, QuotationList item) {
    return Material(
      color: colorScheme.primaryContainer.withOpacity(0.08),
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            backgroundColor: Colors.transparent,
            builder: (context) => CollaborationBottomSheet(quoteId: item.id!),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.people_outline,
                size: 14,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                '协作',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiddleRow(ColorScheme colorScheme) {
    // 格式化编号：添加 # 前缀
    String formatQuoteNo(String? quoteNo) {
      if (quoteNo == null || quoteNo.isEmpty) return '';
      return quoteNo.startsWith('#') ? quoteNo : '#$quoteNo';
    }

    final TextStyle greyTextStyle = TextStyle(
      color: Colors.grey[600],
      fontSize: 11,
    );

    final quoteNo = formatQuoteNo(item.quoteNo);
    final creatorName = item.creator?.name ?? '';

    final collaborators = item.collaborators;
    final hasCollaborators = collaborators != null && collaborators.isNotEmpty;
    final collabText = hasCollaborators
        ? collaborators.map((e) => e.name ?? '').join('、')
        : '暂无协作';

    final collabStyle = hasCollaborators
        ? const TextStyle(color: Colors.green, fontSize: 11)
        : greyTextStyle;

    return Row(
      children: [
        if (quoteNo.isNotEmpty) ...[
          Text(
            quoteNo,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: colorScheme.surfaceContainerHighest,
            ),
          ),
          if (creatorName.isNotEmpty) ...[
            const SizedBox(width: 14),
            Text(
              '创建人: $creatorName',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: colorScheme.surfaceContainerHighest,
              ),
            ),
          ],
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              '协作: $collabText',
              style: collabStyle,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ] else if (creatorName.isNotEmpty) ...[
          Text(
            '创建人: $creatorName',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: colorScheme.surfaceContainerHighest,
            ),
          ),
        ],
      ],
    );
  }

  /// 底部：产品数量、总数量、总金额
  Widget _buildFooter(ColorScheme colorScheme) {
    final productCount = item.productCount ?? 0;
    final sumQty = item.sumQty ?? '';

    // TODO: 如果有总金额字段，在这里使用
    // 目前模型中没有总金额字段，暂时不显示
    // final currency = item.curreny ?? 'JPY';
    // final totalAmount = item.sumAmount ?? '0.00';

    return Row(
      children: [
        // 左侧：产品数量标签
        if (productCount > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '$productCount个产品',
              style: TextStyle(
                fontSize: 11,
                color: colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
        if (productCount > 0 && sumQty.isNotEmpty) const SizedBox(width: 12),
        // 中间：总数量
        if (sumQty.isNotEmpty)
          Text(
            '总数量: $sumQty',
            style: TextStyle(
              fontSize: 11,
              color: colorScheme.surfaceContainerHighest,
            ),
          ),
        // 右侧：总金额（暂时不显示，因为模型中没有该字段）
        // 如果将来添加了总金额字段，取消下面的注释并删除 currency 变量的注释
        // const Spacer(),
        // Text(
        //   '总金额($currency): $totalAmount',
        //   style: TextStyle(
        //     fontSize: 11,
        //     color: colorScheme.surfaceContainerHighest,
        //   ),
        // ),
      ],
    );
  }
}
