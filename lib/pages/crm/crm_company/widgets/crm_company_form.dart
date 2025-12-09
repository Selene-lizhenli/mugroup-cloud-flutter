import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/crm/company.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/crm/crm_company/widgets/contact_card_upload.dart';
import 'package:cloud/pages/widgets/input.dart';
import 'package:cloud/pages/widgets/multi_input.dart';
import 'package:cloud/services/media.dart';
import 'package:flant/components/action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class CrmCompanyForm extends HookConsumerWidget {
  final Company? initial; // 创建时 null，编辑时传 Company
  final bool showUpload;
  final Future<void> Function(Map<String, dynamic>) onSubmit;

  const CrmCompanyForm({
    super.key,
    this.showUpload = false,
    required this.initial,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    final isUploading = useState(false); // 控制 Loading 状态

    final cardImage = useState<TemporaryMedia?>(null);

    // --- 你的核心上传逻辑 ---
    Future<void> handleUploadMedia() async {
      await showFlanActionSheet(
        context,
        cancelText: "取消",
        actions: [
          FlanActionSheetAction(
            name: "拍摄",
            callback: (action) async {
              // 1. 拍照
              final AssetEntity? entity =
                  await CameraPicker.pickFromCamera(context);

              if (context.mounted) {
                Navigator.of(context).maybePop(); // 关闭 ActionSheet
              }

              if (entity == null) return;

              // 2. 开始上传
              isUploading.value = true; // 开启 Loading
              try {
                final file = await entity.file;
                // 调用上传接口
                final temporaryMedia = await upload(file: file!);
                cardImage.value = temporaryMedia;
              } finally {
                isUploading.value = false; // 关闭 Loading
              }
            },
          ),
          FlanActionSheetAction(
            name: "从手机相册选择",
            callback: (action) async {
              // 1. 选图
              final List<AssetEntity>? result = await AssetPicker.pickAssets(
                context,
                pickerConfig: const AssetPickerConfig(
                  maxAssets: 1, // 头像通常只选一张
                  requestType: RequestType.image,
                ),
              );

              if (context.mounted) {
                Navigator.of(context).maybePop();
              }

              if (result == null || result.isEmpty) return;

              // 2. 开始上传
              isUploading.value = true;
              try {
                // 处理第一张选中的图片
                final entity = result.first;
                final file = await entity.file;
                final temporaryMedia = await upload(file: file!);
                cardImage.value = temporaryMedia;
              } finally {
                isUploading.value = false;
              }
            },
          ),
        ],
      );
    }

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: FormBuilder(
                key: formKey,
                initialValue: initial?.toJson() ?? {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FormBuilderField<List<TemporaryMedia>>(
                      name: "images",
                      builder: (field) {
                        return ContactCardUploader(
                          image: cardImage.value,
                          isUploading: isUploading.value,
                          onTap: handleUploadMedia,
                          onSuccess: (value) {
                            if (value != null &&
                                value is Map<String, dynamic>) {
                              formKey.currentState?.patchValue(value);
                              formKey.currentState?.save();
                            }
                          },
                        );
                      },
                    ),
                    FormBuilderField<String>(
                      name: "name",
                      builder: (field) {
                        return Input(
                          label: '客户名称',
                          value: field.value ?? '',
                          onChanged: field.didChange,
                        );
                      },
                    ),
                    FormBuilderField<String>(
                      name: "address",
                      builder: (field) {
                        return Input(
                          label: '地址',
                          value: field.value ?? '',
                          onChanged: field.didChange,
                        );
                      },
                    ),
                    FormBuilderField<String>(
                      name: "country",
                      builder: (field) {
                        return Input(
                          label: '国家/地区',
                          value: field.value ?? '',
                          onChanged: field.didChange,
                        );
                      },
                    ),
                    FormBuilderField<String>(
                      name: "industry",
                      builder: (field) {
                        return Input(
                          label: '行业',
                          value: field.value ?? '',
                          onChanged: field.didChange,
                        );
                      },
                    ),
                    FormBuilderField<String>(
                      name: "source",
                      builder: (field) {
                        return Input(
                          label: '来源',
                          value: field.value ?? '',
                          onChanged: field.didChange,
                        );
                      },
                    ),
                    FormBuilderField<List<String>>(
                      name: "domainAccounts",
                      builder: (field) {
                        return MultiInput(
                          label: '公司网址',
                          btnText: '添加公司网址',
                          values: field.value ?? [''],
                          onChanged: field.didChange,
                        );
                      },
                    ),
                    FormBuilderField<List<String>>(
                      name: "linkedInAccounts",
                      builder: (field) {
                        return MultiInput(
                          label: 'LinkedIn',
                          btnText: '添加 LinkedIn',
                          values: field.value ?? [''],
                          onChanged: field.didChange,
                        );
                      },
                    ),
                    FormBuilderField<List<String>>(
                      name: "whatsAppAccounts",
                      builder: (field) {
                        return MultiInput(
                          label: 'WhatsApp',
                          btnText: '添加 WhatsApp',
                          values: field.value ?? [''],
                          onChanged: field.didChange,
                        );
                      },
                    ),
                    FormBuilderField<List<String>>(
                      name: "faceBookAccounts",
                      builder: (field) {
                        return MultiInput(
                          label: 'Facebook',
                          btnText: '添加 Facebook',
                          values: field.value ?? [''],
                          onChanged: field.didChange,
                        );
                      },
                    ),
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
