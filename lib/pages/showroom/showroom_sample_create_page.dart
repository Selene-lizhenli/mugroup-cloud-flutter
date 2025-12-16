import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/showroom/widgets/showroom_sample_form.dart';
import 'package:cloud/services/sample.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class ShowroomSampleCreatePage extends HookConsumerWidget {
  final String? itemType;
  const ShowroomSampleCreatePage({super.key, this.itemType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('样品创建'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: ShowroomSampleForm(
        initial: null,
        onSave: (data) async {
          EasyLoading.show(status: '创建中...');
          await storeShowroomSample({...data, 'item_type': itemType});
          EasyLoading.showSuccess(
            '创建成功',
            duration: const Duration(seconds: 1),
          );
          return true;
        },
        onSubmit: (data) async {
          EasyLoading.show(status: '创建中...');
          await storeShowroomSample({...data, 'item_type': itemType});
          EasyLoading.showSuccess(
            "创建成功",
            duration: const Duration(seconds: 1),
          );

          if (context.mounted) {
            Navigator.of(context).pop();
          }
          return true;
        },
      ),
    );
  }
}
