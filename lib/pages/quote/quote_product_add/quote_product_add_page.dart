import 'dart:convert';
import 'dart:math';
import 'package:cloud/constants/form_definitions.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/field_config.dart';
import 'package:cloud/models/media.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/quote/quote_page.dart';
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
import 'package:cloud/providers/app_provider.dart';
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

class QuoteProductAddPortraitView extends HookConsumerWidget {
  final int? quoteId;
  final bool isActive;
  final int? companyId;
  final Map<String, dynamic>? initialSupplier;
  final String translationLanguage; // 翻译目标语言（小写，如 'en', 'ja', 'es' 等）

  const QuoteProductAddPortraitView({
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

    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    final configParams = useMemoized(() => FieldConfigParams(
          storageKey: 'quote_product_add_form_v1',
          defaultFields: quoteSampleDefaultFields,
        ));

    final fieldConfigs = ref.watch(fieldConfigProvider(configParams));
    final notifier = ref.read(fieldConfigProvider(configParams).notifier);

    final autoValidateMode = useState(AutovalidateMode.disabled);

    final isSubmitting = useState(false);

    const basicInfoFieldNames = {
      'product_no',
      'product_brand',
      'supplier_sku',
      'customer_sku',
      'purchase_cost',
      'deliver_day',
      'moq',
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

        case 'purchase_cost':
          return FormBuilderField<String>(
            name: "purchase_cost",
            validator: (value) =>
                (value == null || value.isEmpty) ? '该项不能为空' : null,
            builder: (field) => Input(
              label: '供应商报价(￥)',
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))
              ],
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
        case 'moq':
          return FormBuilderField<String>(
            name: "moq",
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
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))
              ],
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
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))
              ],
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

    // 1. 获取 Provider 最新数据
    final formData = ref.watch(quoteProductAddFormProvider);
    final formDataNotifier = ref.read(quoteProductAddFormProvider.notifier);

    ref.listen(quoteProductAddFormProvider, (previous, next) {
      if (!isActive && next.isNotEmpty) {
        if (formKey.currentState != null) {
          logger.d('屏幕切走11$isActive');
          formKey.currentState?.patchValue(next);
        }
      }
    });
    useEffect(() {
      if (isActive) {
        if (formData.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (formKey.currentState != null) {
              logger.d('竖屏激活：加载数据 $formData');
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
      final user = ref.read(userProvider).user;

      if (images == null || (images is List && images.isEmpty)) {
        EasyLoading.showInfo("请先上传图片");
        return;
      }

      await EasyLoading.show(
          status: '智能识别中...', maskType: EasyLoadingMaskType.clear);

      try {
        final result = await identifyOcr('ExtractQtnBasic', {
          "department": user?.department?.name,
          "employee_name": user?.name,
          "employee_number": user?.jobNumber,
          "image": images[0].thumbUrl,
        });

        if (result != null &&
            result is Map<String, dynamic> &&
            result['success'] == true) {
          // 1. 获取内部的数据列表
          final List? dataList = result['data'];

          if (dataList != null && dataList.isNotEmpty) {
            // 2. 取出第一个条目作为处理对象
            final Map<String, dynamic> rawItem =
                Map<String, dynamic>.from(dataList.first);
            final Map<String, dynamic> processedData = {};

            final Map<String, String> fieldMapping = {
              'item_no': 'product_no',
              'price': 'purchase_cost',
              'out_carton': 'outer_capacity',
              'inner_pack': 'inner_capacity',
              'size': 'spec',
              'weight': 'weight',
              'packaging_type': 'packing',
              'unit': 'unit',
              'volume': 'outer_volume',
              'moq': 'moq',
              'description': 'description_cn',
            };

            // 3. 执行映射转换（遍历 mapping 而不是遍历结果，更安全）
            fieldMapping.forEach((oldKey, newKey) {
              if (rawItem.containsKey(oldKey)) {
                // 转换值为 String，因为 Input 组件通常接收 String
                processedData[newKey] = rawItem[oldKey].toString();
              }
            });

            EasyLoading.showSuccess("识别成功");

            // 4. 打印转换后的扁平化数据
            logger.d(processedData);

            // 5. 填充表单
            formKey.currentState?.patchValue(processedData);
          } else {
            EasyLoading.showInfo("未识别到有效内容");
          }
        }
      } catch (e) {
        logger.d(e);
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
          data.remove('image');
          data.remove('images');

          data['supplier_sku'] = '';
          data['customer_sku'] = '';

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
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                child: FormBuilder(
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
                              '图片',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '图片自动识别',
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
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                clipBehavior: Clip.none,
                                child: ImageUploader(
                                  customIcon: Icons.camera_alt,
                                  value: displayValue,
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
                        action: Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.55),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: handleCopyLastItem,
                                  child: Row(children: [
                                    Icon(Icons.content_copy,
                                        size: 16,
                                        color: Theme.of(context).primaryColor),
                                    const SizedBox(width: 4),
                                    Text("复制上一条",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context)
                                                .primaryColor)),
                                  ]),
                                ),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () {
                                    final currentImages = formKey
                                        .currentState?.fields['image']?.value;

                                    showDialog(
                                      context: context,
                                      builder: (context) => SkuSettingsDialog(
                                        currentImages: currentImages is List
                                            ? currentImages
                                            : [],
                                        onConfirm: (generatedSku, syncSupplier,
                                            syncCustomer) {
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

                                          EasyLoading.showSuccess('SKU已生成并填充');
                                        },
                                      ),
                                    );
                                  },
                                  child: Row(children: [
                                    Icon(Icons.settings,
                                        size: 16,
                                        color: Theme.of(context).primaryColor),
                                    Text("SKU设置",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context)
                                                .primaryColor)),
                                  ]),
                                ),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (ctx) {
                                        return FieldSelector(
                                          fields: fieldConfigs,
                                          companyId: companyId,
                                          defaultFields:
                                              quoteSampleDefaultFields,
                                          onConfigChanged:
                                              (List<FieldConfig> newConfigs) {
                                            notifier.updateConfigs(newConfigs);
                                          },
                                          showActionButtons: true,
                                        );
                                      },
                                    );
                                  },
                                  child: Row(children: [
                                    Icon(Icons.settings,
                                        size: 16,
                                        color: Theme.of(context).primaryColor),
                                    Text("字段设置",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context)
                                                .primaryColor)),
                                  ]),
                                ),
                              ],
                            ),
                          ),
                        ),
                        children: [
                          // FormBuilderField<Map<String, dynamic>>(
                          //   name: 'supplier',
                          //   validator: (value) {
                          //     if (value == null || value.isEmpty) {
                          //       return '该项不能为空';
                          //     }
                          //     return null;
                          //   },
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
                          //               backgroundColor: Colors.transparent,
                          //               builder: (_) => const SupplierSelect(),
                          //             );

                          //             if (selectedSupplier != null) {
                          //               field.didChange(selectedSupplier);
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
                          //             padding: const EdgeInsets.only(top: 28),
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
                          //                         syncSupplier, syncCustomer) {
                          //                       if (generatedSku.isEmpty) {
                          //                         return;
                          //                       }

                          //                       Map<String, dynamic> patchData =
                          //                           {};

                          //                       patchData['product_no'] =
                          //                           generatedSku;

                          //                       // 3. 根据勾选同步更新
                          //                       if (syncSupplier) {
                          //                         patchData['supplier_sku'] =
                          //                             generatedSku;
                          //                       }
                          //                       if (syncCustomer) {
                          //                         patchData['customer_sku'] =
                          //                             generatedSku;
                          //                       }

                          //                       formKey.currentState
                          //                           ?.patchValue(patchData);

                          //                       EasyLoading.showSuccess(
                          //                           'SKU已生成并填充');
                          //                     },
                          //                   ),
                          //                 );
                          //               },
                          //               borderRadius: BorderRadius.circular(4),
                          //               child: Container(
                          //                 padding: const EdgeInsets.symmetric(
                          //                     horizontal: 8, vertical: 8),
                          //                 decoration: BoxDecoration(
                          //                   border: Border.all(
                          //                       color: colorScheme.primary),
                          //                   borderRadius:
                          //                       BorderRadius.circular(4),
                          //                   color: colorScheme.primary,
                          //                 ),
                          //                 child: const Text(
                          //                   "SKU设置",
                          //                   style: TextStyle(
                          //                     fontSize: 12,
                          //                     color: Colors.white,
                          //                     fontWeight: FontWeight.w500,
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
                      BuildFormCard(
                        title: '产品规格',
                        children: [
                          ...buildFlowSection(specFieldNames),
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
                                  toLanguage: translationLanguage,
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
                        disabledBackgroundColor:
                            colorScheme.primary.withOpacity(0.6),
                      ),

                      onPressed: isSubmitting.value
                          ? null
                          : () async {
                              final formState = formKey.currentState;
                              if (formState?.saveAndValidate() ?? false) {
                                isSubmitting.value = true;
                                EasyLoading.show(
                                  status: '正在提交...',
                                  maskType: EasyLoadingMaskType.clear,
                                );

                                try {
                                  final Map<String, dynamic> submitValues =
                                      Map.from(formState!.value);

                                  final supplier = initialSupplier;

                                  submitValues['supply_quotes'] = [
                                    {
                                      "supplier_id": supplier?['id'],
                                      'supplier': supplier,
                                      "product_no": submitValues["product_no"],
                                      'product_brand':
                                          submitValues["product_brand"],
                                      'supplier_sku':
                                          submitValues["supplier_sku"],
                                      "customer_sku":
                                          submitValues["customer_sku"],
                                      'purchase_cost':
                                          submitValues["purchase_cost"],
                                      "deliver_day":
                                          submitValues["deliver_day"],
                                      "moq": submitValues["moq"],
                                      "customer_price":
                                          submitValues["customer_price"],
                                      "customer_qty":
                                          submitValues["customer_qty"],
                                      "unit": submitValues["unit"],
                                      "material": submitValues["material"],
                                      "inner_capacity":
                                          submitValues["inner_capacity"],
                                      "weight": submitValues["weight"],
                                      "packing": submitValues["packing"],
                                      "outer_capacity":
                                          submitValues["outer_capacity"],
                                      "outer_volume":
                                          submitValues["outer_volume"],
                                    }
                                  ];

                                  final length =
                                      submitValues['length']?.toString() ?? '';
                                  final width =
                                      submitValues['width']?.toString() ?? '';
                                  final height =
                                      submitValues['heigth']?.toString() ?? '';

                                  final spec =
                                      [length, width, height].join('x');
                                  submitValues['spec'] = spec;

                                  // 2. 发起网络请求
                                  await storeShowroomSample({
                                    ...submitValues,
                                    "supplier_id": supplier?['id'],
                                    if (quoteId != null)
                                      "quotation_id": quoteId,
                                    'item_type': 'market_product'
                                  });

                                  isSubmitting.value = false;

                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  const storageKey = 'last_quote_product_add';
                                  await prefs.setString(
                                      storageKey, jsonEncode(submitValues));

                                  EasyLoading.dismiss();

                                  if (!context.mounted) return;

                                  formDataNotifier.clearFormData();

                                  final currentSupplier =
                                      formState.value['supplier'];
                                  formState.reset();
                                  formDataNotifier.clearFormData();

                                  if (currentSupplier != null) {
                                    formKey.currentState?.patchValue({
                                      'supplier': currentSupplier,
                                    });
                                  }

                                  if (context.mounted) {
                                    ref
                                        .read(quotePageRefreshTrigger.notifier)
                                        .update((state) => state + 1);
                                    Navigator.of(context).pop(true);
                                  }
                                } finally {
                                  // 4. 无论成功失败，必须重置状态，否则按钮会一直卡在转圈状态
                                  isSubmitting.value = false;
                                  if (EasyLoading.isShow) EasyLoading.dismiss();
                                }
                              } else {
                                autoValidateMode.value =
                                    AutovalidateMode.onUserInteraction;
                              }
                            },
                      // 根据状态切换按钮内部显示
                      child: isSubmitting.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              '完成',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.secondary,
                        disabledBackgroundColor:
                            colorScheme.secondary.withOpacity(0.6),
                      ),
                      onPressed: isSubmitting.value
                          ? null
                          : () async {
                              final formState = formKey.currentState;
                              if (formState?.saveAndValidate() ?? false) {
                                isSubmitting.value = true;
                                EasyLoading.show(
                                  status: '正在提交...',
                                  maskType: EasyLoadingMaskType.clear,
                                );

                                try {
                                  final Map<String, dynamic> submitValues =
                                      Map.from(formState!.value);

                                  final supplier = initialSupplier;

                                  submitValues['supply_quotes'] = [
                                    {
                                      "supplier_id": supplier?['id'],
                                      'supplier': supplier,
                                      "product_no": submitValues["product_no"],
                                      'product_brand':
                                          submitValues["product_brand"],
                                      'supplier_sku':
                                          submitValues["supplier_sku"],
                                      "customer_sku":
                                          submitValues["customer_sku"],
                                      'purchase_cost':
                                          submitValues["purchase_cost"],
                                      "deliver_day":
                                          submitValues["deliver_day"],
                                      "moq": submitValues["moq"],
                                      "customer_price":
                                          submitValues["customer_price"],
                                      "customer_qty":
                                          submitValues["customer_qty"],
                                      "unit": submitValues["unit"],
                                      "material": submitValues["material"],
                                      "inner_capacity":
                                          submitValues["inner_capacity"],
                                      "weight": submitValues["weight"],
                                      "packing": submitValues["packing"],
                                      "outer_capacity":
                                          submitValues["outer_capacity"],
                                      "outer_volume":
                                          submitValues["outer_volume"],
                                    }
                                  ];

                                  final length =
                                      submitValues['length']?.toString() ?? '';
                                  final width =
                                      submitValues['width']?.toString() ?? '';
                                  final height =
                                      submitValues['heigth']?.toString() ?? '';

                                  final spec =
                                      [length, width, height].join('x');
                                  submitValues['spec'] = spec;

                                  // 2. 发起网络请求
                                  await storeShowroomSample({
                                    ...submitValues,
                                    "supplier_id": supplier?['id'],
                                    if (quoteId != null)
                                      "quotation_id": quoteId,
                                    'item_type': 'market_product'
                                  });

                                  isSubmitting.value = false;

                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  const storageKey = 'last_quote_product_add';
                                  await prefs.setString(
                                      storageKey, jsonEncode(submitValues));

                                  EasyLoading.dismiss();

                                  if (!context.mounted) return;

                                  formDataNotifier.clearFormData();

                                  final currentSupplier =
                                      formState.value['supplier'];
                                  formState.reset();
                                  formDataNotifier.clearFormData();

                                  if (currentSupplier != null) {
                                    formKey.currentState?.patchValue({
                                      'supplier': currentSupplier,
                                    });
                                  }

                                  handleCopyLastItem();
                                } finally {
                                  // 4. 无论成功失败，必须重置状态，否则按钮会一直卡在转圈状态
                                  isSubmitting.value = false;
                                  if (EasyLoading.isShow) EasyLoading.dismiss();
                                }
                              } else {
                                autoValidateMode.value =
                                    AutovalidateMode.onUserInteraction;
                              }
                            },
                      child: isSubmitting.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              '存并复录',
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
