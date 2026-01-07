import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:cloud/constants/form_definitions.dart';
import 'package:cloud/models/field_config.dart';
import 'package:cloud/models/media.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/widgets/build_form_card.dart';
import 'package:cloud/pages/widgets/confirm_dialog.dart';
import 'package:cloud/pages/widgets/field_selector.dart';
import 'package:cloud/pages/widgets/image_uploader.dart';
import 'package:cloud/pages/widgets/input.dart';
import 'package:cloud/pages/widgets/spacing_row.dart';
import 'package:cloud/pages/widgets/supplier_select.dart';
import 'package:cloud/pages/widgets/text_area.dart';
import 'package:cloud/pages/widgets/translate_input.dart';
import 'package:cloud/providers/field_config_provider.dart';
import 'package:cloud/services/openai.dart';
import 'package:cloud/services/sample.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

@RoutePage()
class QuoteProductPadAddPage extends HookConsumerWidget {
  final int? quoteId;
  const QuoteProductPadAddPage({super.key, this.quoteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());

    final configParams = useMemoized(() => FieldConfigParams(
          storageKey: 'quote_product_add_form_v1',
          defaultFields: quoteSampleDefaultFields,
        ));

    final fieldConfigs = ref.watch(fieldConfigProvider(configParams));
    final notifier = ref.read(fieldConfigProvider(configParams).notifier);

    bool isVisible(String name) {
      return fieldConfigs
          .firstWhere((e) => e.name == name,
              orElse: () => FieldConfig(label: '', name: name, isVisible: true))
          .isVisible;
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

    Future<void> handleSubmit() async {
      final formState = formKey.currentState;
      if (formState?.saveAndValidate() ?? false) {
        final Map<String, dynamic> submitValues = Map.from(formState!.value);

        final supplier = submitValues['supplyQuote'];
        final length = submitValues['length']?.toString() ?? '';
        final width = submitValues['width']?.toString() ?? '';
        final height = submitValues['heigth']?.toString() ?? '';

        final spec = [length, width, height].join('x');
        submitValues['spec'] = spec;

        try {
          await EasyLoading.show(status: '提交中...');
          await storeShowroomSample({
            ...submitValues,
            "supplier_id": supplier?['id'],
            "quotation_id": quoteId,
            'item_type': 'market_product'
          });
          EasyLoading.dismiss();

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(
              'last_quote_product_add', jsonEncode(submitValues));

          if (!context.mounted) return;

          final isContinue = await ConfirmDialog.show(
            context,
            title: '创建成功',
            content: '样品已成功创建，您希望接下来做什么？',
            cancelText: '完成并返回',
            confirmText: '继续创建',
            confirmColor: Colors.blue,
          );
          if (isContinue == true) {
            formState.reset();
          } else {
            if (context.mounted) Navigator.of(context).pop(true);
          }
        } catch (e) {
          EasyLoading.showError(e.toString());
        }
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F5),
      appBar: AppBar(
        title: const Text('添加报价产品'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: FormBuilder(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                                thumbUrl: e.thumbUrl);
                                          } else if (e is TemporaryMedia) {
                                            return e;
                                          }
                                          return null;
                                        })
                                        .whereType<TemporaryMedia>()
                                        .toList();
                                  }

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "上传图片",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 12),
                                      ImageUploader(
                                        value: displayValue,
                                        onChanged: field.didChange,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          border:
                              Border(top: BorderSide(color: Color(0xFFEEEEEE))),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 56, // 统一高度
                          child: ElevatedButton.icon(
                            onPressed: handleSmartRecognize,
                            icon: const Icon(Icons.center_focus_weak, size: 22),
                            label: const Text("智能识别 (AI)",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3B66F5),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 6,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(4),
                          child: Column(
                            children: [
                              BuildFormCard(
                                title: '基本信息',
                                action: Wrap(
                                  children: [
                                    TextButton.icon(
                                      onPressed: () {},
                                      icon: Icon(Icons.content_copy,
                                          size: 16, color: colorScheme.primary),
                                      label: Text("复制上一条",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: colorScheme.primary)),
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton.icon(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (ctx) => FieldSelector(
                                            fields: fieldConfigs,
                                            defaultFields: sampleDefaultFields,
                                            onConfigChanged:
                                                notifier.updateConfigs,
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.settings,
                                          size: 16, color: colorScheme.primary),
                                      label: Text("字段设置",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: colorScheme.primary)),
                                    ),
                                  ],
                                ),
                                children: [
                                  // 供应商
                                  FormBuilderField<Map<String, dynamic>>(
                                    name: 'supplyQuote',
                                    builder: (field) {
                                      final supplier = field.value;
                                      return GestureDetector(
                                        onTap: () async {
                                          final selected =
                                              await showModalBottomSheet<
                                                  Map<String, dynamic>>(
                                            context: context,
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            builder: (_) =>
                                                const SupplierSelect(),
                                          );
                                          if (selected != null)
                                            field.didChange(selected);
                                        },
                                        child: AbsorbPointer(
                                          child: Input(
                                            label: '供应商',
                                            showClearButton: false,
                                            value: supplier == null
                                                ? ''
                                                : (supplier['short_name'] ??
                                                    supplier['name'] ??
                                                    ''),
                                            hintText: '请选择供应商',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  // 货号与品牌
                                  SpacingRow(
                                    spacing: 12,
                                    children: [
                                      if (isVisible('product_no'))
                                        Expanded(
                                          child: FormBuilderField<String>(
                                            name: "product_no",
                                            builder: (field) => Input(
                                              label: '产品货号',
                                              value: field.value ?? '',
                                              onChanged: field.didChange,
                                            ),
                                          ),
                                        ),
                                      if (isVisible('product_brand'))
                                        Expanded(
                                          child: FormBuilderField<String>(
                                            name: "product_brand",
                                            builder: (field) => Input(
                                              label: '品牌',
                                              value: field.value ?? '',
                                              onChanged: field.didChange,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  // SKU
                                  SpacingRow(
                                    spacing: 12,
                                    children: [
                                      if (isVisible('supplier_sku'))
                                        Expanded(
                                          child: FormBuilderField<String>(
                                            name: "supplier_sku",
                                            builder: (field) => Input(
                                              label: '供应商货号',
                                              value: field.value ?? '',
                                              onChanged: field.didChange,
                                            ),
                                          ),
                                        ),
                                      if (isVisible('customer_sku'))
                                        Expanded(
                                          child: FormBuilderField<String>(
                                            name: "customer_sku",
                                            builder: (field) => Input(
                                              label: '客户货号',
                                              value: field.value ?? '',
                                              onChanged: field.didChange,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  // 供应商数据
                                  SpacingRow(
                                    spacing: 12,
                                    children: [
                                      if (isVisible('supplier_price'))
                                        Expanded(
                                          child: FormBuilderField<String>(
                                            name: "supplier_price",
                                            builder: (field) => Input(
                                              label: '供应商报价',
                                              value: field.value ?? '',
                                              onChanged: field.didChange,
                                            ),
                                          ),
                                        ),
                                      if (isVisible('deliver_day'))
                                        Expanded(
                                          child: FormBuilderField<String>(
                                            name: "deliver_day",
                                            builder: (field) => Input(
                                              label: '发货天数',
                                              value: field.value ?? '',
                                              onChanged: field.didChange,
                                            ),
                                          ),
                                        ),
                                      if (isVisible('supplier_moq'))
                                        Expanded(
                                          child: FormBuilderField<String>(
                                            name: "supplier_moq",
                                            builder: (field) => Input(
                                              label: '供应商MOQ',
                                              value: field.value ?? '',
                                              onChanged: field.didChange,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  // 客户数据
                                  SpacingRow(
                                    spacing: 12,
                                    children: [
                                      if (isVisible('customer_price'))
                                        Expanded(
                                          child: FormBuilderField<String>(
                                            name: "customer_price",
                                            builder: (field) => Input(
                                              label: '客户报价',
                                              value: field.value ?? '',
                                              onChanged: field.didChange,
                                            ),
                                          ),
                                        ),
                                      if (isVisible('customer_qty'))
                                        Expanded(
                                          child: FormBuilderField<String>(
                                            name: "customer_qty",
                                            builder: (field) => Input(
                                              label: '客户采购数量',
                                              value: field.value ?? '',
                                              onChanged: field.didChange,
                                            ),
                                          ),
                                        ),
                                      if (isVisible('product_unit'))
                                        Expanded(
                                          child: FormBuilderField<String>(
                                            name: "product_unit",
                                            builder: (field) => Input(
                                              label: '单位',
                                              value: field.value ?? '',
                                              onChanged: field.didChange,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  // 名称翻译
                                  if (isVisible('product_name_cn'))
                                    FormBuilderField<String>(
                                      name: "product_name_cn",
                                      builder: (field) => TranslatableInput(
                                        label: '中文名称',
                                        sourceText: formKey.currentState
                                            ?.fields['product_name_cn']?.value,
                                        value: field.value ?? '',
                                        onChanged: field.didChange,
                                        onTranslateChanged: (value) {
                                          formKey.currentState
                                              ?.fields['product_name_en']
                                              ?.didChange(value);
                                        },
                                      ),
                                    ),
                                  if (isVisible('product_name_en'))
                                    FormBuilderField<String>(
                                      name: "product_name_en",
                                      builder: (field) => Input(
                                        label: '英文名称',
                                        value: field.value ?? '',
                                        onChanged: field.didChange,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              BuildFormCard(
                                title: '产品规格',
                                children: [
                                  SpacingRow(spacing: 12, children: [
                                    if (isVisible('material'))
                                      Expanded(
                                        child: FormBuilderField<String>(
                                          name: "material",
                                          builder: (field) => Input(
                                            label: '材质',
                                            value: field.value ?? '',
                                            onChanged: field.didChange,
                                          ),
                                        ),
                                      ),
                                    if (isVisible('inner_qty'))
                                      Expanded(
                                        child: FormBuilderField<String>(
                                          name: "inner_qty",
                                          builder: (field) => Input(
                                            label: '内箱数量',
                                            value: field.value ?? '',
                                            onChanged: field.didChange,
                                          ),
                                        ),
                                      ),
                                    if (isVisible('weight'))
                                      Expanded(
                                        child: FormBuilderField<String>(
                                          name: "weight",
                                          builder: (field) => Input(
                                            label: '重量',
                                            value: field.value ?? '',
                                            onChanged: field.didChange,
                                          ),
                                        ),
                                      ),
                                  ]),
                                  SpacingRow(
                                    spacing: 12,
                                    children: [
                                      if (isVisible('packing'))
                                        Expanded(
                                          child: FormBuilderField<String>(
                                            name: "packing",
                                            builder: (field) => Input(
                                              label: '包装方式',
                                              value: field.value ?? '',
                                              onChanged: field.didChange,
                                            ),
                                          ),
                                        ),
                                      if (isVisible('outer_qty'))
                                        Expanded(
                                          child: FormBuilderField<String>(
                                            name: "outer_qty",
                                            builder: (field) => Input(
                                              label: '外箱数量',
                                              value: field.value ?? '',
                                              onChanged: field.didChange,
                                            ),
                                          ),
                                        ),
                                      if (isVisible('volume'))
                                        Expanded(
                                          child: FormBuilderField<String>(
                                            name: "volume",
                                            builder: (field) => Input(
                                              label: '体积',
                                              value: field.value ?? '',
                                              onChanged: field.didChange,
                                            ),
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
                                            builder: (field) => Input(
                                              label: '长',
                                              value: field.value ?? '',
                                              onChanged: field.didChange,
                                              keyboardType: const TextInputType
                                                  .numberWithOptions(
                                                  decimal: true),
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(
                                                        RegExp(r'^\d+\.?\d*')),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: FormBuilderField<String>(
                                            name: "width",
                                            builder: (field) => Input(
                                              label: '宽',
                                              value: field.value ?? '',
                                              onChanged: field.didChange,
                                              keyboardType: const TextInputType
                                                  .numberWithOptions(
                                                  decimal: true),
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(
                                                        RegExp(r'^\d+\.?\d*')),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: FormBuilderField<String>(
                                            name: "heigth",
                                            builder: (field) => Input(
                                              label: '高',
                                              value: field.value ?? '',
                                              onChanged: field.didChange,
                                              keyboardType: const TextInputType
                                                  .numberWithOptions(
                                                  decimal: true),
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(
                                                        RegExp(r'^\d+\.?\d*')),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              BuildFormCard(
                                title: '描述',
                                isLast: true,
                                children: [
                                  if (isVisible('description_cn'))
                                    FormBuilderField<String>(
                                      name: "description_cn",
                                      builder: (field) => TextArea(
                                        label: '中文描述',
                                        showTranslate: true,
                                        sourceText: formKey.currentState
                                            ?.fields['description_cn']?.value,
                                        value: field.value,
                                        onChanged: field.didChange,
                                        onTranslateChanged: (value) {
                                          formKey.currentState
                                              ?.fields['description_en']
                                              ?.didChange(value);
                                        },
                                      ),
                                    ),
                                  if (isVisible('description_en'))
                                    FormBuilderField<String>(
                                      name: "description_en",
                                      builder: (field) => TextArea(
                                        label: '英文描述',
                                        value: field.value,
                                        onChanged: field.didChange,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          border:
                              Border(top: BorderSide(color: Color(0xFFEEEEEE))),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 56, // 统一高度
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF53F85),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: handleSubmit,
                            child: const Text(
                              '提交',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
