import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/quote/widgets/quote_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class QuoteCreatePage extends HookConsumerWidget {
  const QuoteCreatePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('报价单管理')),
      body: SupplySupplierForm(
        initial: null,
        onSubmit: (data) async {
          //TODO
          EasyLoading.showSuccess("创建成功");
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
