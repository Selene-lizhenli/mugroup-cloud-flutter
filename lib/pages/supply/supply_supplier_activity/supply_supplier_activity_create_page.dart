import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/widgets/image_uploader.dart';
import 'package:cloud/pages/widgets/text_area.dart';
import 'package:cloud/services/supply.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class SupplySupplierActivityCreatePage extends HookConsumerWidget {
  final int supplierId;
  const SupplySupplierActivityCreatePage({super.key, required this.supplierId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('供应商动态创建')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: FormBuilder(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FormBuilderField<List<TemporaryMedia>>(
                  name: "attachments",
                  validator: (value) {
                    return '必填';
                  },
                  builder: (field) {
                    return ImageUploader(
                      label: "附件",
                      value: field.value,
                      onChanged: field.didChange,
                      errorText: field.errorText,
                    );
                  },
                ),
                FormBuilderField<String>(
                  name: "description",
                  builder: (field) {
                    return TextArea(
                      label: '备注',
                      value: field.value,
                      onChanged: field.didChange,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: () async {
            final formState = formKey.currentState;
            if (formState?.saveAndValidate() ?? false) {
              final values = formState!.value;
              debugPrint('提交表单: $values');

              await storeSupplySupplierActivity(supplierId, values);
              EasyLoading.showSuccess('供应商动态创建成功!');
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            } else {
              debugPrint('表单校验失败');
            }
          },
          child: const Text(
            '提交',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
