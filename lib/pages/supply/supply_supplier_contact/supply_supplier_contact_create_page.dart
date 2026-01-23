import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/models/schema.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/pages/widgets/dynamic_build_field.dart';
import 'package:cloud/pages/widgets/image_uploader.dart';
import 'package:cloud/services/openai.dart';
import 'package:cloud/services/schema.dart';
import 'package:cloud/services/supply.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class SupplySupplierContactCreatePage extends HookConsumerWidget {
  final int supplierId;
  const SupplySupplierContactCreatePage({super.key, required this.supplierId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final schemas = useState<List<Schema>?>(null);
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());

    useEffect(() {
      loadSchema() async {
        final resp = await getSchema('supply_contacts');
        schemas.value = resp?.where((s) => s.hidden != true).toList();
      }

      loadSchema();
      return () {};
    }, []);

    if (schemas.value == null) {
      return const Scaffold(
        body: Center(child: MuProgressIndicator()),
      );
    }

    Future<void> handleSmartRecognize() async {
      formKey.currentState?.save();
      final images = formKey.currentState?.value['images'];

      if (images == null || (images is List && images.isEmpty)) {
        EasyLoading.showInfo("请先上传图片");
        return;
      }

      await EasyLoading.show(
          status: '智能识别中...', maskType: EasyLoadingMaskType.clear);

      try {
        final result = await identifySupplySuppliersCard({'image': images});

        if (result != null && result is Map<String, dynamic>) {
          EasyLoading.showSuccess("识别成功");

          formKey.currentState?.patchValue(result);
        } else {
          EasyLoading.dismiss();
        }
      } catch (e) {
        EasyLoading.showError('识别失败');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('供应商联系人创建'),
        backgroundColor: colorScheme.surface,
      ),
      body: Column(children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: FormBuilder(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BuildFormCard(
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        const Text(
                          '名片',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '名片自动识别',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    action: GestureDetector(
                      onTap: handleSmartRecognize,
                      child: Row(
                        children: [
                          Icon(Icons.center_focus_weak,
                              size: 16, color: Theme.of(context).primaryColor),
                          const SizedBox(width: 4),
                          Text(
                            "智能识别",
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    children: [
                      FormBuilderField<List<TemporaryMedia>>(
                        name: "images",
                        builder: (field) {
                          return ImageUploader(
                            customIcon: Icons.camera_alt,
                            value: field.value,
                            onChanged: field.didChange,
                          );
                        },
                      ),
                    ],
                  ),
                  BuildFormCard(
                    title: '基本信息',
                    children: [
                      for (final item in schemas.value ?? [])
                        DynamicBuildField(schema: item),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ))
      ]),
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
              final values = formState?.value;
              debugPrint('提交表单: $values');
              final data = {
                ...?values,
                'supplier_id': supplierId,
              };

              await storeSupplySupplierContact(data);
              EasyLoading.showSuccess('创建供应商联系人成功!');
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
