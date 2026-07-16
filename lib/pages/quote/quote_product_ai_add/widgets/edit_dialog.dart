import 'package:flutter/material.dart';

class EditDialog extends StatefulWidget {
  final String initialText;
  final String title;
  final Function(String) onConfirm;
  // 新增：键盘类型和校验回调
  final TextInputType? keyboardType;
  final String? Function(String)? validator;

  const EditDialog({
    super.key,
    required this.initialText,
    required this.onConfirm,
    this.title = "修改内容",
    this.keyboardType,
    this.validator,
  });

  static void show(
    BuildContext context, {
    required String initialText,
    String title = "修改内容",
    required Function(String newValue) onConfirm,
    TextInputType? keyboardType, // 允许传入键盘类型（如数字键盘）
    String? Function(String)? validator, // 允许传入校验逻辑
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return EditDialog(
          initialText: initialText,
          title: title,
          onConfirm: onConfirm,
          keyboardType: keyboardType,
          validator: validator,
        );
      },
    );
  }

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  late TextEditingController _controller;
  // 新增：错误信息状态
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // 内部执行校验的逻辑
  void _handleConfirm() {
    if (widget.validator != null) {
      final error = widget.validator!(_controller.text);
      if (error != null) {
        setState(() {
          _errorText = error;
        });
        return; // 校验不通过，拦截提交
      }
    }
    widget.onConfirm(_controller.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const colorBlack = Color(0xFF323233);
    const colorGrayText = Color(0xFF646566);
    const colorGrayHint = Color(0xFF969799);
    const colorInputBg = Color(0xFFF7F8FA);
    const colorBlue = Color(0xFF1989FA);
    const colorDivider = Color(0xFFEBEDF0);
    const colorRed = Colors.red; // 错误信息颜色

    return Dialog(
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 8),
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorBlack,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: colorInputBg,
                    borderRadius: BorderRadius.circular(4),
                    // 如果有错误，可以给边框加点颜色提醒（可选）
                    border: _errorText != null
                        ? Border.all(color: colorRed, width: 0.5)
                        : null,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    keyboardType: widget.keyboardType, // 使用传入的键盘类型
                    style: const TextStyle(fontSize: 14, color: colorBlack),
                    cursorColor: colorBlue,
                    onChanged: (val) {
                      // 用户输入时，如果当前有错误信息，则清除它
                      if (_errorText != null) {
                        setState(() {
                          _errorText = null;
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "请输入内容",
                      hintStyle: TextStyle(color: colorGrayHint),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                // 新增：错误信息展示，不改变原有布局间距
                if (_errorText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 2),
                    child: Text(
                      _errorText!,
                      style: const TextStyle(color: colorRed, fontSize: 11),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 0.5, color: colorDivider),
          SizedBox(
            height: 48,
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: colorGrayText,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(16)),
                      ),
                    ),
                    child: const Text("取消", style: TextStyle(fontSize: 16)),
                  ),
                ),
                Container(width: 0.5, color: colorDivider),
                Expanded(
                  child: TextButton(
                    onPressed: _handleConfirm, // 调用封装好的确认逻辑
                    style: TextButton.styleFrom(
                      foregroundColor: colorBlue,
                      textStyle: const TextStyle(fontWeight: FontWeight.w500),
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.only(bottomRight: Radius.circular(16)),
                      ),
                    ),
                    child: const Text("确认", style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
