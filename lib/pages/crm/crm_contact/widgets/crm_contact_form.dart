import 'package:cloud/helper/form_data_converter.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/company_card_data.dart';
import 'package:cloud/models/crm/contact.dart' as crm_contact;
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/widgets/build_form_card.dart';
import 'package:cloud/pages/widgets/company_select.dart';
import 'package:cloud/pages/widgets/image_uploader.dart';
import 'package:cloud/pages/widgets/input.dart';
import 'package:cloud/pages/widgets/multi_input.dart';
import 'package:cloud/services/openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CrmCotactForm extends HookConsumerWidget {
  final crm_contact.Contact? initial;

  final Future<void> Function(Map<String, dynamic>) onSubmit;

  const CrmCotactForm({
    super.key,
    required this.initial,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());

    /// 将 CompanyCardData 对象转换为扁平化的 Map 格式，适用于 FormBuilder
    Map<String, dynamic> convertCompanyCardDataToFormValues(
        CompanyCardData data) {
      final Map<String, dynamic> formValues = {
        'address': data.address,
        'location': data.location,
        'industry': data.industry,
        'domain': data.domain,
        'email': data.email,
        'linkedin': data.linkedin,
        'whatsapp': data.whatsapp,
        'facebook': data.facebook,
      };

      if (data.contact != null) {
        final contact = data.contact!;
        formValues['name'] = contact.name;
        formValues['mobile'] = contact.mobile;
        formValues['position'] = contact.position;
      }
      return formValues;
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
        final result = await identifyCompanyCard({'image': images});

        if (result != null) {
          EasyLoading.showSuccess("识别成功");
          final formValues = convertCompanyCardDataToFormValues(result);
          formKey.currentState?.patchValue(formValues);
        } else {
          EasyLoading.dismiss();
        }
      } catch (e) {
        logger.d('error$e');
        EasyLoading.showError('识别失败$e');
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
                initialValue: initial == null
                    ? {}
                    : {
                        ...initial!.toJson(),
                        'email': List<String>.from(initial!.email ?? []),
                        'whatsapp': List<String>.from(initial!.whatsapp ?? []),
                        'linkedin': List<String>.from(initial!.linkedin ?? []),
                        'facebook': List<String>.from(initial!.facebook ?? []),
                      },
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
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              clipBehavior: Clip.none,
                              child: ImageUploader(
                                customIcon: Icons.camera_alt,
                                value: field.value,
                                onChanged: (value) {
                                  field.didChange(value);
                                },
                              ),
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
                          builder: (field) {
                            return Input(
                              label: '名称',
                              value: field.value ?? '',
                              onChanged: field.didChange,
                            );
                          },
                        ),
                        FormBuilderField<int>(
                          name: "company_id",
                          builder: (field) {
                            return CompanySelect(
                              label: '公司',
                              value: field.value,
                              onChanged: field.didChange,
                            );
                          },
                        ),
                        FormBuilderField<String>(
                          name: "mobile", // 字段重命名
                          builder: (field) {
                            return Input(
                              label: '手机号',
                              value: field.value ?? '',
                              onChanged: field.didChange,
                            );
                          },
                        ),
                        FormBuilderField<String>(
                          name: "position",
                          builder: (field) {
                            return Input(
                              label: '职位',
                              value: field.value ?? '',
                              onChanged: field.didChange,
                            );
                          },
                        ),
                        FormBuilderField<String>(
                          name: "birthday",
                          builder: (field) {
                            return Input(
                              label: '生日',
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
                        FormBuilderField<List<String>>(
                          name: "email",
                          builder: (field) {
                            return MultiInput(
                              label: '公司邮箱',
                              btnText: '添加邮箱',
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
