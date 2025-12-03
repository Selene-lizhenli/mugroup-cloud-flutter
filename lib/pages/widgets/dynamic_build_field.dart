import 'package:cloud/models/media.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/models/schema.dart';
import 'package:cloud/pages/widgets/category_select.dart';
import 'package:cloud/pages/widgets/date_picker_input.dart';
import 'package:cloud/pages/widgets/image_uploader.dart';
import 'package:cloud/pages/widgets/input.dart';
import 'package:cloud/pages/widgets/select.dart';
import 'package:cloud/pages/widgets/text_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class DynamicBuildField extends StatelessWidget {
  final Schema schema;

  const DynamicBuildField({super.key, required this.schema});

  @override
  Widget build(BuildContext context) {
    final s = schema;

    if (s.widget == 'input') {
      return FormBuilderField<String>(
        name: s.name,
        validator: (value) {
          if (s.isRequired && (value == null || value.isEmpty)) {
            return '必填';
          }
          return null;
        },
        builder: (field) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Input(
                label: s.title,
                value: field.value ?? '',
                onChanged: field.didChange,
              ),
            ],
          );
        },
      );
    }

    if (s.widget == 'inputNumber') {
      return FormBuilderField<String>(
        name: s.name,
        validator: (value) {
          if (s.isRequired && (value == null || value.isEmpty)) {
            return '必填';
          }
          if (value != null && double.tryParse(value) == null) {
            return '请输入数字';
          }
          return null;
        },
        builder: (field) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Input(
                label: s.title,
                value: field.value ?? '',
                onChanged: field.didChange,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  // 正则表达式：只允许数字和一个小数点
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                ],
              ),
            ],
          );
        },
      );
    }

    if (s.widget == 'select') {
      return FormBuilderField<String>(
        name: schema.name,
        validator: (value) {
          if (schema.isRequired && value == null) return '必填';
          return null;
        },
        builder: (field) {
          return Select(
            label: schema.title,
            value: field.value,
            options: (schema.props?.options ?? [])
                .map((o) => SelectOption(label: o.label, value: o.value))
                .toList(),
            onChanged: (value) {
              field.didChange(value); // 更新表单状态
            },
          );
        },
      );
    }

    if (s.widget == 'switch') {
      return FormBuilderSwitch(
        name: s.name,
        title: Text(s.title),
        initialValue: false,
      );
    }

    if (s.widget == 'datePicker') {
      return FormBuilderField<String>(
        name: s.name,
        validator: (value) {
          if (s.isRequired && value == null) return '必填';
          return null;
        },
        builder: (field) {
          return DatePickerInput(
            label: s.title,
            value: field.value,
            onChanged: (date) {
              field.didChange(date);
            },
          );
        },
      );
    }

    if (s.widget == 'SampleImagesUpload') {
      return FormBuilderField<List<dynamic>>(
        name: s.name,
        validator: (value) {
          if (s.isRequired && (value == null || value.isEmpty)) return '必填';
          return null;
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
            label: s.title,
            value: displayValue,
            onChanged: (newValue) {
              field.didChange(newValue);
            },
          );
        },
      );
    }

    if (s.widget == 'ShowroomCategorySelect') {
      return FormBuilderField<int>(
        name: s.name,
        validator: (value) {
          if (s.isRequired && value == null) return '必填';
          return null;
        },
        builder: (field) {
          return CategorySelect(
            label: s.title,
            value: field.value,
            onChanged: (categoryId) {
              field.didChange(categoryId);
            },
          );
        },
      );
    }

    if (s.widget == 'textArea') {
      return FormBuilderField<String>(
        name: schema.name,
        validator: (value) {
          if (schema.isRequired && value == null) return '必填';
          return null;
        },
        builder: (field) {
          return TextArea(
            label: schema.title,
            value: field.value,
            onChanged: (value) {
              field.didChange(value);
            },
          );
        },
      );
    }

    /// 未匹配到，返回空
    return const SizedBox.shrink();
  }
}
