import 'package:cloud/models/sample/media.dart';
import 'package:cloud/models/supply/supplier.dart';
import 'package:cloud/pages/widgets/check_box_input.dart';
import 'package:cloud/pages/widgets/date_picker_input.dart';
import 'package:cloud/pages/widgets/image_uploader.dart';
import 'package:cloud/pages/widgets/input.dart';
import 'package:cloud/pages/widgets/select.dart';
import 'package:cloud/pages/widgets/text_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SupplySupplierForm extends HookConsumerWidget {
  final Supplier? initial;
  final Future<void> Function(Map<String, dynamic>) onSubmit;

  const SupplySupplierForm(
      {super.key, required this.initial, required this.onSubmit});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());

    final name = useState(initial?.name ?? '');
    final shortName = useState(initial?.shortName ?? '');
    final supplierNo = useState(initial?.supplierNo ?? '');
    final usciCode = useState(initial?.usciCode ?? '');
    final businessScope = useState(initial?.businessScope ?? '');
    final bankName = useState(initial?.bankName ?? '');
    final bankAccount = useState(initial?.bankAccount ?? '');
    final businessTitle = useState(initial?.businessTitle ?? "");
    final billType = useState(initial?.billType ?? "");
    final typeId = useState(initial?.typeId ?? "");
    final isCore = useState(initial?.isCore ?? false);
    final isCorporate = useState(initial?.isCorporate ?? false);
    final supplierType = useState(initial?.supplierType ?? "");
    final exportMarket = useState(initial?.exportMarket ?? '');
    final corpCustomer = useState(initial?.corpCustomer ?? '');
    final corpCompany = useState(initial?.corpCompany ?? "");
    final corpSkuid = useState(initial?.corpSkuid ?? "");
    final showroomArea = useState(initial?.showroomArea ?? '');
    final marketRate = useState(initial?.marketRate ?? '');
    final landType = useState(initial?.landType ?? '');
    final factoryArea = useState(initial?.factoryArea ?? "");
    final employeeCount = useState(initial?.employeeCount ?? '');
    final annual = useState(initial?.annual ?? '');
    final advantages = useState(initial?.advantages ?? "");
    final developedAt = useState(initial?.developedAt ?? '');
    final images = useState<List<TemporaryMedia>?>(null);

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
                    ImageUploader(
                      name: 'images',
                      label: '名片',
                      value: images.value,
                      onChanged: (value) {
                        images.value = value;
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Input(
                            label: '厂商编号',
                            value: supplierNo.value,
                            onChanged: (v) => supplierNo.value = v,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Input(
                            label: '税号代码',
                            value: usciCode.value,
                            onChanged: (v) => usciCode.value = v,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Input(
                            label: '厂商简称',
                            value: shortName.value,
                            onChanged: (v) => shortName.value = v,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Input(
                            label: '厂商名称',
                            value: name.value,
                            onChanged: (v) => name.value = v,
                          ),
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        Expanded(
                          child: Text('省份'),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Text('城市'),
                        ),
                      ],
                    ),
                    Input(
                      label: '厂商地址',
                      value: supplierNo.value,
                      onChanged: (v) => supplierNo.value = v,
                    ),
                    TextArea(
                      name: 'business_scope',
                      label: '营业范围',
                      value: businessScope.value,
                      onChanged: (value) {
                        businessScope.value = value ?? "";
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Input(
                            label: '开户银行',
                            value: bankName.value,
                            onChanged: (v) => bankName.value = v,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Input(
                            label: '银行账号',
                            value: bankAccount.value,
                            onChanged: (v) => bankAccount.value = v,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Input(
                            label: '收款单位',
                            value: businessTitle.value,
                            onChanged: (v) => businessTitle.value = v,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Select(
                            label: '发票类型',
                            value: billType.value,
                            options: [
                              SelectOption(label: '1', value: '1'),
                              SelectOption(label: '3', value: '3'),
                              SelectOption(label: '9', value: '9'),
                              SelectOption(label: '13', value: '13'),
                              SelectOption(label: '不开票', value: 'none'),
                            ],
                            onChanged: (value) {
                              billType.value = value ?? '';
                            },
                          ),
                        ),
                      ],
                    ),
                    const Text('供应商分类'),
                    Row(
                      children: [
                        Expanded(
                          child: CheckboxInput(
                              label: '是否核心',
                              value: isCore.value,
                              onChanged: (value) {
                                isCore.value = value;
                              }),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                            child: CheckboxInput(
                                label: '是否已合作',
                                value: isCorporate.value,
                                onChanged: (value) {
                                  isCorporate.value = value;
                                })),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Select(
                            label: '供应商类型',
                            value: supplierType.value,
                            options: [
                              SelectOption(label: '生产工厂', value: '1'),
                              SelectOption(label: '工贸一体', value: '2'),
                              SelectOption(label: '贸易商', value: '3'),
                            ],
                            onChanged: (value) {
                              supplierType.value = value ?? '';
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Input(
                            label: '主销市场',
                            value: exportMarket.value,
                            onChanged: (v) => exportMarket.value = v,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Input(
                            label: '合作客户',
                            value: corpCustomer.value,
                            onChanged: (v) => corpCustomer.value = v,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Input(
                            label: '合作公司',
                            value: corpCompany.value,
                            onChanged: (v) => corpCompany.value = v,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Input(
                            label: '合作货号',
                            value: corpSkuid.value,
                            onChanged: (v) => corpSkuid.value = v,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Input(
                            label: '样品间面积',
                            value: showroomArea.value,
                            onChanged: (v) => showroomArea.value = v,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Input(
                            label: '市场占比',
                            value: marketRate.value,
                            onChanged: (v) => marketRate.value = v,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Input(
                            label: '土地厂房性质',
                            value: landType.value,
                            onChanged: (v) => landType.value = v,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Input(
                            label: '工厂面积',
                            value: factoryArea.value,
                            onChanged: (v) => factoryArea.value = v,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Input(
                            label: '员工人数',
                            value: employeeCount.value,
                            onChanged: (v) => employeeCount.value = v,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Input(
                            label: '年产值',
                            value: annual.value,
                            onChanged: (v) => annual.value = v,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Input(
                            label: '工厂优势',
                            value: advantages.value,
                            onChanged: (v) => advantages.value = v,
                          ),
                        ),
                      ],
                    ),
                    DatePickerInput(
                      name: 'developed_at',
                      label: '开发日期',
                      value: developedAt.value,
                      onChanged: (date) {
                        developedAt.value = date ?? '';
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
                  final values = formState?.value;
                  debugPrint('提交表单: $values');
                  //TODO

                  EasyLoading.showSuccess('创建供应商成功!');
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
        ),
      ],
    );
  }
}
