import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/widgets/build_form_card.dart';
import 'package:cloud/pages/widgets/image_uploader.dart';
import 'package:cloud/pages/widgets/input.dart';
import 'package:cloud/pages/widgets/text_area.dart';
import 'package:cloud/services/openai.dart';
import 'package:cloud/services/supply.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class MarketProductSupplierCreatePage extends HookConsumerWidget {
  const MarketProductSupplierCreatePage({super.key});
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
          title: const Text("新建供应商"),
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '该项不能为空';
                                }
                                return null;
                              },
                              builder: (field) {
                                return Input(
                                  label: '供应商名称',
                                  isRequired: true,
                                  value: field.value ?? '',
                                  onChanged: field.didChange,
                                  errorText: field.errorText,
                                );
                              },
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: FormBuilderField<String>(
                                  name: "area",
                                  builder: (field) {
                                    return Input(
                                      label: '区域',
                                      value: field.value ?? '',
                                      onChanged: field.didChange,
                                    );
                                  },
                                )),
                                const SizedBox(width: 10),
                                Expanded(
                                    child: FormBuilderField<String>(
                                  name: "stall",
                                  builder: (field) {
                                    return Input(
                                      label: '店铺号',
                                      value: field.value ?? '',
                                      onChanged: field.didChange,
                                    );
                                  },
                                )),
                              ],
                            ),
                          ],
                        ),
                        BuildFormCard(
                          title: '联系人',
                          children: [
                            FormBuilderField<String>(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '该项不能为空';
                                }
                                return null;
                              },
                              name: "supplier_name",
                              builder: (field) {
                                return Input(
                                  label: '联系人姓名',
                                  isRequired: true,
                                  value: field.value ?? '',
                                  onChanged: field.didChange,
                                  errorText: field.errorText,
                                );
                              },
                            ),
                            FormBuilderField<String>(
                              name: "supplier_mobile",
                              builder: (field) {
                                return Input(
                                  label: '手机号',
                                  value: field.value ?? '',
                                  onChanged: field.didChange,
                                );
                              },
                            ),
                            FormBuilderField<String>(
                              name: "supplier_department",
                              builder: (field) {
                                return Input(
                                  label: '部门',
                                  value: field.value ?? '',
                                  onChanged: field.didChange,
                                );
                              },
                            ),
                            FormBuilderField<String>(
                              name: "supplier_sex",
                              builder: (field) {
                                return Input(
                                  label: '性别',
                                  value: field.value ?? '',
                                  onChanged: field.didChange,
                                );
                              },
                            ),
                            FormBuilderField<String>(
                              name: "supplier_position",
                              builder: (field) {
                                return Input(
                                  label: '职位',
                                  value: field.value ?? '',
                                  onChanged: field.didChange,
                                );
                              },
                            ),
                            FormBuilderField<String>(
                              name: "supplier_wechat",
                              builder: (field) {
                                return Input(
                                  label: '微信',
                                  value: field.value ?? '',
                                  onChanged: field.didChange,
                                );
                              },
                            ),
                            FormBuilderField<String>(
                              name: "supplier_qq",
                              builder: (field) {
                                return Input(
                                  label: 'QQ',
                                  value: field.value ?? '',
                                  onChanged: field.didChange,
                                );
                              },
                            ),
                            FormBuilderField<String>(
                              name: "supplier_phone",
                              builder: (field) {
                                return Input(
                                  label: '座机',
                                  value: field.value ?? '',
                                  onChanged: field.didChange,
                                );
                              },
                            ),
                            FormBuilderField<String>(
                              name: "supplier_email",
                              builder: (field) {
                                return Input(
                                  label: 'Email',
                                  value: field.value ?? '',
                                  onChanged: field.didChange,
                                );
                              },
                            ),
                            FormBuilderField<String>(
                              name: "supplier_fax",
                              builder: (field) {
                                return Input(
                                  label: '传真',
                                  value: field.value ?? '',
                                  onChanged: field.didChange,
                                );
                              },
                            ),
                            FormBuilderField<String>(
                              name: "supplier_remark",
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

                        final area = values['area']?.toString() ?? '';
                        final stall = values['stall']?.toString() ?? '';

                        final data = {
                          'images': values['images'],
                          'name': values['name'],
                          'stall_address': '$area$stall',
                        };

                        final newSupplier = await storeSupplySupplier(data);

                        // 3. 检查是否有联系人数据需要提交
                        final hasSupplierName =
                            values['supplier_name'] != null &&
                                values['supplier_name'].toString().isNotEmpty;

                        if (hasSupplierName) {
                          final supplierId = newSupplier?.id;

                          // 4. 整理联系人数据 (映射回后端需要的标准字段名)
                          final supplierData = {
                            'supplier_id': supplierId,
                            'name': values['supplier_name'],
                            'mobile': values['supplier_mobile'],
                            'department': values['supplier_department'],
                            'sex': values['supplier_sex'],
                            'position': values['supplier_position'],
                            'wechat': values['supplier_wechat'],
                            'qq': values['supplier_qq'],
                            'phone': values['supplier_phone'],
                            'email': values['supplier_email'],
                            'fax': values['supplier_fax'],
                            'remark': values['supplier_remark'],
                          };

                          await storeSupplySupplierContact(supplierData);
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
