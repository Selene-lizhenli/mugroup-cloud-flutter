import 'dart:convert';
import 'dart:math';
import 'package:auto_route/auto_route.dart';
import 'package:cloud/constants/form_definitions.dart';
import 'package:cloud/models/field_config.dart';
import 'package:cloud/models/media.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/quote/quote_product_add/widgets/sku_setting_dialog.dart';
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
import 'package:cloud/providers/quote_product_form_provider.dart';
import 'package:cloud/router/router.gr.dart';
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

class QuoteProductAddPortraitView extends HookConsumerWidget {
  final int? quoteId;
  final bool isActive;

  const QuoteProductAddPortraitView({
    super.key,
    this.quoteId,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    final formDataNotifier = ref.read(quoteProductFormDataProvider.notifier);
    final savedFormData = ref.watch(quoteProductFormDataProvider);

    final configParams = useMemoized(() => FieldConfigParams(
          storageKey: 'quote_product_add_form_v1',
          defaultFields: quoteSampleDefaultFields,
        ));

    final fieldConfigs = ref.watch(fieldConfigProvider(configParams));
    final notifier = ref.read(fieldConfigProvider(configParams).notifier);

    final autoValidateMode = useState(AutovalidateMode.disabled);

    // 从 provider 同步表单数据：仅在非激活状态时接收更新，避免覆盖正在编辑的数据
    useEffect(() {
      if (!isActive && savedFormData != null && formKey.currentState != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          formKey.currentState?.patchValue(savedFormData);
        });
      }
      return null;
    }, [savedFormData, isActive]);

