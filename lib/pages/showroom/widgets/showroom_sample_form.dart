import 'dart:convert';

import 'package:cloud/constants/form_definitions.dart';
import 'package:cloud/models/field_config.dart';
import 'package:cloud/models/media.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/pages/widgets/build_form_card.dart';
import 'package:cloud/pages/widgets/confirm_dialog.dart';
import 'package:cloud/pages/widgets/field_selector.dart';
import 'package:cloud/pages/widgets/image_uploader.dart';
import 'package:cloud/pages/widgets/input.dart';
import 'package:cloud/pages/widgets/select.dart';
import 'package:cloud/pages/widgets/spacing_row.dart';
import 'package:cloud/pages/widgets/supplier_select.dart';
import 'package:cloud/pages/widgets/text_area.dart';
import 'package:cloud/pages/widgets/translate_input.dart';
import 'package:cloud/providers/field_config_provider.dart';
import 'package:cloud/services/openai.dart';
import 'package:cloud/services/supply.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowroomSampleForm extends HookConsumerWidget {
  final Sample? initial;

  final ValueChanged<bool>? onDirtyChanged;

  final Future<bool?> Function(Map<String, dynamic>)? onDraft;
  final Future<bool?> Function(Map<String, dynamic>) onSubmit;

  const ShowroomSampleForm({
    super.key,
    required this.initial,
    this.onDraft, //预留草稿操作
    required this.onSubmit,
    this.onDirtyChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());

    final configParams = useMemoized(() => FieldConfigParams(
          storageKey: 'sample_form_v1',
          defaultFields: sampleDefaultFields,
        ));

    final fieldConfigs = ref.watch(fieldConfigProvider(configParams));

    final notifier = ref.read(fieldConfigProvider(configParams).notifier);

    bool isVisible(String name) {
      return fieldConfigs
          .firstWhere((e) => e.name == name,
              orElse: () => FieldConfig(label: '', name: name, isVisible: true))
          .isVisible;
    }

    final Map<String, dynamic> initialValues =
        Map<String, dynamic>.from(initial?.toJson() ?? {});

    if (initialValues['spec'] != null &&
        initialValues['spec'].toString().isNotEmpty) {
      final String spec = initialValues['spec'].toString();
      final List<String> parts = spec.split('x');

      if (parts.isNotEmpty) initialValues['length'] = parts[0];
      if (parts.length > 1) initialValues['width'] = parts[1];
      if (parts.length > 2) {
        initialValues['heigth'] = parts[2];
      }
    }

    Future<void> handleSmartRecognize() async {
      formKey.currentState?.save();
      final images = formKey.currentState?.value['image'];

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

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              child: FormBuilder(
                key: formKey,
                onChanged: () {
                  onDirtyChanged?.call(true);
                },
                initialValue: initialValues,
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
                        FormBuilderField<List<dynamic>>(
                          name: "image",
                          builder: (field) {
                            List<TemporaryMedia> displayValue = [];

                            if (field.value != null) {
                              displayValue = field.value!
                                  .map((e) {
                                    if (e is Media) {
                                      return TemporaryMedia(
                                        id: e.id!,
                                        url: e.url!,
                                        thumbUrl: e.thumbUrl,
                                      );
                                    } else if (e is TemporaryMedia) {
                                      return e;
                                    }

                                    return null;
                                  })
                                  .whereType<TemporaryMedia>()
                                  .toList();
                            }
                            return ImageUploader(
                              value: displayValue,
                              onChanged: field.didChange,
                            );
                          },
                        ),
                      ],
                    ),
                    BuildFormCard(
                      title: '基本信息',
                      action: Row(
                        children: [
                          if (initial == null) ...[
                            GestureDetector(
                              onTap: () async {
                                try {
                                  EasyLoading.show(status: '加载中...');

                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  final jsonStr = prefs.getString(
                                    'last_sample_data_market_product',
                                  );

                                  if (jsonStr != null) {
                                    final data = jsonDecode(jsonStr);

                                    // 移除不需要复用的字段
                                    data.remove('id');
                                    data.remove('product_no');
                                    data.remove('image');
                                    data.remove('supply_quotes');

                                    // spec 拆分
                                    if (data['spec'] != null &&
                                        data['spec'].toString().isNotEmpty) {
                                      final parts =
                                          data['spec'].toString().split('x');
                                      if (parts.isNotEmpty) {
                                        data['length'] = parts[0];
                                      }
                                      if (parts.length > 1) {
                                        data['width'] = parts[1];
                                      }
                                      if (parts.length > 2) {
                                        data['heigth'] = parts[2];
                                      }
                                    }

                                    // 填充表单
                                    formKey.currentState?.patchValue(data);
                                  }
                                } catch (e) {
                                  EasyLoading.showError('加载失败');
                                } finally {
                                  EasyLoading.dismiss();
                                }
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.content_copy,
                                    size: 16,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "复制上一条",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6)
                          ],
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (ctx) {
                                  return FieldSelector(
                                    fields: fieldConfigs,
                                    defaultFields: sampleDefaultFields,
                                    onConfigChanged:
                                        (List<FieldConfig> newConfigs) {
                                      notifier.updateConfigs(newConfigs);
                                    },
                                  );
                                },
                              );
                            },
                            child: Row(
                              children: [
                                Icon(Icons.settings,
                                    size: 16,
                                    color: Theme.of(context).primaryColor),
                                const SizedBox(width: 4),
                                Text("字段设置",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context).primaryColor)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      children: [
                        SpacingRow(
                          spacing: 12,
                          children: [
                            if (isVisible('product_no'))
                              Expanded(
                                child: FormBuilderField<String>(
                                  name: "product_no",
                                  builder: (field) {
                                    return Input(
                                      label: '产品货号',
                                      hintText: '自动生成',
                                      value: field.value ?? '',
                                      onChanged: field.didChange,
                                    );
                                  },
                                ),
                              ),
                            if (isVisible('purchase_cost'))
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
                        if (isVisible('name_cn'))
                          FormBuilderField<String>(
                            name: "name_cn",
                            builder: (field) {
                              return TranslatableInput(
                                label: '中文名称',
                                sourceText: formKey
                                    .currentState?.fields['name_cn']?.value,
                                value: field.value ?? '',
                                onChanged: field.didChange,
                                onTranslateChanged: (value) {
                                  formKey.currentState?.fields['name_en']
                                      ?.didChange(value);
                                },
                              );
                            },
                          ),
                        if (isVisible('name_en'))
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
                    FormBuilderField<List<Map<String, dynamic>>>(
                      name: "supply_quotes",
                      initialValue: initial?.supplyQuotes
                              ?.map((e) => e.toJson())
                              .toList() ??
                          [],
                      builder:
                          (FormFieldState<List<Map<String, dynamic>>> field) {
                        final List<Map<String, dynamic>> valueList =
                            field.value ?? [];

                        return BuildFormCard(
                          title: '工厂报价',
                          action: GestureDetector(
                            onTap: () async {
                              final selectedSupplier =
                                  await showModalBottomSheet<
                                      Map<String, dynamic>>(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (BuildContext ctx) {
                                  return const SupplierSelect();
                                },
                              );

                              if (selectedSupplier != null) {
                                final currentList =
                                    List<Map<String, dynamic>>.from(valueList);

                                final newId = selectedSupplier['id'];

                                final isExist = currentList.any(
                                    (item) => item['supplier_id'] == newId);

                                if (!isExist) {
                                  final newItem = {
                                    'supplier_id': newId,
                                    'supplier': {
                                      'id': newId,
                                      'name': selectedSupplier['name'] ??
                                          selectedSupplier['shortName'],
                                    }
                                  };

                                  currentList.add(newItem);
                                  field.didChange(currentList);
                                } else {
                                  EasyLoading.showInfo('该供应商已在列表中');
                                }
                              }
                            },
                            child: Row(
                              children: [
                                Icon(Icons.add_circle_outline,
                                    size: 16,
                                    color: Theme.of(context).primaryColor),
                                const SizedBox(width: 4),
                                Text("添加",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 13)),
                              ],
                            ),
                          ),
                          children: [
                            if (valueList.isEmpty)
                              Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 24),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.1)),
                                ),
                                child: Column(
                                  children: [
                                    Icon(Icons.inbox_outlined,
                                        size: 32, color: Colors.grey[300]),
                                    const SizedBox(height: 4),
                                    Text(
                                      "暂无工厂报价",
                                      style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              )
                            else
                              ...valueList.asMap().entries.map((entry) {
                                final int index = entry.key;
                                final Map<String, dynamic> item = entry.value;

                                String name = '';
                                final supplier = item['supplier'];

                                if (supplier is Map) {
                                  name = supplier['name']?.toString() ?? '';
                                } else if (supplier != null) {
                                  name = supplier.name ?? '';
                                }

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.2)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: Text(
                                            name,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[800]),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          )),
                                          InkWell(
                                            onTap: () async {
                                              final bool isConfirmed =
                                                  await ConfirmDialog.show(
                                                context,
                                                content: '确定要移除这个工厂报价吗？',
                                              );
                                              if (isConfirmed) {
                                                final newList = List<
                                                        Map<String,
                                                            dynamic>>.from(
                                                    valueList);

                                                final quoteId = item['id'];

                                                if (quoteId != null) {
                                                  EasyLoading.show(
                                                      status: '删除中...');
                                                  await deleteSupplyQuote(
                                                      quoteId);
                                                  EasyLoading.dismiss();

                                                  newList.removeAt(index);
                                                  field.didChange(newList);
                                                  EasyLoading.showSuccess(
                                                      '删除成功');
                                                } else {
                                                  newList.removeAt(index);
                                                  field.didChange(newList);
                                                }
                                              }
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.all(4.0),
                                              child: Icon(Icons.delete_outline,
                                                  size: 18, color: Colors.red),
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Input(
                                              label: '供应商货号',
                                              value: item['supplier_product_no']
                                                      ?.toString() ??
                                                  "",
                                              onChanged: (val) {
                                                final newList = List<
                                                        Map<String,
                                                            dynamic>>.from(
                                                    valueList);
                                                newList[index] = {
                                                  ...newList[index],
                                                  'supplier_product_no': val
                                                };
                                                field.didChange(newList);
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Input(
                                              label: '供应商价格',
                                              value: item['purchase_cost']
                                                      ?.toString() ??
                                                  '',
                                              keyboardType: const TextInputType
                                                  .numberWithOptions(
                                                  decimal: true),
                                              onChanged: (val) {
                                                final newList = List<
                                                        Map<String,
                                                            dynamic>>.from(
                                                    valueList);

                                                newList[index] = {
                                                  ...newList[index],
                                                  'purchase_cost': val
                                                };
                                                field.didChange(newList);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Input(
                                              label: '最小起订量',
                                              value:
                                                  item['moq']?.toString() ?? '',
                                              onChanged: (val) {
                                                final newList = List<
                                                        Map<String,
                                                            dynamic>>.from(
                                                    valueList);
                                                newList[index] = {
                                                  ...newList[index],
                                                  'moq': val
                                                };
                                                field.didChange(newList);
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Input(
                                              label: '材质',
                                              value: item['material']
                                                      ?.toString() ??
                                                  '',
                                              onChanged: (val) {
                                                final newList = List<
                                                        Map<String,
                                                            dynamic>>.from(
                                                    valueList);
                                                newList[index] = {
                                                  ...newList[index],
                                                  'material': val
                                                };
                                                field.didChange(newList);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }),
                          ],
                        );
                      },
                    ),
                    BuildFormCard(
                      title: '产品规格',
                      children: [
                        SpacingRow(
                          spacing: 12,
                          children: [
                            if (isVisible('unit'))
                              Expanded(
                                child: FormBuilderField<String>(
                                  name: "unit",
                                  builder: (field) {
                                    return Select(
                                      label: '单位',
                                      value: field.value,
                                      options: [
                                        SelectOption(label: 'PC', value: 'PC'),
                                        SelectOption(
                                            label: 'SET', value: 'SET'),
                                        SelectOption(
                                            label: 'CTN', value: 'CTN'),
                                        SelectOption(label: 'KG', value: 'KG'),
                                        SelectOption(label: 'T', value: 'T'),
                                        SelectOption(
                                            label: 'CBM', value: 'CBM'),
                                        SelectOption(label: 'M', value: 'M'),
                                        SelectOption(label: 'L', value: 'L'),
                                        SelectOption(
                                            label: 'BAG', value: 'BAG'),
                                        SelectOption(
                                            label: 'PACK', value: 'PACK'),
                                        SelectOption(
                                            label: 'CASE', value: 'CASE'),
                                        SelectOption(
                                            label: 'PAIR', value: 'PAIR'),
                                        SelectOption(
                                            label: 'BOX', value: 'BOX'),
                                        SelectOption(
                                            label: 'SQM', value: 'SQM'),
                                        SelectOption(label: 'G', value: 'G'),
                                        SelectOption(
                                            label: 'Pieces', value: 'Pieces'),
                                        SelectOption(
                                            label: 'Pair', value: 'Pair'),
                                      ],
                                      onChanged: field.didChange,
                                    );
                                  },
                                ),
                              ),
                            if (isVisible('packing'))
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
                            if (isVisible('series'))
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
                        if (isVisible('spec'))
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
                        if (isVisible('description_cn'))
                          FormBuilderField<String>(
                            name: "description_cn",
                            builder: (field) {
                              return TextArea(
                                label: '中文描述',
                                showTranslate: true,
                                sourceText: formKey.currentState
                                    ?.fields['description_cn']?.value,
                                value: field.value,
                                onChanged: field.didChange,
                                onTranslateChanged: (value) {
                                  formKey.currentState?.fields['description_en']
                                      ?.didChange(value);
                                },
                              );
                            },
                          ),
                        if (isVisible('description_en'))
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
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Row(
            children: [
              Expanded(
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
                        final Map<String, dynamic> submitValues =
                            Map.from(formState!.value);

                        final length = submitValues['length']?.toString() ?? '';
                        final width = submitValues['width']?.toString() ?? '';
                        final height = submitValues['heigth']?.toString() ?? '';

                        final spec = [length, width, height].join('x');
                        submitValues['spec'] = spec;

                        final success = await onSubmit(submitValues);
                        if (success == true) {
                          formKey.currentState?.reset();
                        }
                      }
                    },
                    child: const Text(
                      '提交',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
