import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/showroom/widgets/showroom_sample_form.dart';
import 'package:cloud/services/sample.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class ShowroomSampleCreatePage extends HookConsumerWidget {
  const ShowroomSampleCreatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('样品创建'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: ShowroomSampleForm(
        initial: null,
        onSave: (data) async {
          await storeShowroomSample({...data, 'item_type': 'market_product'});
          EasyLoading.showSuccess("创建成功");
        },
        onSubmit: (data) async {
          await storeShowroomSample({...data, 'item_type': 'market_product'});
          EasyLoading.showSuccess("创建成功");
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
