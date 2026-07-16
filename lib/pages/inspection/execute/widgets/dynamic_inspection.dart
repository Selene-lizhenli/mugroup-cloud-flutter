import 'package:cloud/pages/inspection/execute/widgets/dynamic_template_renderer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class InspectionItemDynamicPage extends HookConsumerWidget {
  final Map? schema;
  final bool isLoading;

  const InspectionItemDynamicPage({
    super.key,
    this.schema,
    this.isLoading = false,
    Map<String, dynamic>? inspectionItem,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isLoading == true) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        height: 220,
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: const Center(
          child: Text('加载中...'),
        ),
      );
    } else if (schema == null) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child:   Center(
          child: Text(
            '❌ 无法获取到模板数据，请检查模板是否正确！',
            style: TextStyle(color: Color.fromARGB(255, 172, 147, 146)!, fontSize: 14),
          ),
        ),
      );
    } else if (schema?['zones'] == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            '暂无验货内容',
            style: TextStyle(color: Color(0xFF999999), fontSize: 14),
          ),
        ),
      );
    } else {
      return const DynamicTemplateRenderer();
    }
  }
}
