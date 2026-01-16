import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/widgets/build_form_card.dart';
import 'package:cloud/pages/widgets/image_uploader.dart';
import 'package:cloud/pages/widgets/input.dart';
import 'package:cloud/pages/widgets/multi_input.dart';
import 'package:cloud/services/crm.dart';
import 'package:cloud/services/openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class MarketProductCompanyCreatePage extends HookConsumerWidget {
  const MarketProductCompanyCreatePage({super.key});

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

    return Scaffold(
        appBar: AppBar(
          title: const Text("新建客户"),
          backgroundColor: colorScheme.surface,
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SingleChildScrollView(
                  child: FormBuilder(
                    key: formKey,
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
                          title: '公司信息',
                          children: [
                            FormBuilderField<String>(
                              name: "name", // 公司名称
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
                              name: "email", // 公司邮箱
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
                              name: "linkedin", // 公司LinkedIn
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
                              name: "whatsapp", // 公司WhatsApp
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
                              name: "facebook", // 公司Facebook
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
                        BuildFormCard(
                          title: '联系人',
                          children: [
                            FormBuilderField<String>(
                              name: "contact_name", // 字段重命名
                              builder: (field) {
                                return Input(
                                  label: '联系人姓名',
                                  value: field.value ?? '',
                                  onChanged: field.didChange,
                                );
                              },
                            ),
                            FormBuilderField<String>(
                              name: "contact_position",
                              builder: (field) {
                                return Input(
                                  label: '职位',
                                  value: field.value ?? '',
                                  onChanged: field.didChange,
                                );
                              },
                            ),
                            FormBuilderField<String>(
                              name: "contact_birthday",
                              builder: (field) {
                                return Input(
                                  label: '生日',
                                  value: field.value ?? '',
                                  onChanged: field.didChange,
                                );
                              },
                            ),
                            FormBuilderField<String>(
                              name: "contact_location",
                              builder: (field) {
                                return Input(
                                  label: '联系人地区',
                                  value: field.value ?? '',
                                  onChanged: field.didChange,
                                );
                              },
                            ),
                            FormBuilderField<List<String>>(
                              name: "contact_email", // 字段重命名
                              builder: (field) {
                                return MultiInput(
                                  label: '个人邮箱',
                                  btnText: '添加邮箱',
                                  values: field.value ?? [''],
                                  onChanged: field.didChange,
                                );
                              },
                            ),
                            FormBuilderField<List<String>>(
                              name: "contact_whatsapp", // 字段重命名
                              builder: (field) {
                                return MultiInput(
                                  label: '个人 WhatsApp',
                                  btnText: '添加 WhatsApp',
                                  values: field.value ?? [''],
                                  onChanged: field.didChange,
                                );
                              },
                            ),
                            FormBuilderField<List<String>>(
                              name: "contact_linkedin", // 字段重命名
                              builder: (field) {
                                return MultiInput(
                                  label: '个人 LinkedIn',
                                  btnText: '添加 LinkedIn',
                                  values: field.value ?? [''],
                                  onChanged: field.didChange,
                                );
                              },
                            ),
                            FormBuilderField<List<String>>(
                              name: "contact_facebook", // 字段重命名
                              builder: (field) {
                                return MultiInput(
                                  label: '个人 Facebook',
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

                      try {
                        await EasyLoading.show(status: '提交中...');

                        // 1. 整理公司数据
                        final companyData = {
                          'images': values['images'],
                          'name': values['name'],
                          'address': values['address'],
                          'location': values['location'],
                          'industry': values['industry'],
                          'source': values['source'],
                          'domain': values['domain'],
                          'email': values['email'],
                          'linkedin': values['linkedin'],
                          'whatsapp': values['whatsapp'],
                          'facebook': values['facebook'],
                        };

                        final newCompany = await storeCrmCompany(companyData);

                        // 3. 检查是否有联系人数据需要提交
                        final hasContactName = values['contact_name'] != null &&
                            values['contact_name'].toString().isNotEmpty;

                        if (hasContactName) {
                          final companyId = newCompany?.id;

                          // 4. 整理联系人数据 (映射回后端需要的标准字段名)
                          final contactData = {
                            'company_id': companyId,
                            'name': values['contact_name'],
                            'position': values['contact_position'],
                            'birthday': values['contact_birthday'],
                            'location': values['contact_location'],
                            'email': values['contact_email'],
                            'whatsapp': values['contact_whatsapp'],
                            'linkedin': values['contact_linkedin'],
                            'facebook': values['contact_facebook'],
                          };

                          await storeCrmContact(contactData);
                        }

                        EasyLoading.showSuccess("创建成功");
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      } catch (e) {
                        EasyLoading.showError("创建失败: $e");
                      }
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
        ));
  }
}
