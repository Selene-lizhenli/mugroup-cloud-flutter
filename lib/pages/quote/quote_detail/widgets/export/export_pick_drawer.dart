import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/user.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/quotation_list.dart';
import 'package:cloud/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum ExportTemplateType {
  normal(
    title: '出货清单',
    templateKey: 'chqd',
    permissionKey: 'showroom.quotation.export.chuhuoExcel',
  ),
  encrypt(
    title: '出货清单（含加密信息）',
    templateKey: 'chqd_secret',
    permissionKey: 'showroom.quotation.export.admin.chuhuoExcel',
  ),
  quote(
    title: '报价单',
    templateKey: 'bjd',
    permissionKey: 'showroom.quotation.export.baojiaExcel',
  );

  final String title;
  final String templateKey;
  final String permissionKey;

  const ExportTemplateType({
    required this.title,
    required this.templateKey,
    required this.permissionKey,
  });
}

enum ExportChannel {
  wework, // 企微
}

class EmployeePickerSheet extends StatelessWidget {
  final int? quoteId;
  const EmployeePickerSheet(this.quoteId, {super.key});

  @override
  Widget build(BuildContext context) {
    return ExportShareSheet(
      quoteId: quoteId,
      channel: ExportChannel.wework,
    );
  }
}

class ExportShareSheet extends HookConsumerWidget {
  final int? quoteId;
  final ExportChannel channel;
  const ExportShareSheet({
    super.key,
    required this.quoteId,
    required this.channel,
  });

 

  bool _canUseTemplate(ExportTemplateType type, List<String> permissions) {
    return permissions.contains(type.permissionKey);
  }

  List<ExportTemplateType> _availableTemplates(List<String> permissions) {
    return ExportTemplateType.values
        .where((e) => _canUseTemplate(e, permissions))
        .toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).user;
    final permissions = user?.permissions ?? const <String>[]; 
    final selected = useState<User?>(null);
    final templateType = useState(ExportTemplateType.quote);
    final channel = useState(this.channel);
    final submitting = useState(false);
    final colorScheme = Theme.of(context).colorScheme;
    final isWework = channel.value == ExportChannel.wework;
    final availableTemplates = _availableTemplates(permissions);
    final canExportNormal =
        availableTemplates.contains(ExportTemplateType.normal);
    final canExportEncrypt =
        availableTemplates.contains(ExportTemplateType.encrypt);
    final canExportQuote =
        availableTemplates.contains(ExportTemplateType.quote);

    useEffect(() {
      if (availableTemplates.isNotEmpty &&
          !availableTemplates.contains(templateType.value)) {
        templateType.value = availableTemplates.first;
      }
      return null;
    }, [availableTemplates, templateType.value]);

