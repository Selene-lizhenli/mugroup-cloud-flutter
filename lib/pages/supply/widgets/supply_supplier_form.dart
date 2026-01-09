import 'package:city_pickers/city_pickers.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/models/supply/supplier.dart';
import 'package:cloud/pages/widgets/build_form_card.dart';
import 'package:cloud/pages/widgets/check_box_input.dart';
import 'package:cloud/pages/widgets/date_picker_input.dart';
import 'package:cloud/pages/widgets/dynamic_city_pickers.dart';
import 'package:cloud/pages/widgets/image_uploader.dart';
import 'package:cloud/pages/widgets/input.dart';
import 'package:cloud/pages/widgets/multi_select.dart';
import 'package:cloud/pages/widgets/select.dart';
import 'package:cloud/pages/widgets/supplier_type_select.dart';
import 'package:cloud/pages/widgets/text_area.dart';
import 'package:cloud/services/openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SupplySupplierForm extends HookConsumerWidget {
  final Supplier? initial;
  final Future<void> Function(Map<String, dynamic>) onSubmit;

  const SupplySupplierForm({
    super.key,
    required this.initial,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());

    final provinceId = useState<String?>(null);

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

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: FormBuilder(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      collapsible: true,
                      defaultExpanded: true,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: FormBuilderField<String>(
                                name: "supplier_no",
                                builder: (field) {
                                  return Input(
                                    label: '厂商编号',
                                    value: field.value ?? '',
                                    onChanged: field.didChange,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: FormBuilderField<String>(
                                name: "usci_code",
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '该项不能为空';
                                  }
                                  return null;
                                },
                                builder: (field) {
                                  return Input(
                                    label: '税号代码',
                                    value: field.value ?? '',
                                    onChanged: field.didChange,
                                    errorText: field.errorText,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: FormBuilderField<String>(
                                name: "short_name",
                                builder: (field) {
                                  return Input(
                                    label: '厂商简称',
                                    value: field.value ?? '',
                                    onChanged: field.didChange,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: FormBuilderField<String>(
                                name: "name",
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '该项不能为空';
                                  }
                                  return null;
                                },
                                builder: (field) {
                                  return Input(
                                    label: '厂商名称',
                                    value: field.value ?? '',
                                    onChanged: field.didChange,
                                    errorText: field.errorText,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: FormBuilderField<String>(
                                name: "province",
                                builder: (field) {
                                  return DynamicCityPickers(
                                    label: '省份',
                                    showType: ShowType.p,
                                    value: field.value ?? '',
                                    onChanged: (value) {
                                      field.didChange(value?.provinceName);
                                      provinceId.value = value?.provinceId;
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: FormBuilderField<String>(
                                name: "city",
                                builder: (field) {
                                  return DynamicCityPickers(
                                    label: '城市',
                                    showType: ShowType.c,
                                    locationCode: provinceId.value,
                                    value: field.value ?? '',
                                    onChanged: (value) {
                                      field.didChange(value?.cityName);
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        FormBuilderField<String>(
                          name: "address",
                          builder: (field) {
                            return Input(
                              label: '厂商地址',
                              value: field.value ?? '',
                              onChanged: field.didChange,
                            );
                          },
                        ),
                        FormBuilderField<String>(
                          name: "business_scope",
                          builder: (field) {
                            return TextArea(
                              label: '营业范围',
                              value: field.value,
                              onChanged: field.didChange,
                            );
                          },
                        ),
                      ],
                    ),
                    BuildFormCard(title: '账户信息', collapsible: true, children: [
                      Row(
                        children: [
                          Expanded(
                            child: FormBuilderField<String>(
                              name: "bank_name",
                              builder: (field) {
                                return Input(
                                  label: '开户银行',
                                  value: field.value ?? '',
                                  onChanged: field.didChange,
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: FormBuilderField<String>(
                              name: "bank_account",
                              builder: (field) {
                                return Input(
                                  label: '银行账号',
                                  value: field.value ?? '',
                                  onChanged: field.didChange,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: FormBuilderField<String>(
                              name: "business_title",
                              builder: (field) {
                                return Input(
                                  label: '收款单位',
                                  value: field.value ?? '',
                                  onChanged: field.didChange,
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: FormBuilderField<String>(
                              name: "bill_type",
                              builder: (field) {
                                return Select(
                                  label: '发票类型',
                                  value: field.value,
                                  options: [
                                    SelectOption(label: '1', value: '1'),
                                    SelectOption(label: '3', value: '3'),
                                    SelectOption(label: '9', value: '9'),
                                    SelectOption(label: '13', value: '13'),
                                    SelectOption(label: '不开票', value: 'none'),
                                  ],
                                  onChanged: field.didChange,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ]),
                    BuildFormCard(
                        title: '业务信息',
                        isLast: true,
                        collapsible: true,
                        children: [
                          FormBuilderField<dynamic>(
                            name: "type_id",
                            builder: (field) {
                              return SupplierTypeSelect(
                                  label: '供应商分类',
                                  value: field.value.toString(),
                                  onChanged: (value) {
                                    field.didChange(value);
                                  });
                            },
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: FormBuilderField<bool>(
                                  name: "is_core",
                                  builder: (field) {
                                    return CheckboxInput(
                                      label: "是否核心",
                                      value: field.value ?? false,
                                      onChanged: field.didChange,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: FormBuilderField<String>(
                                  name: "is_corporate",
                                  builder: (field) {
                                    final boolValue = field.value == '1';
                                    return CheckboxInput(
                                      label: "是否已合作",
                                      value: boolValue,
                                      onChanged: (checked) {
                                        field.didChange(checked ? '1' : '0');
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: FormBuilderField<String>(
                                  name: "supplier_type",
                                  builder: (field) {
                                    return Select(
                                      label: '供应商类型',
                                      value: field.value,
                                      options: [
                                        SelectOption(
                                            label: '生产工厂', value: '生产工厂'),
                                        SelectOption(
                                            label: '工贸一体', value: '工贸一体'),
                                        SelectOption(
                                            label: '贸易商', value: '贸易商'),
                                      ],
                                      onChanged: field.didChange,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: FormBuilderField<String>(
                                  name: "export_market",
                                  builder: (field) {
                                    return Input(
                                      label: '主销市场',
                                      value: field.value ?? '',
                                      onChanged: field.didChange,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: FormBuilderField<String>(
                                  name: "corp_customer",
                                  builder: (field) {
                                    return Input(
                                      label: '合作客户',
                                      value: field.value ?? '',
                                      onChanged: field.didChange,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: FormBuilderField<String>(
                                  name: "corp_company",
                                  builder: (field) {
                                    return Input(
                                      label: '合作公司',
                                      value: field.value ?? '',
                                      onChanged: field.didChange,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: FormBuilderField<String>(
                                  name: "corp_skuid",
                                  builder: (field) {
                                    return Input(
                                      label: '合作货号',
                                      value: field.value ?? '',
                                      onChanged: field.didChange,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: FormBuilderField<String>(
                                  name: "showroom_area",
                                  builder: (field) {
                                    return Input(
                                      label: '样品间面积',
                                      value: field.value ?? '',
                                      onChanged: field.didChange,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: FormBuilderField<String>(
                                  name: "market_rate",
                                  builder: (field) {
                                    return Input(
                                      label: '市场占比',
                                      value: field.value ?? '',
                                      onChanged: field.didChange,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: FormBuilderField<String>(
                                  name: "land_type",
                                  builder: (field) {
                                    return Input(
                                      label: '土地厂房性质',
                                      value: field.value ?? '',
                                      onChanged: field.didChange,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: FormBuilderField<String>(
                                  name: "factory_area",
                                  builder: (field) {
                                    return Input(
                                      label: '工厂面积',
                                      value: field.value ?? '',
                                      onChanged: field.didChange,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: FormBuilderField<String>(
                                  name: "employee_count",
                                  builder: (field) {
                                    return Input(
                                      label: '员工人数',
                                      value: field.value ?? '',
                                      onChanged: field.didChange,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          FormBuilderField<String>(
                            name: "annual",
                            builder: (field) {
                              return Input(
                                label: '年产值',
                                value: field.value ?? '',
                                onChanged: field.didChange,
                              );
                            },
                          ),
                          FormBuilderField<List<dynamic>>(
                            name: "advantages",
                            builder: (field) {
                              return MultiSelect(
                                label: "工厂优势",
                                value: field.value ?? [],
                                options: [
                                  SelectOption(label: '价格', value: '价格'),
                                  SelectOption(
                                      label: '各类认证齐全', value: '各类认证齐全'),
                                  SelectOption(label: '配合服务好', value: '配合服务好'),
                                  SelectOption(
                                      label: '工厂开发能力强', value: '工厂开发能力强'),
                                  SelectOption(label: '资金稳定', value: '资金稳定'),
                                  SelectOption(
                                      label: '地方政府关系好', value: '地方政府关系好'),
                                  SelectOption(
                                      label: '产品有专利不可代替', value: '产品有专利不可代替'),
                                  SelectOption(label: '契约精神强', value: '契约精神强'),
                                ],
                                onChanged: (val) => field.didChange(val),
                              );
                            },
                          ),
                          FormBuilderField<String>(
                            name: "developed_at",
                            builder: (field) {
                              DateTime? date;
                              if (field.value != null &&
                                  field.value!.isNotEmpty) {
                                date = DateTime.tryParse(field.value!);
                              }

                              String? formattedDate;
                              if (date != null) {
                                formattedDate =
                                    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                              }
                              return DatePickerInput(
                                label: '开发日期',
                                value: formattedDate,
                                onChanged: field.didChange,
                              );
                            },
                          )
                        ])
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
