import 'package:cloud/constants/theme_config.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/crm/company.dart';
import 'package:cloud/models/quote/quotation_list.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/baseInfo/item_info.dart';
import 'package:cloud/services/quotation_list.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/action_pill_button.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// 按时间维度查看带客详情 基础信息模块
class BaseInfoSection extends HookConsumerWidget {
  final QuotationList? item;

  const BaseInfoSection({
    super.key,
    this.item,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final Company? company = item?.company;
    final isExpanded = useState(false);

    Future<void> handleEdit() async {
      if (item == null || item!.id == null) return;
      // 跳转到报价单创建页面（编辑模式），传递报价单ID
      context.router.push(QuoteCreateRoute(quoteId: item!.id));
    }

    Future<void> handleDelete() async {
      if (item?.id == null) return;
      await deleteQuotation(item!.id!);
      EasyLoading.showSuccess('删除成功');
      // 通知上一个页面执行刷新逻辑
      context.router.maybePop(true);
    }

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
            // 折叠时
            if (isExpanded.value == false) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            company?.name ?? ' ',
                            style: const TextStyle(fontSize: 12, height: 1.2),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            flex: 1,
                            child: Text(
                              '币种：${item?.curreny ?? ''}',
                              style: const TextStyle(fontSize: 12, height: 1.2),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            flex: 1,
                            child: Text(
                              '语言：${item?.language ?? ''}',
                              style: const TextStyle(fontSize: 12, height: 1.2),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ]),
                  ),
                  // const Spacer(),
                  InkWell(
                    onTap: () {
                      isExpanded.value = !isExpanded.value;
                    },
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.keyboard_double_arrow_down,
                            size: 15,
                            color: colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      truncateText(company?.name ?? ' ', maxChars: 10),
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w500, height: 1.2),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ActionPillButton(
                      label: '编辑',
                      textColor: colorScheme.primary,
                      onTap: handleEdit!,
                      icon: Icons.edit_outlined,
                      fontSize: 12,
                      vertical: 4,
                      horizontal: 9,
                    ),
                    const SizedBox(width: 10),
                    ActionPillButton(
                      label: '删除',
                      textColor: colorScheme.error,
                      onTap: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('确认删除'),
                            content: const Text('确定要删除该带客记录吗？此操作不可恢复。'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(false),
                                child: const Text('取消'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(true),
                                child: const Text('删除'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          handleDelete();
                        }
                      },
                      icon: Icons.delete_outline,
                      fontSize: 12,
                      vertical: 4,
                      horizontal: 9,
                    ),
                  ]),
              // ===== 内容区域（2列网格）=====
              // 展开时
              LayoutBuilder(
                builder: (context, constraints) {
                  // 所有信息项
                  final allItems = [
                    // 客户名称
                    SizedBox(
                      width: (constraints.maxWidth - 16) / 2,
                      child: InfoItem(
                        label: '客户名称',
                        useTrun: true,
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
                    // 报价货币
                    SizedBox(
                      width: (constraints.maxWidth - 16) / 2,
                      child: InfoItem(
                        label: '报价货币',
                        value: item?.curreny ?? 'CNY',
                      ),
                    ),
                    // 联系人
                    SizedBox(
                      width: (constraints.maxWidth - 16) / 2,
                      child: InfoItem(
                        label: '联系人',
                        value: item?.contactId ?? "",
                      ),
                    ),
                    // 外销员
                    SizedBox(
                      width: (constraints.maxWidth - 16) / 2,
                      child: InfoItem(
                        label: '外销员',
                        value: item?.user?.name ?? '-',
                      ),
                    ),
                    // 报价日期
                    SizedBox(
                      width: (constraints.maxWidth - 16) / 2,
                      child: InfoItem(
                        label: '报价日期',
                        value: _formatDate(item?.quoteAt),
                      ),
                    ),
                    // 报价语言
                    SizedBox(
                      width: (constraints.maxWidth - 16) / 2,
                      child: InfoItem(
                        label: '报价语言',
                        value: item?.language ?? '',
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
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 16,
                        runSpacing: 12,
                        children: allItems,
                      ),
                    ],
                  );
                },
              ),

              // ===== 尾部操作（2列网格）===== //展开时
              const SizedBox(height: 4),
              Row(children: [
                const Spacer(),
                InkWell(
                  onTap: () {
                    isExpanded.value = !isExpanded.value;
                  },
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('收起',
                            style: TextStyle(
                                color: colorScheme.primary, fontSize: 12)),
                        const SizedBox(width: 2),
                        Icon(
                          Icons.keyboard_double_arrow_up_outlined,
                          size: 15,
                          color: colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ],
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

  String _two(int n) => n.toString().padLeft(2, '0');
}

// 按时间维度查看带客详情 基础信息模块
class BaseInfoSectionByTime extends HookConsumerWidget {
  final QuotationList? item;

  const BaseInfoSectionByTime({
    super.key,
    this.item,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final Company? company = item?.company;
    final isExpanded = useState(false);

    Future<void> handleEdit() async {
      if (item == null || item!.id == null) return;
      // 跳转到报价单创建页面（编辑模式），传递报价单ID
      context.router.push(QuoteCreateRoute(quoteId: item!.id));
    }

    Future<void> handleDelete() async {
      if (item?.id == null) return;
      await deleteQuotation(item!.id!);
      EasyLoading.showSuccess('删除成功');
      // 通知上一个页面执行刷新逻辑
      context.router.maybePop(true);
    }

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: colorScheme.surface,
      // color: Color.fromARGB(224, 5, 137, 157),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== 标题栏 =====
            InkWell(
              onTap: () => isExpanded.value = !isExpanded.value,
              borderRadius: BorderRadius.circular(4),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(Icons.format_list_bulleted,
                        color: colorScheme.primary, size: 24),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        '基础信息',
                        style: TextStyle(
                          fontSize: 16,
                          // fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ),
                    if (isExpanded.value) ...[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const SizedBox(width: 10),
                            InkWell(
                              borderRadius: BorderRadius.circular(6),
                              onTap: handleEdit,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 9, vertical: 4),
                                decoration: BoxDecoration(
                                  color: accentTealColor.withOpacity(0.08),
                                  border: null,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.penToSquare,
                                      size: 17,
                                      color: accentTealColor,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '编辑',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: accentTealColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              borderRadius: BorderRadius.circular(6),
                              onTap: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('确认删除'),
                                    content: const Text('确定要删除该带客记录吗？此操作不可恢复。'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(ctx).pop(false),
                                        child: const Text('取消'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(ctx).pop(true),
                                        child: const Text('删除'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  handleDelete();
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 9, vertical: 4),
                                decoration: BoxDecoration(
                                  color: colorScheme.error.withOpacity(0.08),
                                  border: null,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.trashCan,
                                      size: 16,
                                      color: colorScheme.error,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '删除',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: colorScheme.error,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 25),
                          ]),
                    ],
                    AnimatedRotation(
                      turns: isExpanded.value ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFF666666),
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (isExpanded.value) ...[
              const SizedBox(height: 6),
              // 展开时
              Divider(
                height: 1,
                color: colorScheme.outlineVariant.withOpacity(0.6),
              ),
              // ===== 内容区域（每行一个字段）=====
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: company != null && company.id != null
                        ? () {
                            context.router.push(
                              CrmCompanyDetailRoute(id: company.id!),
                            );
                          }
                        : null,
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '客户名称',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                                child: Row(
                              children: [
                                Text(
                                  company?.name ?? ' ',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: accentTealColor,
                                    fontSize: 13,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(width: 2),
                              ],
                            )),
                          ],
                        )),
                  ),
                  const SizedBox(height: 12),
                  InfoItem(
                    label: '报价货币',
                    value: item?.curreny ?? 'CNY',
                    fontSize: 13,
                  ),
                  const SizedBox(height: 12),
                  InfoItem(
                    label: '联系人',
                    fontSize: 13,
                    value: item?.contactId ?? "",
                  ),
                  const SizedBox(height: 12),
                  InfoItem(
                    label: '外销员',
                    fontSize: 13,
                    value: item?.user?.name ?? '-',
                  ),
                  const SizedBox(height: 12),
                  InfoItem(
                    label: '创建日期',
                    fontSize: 13,
                    value: _formatDate(item?.quoteAt),
                  ),
                  const SizedBox(height: 12),
                  InfoItem(
                    label: '报价语言',
                    fontSize: 13,
                    value: item?.language ?? '',
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
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

  String _two(int n) => n.toString().padLeft(2, '0');
}
