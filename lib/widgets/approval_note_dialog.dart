import 'package:flutter/material.dart';

/// 提交审批备注弹窗（购物车创建报价、报价单详情等场景复用）。
class ApprovalNoteDialog {
  ApprovalNoteDialog._();

  static Future<void> show(
    BuildContext context, {
    String title = '确认审批',
    String description = '可填写审批备注（选填），将随提交一并发送。',
    String hintText = '选填，审批备注信息',
    String confirmText = '确定',
    String closeTooltip = '关闭',
    required Future<void> Function(
      String note,
      BuildContext dialogContext,
    ) onConfirm,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return _ApprovalNoteDialogPanel(
          title: title,
          description: description,
          hintText: hintText,
          confirmText: confirmText,
          closeTooltip: closeTooltip,
          onConfirm: onConfirm,
        );
      },
    );
  }
}

class _ApprovalNoteDialogPanel extends StatefulWidget {
  const _ApprovalNoteDialogPanel({
    required this.title,
    required this.description,
    required this.hintText,
    required this.confirmText,
    required this.closeTooltip,
    required this.onConfirm,
  });

  final String title;
  final String description;
  final String hintText;
  final String confirmText;
  final String closeTooltip;
  final Future<void> Function(String note, BuildContext dialogContext) onConfirm;

  @override
  State<_ApprovalNoteDialogPanel> createState() =>
      _ApprovalNoteDialogPanelState();
}

class _ApprovalNoteDialogPanelState extends State<_ApprovalNoteDialogPanel> {
  late final TextEditingController _noteController;
  late final FocusNode _noteFocusNode;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
    _noteFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _noteFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    _noteFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final maxWidth = MediaQuery.sizeOf(context).width - 32;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Material(
            color: theme.dialogTheme.backgroundColor ?? colorScheme.surface,
            elevation: theme.dialogTheme.elevation ?? 24,
            shadowColor: theme.shadowColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                        tooltip: widget.closeTooltip,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color.fromARGB(255, 236, 236, 236),
                    ),
                    child: TextField(
                      controller: _noteController,
                      focusNode: _noteFocusNode,
                      autofocus: true,
                      minLines: 2,
                      maxLines: 2,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 191, 191, 191),
                        ),
                        hintText: widget.hintText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await widget.onConfirm(
                          _noteController.text,
                          context,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                      ),
                      child: Text(widget.confirmText),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