    // 使用定时器定期保存表单数据到 provider，仅在当前激活时运行
    useEffect(() {
      if (!isActive) return null;
      final timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
        if (formKey.currentState != null) {
          formKey.currentState!.save();
          final currentValue = formKey.currentState!.value;
          if (currentValue.isNotEmpty) {
            formDataNotifier.saveFormData(currentValue);
          }
        }
      });
      return timer.cancel;
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
      appBar: AppBar(
        title: const Text('添加报价产品'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        actions: [
          TextButton(
            onPressed: () async {
              context.router.push(QuoteProductAddAdaptiveRoute(
                quoteId: quoteId,
                initialMode: 1,
              ));
            },
            child: Text(
              "平板模式",
              style: TextStyle(
                color: colorScheme.primary,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                child: FormBuilder(
                  key: formKey,
                  autovalidateMode: autoValidateMode.value,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      BuildFormCard(
                        title: '图片',
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
                                  } else if (firstImg.runtimeType.toString() ==
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
                            GestureDetector(
                              onTap: handleCopyLastItem,
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
                            const SizedBox(width: 6),
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
                                          color:
                                              Theme.of(context).primaryColor)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        children: [
                          FormBuilderField<Map<String, dynamic>>(
                            name: 'supplyQuote',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '该项不能为空';
                              }
                              return null;
                            },
                            builder: (field) {
                              final supplier = field.value;
                              return Row(
                                children: [
                                  Expanded(
                                      child: GestureDetector(
                                    onTap: () async {
                                      final selectedSupplier =
                                          await showModalBottomSheet<
                                              Map<String, dynamic>>(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (_) => const SupplierSelect(),
                                      );

                                      if (selectedSupplier != null) {
                                        field.didChange(selectedSupplier);
                                      }
                                    },
                                    child: AbsorbPointer(
                                      child: Input(
                                        label: '供应商',
                                        showClearButton: false,
                                        isRequired: true,
                                        value: supplier == null
                                            ? ''
                                            : (supplier['short_name'] ??
                                                supplier['name'] ??
                                                ''),
                                        hintText: '请选择供应商',
                                        errorText: field.errorText,
                                      ),
                                    ),
                                  )),
                                  const SizedBox(width: 8), // 间距
                                  Padding(
                                      padding: const EdgeInsets.only(top: 28),
                                      child: InkWell(
                                        onTap: () {
                                          final currentImages = formKey
                                              .currentState
                                              ?.fields['image']
                                              ?.value;

                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                SkuSettingsDialog(
                                              currentImages:
                                                  currentImages is List
                                                      ? currentImages
                                                      : [],
                                              onConfirm: (generatedSku,
                                                  syncSupplier, syncCustomer) {
                                                if (generatedSku.isEmpty) {
                                                  return;
                                                }

                                                Map<String, dynamic> patchData =
                                                    {};

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
                                        },
                                        borderRadius: BorderRadius.circular(4),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 8),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: colorScheme.primary),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: colorScheme.primary,
                                          ),
                                          child: const Text(
                                            "SKU设置",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ))
                                ],
                              );
                            },
                          ),
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
                                        value: field.value ?? '',
                                        onChanged: field.didChange,
                                      );
                                    },
                                  ),
                                ),
                              if (isVisible('product_brand'))
                                Expanded(
                                  child: FormBuilderField<String>(
                                    name: "product_brand",
                                    builder: (field) {
                                      return Input(
                                        label: '品牌',
                                        value: field.value ?? '',
                                        onChanged: field.didChange,
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                          SpacingRow(
                            spacing: 12,
                            children: [
                              if (isVisible('supplier_sku'))
                                Expanded(
                                  child: FormBuilderField<String>(
                                    name: "supplier_sku",
                                    builder: (field) {
                                      return Input(
                                        label: '供应商货号',
                                        value: field.value ?? '',
                                        onChanged: field.didChange,
                                      );
                                    },
                                  ),
                                ),
                              if (isVisible('customer_sku'))
                                Expanded(
                                  child: FormBuilderField<String>(
                                    name: "customer_sku",
                                    builder: (field) {
                                      return Input(
                                        label: '客户货号',
                                        value: field.value ?? '',
                                        onChanged: field.didChange,
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                          SpacingRow(
                            spacing: 12,
                            children: [
                              if (isVisible('supplier_price'))
                                Expanded(
                                  child: FormBuilderField<String>(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return '该项不能为空';
                                      }
                                      return null;
                                    },
                                    name: "supplier_price",
                                    builder: (field) {
                                      return Input(
                                        label: '供应商报价(￥)',
                                        keyboardType: TextInputType.number,
                                        isRequired: true,
                                        value: field.value ?? '',
                                        onChanged: field.didChange,
                                        errorText: field.errorText,
                                      );
                                    },
                                  ),
                                ),
                              if (isVisible('deliver_day'))
                                Expanded(
                                  child: FormBuilderField<String>(
                                    name: "deliver_day",
                                    builder: (field) {
                                      return Input(
                                        label: '发货天数',
                                        keyboardType: TextInputType.number,
                                        value: field.value ?? '',
                                        onChanged: field.didChange,
                                      );
                                    },
                                  ),
                                ),
                              if (isVisible('supplier_moq'))
                                Expanded(
                                  child: FormBuilderField<String>(
                                    name: "supplier_moq",
                                    builder: (field) {
                                      return Input(
                                        label: '供应商MOQ',
                                        keyboardType: TextInputType.number,
                                        value: field.value ?? '',
                                        onChanged: field.didChange,
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                          SpacingRow(
                            spacing: 12,
                            children: [
                              if (isVisible('customer_price'))
                                Expanded(
                                  child: FormBuilderField<String>(
                                    name: "customer_price",
                                    builder: (field) {
                                      return Input(
                                        label: '客户报价',
                                        keyboardType: TextInputType.number,
                                        value: field.value ?? '',
                                        onChanged: field.didChange,
                                      );
                                    },
                                  ),
                                ),
                              if (isVisible('customer_qty'))
                                Expanded(
                                  child: FormBuilderField<String>(
                                    name: "customer_qty",
                                    builder: (field) {
                                      return Input(
                                        label: '客户采购数量',
                                        keyboardType: TextInputType.number,
                                        value: field.value ?? '',
                                        onChanged: field.didChange,
                                      );
                                    },
                                  ),
                                ),
                              if (isVisible('product_unit'))
                                Expanded(
                                  child: FormBuilderField<String>(
                                    name: "product_unit",
                                    builder: (field) {
                                      return Input(
                                        label: '单位',
                                        value: field.value ?? '',
                                        onChanged: field.didChange,
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                          if (isVisible('product_name_cn'))
                            FormBuilderField<String>(
                              name: "product_name_cn",
                              builder: (field) {
                                return TranslatableInput(
                                  label: '中文名称',
                                  sourceText: formKey.currentState
                                      ?.fields['product_name_cn']?.value,
                                  value: field.value ?? '',
                                  onChanged: field.didChange,
                                  onTranslateChanged: (value) {
                                    formKey
                                        .currentState?.fields['product_name_en']
                                        ?.didChange(value);
                                  },
                                );
                              },
                            ),
                          if (isVisible('product_name_en'))
                            FormBuilderField<String>(
                              name: "product_name_en",
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
                          SpacingRow(spacing: 12, children: [
                            if (isVisible('material'))
                              Expanded(
                                child: FormBuilderField<String>(
                                  name: "material",
                                  builder: (field) {
                                    return Input(
                                      label: '材质',
                                      value: field.value ?? '',
                                      onChanged: field.didChange,
                                    );
                                  },
                                ),
                              ),
                            if (isVisible('inner_qty'))
                              Expanded(
                                child: FormBuilderField<String>(
                                  name: "inner_qty",
                                  builder: (field) {
                                    return Input(
                                      label: '内箱数量',
                                      keyboardType: TextInputType.number,
                                      value: field.value ?? '',
                                      onChanged: field.didChange,
                                    );
                                  },
                                ),
                              ),
                            if (isVisible('weight'))
                              Expanded(
                                child: FormBuilderField<String>(
                                  name: "weight",
                                  builder: (field) {
                                    return Input(
                                      label: '重量',
                                      keyboardType: TextInputType.number,
                                      value: field.value ?? '',
                                      onChanged: field.didChange,
                                    );
                                  },
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
                                    builder: (field) {
                                      return Input(
                                        label: '包装方式',
                                        value: field.value ?? '',
                                        onChanged: field.didChange,
                                      );
                                    },
                                  ),
                                ),
                              if (isVisible('outer_qty'))
                                Expanded(
                                  child: FormBuilderField<String>(
                                    name: "outer_qty",
                                    builder: (field) {
                                      return Input(
                                        label: '外箱数量',
                                        keyboardType: TextInputType.number,
                                        value: field.value ?? '',
                                        onChanged: field.didChange,
                                      );
                                    },
                                  ),
                                ),
                              if (isVisible('volume'))
                                Expanded(
                                  child: FormBuilderField<String>(
                                    name: "volume",
                                    builder: (field) {
                                      return Input(
                                        label: '体积',
                                        keyboardType: TextInputType.number,
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
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
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
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
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
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
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
                                    formKey
                                        .currentState?.fields['description_en']
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

                          final supplier = submitValues['supplyQuote'];

                          final length =
                              submitValues['length']?.toString() ?? '';
                          final width = submitValues['width']?.toString() ?? '';
                          final height =
                              submitValues['heigth']?.toString() ?? '';

                          final spec = [length, width, height].join('x');
                          submitValues['spec'] = spec;

                          await storeShowroomSample({
                            ...submitValues,
                            "supplier_id": supplier?['id'],
                            "quotation_id": quoteId,
                            'item_type': 'market_product'
                          });
                          final prefs = await SharedPreferences.getInstance();

                          const storageKey = 'last_quote_product_add';
                          await prefs.setString(
                              storageKey, jsonEncode(submitValues));

                          if (!context.mounted) return;

                          formDataNotifier.clearFormData();

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
                            formDataNotifier.clearFormData();
                          } else {
                            if (context.mounted) {
                              Navigator.of(context).pop(true);
                            }
                          }
                        } else {
                          autoValidateMode.value =
                              AutovalidateMode.onUserInteraction;
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
      ),
    );
  }
}
