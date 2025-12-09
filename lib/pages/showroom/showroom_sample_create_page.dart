import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/models/schema.dart';
import 'package:cloud/pages/showroom/widgets/build_form_card.dart';
import 'package:cloud/pages/widgets/image_uploader.dart';
import 'package:cloud/pages/widgets/input.dart';
import 'package:cloud/pages/widgets/select.dart';
import 'package:cloud/pages/widgets/text_area.dart';
import 'package:cloud/services/openai.dart';
import 'package:cloud/services/sample.dart';
import 'package:cloud/services/schema.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

@RoutePage()
class ShowroomSampleCreatePage extends HookConsumerWidget {
  const ShowroomSampleCreatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final schemas = useState<List<Schema>?>(null);
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());

    useEffect(() {
      loadSchema() async {
        final resp = await getSchema('showroom_samples');
        schemas.value = resp?.where((s) => s.hidden != true).toList();
      }

      loadSchema();
      return () {};
    }, []);

    if (schemas.value == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
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
        final result = await identifySample({'image': images});

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
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('样品创建'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: FormBuilder(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BuildFormCard(
                title: '图片资料',
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
                  Row(
                    children: [
                      Expanded(
                        child: FormBuilderField<String>(
                          name: "product_no",
                          builder: (field) {
                            return Input(
                              label: '产品货号',
                              value: field.value ?? '',
                              onChanged: field.didChange,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FormBuilderField<String>(
                          name: "purchase_cost",
                          builder: (field) {
                            return Input(
                              label: '价格',
                              value: field.value ?? '',
                              onChanged: field.didChange,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  FormBuilderField<String>(
                    name: "name_cn",
                    builder: (field) {
                      return Input(
                        label: '中文名称',
                        value: field.value ?? '',
                        onChanged: field.didChange,
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  FormBuilderField<String>(
                    name: "name_en",
                    builder: (field) {
                      return Input(
                        label: '英文名称',
                        value: field.value ?? '',
                        onChanged: field.didChange,
                      );
                    },
                  ),
                ],
              ),
              BuildFormCard(
                title: '产品规格',
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: FormBuilderField<String>(
                          name: "unit",
                          builder: (field) {
                            return Select(
                              label: '单位',
                              value: field.value,
                              options: [
                                SelectOption(label: 'Piece', value: 'Piece'),
                                SelectOption(label: 'Set', value: 'Set'),
                                SelectOption(label: 'Pair', value: 'Pair'),
                                SelectOption(label: 'Bag', value: 'Bag'),
                              ],
                              onChanged: field.didChange,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FormBuilderField<String>(
                          name: "packing",
                          builder: (field) {
                            return Input(
                              label: '包装方式',
                              value: field.value ?? '',
                              onChanged: field.didChange,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FormBuilderField<String>(
                          name: "series",
                          builder: (field) {
                            return Input(
                              label: '系列',
                              value: field.value ?? '',
                              onChanged: field.didChange,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: FormBuilderField<String>(
                          name: "length",
                          builder: (field) {
                            return Input(
                              label: '长',
                              value: field.value ?? '',
                              onChanged: field.didChange,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d*')),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FormBuilderField<String>(
                          name: "width",
                          builder: (field) {
                            return Input(
                              label: '宽',
                              value: field.value ?? '',
                              onChanged: field.didChange,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d*')),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FormBuilderField<String>(
                          name: "heigth",
                          builder: (field) {
                            return Input(
                              label: '高',
                              value: field.value ?? '',
                              onChanged: field.didChange,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d*')),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              BuildFormCard(
                title: '描述',
                isLast: true,
                children: [
                  FormBuilderField<String>(
                    name: "description_cn",
                    builder: (field) {
                      return TextArea(
                        label: '中文描述',
                        value: field.value,
                        onChanged: field.didChange,
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  FormBuilderField<String>(
                    name: "description_en",
                    builder: (field) {
                      return TextArea(
                        label: '英文描述',
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
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () async {
            final formState = formKey.currentState;
            if (formState?.saveAndValidate() ?? false) {
              final Map<String, dynamic> submitValues =
                  Map.from(formState!.value);

              final length = submitValues['length']?.toString() ?? '';
              final width = submitValues['width']?.toString() ?? '';
              final height = submitValues['heigth']?.toString() ?? '';

              final spec = [length, width, height].join('x');
              submitValues['spec'] = spec;

              await storeShowroomSample(submitValues);
              EasyLoading.showSuccess('创建样品成功!');
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            } else {
              debugPrint('表单校验失败');
              EasyLoading.showError('请检查必填项');
            }
          },
          child: const Text(
            '提交',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
