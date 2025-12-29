import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class InspectionAddPage extends HookConsumerWidget {
  const InspectionAddPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const Color backgroundColor = Color(0xFFF5F7FA);
    const Color primaryBlue = Color(0xFF3B66F5);
    const Color labelColor = Color(0xFF333333);
    final Color borderColor = Colors.grey[300]!;
    const Color hintColor = Color(0xFF999999);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new, color: labelColor, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '新增验货任务',
          style: TextStyle(
            color: labelColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.check_circle_outline,
                        color: primaryBlue, size: 22),
                    SizedBox(width: 8),
                    Text(
                      '新增验货任务',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: labelColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(
                    height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
                const SizedBox(height: 20),
                RichText(
                  text: const TextSpan(
                    text: '*',
                    style: TextStyle(color: Colors.red, fontSize: 14),
                    children: [
                      TextSpan(
                        text: ' 任务标题',
                        style: TextStyle(color: labelColor, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: '示例：某某客户验货、某某订单号或者以及其他标识',
                    hintStyle: const TextStyle(color: hintColor, fontSize: 14),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: primaryBlue),
                    ),
                    isDense: true,
                  ),
                  style: const TextStyle(fontSize: 14, color: labelColor),
                ),
              ],
            ),
          ),
        ),
      ),
      // 底部按钮区域
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, -1),
              blurRadius: 2,
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 48,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: 处理创建任务逻辑
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '创建验货任务',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
