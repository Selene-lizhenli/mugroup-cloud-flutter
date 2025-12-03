import 'package:cloud/models/sample/media.dart';
import 'package:cloud/models/supply/supplier.dart';
import 'package:cloud/pages/widgets/check_box_input.dart';
import 'package:cloud/pages/widgets/date_picker_input.dart';
import 'package:cloud/pages/widgets/image_uploader.dart';
import 'package:cloud/pages/widgets/input.dart';
import 'package:cloud/pages/widgets/select.dart';
import 'package:cloud/pages/widgets/text_area.dart';
import 'package:flutter/material.dart';
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

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: FormBuilder(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FormBuilderField<List<TemporaryMedia>>(
                      name: "images",
                      builder: (field) {
                        return ImageUploader(
                          label: "名片",
                          value: field.value,
                          onChanged: field.didChange,
                        );
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: FormBuilderField<String>(
                            name: "supplier_no",
                            initialValue: initial?.supplierNo,
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
                            initialValue: initial?.usciCode,
                            builder: (field) {
                              return Input(
                                label: '税号代码',
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
                            name: "short_name",
                            initialValue: initial?.shortName,
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
                            initialValue: initial?.name,
                            builder: (field) {
                              return Input(
                                label: '厂商名称',
                                value: field.value ?? '',
                                onChanged: field.didChange,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        Expanded(child: Text('省份')),
                        SizedBox(width: 16),
                        Expanded(child: Text('城市')),
                      ],
                    ),
                    FormBuilderField<String>(
                      name: "address",
                      initialValue: initial?.address,
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
                      initialValue: initial?.businessScope,
                      builder: (field) {
                        return TextArea(
                          label: '营业范围',
                          value: field.value,
                          onChanged: field.didChange,
                        );
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: FormBuilderField<String>(
                            name: "bank_name",
                            initialValue: initial?.bankName,
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
                            initialValue: initial?.bankAccount,
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
                            initialValue: initial?.businessTitle,
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
                            initialValue: initial?.billType,
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
                    const Text("供应商分类"),
                    Row(
                      children: [
                        Expanded(
                          child: FormBuilderField<bool>(
                            name: "is_core",
                            initialValue: initial?.isCore ?? false,
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
                          child: FormBuilderField<bool>(
                            name: "is_corporate",
                            initialValue: initial?.isCorporate ?? false,
                            builder: (field) {
                              return CheckboxInput(
                                label: "是否已合作",
                                value: field.value ?? false,
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
                            name: "supplier_type",
                            initialValue: initial?.supplierType,
                            builder: (field) {
                              return Select(
                                label: '供应商类型',
                                value: field.value,
                                options: [
                                  SelectOption(label: '生产工厂', value: '1'),
                                  SelectOption(label: '工贸一体', value: '2'),
                                  SelectOption(label: '贸易商', value: '3'),
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
                            initialValue: initial?.exportMarket,
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
                            initialValue: initial?.corpCustomer,
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
                            initialValue: initial?.corpCompany,
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
                            initialValue: initial?.corpSkuid,
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
                            initialValue: initial?.showroomArea,
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
                            initialValue: initial?.marketRate,
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
                            initialValue: initial?.landType,
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
                            initialValue: initial?.factoryArea,
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
                            initialValue: initial?.employeeCount,
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
                    Row(
                      children: [
                        Expanded(
                          child: FormBuilderField<String>(
                            name: "annual",
                            initialValue: initial?.annual,
                            builder: (field) {
                              return Input(
                                label: '年产值',
                                value: field.value ?? '',
                                onChanged: field.didChange,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: FormBuilderField<String>(
                            name: "advantages",
                            initialValue: initial?.advantages,
                            builder: (field) {
                              return Input(
                                label: '工厂优势',
                                value: field.value ?? '',
                                onChanged: field.didChange,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    FormBuilderField<String>(
                      name: "developed_at",
                      initialValue: initial?.developedAt,
                      builder: (field) {
                        return DatePickerInput(
                          label: '开发日期',
                          value: field.value,
                          onChanged: field.didChange,
                        );
                      },
                    )
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
