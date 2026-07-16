import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String cancelText;
  final String confirmText;
  final Color confirmColor;

  const ConfirmDialog({
    super.key,
    this.title = '提示',
    required this.content,
    this.cancelText = '取消',
    this.confirmText = '确定',
    this.confirmColor = const Color(0xFFEE0A24),
  });

  static Future<dynamic> show(
    BuildContext context, {
    required String content,
    String title = '提示',
    String cancelText = '取消',
    String confirmText = '确定',
    Color? confirmColor,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return ConfirmDialog(
          title: title,
          content: content,
          cancelText: cancelText,
          confirmText: confirmText,
          confirmColor: confirmColor ?? const Color(0xFFEE0A24),
        );
      },
    );

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 36,
                  left: 24,
                  right: 24,
                  bottom: 26,
                ),
                child: Column(
                  children: [
                    if (title.isNotEmpty) ...[
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF323233),
                        ),
                      ),
                    ],
                    if (title.isNotEmpty && content.isNotEmpty)
                      const SizedBox(height: 8),
                    Text(
                      content,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF646566),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                  height: 0, thickness: 0.5, color: Color(0xFFEBEDF0)),
              SizedBox(
                height: 48,
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        // 业务逻辑: 移除
                        onPressed: () => Navigator.of(context).pop(false),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16)),
                          ),
                        ),
                        child: Text(
                          cancelText,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ),
                    const VerticalDivider(
                        width: 0, thickness: 0.5, color: Color(0xFFEBEDF0)),
                    Expanded(
                      child: TextButton(
                        // 业务逻辑: 删除
                        onPressed: () => Navigator.of(context).pop(true),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(16)),
                          ),
                        ),
                        child: Text(
                          confirmText,
                          style: TextStyle(fontSize: 16, color: confirmColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              icon: const Icon(Icons.close, size: 22, color: Color(0xFFC8C9CC)),
              onPressed: () => Navigator.of(context).pop(null),
            ),
          ),
        ],
      ),
    );
  }
}
