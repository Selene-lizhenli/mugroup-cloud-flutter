 
import 'package:cloud/pages/inspection/execute/widgets/dynamic_inspection_components.dart'; 
import 'package:cloud/pages/inspection/providers/inspection_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
 
 
class DynamicTemplateRenderer extends ConsumerWidget {
  const DynamicTemplateRenderer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final children = <Widget>[];
    final detailState = ref.watch(inspectionDetailProvider);
    final nodes =
        (detailState.dynamicZonesNodes ?? const <String, List<Map<String, dynamic>>?>{})
            .entries;

    for (final entry in nodes) {
      final zoneNodes = entry.value;
      if (zoneNodes == null) continue;

      children.add(
        DynamicInspectionPhotosWidget(
          props: const {'title': '验货内容'},
          zoneChildren: zoneNodes,
          zoneKey: entry.key,
        ),
      );

      children.add(const SizedBox(height: 12));
    }

    if (children.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            '暂无验货内容',
            style: TextStyle(color: Color(0xFF999999), fontSize: 14),
          ),
        ),
      );
    }

    children.removeLast();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: children,
    );
  }
}
 