    Future<void> handleConfirm() async {
      if (availableTemplates.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('暂无可用模板，请联系管理员',
                style: TextStyle(color: colorScheme.onError)),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return;
      }

      if (!availableTemplates.contains(templateType.value)) {
        templateType.value = availableTemplates.first;
      }

      if (channel.value == ExportChannel.wework && selected.value == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('请选择用户'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return;
      }

      submitting.value = true;
      try {
        final params = <String, dynamic>{
          "channel": "wework",
          "template": templateType.value.templateKey,
        };

        if (channel.value == ExportChannel.wework) {
          params["user_id"] = selected.value?.id;
        }
        final result = await exportQuotationFile(quoteId ?? 0, params);
        if (!context.mounted) return;

        if (result.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(channel.value == ExportChannel.wework
                  ? '导出成功，请到企微查看！'
                  : '导出成功！'),
              backgroundColor: Colors.green.shade600,
              duration: const Duration(seconds: 3),
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message ?? '导出失败'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      } catch (e, s) {
        if (!context.mounted) return;
        debugPrint('导出失败: $e\n$s');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('导出失败，请稍后重试'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      } finally {
        submitting.value = false;
      }
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
          maxWidth: 500,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.primary, width: 6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ===== 标题 =====
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.primary, width: 6),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                color: colorScheme.primary,
              ),
              padding: const EdgeInsets.fromLTRB(12, 5, 12, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '分享',
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontSize: 18, color: colorScheme.onPrimary),
                  ),
                  const SizedBox(width: 5),
                  Transform.rotate(
                    angle: -math.pi / 4,
                    child: Icon(
                      Icons.send,
                      size: 20,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
            // ===== 表单内容 =====
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '渠道:',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 10),
                        _ChannelOption(
                          label: '企微',
                          assetPath: 'assets/icons/wxwork.svg',
                          selected: isWework,
                          iconColor: colorScheme.outline,
                          onTap: () {
                            channel.value = ExportChannel.wework;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // ===== 模板选择 =====

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '模板:',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (canExportQuote) ...[
                                _RadioItem(
                                  title: ExportTemplateType.quote.title,
                                  value: ExportTemplateType.quote,
                                  groupValue: templateType.value,
                                  onChanged: (v) {
                                    templateType.value = v;
                                  },
                                ),
                                const SizedBox(height: 4),
                              ],
                              if (canExportNormal) ...[
                                _RadioItem(
                                  title: ExportTemplateType.normal.title,
                                  value: ExportTemplateType.normal,
                                  groupValue: templateType.value,
                                  onChanged: (v) {
                                    templateType.value = v;
                                  },
                                ),
                                const SizedBox(height: 4),
                              ],
                              if (canExportEncrypt) ...[
                                _RadioItem(
                                  title: ExportTemplateType.encrypt.title,
                                  value: ExportTemplateType.encrypt,
                                  groupValue: templateType.value,
                                  onChanged: (v) {
                                    templateType.value = v;
                                  },
                                ),
                              ],
                              if (availableTemplates.isEmpty)
                                Text(
                                  '  暂无可用模板，请联系管理员',
                                  style: TextStyle(color: colorScheme.outline),
                                ),
                            ],
                          ),
                        )
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("用户:"),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                final selectedUser = await context.router
                                    .push<User>(const SelectUserRoute());
                                if (selectedUser != null && context.mounted) {
                                  selected.value = selectedUser;
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 11,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: colorScheme.surfaceTint,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: selected.value == null
                                          ? Text(
                                              "请选择用户",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey.shade600,
                                              ),
                                            )
                                          : Text(
                                              "${selected.value!.name} (${selected.value!.department?.name ?? '暂无部门'})",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: colorScheme.primary,
                                              ),
                                            ),
                                    ),
                                    const Icon(Icons.keyboard_arrow_right,
                                        color: Colors.grey),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ]),

                    // ===== 员工搜索选择 =====
                  ],
                ),
              ),
            ),
            // ===== 底部操作按钮 =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // 取消按钮：白色背景，黑色文字
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: submitting.value
                          ? null
                          : () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        child: const Text(
                          '取消',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Material(
                    color: submitting.value
                        ? colorScheme.primary.withOpacity(0.3)
                        : colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: submitting.value ? null : handleConfirm,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 10,
                        ),
                        child: Text(
                          submitting.value ? '发送中...' : '确认',
                          style: TextStyle(
                            color: colorScheme.onPrimary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadioItem extends StatelessWidget {
  final String title;
  final ExportTemplateType value;
  final ExportTemplateType groupValue;
  final ValueChanged<ExportTemplateType> onChanged;

  const _RadioItem({
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        decoration: BoxDecoration(
          color: selected
              ? colorScheme.primary.withOpacity(0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Radio<ExportTemplateType>(
              value: value,
              groupValue: groupValue,
              onChanged: (v) => onChanged(v!),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              fillColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.selected)) {
                    return colorScheme.primary; // 选中时使用主题主色
                  }
                  return colorScheme.onSurface.withOpacity(0.45); // 未选中时使用灰色
                },
              ),
            ),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurface.withOpacity(0.92),
                  fontWeight: selected ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChannelOption extends StatelessWidget {
  final String label;
  final String assetPath;
  final bool selected;
  final Color? iconColor;
  final VoidCallback onTap;

  const _ChannelOption({
    required this.label,
    required this.assetPath,
    required this.selected,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final fgColor = selected ? colorScheme.primary : colorScheme.onSurface;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          // border: Border.all(color: borderColor, width: 1),
          color: selected
              ? colorScheme.primary.withOpacity(0.2)
              : colorScheme.surface,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(assetPath,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(fgColor, BlendMode.srcIn)),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: fgColor,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
