import 'package:auto_route/auto_route.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/pages/crm/crm_company/widgets/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class CrmCompanyCreatePage extends HookConsumerWidget {
  const CrmCompanyCreatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final companyName = useState('');

    return Scaffold(
      appBar: AppBar(
        title: const Text("客户创建"),
        backgroundColor: colorScheme.primary,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text("基本资料",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Input(
              label: '客户名称',
              onChanged: (value) {
                logger.d(value);
              },
            ),
            const SizedBox(height: 12),
            Input(
              label: '地址',
              onChanged: (value) {
                logger.d(value);
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: Input(
                  label: '国家/地区',
                  onChanged: (value) {
                    logger.d(value);
                  },
                )),
                const SizedBox(width: 12), // 间距
                Expanded(
                  child: Input(
                    label: '行业',
                    onChanged: (value) {
                      logger.d(value);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: Input(
                  label: '来源',
                  onChanged: (value) {
                    logger.d(value);
                  },
                )),
                const SizedBox(width: 12), // 间距
                Expanded(
                  child: Input(
                    label: '公司网址',
                    onChanged: (value) {
                      logger.d(value);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary, // 按钮背景色
                  foregroundColor: Colors.black, // 文字颜色
                  side: BorderSide(
                      color: Colors.grey.shade300, width: 1.5), // 边框颜色和宽度
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // 圆角
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16), // 内边距
                ),
                onPressed: () {
                  print("提交：");
                },
                child: const Text(
                  "保存",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
