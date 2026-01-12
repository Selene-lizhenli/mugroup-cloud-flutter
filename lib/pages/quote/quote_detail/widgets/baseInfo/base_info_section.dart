import 'package:cloud/models/crm/company.dart';
import 'package:cloud/models/quote/quotation_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/action_pill_button.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BaseInfoSection extends HookConsumerWidget {
  final QuotationList? item;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const BaseInfoSection({
    super.key,
    this.item,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final Company? company = item?.company;
    final isExpanded = useState(false);
    
    // 获取第一个联系人
    final contact = company?.contacts?.isNotEmpty == true
        ? company!.contacts!.first
        : null;
  

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== 标题栏 =====
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 18,
                  color: colorScheme.secondary.withOpacity(1),
                ),
                const SizedBox(width: 6),
                Text(
                  '基本信息${item?.id != null ? '#${item!.id}' : ''}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(), 
                if (onEdit != null)
                  ActionPillButton(
                    label: '编辑',
                    icon: Icons.edit_outlined,
                    textColor: colorScheme.primary,
                    borderColor: colorScheme.primary,
                    onTap: onEdit!,
                  ),
                if (onEdit != null && onDelete != null)
                  const SizedBox(width: 8), 
                if (onDelete != null)
                  ActionPillButton(
                    label: '删除',
                    icon: Icons.delete_outline,
                    textColor: colorScheme.error,
                    borderColor: colorScheme.error,
                    onTap: onDelete!,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            // ===== 内容区域（2列网格）=====
            LayoutBuilder(
              builder: (context, constraints) {
                // 所有信息项
                final allItems = [
                  // 客户名称
                  SizedBox(
                    width: (constraints.maxWidth - 16) / 2,
                    child: _InfoItem(
                      label: '客户名称',
                      value: company?.name ?? ' ',
                      showArrow: company != null && company.id != null,
                      onTap: company != null && company.id != null
                          ? () {
                              context.router.push(
                                CrmCompanyDetailRoute(id: company.id!),
                              );
                            }
                          : null,
                    ),
                  ),
                  // 联系人
                  SizedBox(
                    width: (constraints.maxWidth - 16) / 2,
                    child: _InfoItem(
                      label: '联系人',
                      value: item?.contactId??"",
                    ),
                  ),
                  // 外销员
                  SizedBox(
                    width: (constraints.maxWidth - 16) / 2,
                    child: _InfoItem(
                      label: '外销员',
                      value: item?.user?.name ?? '-',
                    ),
                  ),
                  // 报价日期
                  SizedBox(
                    width: (constraints.maxWidth - 16) / 2,
                    child: _InfoItem(
                      label: '报价日期',
                      value: _formatDate(item?.quoteAt),
                    ),
                  ),
                  // 报价语言
                  SizedBox(
                    width: (constraints.maxWidth - 16) / 2,
                    child:   _InfoItem(
                      label: '报价语言',
                      value: item?.language??'',  
                    ),

                  ),
                  // 报价货币
                  SizedBox(
                    width: (constraints.maxWidth - 16) / 2,
                    child: _InfoItem(
                      label: '报价货币',
                      value: item?.curreny ?? 'CNY',
                    ),
                  ),
                  // 更新日期
                  // SizedBox(
                  //   width: (constraints.maxWidth - 16) / 2,
                  //   child: _InfoItem(
                  //     label: '更新日期',
                  //     value: item?.updatedAt != null
                  //         ? _formatDateTime(item!.updatedAt!)
                  //         : '无日期',
                  //   ),
                  // ),
                ];

                // 默认显示3行（6个信息项）
                const maxVisibleItems = 6;
                final shouldShowExpand = allItems.length > maxVisibleItems;
                final visibleItems = isExpanded.value
                    ? allItems
                    : allItems.take(maxVisibleItems).toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      children: visibleItems,
                    ),
                    if (shouldShowExpand)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: InkWell(
                          onTap: () {
                            isExpanded.value = !isExpanded.value;
                          },
                          borderRadius: BorderRadius.circular(4),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 4,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  isExpanded.value ? '收起' : '展开',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.secondary,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  isExpanded.value
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                  size: 16,
                                  color: colorScheme.secondary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.year}-${_two(date.month)}-${_two(date.day)}';
    } catch (e) {
      return dateStr;
    }
  }

  String _formatDateTime(DateTime date) {
    return '${date.year}-${_two(date.month)}-${_two(date.day)}';
  }

  String _two(int n) => n.toString().padLeft(2, '0');
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final bool showArrow;
  final VoidCallback? onTap;

  const _InfoItem({
    required this.label,
    required this.value,
    this.showArrow = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    Widget content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.surfaceContainerHighest,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.87),
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (showArrow)
          Icon(
            Icons.chevron_right,
            size: 16,
            color: colorScheme.onSurface.withOpacity(0.4),
          ),
      ],
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: content,
        ),
      );
    }

    return content;
  }
}
