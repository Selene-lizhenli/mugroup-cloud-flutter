import 'dart:convert';
import 'dart:math';
import 'package:cloud/constants/form_definitions.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/field_config.dart';
import 'package:cloud/models/media.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/quote/quote_product_add/providers/quote_product_add_form_provider.dart';
import 'package:cloud/pages/quote/quote_product_add/widgets/sku_setting_dialog.dart';
import 'package:cloud/pages/widgets/build_form_card.dart';
import 'package:cloud/pages/widgets/confirm_dialog.dart';
import 'package:cloud/pages/widgets/field_selector.dart';
import 'package:cloud/pages/widgets/image_uploader.dart';
import 'package:cloud/pages/widgets/input.dart';
import 'package:cloud/pages/widgets/spacing_row.dart';
import 'package:cloud/pages/widgets/text_area.dart';
import 'package:cloud/pages/widgets/translate_input.dart';
import 'package:cloud/providers/field_config_provider.dart';
import 'package:cloud/services/openai.dart';
import 'package:cloud/services/sample.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:async';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuoteProductAddLandscapeView extends HookConsumerWidget {
  final int? quoteId;
  final int? companyId;
  final bool isActive;
  final Map<String, dynamic>? initialSupplier;
  final String translationLanguage; // 翻译目标语言（小写，如 'en', 'ja', 'es' 等）

  const QuoteProductAddLandscapeView({
    super.key,
    this.quoteId,
    this.companyId,
    this.initialSupplier,
    required this.isActive,
    this.translationLanguage = 'en', // 默认英语
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    final configParams = useMemoized(() => FieldConfigParams(
          storageKey: 'quote_product_add_form_v1',
          defaultFields: quoteSampleDefaultFields,
        ));
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    final fieldConfigs = ref.watch(fieldConfigProvider(configParams));
    final notifier = ref.read(fieldConfigProvider(configParams).notifier);

    final autoValidateMode = useState(AutovalidateMode.disabled);

    const basicInfoFieldNames = {
      'product_no',
      'product_brand',
      'supplier_sku',
      'customer_sku',
      'supplier_price',
      'deliver_day',
      'supplier_moq',
      'customer_price',
      'customer_qty',
      'unit',
      'name_cn',
      'name_en'
    };

    const specFieldNames = {
      'material',
      'inner_capacity',
      'weight',
      'packing',
      'outer_capacity',
      'outer_volume',
      'spec'
    };

    double getFieldWeight(String name) {
      const largeFields = {'spec', 'name_cn', 'name_en'};

      if (largeFields.contains(name)) return 3;

      const mediumFields = {
        'product_no',
        'product_brand',
        'supplier_sku',
        'customer_sku',
      };
      if (mediumFields.contains(name)) return 1.5;

      return 1.0;
    }

    Widget buildFieldItem(String fieldName) {
      switch (fieldName) {
        case 'product_no':
          return FormBuilderField<String>(
            name: "product_no",
            builder: (field) => Input(
              label: '产品货号',
              value: field.value ?? '',
              onChanged: field.didChange,
            ),
          );
        case 'product_brand':
          return FormBuilderField<String>(
            name: "product_brand",
            builder: (field) => Input(
              label: '品牌',
              value: field.value ?? '',
              onChanged: field.didChange,
            ),
          );
        case 'supplier_sku':
          return FormBuilderField<String>(
            name: "supplier_sku",
            builder: (field) => Input(
              label: '供应商货号',
              value: field.value ?? '',
              onChanged: field.didChange,
            ),
          );
        case 'customer_sku':
          return FormBuilderField<String>(
            name: "customer_sku",
            builder: (field) => Input(
              label: '客户货号',
              value: field.value ?? '',
              onChanged: field.didChange,
            ),
          );

        case 'supplier_price':
          return FormBuilderField<String>(
            name: "supplier_price",
            validator: (value) =>
                (value == null || value.isEmpty) ? '该项不能为空' : null,
            builder: (field) => Input(
              label: '供应商报价(￥)',
              keyboardType: TextInputType.number,
              isRequired: true,
              value: field.value ?? '',
              onChanged: field.didChange,
              errorText: field.errorText,
            ),
          );
        case 'deliver_day':
          return FormBuilderField<String>(
            name: "deliver_day",
            builder: (field) => Input(
              label: '发货天数',
              keyboardType: TextInputType.number,
              value: field.value ?? '',
              onChanged: field.didChange,
            ),
          );
        case 'supplier_moq':
          return FormBuilderField<String>(
            name: "supplier_moq",
            builder: (field) => Input(
              label: '供应商MOQ',
              keyboardType: TextInputType.number,
              value: field.value ?? '',
              onChanged: field.didChange,
            ),
          );
        case 'customer_price':
          return FormBuilderField<String>(
            name: "customer_price",
            builder: (field) => Input(
              label: '客户报价',
              keyboardType: TextInputType.number,
              value: field.value ?? '',
              onChanged: field.didChange,
            ),
          );
        case 'customer_qty':
          return FormBuilderField<String>(
            name: "customer_qty",
            builder: (field) => Input(
              label: '客户采购数量',
              keyboardType: TextInputType.number,
              value: field.value ?? '',
              onChanged: field.didChange,
            ),
          );
        case 'unit':
          return FormBuilderField<String>(
            name: "unit",
            builder: (field) => Input(
              label: '单位',
              value: field.value ?? '',
              onChanged: field.didChange,
            ),
          );

        case 'name_cn':
          return FormBuilderField<String>(
            name: "name_cn",
            builder: (field) => TranslatableInput(
              label: '中文名称',
              toLanguage: translationLanguage,
              sourceText: formKey.currentState?.fields['name_cn']?.value,
              value: field.value ?? '',
              onChanged: field.didChange,
              onTranslateChanged: (value) {
                formKey.currentState?.fields['name_en']?.didChange(value);
              },
            ),
          );
        case 'name_en':
          return FormBuilderField<String>(
            name: "name_en",
            builder: (field) => Input(
              label: '英文名称',
              value: field.value ?? '',
              onChanged: field.didChange,
            ),
          );

        case 'material':
          return FormBuilderField<String>(
            name: "material",
            builder: (field) => Input(
              label: '材质',
              value: field.value ?? '',
              onChanged: field.didChange,
            ),
          );
        case 'inner_capacity':
          return FormBuilderField<String>(
            name: "inner_capacity",
            builder: (field) => Input(
              label: '内箱数量',
              keyboardType: TextInputType.number,
              value: field.value ?? '',
              onChanged: field.didChange,
            ),
          );
        case 'weight':
          return FormBuilderField<String>(
            name: "weight",
            builder: (field) => Input(
              label: '重量',
              keyboardType: TextInputType.number,
              value: field.value ?? '',
              onChanged: field.didChange,
            ),
          );
        case 'packing':
          return FormBuilderField<String>(
            name: "packing",
            builder: (field) => Input(
              label: '包装方式',
              value: field.value ?? '',
              onChanged: field.didChange,
            ),
          );
        case 'outer_capacity':
          return FormBuilderField<String>(
            name: "outer_capacity",
            builder: (field) => Input(
              label: '外箱数量',
              keyboardType: TextInputType.number,
              value: field.value ?? '',
              onChanged: field.didChange,
            ),
          );
        case 'outer_volume':
          return FormBuilderField<String>(
            name: "outer_volume",
            builder: (field) => Input(
              label: '体积',
              keyboardType: TextInputType.number,
              value: field.value ?? '',
              onChanged: field.didChange,
            ),
          );

        case 'spec':
          return Row(
            children: [
              Expanded(
                child: FormBuilderField<String>(
                  name: "length",
                  builder: (field) => Input(
                    label: '长',
                    value: field.value ?? '',
                    onChanged: field.didChange,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))
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
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))
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
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))
                    ],
                  ),
                ),
              ),
            ],
          );

        default:
          return const SizedBox.shrink();
      }
    }

    List<Widget> buildFlowSection(Set<String> scopeNames) {
      final sortedConfigs = fieldConfigs.where((config) {
        if (config.name == 'spec' && scopeNames.contains('size')) {
          return config.isVisible;
        }
        return scopeNames.contains(config.name) && config.isVisible;
      }).toList();

      List<Widget> rows = [];
      List<Widget> buffer = [];
      double currentLineWeight = 0.0;

      void flushBuffer() {
        if (buffer.isEmpty) return;

        List<Widget> rowChildren = [];
        for (int i = 0; i < buffer.length; i++) {
          rowChildren.add(Expanded(child: buffer[i]));
        }

        if (currentLineWeight < 2.0 && buffer.length < 2) {
          rowChildren.add(const Spacer());
          if (currentLineWeight < 1.1) rowChildren.add(const Spacer());
        }

        rows.add(SpacingRow(spacing: 12, children: rowChildren));
        buffer.clear();
        currentLineWeight = 0.0;
      }

      for (var config in sortedConfigs) {
        String logicName =
            (config.name == 'size' && scopeNames.contains('spec'))
                ? 'spec'
                : config.name;

        double weight = getFieldWeight(logicName);

        if (currentLineWeight + weight > 3.1) {
          flushBuffer();
        }

        if (weight >= 3.0 && buffer.isNotEmpty) {
          flushBuffer();
        }

        if (weight >= 3.0) {
          rows.add(buildFieldItem(logicName));
          rows.add(const SizedBox(height: 12));
        } else {
          buffer.add(buildFieldItem(logicName));
          currentLineWeight += weight;
        }
      }
      flushBuffer();
      return rows;
    }

    final formData = ref.watch(quoteProductAddFormProvider);
    final formDataNotifier = ref.read(quoteProductAddFormProvider.notifier);

    ref.listen(quoteProductAddFormProvider, (previous, next) {
      if (!isActive && next.isNotEmpty) {
        if (formKey.currentState != null) {
          logger.d('屏幕切走22$isActive');
          formKey.currentState?.patchValue(next);
        }
      }
    });

    useEffect(() {
      if (isActive) {
        if (formData.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (formKey.currentState != null) {
              logger.d('横屏激活：加载数据 $formData');
              formKey.currentState?.patchValue(formData);
            }
          });
        }
      }
      return null;
    }, [isActive]);

    bool isVisible(String name) {
      return fieldConfigs
          .firstWhere(
            (e) => e.name == name,
            orElse: () => FieldConfig(label: '', name: name, isVisible: true),
          )
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

        if (initialSupplier == null) {
          EasyLoading.showInfo('没有供应商');
          return;
        }
        final supplier = initialSupplier!;

        submitValues['supply_quotes'] = [
          {
            "supplier_id": supplier['id'],
            'supplier': supplier,
            "product_no": submitValues["product_no"],
            'product_brand': submitValues["product_brand"],
            'supplier_sku': submitValues["supplier_sku"],
            "customer_sku": submitValues["customer_sku"],
            'supplier_price': submitValues["supplier_price"],
            "deliver_day": submitValues["deliver_day"],
            "supplier_moq": submitValues["supplier_moq"],
            "customer_price": submitValues["customer_price"],
            "customer_qty": submitValues["customer_qty"],
            "unit": submitValues["unit"],
            "material": submitValues["material"],
            "inner_capacity": submitValues["inner_capacity"],
            "weight": submitValues["weight"],
            "packing": submitValues["packing"],
            "outer_capacity": submitValues["outer_capacity"],
            "outer_volume": submitValues["outer_volume"],
          }
        ];
        final length = submitValues['length']?.toString() ?? '';
        final width = submitValues['width']?.toString() ?? '';
        final height = submitValues['heigth']?.toString() ?? '';

        final spec = [length, width, height].join('x');
        submitValues['spec'] = spec;

        try {
          await EasyLoading.show(status: '提交中...');
          await storeShowroomSample({
            ...submitValues,
            "supplier_id": supplier['id'],
            if (quoteId != null) "quotation_id": quoteId,
            'item_type': 'market_product'
          });
          EasyLoading.dismiss();

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(
              'last_quote_product_add', jsonEncode(submitValues));

          if (!context.mounted) return;

          formDataNotifier.clearFormData();

          final isContinue = await ConfirmDialog.show(
            context,
            title: '创建成功',
            content: '创建成功，是否继续添加？',
            cancelText: '不，直接返回',
            confirmText: '继续添加',
            confirmColor: colorScheme.primary,
          );
          if (isContinue == true) {
            final currentSupplier = formState.value['supplier'];
            formState.reset();
            formDataNotifier.clearFormData();

            if (currentSupplier != null) {
              formKey.currentState?.patchValue({
                'supplier': currentSupplier,
              });
            }
          } else {
            if (context.mounted) Navigator.of(context).pop(true);
          }
        } catch (e) {
          EasyLoading.showError(e.toString());
        }
      } else {
        autoValidateMode.value = AutovalidateMode.onUserInteraction;
      }
    }

    Future<void> handleCopyLastItem() async {
      try {
        EasyLoading.show(status: '加载中...');
        final prefs = await SharedPreferences.getInstance();

        const storageKey = 'last_quote_product_add';
        final jsonStr = prefs.getString(storageKey);

        if (jsonStr != null) {
          final data = jsonDecode(jsonStr) as Map<String, dynamic>;

          data.remove('id');
          data.remove('product_no');
          data.remove('image');
          data.remove('images');

          if (data['spec'] != null && data['spec'].toString().isNotEmpty) {
            final parts = data['spec'].toString().split('x');
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

          // 3. 填充表单
          formKey.currentState?.patchValue(data);
          EasyLoading.showSuccess('已复制上一条数据');
        } else {
          EasyLoading.showInfo('暂无历史数据');
        }
      } catch (e) {
        EasyLoading.showError('加载失败');
      } finally {
        EasyLoading.dismiss();
      }
    }

    Future<void> autoFillSkuFromCache() async {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString('sku_settings_pref_v1');

      if (jsonStr == null) return;

      try {
        final data = jsonDecode(jsonStr);
        final bool isAutoFill = data['isAutoFill'] ?? false;

        if (!isAutoFill) return;

        final int type = data['generationType'] ?? 0;
        String generatedSku = '';

        if (type == 0) {
          final now = DateTime.now();
          final dateStr = DateFormat('yyMMdd').format(now);
          const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
          final rnd = Random();
          final randomStr = String.fromCharCodes(Iterable.generate(
              4, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
          generatedSku = "$dateStr$randomStr";
        } else if (type == 1) {
          return;
        } else if (type == 2) {
          final String prefix = data['customPrefix'] ?? '';
          final mockSerial = Random().nextInt(9999).toString().padLeft(4, '0');
          generatedSku = "$prefix$mockSerial";
        }

        if (generatedSku.isEmpty) return;

        final bool syncSupplier = data['syncSupplier'] ?? true;
        final bool syncCustomer = data['syncCustomer'] ?? true;

        final currentValues = formKey.currentState?.value ?? {};

        Map<String, dynamic> patchData = {};

        if ((currentValues['product_no']?.toString().isEmpty ?? true)) {
          patchData['product_no'] = generatedSku;
        }

        if (syncSupplier &&
            (currentValues['supplier_sku']?.toString().isEmpty ?? true)) {
          patchData['supplier_sku'] = generatedSku;
        }

        if (syncCustomer &&
            (currentValues['customer_sku']?.toString().isEmpty ?? true)) {
          patchData['customer_sku'] = generatedSku;
        }

        if (patchData.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            formKey.currentState?.patchValue(patchData);
          });
        }
      } catch (e) {
        debugPrint("自动填充SKU出错: $e");
      }
    }

    useEffect(() {
      autoFillSkuFromCache();
      return null;
    }, []);

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
        onChanged: () {
          if (isActive) {
            formKey.currentState?.save();
            final currentData = formKey.currentState?.value;
            if (currentData != null) {
              ref
                  .read(quoteProductAddFormProvider.notifier)
                  .updateForm(currentData);
            }
          }
        },
        initialValue: initialSupplier != null
            ? <String, dynamic>{
                'supplyQuote': initialSupplier,
              }
            : <String, dynamic>{},
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
                                onChanged: (images) async {
                                  if (images == null || images.isEmpty) return;

                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  final jsonStr =
                                      prefs.getString('sku_settings_pref_v1');
                                  if (jsonStr == null) return;

                                  final data = jsonDecode(jsonStr);
                                  final bool isAutoFill =
                                      data['isAutoFill'] ?? false;
                                  final int type = data['generationType'] ?? 0;

                                  if (isAutoFill && type == 1) {
                                    String filename = "";
                                    try {
                                      dynamic firstImg = images.first;

                                      if (firstImg is String) {
                                        filename = firstImg.split('/').last;
                                      } else if (firstImg is Map) {
                                        filename = firstImg['url'] ??
                                            firstImg['path'] ??
                                            '';
                                        filename = filename.split('/').last;
                                      } else if (firstImg.runtimeType
                                              .toString() ==
                                          'Media') {
                                        filename = (firstImg as dynamic)
                                                .url
                                                ?.split('/')
                                                .last ??
                                            '';
                                      } else {
                                        filename =
                                            firstImg.toString().split('/').last;
                                      }

                                      if (filename.contains('.')) {
                                        filename = filename.substring(
                                            0, filename.lastIndexOf('.'));
                                      }

                                      if (filename.length > 15) {
                                        filename = filename.substring(0, 15);
                                      }
                                      filename = filename.toUpperCase();
                                    } catch (e) {
                                      debugPrint("解析文件名失败: $e");
                                      return;
                                    }

                                    if (filename.isEmpty) return;

                                    final bool syncSupplier =
                                        data['syncSupplier'] ?? true;
                                    final bool syncCustomer =
                                        data['syncCustomer'] ?? true;

                                    Map<String, dynamic> patchData = {};

                                    patchData['product_no'] = filename;

                                    if (syncSupplier) {
                                      patchData['supplier_sku'] = filename;
                                    }
                                    if (syncCustomer) {
                                      patchData['customer_sku'] = filename;
                                    }

                                    formKey.currentState?.patchValue(patchData);
                                  }
                                },
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
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        clipBehavior: Clip.none,
                                        child: ImageUploader(
                                          customIcon: Icons.camera_alt,
                                          value: displayValue,
                                          onChanged: (value) {
                                            field.didChange(value);
                                          },
                                        ),
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
                          height: 56,
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
                                action: PopupMenuButton<String>(
                                  icon: Icon(Icons.more_horiz,
                                      color: colorScheme.primary),
                                  onSelected: (value) {
                                    if (value == 'copy') {
                                      handleCopyLastItem();
                                    } else if (value == 'setting') {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (ctx) => FieldSelector(
                                          fields: fieldConfigs,
                                          companyId: companyId,
                                          defaultFields:
                                              quoteSampleDefaultFields,
                                          onConfigChanged:
                                              notifier.updateConfigs,
                                          showActionButtons: true,
                                        ),
                                      );
                                    } else if (value == 'sku') {
                                      final currentImages = formKey
                                          .currentState?.fields['image']?.value;

                                      showDialog(
                                        context: context,
                                        builder: (context) => SkuSettingsDialog(
                                          currentImages: currentImages is List
                                              ? currentImages
                                              : [],
                                          onConfirm: (generatedSku,
                                              syncSupplier, syncCustomer) {
                                            if (generatedSku.isEmpty) {
                                              return;
                                            }

                                            Map<String, dynamic> patchData = {};

                                            patchData['product_no'] =
                                                generatedSku;

                                            // 3. 根据勾选同步更新
                                            if (syncSupplier) {
                                              patchData['supplier_sku'] =
                                                  generatedSku;
                                            }
                                            if (syncCustomer) {
                                              patchData['customer_sku'] =
                                                  generatedSku;
                                            }

                                            formKey.currentState
                                                ?.patchValue(patchData);

                                            EasyLoading.showSuccess(
                                                'SKU已生成并填充');
                                          },
                                        ),
                                      );
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    final colorScheme =
                                        Theme.of(context).colorScheme;
                                    final textStyle = TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: colorScheme.onSurface,
                                    );

                                    return <PopupMenuEntry<String>>[
                                      PopupMenuItem<String>(
                                        value: 'copy',
                                        height: 44,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: colorScheme.primary
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Icon(
                                                Icons.content_copy_rounded,
                                                size: 16,
                                                color: colorScheme.primary,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Text('复制上一条', style: textStyle),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'sku',
                                        height: 44,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: colorScheme.primary
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Icon(
                                                Icons.settings_rounded,
                                                size: 16,
                                                color: colorScheme.primary,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Text('SKU设置', style: textStyle),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuDivider(height: 1),
                                      PopupMenuItem<String>(
                                        value: 'setting',
                                        height: 44,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: colorScheme.secondary
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Icon(
                                                Icons.settings_rounded,
                                                size: 16,
                                                color: colorScheme.secondary,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Text('字段设置', style: textStyle),
                                          ],
                                        ),
                                      ),
                                    ];
                                  },
                                ),
                                children: [
                                  // FormBuilderField<Map<String, dynamic>>(
                                  //   name: 'supplier',
                                  //   builder: (field) {
                                  //     final supplier = field.value;
                                  //     return Row(
                                  //       children: [
                                  //         Expanded(
                                  //             child: GestureDetector(
                                  //           onTap: () async {
                                  //             final selectedSupplier =
                                  //                 await showModalBottomSheet<
                                  //                     Map<String, dynamic>>(
                                  //               context: context,
                                  //               isScrollControlled: true,
                                  //               backgroundColor:
                                  //                   Colors.transparent,
                                  //               builder: (_) =>
                                  //                   const SupplierSelect(),
                                  //             );

                                  //             if (selectedSupplier != null) {
                                  //               field.didChange(
                                  //                   selectedSupplier);
                                  //             }
                                  //           },
                                  //           child: AbsorbPointer(
                                  //             child: Input(
                                  //               label: '供应商',
                                  //               showClearButton: false,
                                  //               isRequired: true,
                                  //               value: supplier == null
                                  //                   ? ''
                                  //                   : (supplier['short_name'] ??
                                  //                       supplier['name'] ??
                                  //                       ''),
                                  //               hintText: '请选择供应商',
                                  //               errorText: field.errorText,
                                  //             ),
                                  //           ),
                                  //         )),
                                  //         const SizedBox(width: 8), // 间距
                                  //         Padding(
                                  //             padding: const EdgeInsets.only(
                                  //                 top: 28),
                                  //             child: InkWell(
                                  //               onTap: () {
                                  //                 final currentImages = formKey
                                  //                     .currentState
                                  //                     ?.fields['image']
                                  //                     ?.value;

                                  //                 showDialog(
                                  //                   context: context,
                                  //                   builder: (context) =>
                                  //                       SkuSettingsDialog(
                                  //                     currentImages:
                                  //                         currentImages is List
                                  //                             ? currentImages
                                  //                             : [],
                                  //                     onConfirm: (generatedSku,
                                  //                         syncSupplier,
                                  //                         syncCustomer) {
                                  //                       if (generatedSku
                                  //                           .isEmpty) {
                                  //                         return;
                                  //                       }

                                  //                       Map<String, dynamic>
                                  //                           patchData = {};

                                  //                       patchData[
                                  //                               'product_no'] =
                                  //                           generatedSku;

                                  //                       if (syncSupplier) {
                                  //                         patchData[
                                  //                                 'supplier_sku'] =
                                  //                             generatedSku;
                                  //                       }
                                  //                       if (syncCustomer) {
                                  //                         patchData[
                                  //                                 'customer_sku'] =
                                  //                             generatedSku;
                                  //                       }

                                  //                       formKey.currentState
                                  //                           ?.patchValue(
                                  //                               patchData);

                                  //                       EasyLoading.showSuccess(
                                  //                           'SKU已生成并填充');
                                  //                     },
                                  //                   ),
                                  //                 );
                                  //               },
                                  //               borderRadius:
                                  //                   BorderRadius.circular(4),
                                  //               child: Container(
                                  //                 padding: const EdgeInsets
                                  //                     .symmetric(
                                  //                     horizontal: 8,
                                  //                     vertical: 8),
                                  //                 decoration: BoxDecoration(
                                  //                   border: Border.all(
                                  //                       color: colorScheme
                                  //                           .primary),
                                  //                   borderRadius:
                                  //                       BorderRadius.circular(
                                  //                           4),
                                  //                   color: colorScheme.primary,
                                  //                 ),
                                  //                 child: const Text(
                                  //                   "SKU设置",
                                  //                   style: TextStyle(
                                  //                     fontSize: 12,
                                  //                     color: Colors.white,
                                  //                     fontWeight:
                                  //                         FontWeight.w500,
                                  //                   ),
                                  //                 ),
                                  //               ),
                                  //             ))
                                  //       ],
                                  //     );
                                  //   },
                                  // ),
                                  ...buildFlowSection(basicInfoFieldNames),
                                ],
                              ),
                              const SizedBox(height: 16),
                              BuildFormCard(
                                title: '产品规格',
                                children: [
                                  ...buildFlowSection(specFieldNames),
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
                                        toLanguage: translationLanguage,
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
                          height: 56,
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
