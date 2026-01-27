import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/user.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/quotation_list.dart';
import 'package:cloud/pages/widgets/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum ExportTemplateType {
  normal, // 出货清单
  encrypt, // 出货清单（含加密信息）
  quote, // 报价单
}

enum ExportChannel {
  email, // 邮箱
  wework, // 企微
}

class EmailExportSheet extends StatefulWidget {
  final int? quoteId;
  const EmailExportSheet(this.quoteId);

  @override
  State<EmailExportSheet> createState() => _EmailExportSheetState();
}

class _EmailExportSheetState extends State<EmailExportSheet> {
  @override
  Widget build(BuildContext context) {
    return ExportShareSheet(
      quoteId: widget.quoteId,
      channel: ExportChannel.email,
    );
  }
}

class EmployeePickerSheet extends StatefulWidget {
  final int? quoteId;
  const EmployeePickerSheet(this.quoteId);

  @override
  State<EmployeePickerSheet> createState() => _EmployeePickerSheetState();
}

class _EmployeePickerSheetState extends State<EmployeePickerSheet> {
  @override
  Widget build(BuildContext context) {
    return ExportShareSheet(
      quoteId: widget.quoteId,
      channel: ExportChannel.wework,
    );
  }
}

class ExportShareSheet extends StatefulWidget {
  final int? quoteId;
  final ExportChannel channel;
  const ExportShareSheet({
    required this.quoteId,
    required this.channel,
  });

  @override
  State<ExportShareSheet> createState() => _ExportShareSheetState();
}

class _ExportShareSheetState extends State<ExportShareSheet> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ccController = TextEditingController();
  User? _selected;
  ExportTemplateType _templateType = ExportTemplateType.normal;
  late ExportChannel _channel;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _channel = widget.channel;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _ccController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    if (email.isEmpty) return false;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> _handleConfirm() async {
    // 邮箱渠道验证
    if (_channel == ExportChannel.email) {
      final email = _emailController.text.trim();

      if (email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('请输入邮箱地址'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return;
      }

      if (!_isValidEmail(email)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('请输入有效的邮箱地址'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return;
      }
    }

    // 企微渠道验证
    if (_channel == ExportChannel.wework) {
      if (_selected == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('请选择用户'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return;
      }
    }

    setState(() {
      _submitting = true;
    });

    try {
      final params = <String, dynamic>{
        "channel": _channel == ExportChannel.email ? "email" : "wework",
        "template": _getTemplateString(_templateType),
      };

      if (_channel == ExportChannel.email) {
        params["email"] = _emailController.text.trim();
        if (_ccController.text.trim().isNotEmpty) {
          params["cc"] = _ccController.text.trim();
        }
      } else {
        params["user_id"] = _selected?.id;
      }

      final result = await exportQuotationFile(
        widget.quoteId ?? 0,
        params,
      );

      if (!context.mounted) return;

      if (result.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_channel == ExportChannel.email
                ? '导出成功，邮件已发送！'
                : '导出成功，请到企微查看！'),
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
      if (mounted) {
        setState(() {
          _submitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEmail = _channel == ExportChannel.email;
    final isWework = _channel == ExportChannel.wework;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 12, 8, 20),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
          maxWidth: 500,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ===== 标题 =====
            const Padding(
              padding: EdgeInsets.fromLTRB(12, 8, 12, 4),
              child: Text(
                '分享',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18),
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
                          '渠道',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 12),
                        _ChannelOption(
                          label: '企微',
                          assetPath: 'assets/icons/wxwork.svg',
                          selected: isWework,
                          iconColor: colorScheme.outline,
                          onTap: () {
                            setState(() {
                              _channel = ExportChannel.wework;
                            });
                          },
                        ),
                        const SizedBox(width: 12),
                        _ChannelOption(
                          label: '邮箱',
                          assetPath: 'assets/icons/email.svg',
                          selected: isEmail,
                          iconColor: colorScheme.outline,
                          onTap: () {
                            setState(() {
                              _channel = ExportChannel.email;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // ===== 模板选择 =====
                    Text(
                      '模板',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _RadioItem(
                          title: '出货清单',
                          value: ExportTemplateType.normal,
                          groupValue: _templateType,
                          onChanged: (v) {
                            setState(() => _templateType = v);
                          },
                        ),
                        const SizedBox(width: 12),
                        _RadioItem(
                          title: '出货清单（含加密信息）',
                          value: ExportTemplateType.encrypt,
                          groupValue: _templateType,
                          onChanged: (v) {
                            setState(() => _templateType = v);
                          },
                        ),
                        const SizedBox(height: 4),
                        _RadioItem(
                          title: '报价单',
                          value: ExportTemplateType.quote,
                          groupValue: _templateType,
                          onChanged: (v) {
                            setState(() => _templateType = v);
                          },
                        ),
                      ],
                    ),

                    // ===== 根据渠道显示不同的表单 =====
                    const SizedBox(height: 8),
                    if (isEmail) ...[
                      // ===== 邮箱输入框 =====

                      Input(
                        label: '邮箱',
                        value: _emailController.text,
                        hintText: '请输入邮箱地址',
                        onChanged: (value) {
                          setState(() {
                            _emailController.text = value;
                          });
                        },
                        keyboardType: TextInputType.emailAddress,
                      ),
                      // ===== 抄送输入框 =====
                      const SizedBox(height: 8),
                      Input(
                        label: '抄送',
                        hintText: '抄送地址',
                        value: _ccController.text,
                        onChanged: (value) {
                          setState(() {
                            _ccController.text = value;
                          });
                        },
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ] else ...[
                      // ===== 员工搜索选择 =====
                      const Text("用户"),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () async {
                          final selectedUser = await context.router
                              .push<User>(const SelectUserRoute());
                          if (selectedUser != null && mounted) {
                            setState(() {
                              _selected = selectedUser;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: colorScheme.surfaceTint,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _selected == null
                                      ? "请选择用户"
                                      : "${_selected!.name} (${_selected!.department?.name ?? '暂无部门'})",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: _selected == null
                                        ? Colors.grey.shade600
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                              const Icon(Icons.keyboard_arrow_right,
                                  color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    ],
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
                      onTap: _submitting ? null : () => Navigator.pop(context),
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
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: _submitting ? null : _handleConfirm,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 10,
                        ),
                        child: _submitting
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: MuProgressIndicator(),
                              )
                            : Text(
                                '确认',
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

/// 将模板类型转换为字符串
String _getTemplateString(ExportTemplateType type) {
  switch (type) {
    case ExportTemplateType.normal:
      return "chqd";
    case ExportTemplateType.encrypt:
      return "chqd_secret";
    case ExportTemplateType.quote:
      return "bjd";
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
          // borderRadius: BorderRadius.circular(12),
          // border: Border.all(color: borderColor, width: 1),
          color: selected
              ? colorScheme.primary.withOpacity(0.06)
              : colorScheme.surface,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(assetPath,
                width: 20,
                height: 20,
                colorFilter:
                    ColorFilter.mode(iconColor ?? fgColor, BlendMode.srcIn)),
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
