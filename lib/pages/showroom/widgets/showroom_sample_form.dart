import 'dart:convert';

import 'package:cloud/constants/form_definitions.dart';
import 'package:cloud/l10n/l10n_extension.dart';
import 'package:cloud/models/field_config.dart';
import 'package:cloud/models/media.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/pages/showroom/widgets/audio_playable_item.dart';
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
    this.onDraft,
    required this.onSubmit,
    this.onDirtyChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());

    final configParams = useMemoized(() => FieldConfigParams(
          storageKey: 'sample_form_v1',
          defaultFields: sampleDefaultFields,
        ));

    final fieldConfigs = ref.watch(fieldConfigProvider(configParams));

    final notifier = ref.read(fieldConfigProvider(configParams).notifier);

    const basicInfoFieldNames = {
      'product_no',
      'purchase_cost',
      'name_cn',
      'name_en'
    };

    const specFieldNames = {'unit', 'packing', 'series', 'spec'};

    double getFieldWeight(String name) {
      const largeFields = {'spec', 'name_cn', 'name_en'};

      if (largeFields.contains(name)) return 3;

      const mediumFields = {
        'product_no',
        'purchase_cost',
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
              label: l10n.showroomProductNo,
              value: field.value ?? '',
              onChanged: field.didChange,
            ),
          );

        case 'purchase_cost':
          return FormBuilderField<String>(
            name: "purchase_cost",
            builder: (field) => Input(
              label: l10n.showroomPrice,
              keyboardType: TextInputType.number,
              value: field.value ?? '',
              onChanged: field.didChange,
            ),
          );

        case 'unit':
          return FormBuilderField<String>(
            name: "unit",
            builder: (field) {
              return Select(
                label: l10n.showroomUnit,
                value: field.value,
                options: [
                  SelectOption(label: 'PC', value: 'PC'),
                  SelectOption(label: 'SET', value: 'SET'),
                  SelectOption(label: 'CTN', value: 'CTN'),
                  SelectOption(label: 'KG', value: 'KG'),
                  SelectOption(label: 'T', value: 'T'),
                  SelectOption(label: 'CBM', value: 'CBM'),
                  SelectOption(label: 'M', value: 'M'),
                  SelectOption(label: 'L', value: 'L'),
                  SelectOption(label: 'BAG', value: 'BAG'),
                  SelectOption(label: 'PACK', value: 'PACK'),
                  SelectOption(label: 'CASE', value: 'CASE'),
                  SelectOption(label: 'PAIR', value: 'PAIR'),
                  SelectOption(label: 'BOX', value: 'BOX'),
                  SelectOption(label: 'SQM', value: 'SQM'),
                  SelectOption(label: 'G', value: 'G'),
                  SelectOption(label: 'Pieces', value: 'Pieces'),
                  SelectOption(label: 'Pair', value: 'Pair'),
                ],
                onChanged: field.didChange,
              );
            },
          );

        case 'name_cn':
          return FormBuilderField<String>(
            name: "name_cn",
            builder: (field) => TranslatableInput(
              label: l10n.showroomNameCn,
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
              label: l10n.showroomNameEn,
              value: field.value ?? '',
              onChanged: field.didChange,
            ),
          );

        case 'series':
          return FormBuilderField<String>(
            name: "series",
            builder: (field) => Input(
              label: l10n.showroomSeries,
              value: field.value ?? '',
              onChanged: field.didChange,
            ),
          );
        case 'packing':
          return FormBuilderField<String>(
            name: "packing",
            builder: (field) => Input(
              label: l10n.showroomPacking,
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
                    label: l10n.showroomLength,
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
                    label: l10n.showroomWidth,
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
                    label: l10n.showroomHeight,
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
        EasyLoading.showInfo(l10n.showroomUploadImageFirst);
        return;
      }

      await EasyLoading.show(
          status: l10n.showroomSmartRecognizing,
          maskType: EasyLoadingMaskType.clear);

      try {
        final result = await identifySample({'image': images});

        if (result != null && result is Map<String, dynamic>) {
          EasyLoading.showSuccess(l10n.showroomRecognizeSuccess);

          formKey.currentState?.patchValue(result);
        } else {
          EasyLoading.dismiss();
        }
      } catch (e) {
        EasyLoading.showError(l10n.showroomRecognizeFailed);
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
                      title: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            l10n.showroomImages,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            l10n.showroomImageAutoRecognize,
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
                              l10n.showroomSmartRecognize,
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
                    FormBuilderField<List<dynamic>>(
                      name: "audios",
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

                        if (displayValue.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return BuildFormCard(
                          title: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                l10n.showroomAuxAudio,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          children: [
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: displayValue.map((media) {
                                return AudioPlayableItem(
                                  url: media.url,
                                  onDelete: () {
                                    final newValue =
                                        List.from(field.value ?? [])
                                          ..removeWhere((e) {
                                            if (e is Media) {
                                              return e.id == media.id;
                                            }
                                            if (e is TemporaryMedia) {
                                              return e.idEquals(media.id);
                                            }
                                            return false;
                                          });

                                    field.didChange(newValue);
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        );
                      },
                    ),
                    BuildFormCard(
                      title: l10n.quoteBasicInfo,
                      action: Row(
                        children: [
                          if (initial == null) ...[
                            GestureDetector(
                              onTap: () async {
                                try {
                                  EasyLoading.show(status: l10n.loading);

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
                                  EasyLoading.showError(l10n.selectUserLoadFailed);
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
                                    l10n.showroomCopyLast,
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
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context)
                                      .size
                                      .width, // 底部抽屉宽度占满屏幕
                                ),
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
                                Text(l10n.showroomFieldSettings,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context).primaryColor)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      children: [...buildFlowSection(basicInfoFieldNames)],
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
                          title: l10n.showroomFactoryQuotes,
                          action: GestureDetector(
                            onTap: () async {
                              final selectedSupplier =
                                  await showModalBottomSheet<
                                      Map<String, dynamic>>(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context)
                                      .size
                                      .width, // 底部抽屉宽度占满屏幕
                                ),
                                builder: (ctx) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      bottom:
                                          MediaQuery.of(ctx).viewInsets.bottom,
                                    ),
                                    child: const SupplierSelect(),
                                  );
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
                                  EasyLoading.showInfo(l10n.showroomSupplierExists);
                                }
                              }
                            },
                            child: Row(
                              children: [
                                Icon(Icons.add_circle_outline,
                                    size: 16,
                                    color: Theme.of(context).primaryColor),
                                const SizedBox(width: 4),
                                Text(l10n.showroomAdd,
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
                                      l10n.showroomNoFactoryQuotes,
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
                                                content:
                                                    l10n.showroomRemoveFactoryQuoteConfirm,
                                              );
                                              if (isConfirmed) {
                                                final newList = List<
                                                        Map<String,
                                                            dynamic>>.from(
                                                    valueList);

                                                final quoteId = item['id'];

                                                if (quoteId != null) {
                                                  EasyLoading.show(
                                                      status: l10n.showroomDeleting);
                                                  await deleteSupplyQuote(
                                                      quoteId);
                                                  EasyLoading.dismiss();

                                                  newList.removeAt(index);
                                                  field.didChange(newList);
                                                  EasyLoading.showSuccess(
                                                      l10n.showroomDeleteSuccess);
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
                                              label: l10n.showroomSupplierProductNo,
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
                                              label: l10n.showroomSupplierPrice,
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
                                              label: l10n.showroomMoq,
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
                                              label: l10n.showroomMaterial,
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
                      title: l10n.showroomProductSpec,
                      children: [...buildFlowSection(specFieldNames)],
                    ),
                    BuildFormCard(
                      title: l10n.showroomDescription,
                      isLast: true,
                      children: [
                        if (isVisible('description_cn'))
                          FormBuilderField<String>(
                            name: "description_cn",
                            builder: (field) {
                              return TextArea(
                                label: l10n.showroomDescriptionCn,
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
                                label: l10n.showroomDescriptionEn,
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
                    child: Text(
                      l10n.submit,
                      style: const TextStyle(color: Colors.white),
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
