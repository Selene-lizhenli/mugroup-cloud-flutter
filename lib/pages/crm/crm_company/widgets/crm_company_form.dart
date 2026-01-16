import 'package:cloud/models/crm/company.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/widgets/build_form_card.dart';
import 'package:cloud/pages/widgets/image_uploader.dart';
import 'package:cloud/pages/widgets/input.dart';
import 'package:cloud/pages/widgets/multi_input.dart';
import 'package:cloud/services/openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CrmCompanyForm extends HookConsumerWidget {
  final Company? initial;
  final bool showUpload;
  final Future<void> Function(Map<String, dynamic>) onSubmit;

  const CrmCompanyForm({
    super.key,
    this.showUpload = false,
    required this.initial,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());

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
        final result = await identifyCompanyCard({'image': images});

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

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: FormBuilder(
                key: formKey,
                initialValue: initial?.toJson() ?? {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    BuildFormCard(
                      title: '名片',
                      action: GestureDetector(
                        onTap: handleSmartRecognize,
                        child: Row(
                          children: [
                            Icon(Icons.center_focus_weak,
                                size: 16,
                                color: Theme.of(context).primaryColor),
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
                        FormBuilderField<String>(
                          name: "name",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '该项不能为空';
                            }
                            return null;
                          },
                          builder: (field) {
                            return Input(
                              label: '客户名称',
                              isRequired: true,
                              value: field.value ?? '',
                              onChanged: field.didChange,
                              errorText: field.errorText,
                            );
                          },
                        ),
                        FormBuilderField<String>(
                          name: "address",
                          builder: (field) {
                            return Input(
                              label: '地址',
                              value: field.value ?? '',
                              onChanged: field.didChange,
                            );
                          },
                        ),
                        FormBuilderField<String>(
                          name: "location",
                          builder: (field) {
                            return Input(
                              label: '国家/地区',
                              value: field.value ?? '',
                              onChanged: field.didChange,
                            );
                          },
                        ),
                        FormBuilderField<String>(
                          name: "industry",
                          builder: (field) {
                            return Input(
                              label: '行业',
                              value: field.value ?? '',
                              onChanged: field.didChange,
                            );
                          },
                        ),
                        FormBuilderField<String>(
                          name: "source",
                          builder: (field) {
                            return Input(
                              label: '来源',
                              value: field.value ?? '',
                              onChanged: field.didChange,
                            );
                          },
                        ),
                        FormBuilderField<List<String>>(
                          name: "domain",
                          builder: (field) {
                            return MultiInput(
                              label: '公司网址',
                              btnText: '添加公司网址',
                              values: field.value ?? [''],
                              onChanged: field.didChange,
                            );
                          },
                        ),
                        FormBuilderField<List<String>>(
                          name: "email",
                          builder: (field) {
                            return MultiInput(
                              label: '邮箱',
                              btnText: '添加邮箱',
                              values: field.value ?? [''],
                              onChanged: field.didChange,
                            );
                          },
                        ),
                        FormBuilderField<List<String>>(
                          name: "linkedin",
                          builder: (field) {
                            return MultiInput(
                              label: 'LinkedIn',
                              btnText: '添加 LinkedIn',
                              values: field.value ?? [''],
                              onChanged: field.didChange,
                            );
                          },
                        ),
                        FormBuilderField<List<String>>(
                          name: "whatsapp",
                          builder: (field) {
                            return MultiInput(
                              label: 'WhatsApp',
                              btnText: '添加 WhatsApp',
                              values: field.value ?? [''],
                              onChanged: field.didChange,
                            );
                          },
                        ),
                        FormBuilderField<List<String>>(
                          name: "facebook",
                          builder: (field) {
                            return MultiInput(
                              label: 'Facebook',
                              btnText: '添加 Facebook',
                              values: field.value ?? [''],
                              onChanged: field.didChange,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () async {
                final formState = formKey.currentState;
                if (formState?.saveAndValidate() ?? false) {
                  final values = formState!.value;

                  onSubmit(values);
                }
              },
              child: const Text(
                '提交',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
