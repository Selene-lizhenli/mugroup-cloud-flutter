import 'package:flutter/material.dart';

class EditDialog extends StatefulWidget {
  final String initialText;
  final String title;
  final Function(String) onConfirm;

  const EditDialog({
    super.key,
    required this.initialText,
    required this.onConfirm,
    this.title = "修改内容",
  });

  static void show(
    BuildContext context, {
    required String initialText,
    String title = "修改内容",
    required Function(String newValue) onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return EditDialog(
          initialText: initialText,
          title: title,
          onConfirm: onConfirm,
        );
      },
    );
  }

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  late TextEditingController _controller;

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

  @override
  Widget build(BuildContext context) {
    const colorBlack = Color(0xFF323233);
    const colorGrayText = Color(0xFF646566);
    const colorGrayHint = Color(0xFF969799);
    const colorInputBg = Color(0xFFF7F8FA);
    const colorBlue = Color(0xFF1989FA);
    const colorDivider = Color(0xFFEBEDF0);

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
            child: Container(
              decoration: BoxDecoration(
                color: colorInputBg,
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: _controller,
                autofocus: true,
                style: const TextStyle(fontSize: 14, color: colorBlack),
                cursorColor: colorBlue,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "请输入内容",
                  hintStyle: TextStyle(color: colorGrayHint),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
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
                    onPressed: () {
                      widget.onConfirm(_controller.text);
                      Navigator.pop(context);
                    },
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
