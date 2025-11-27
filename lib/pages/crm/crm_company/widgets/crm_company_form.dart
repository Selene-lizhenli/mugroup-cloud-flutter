import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/crm/company.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/crm/crm_company/widgets/contact_card_upload.dart';
import 'package:cloud/pages/widgets/input.dart';
import 'package:cloud/pages/widgets/multi_input.dart';
import 'package:cloud/services/media.dart';
import 'package:flant/components/action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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

    final isUploading = useState(false); // 控制 Loading 状态
    final isSubmitting = useState(false);
    final cardImage = useState<TemporaryMedia?>(null);

    final name = useState(initial?.name ?? '');
    final address = useState(initial?.address ?? '');
    final country = useState(initial?.location ?? '');
    final industry = useState(initial?.industry ?? '');
    final source = useState(initial?.source ?? '');
    final domain = useState(initial?.domain ?? '');

    final domainAccounts =
        useState<List<String>>(initial?.domain?.toList() ?? ['']);
    final emailAccounts =
        useState<List<String>>(initial?.email?.toList() ?? ['']);
    final linkedInAccounts =
        useState<List<String>>(initial?.linkedin?.toList() ?? ['']);
    final whatsAppAccounts =
        useState<List<String>>(initial?.whatsapp?.toList() ?? ['']);
    final faceBookAccounts =
        useState<List<String>>(initial?.facebook?.toList() ?? ['']);

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
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            children: [
              if (showUpload) ...[
                ContactCardUploader(
                  image: cardImage.value,
                  isUploading: isUploading.value,
                  onTap: handleUploadMedia,
                  onSuccess: (value) {
                    // 成功回调
                    logger.d(value);
                  },
                ),
                const SizedBox(height: 32)
              ],
              const Text(
                "基本资料",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Input(
                label: '客户名称',
                value: name.value,
                onChanged: (v) => name.value = v,
              ),
              const SizedBox(height: 16),
              Input(
                label: '地址',
                value: address.value,
                onChanged: (v) => address.value = v,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Input(
                      label: '国家/地区',
                      value: country.value,
                      onChanged: (v) => country.value = v,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Input(
                      label: '行业',
                      value: industry.value,
                      onChanged: (v) => industry.value = v,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Input(
                      label: '来源',
                      value: source.value,
                      onChanged: (v) => source.value = v,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              MultiInput(
                label: '公司网址',
                btnText: '添加公司网址',
                values: domainAccounts.value,
                onChanged: (v) => domainAccounts.value = v,
              ),
              const SizedBox(height: 16),
              MultiInput(
                label: '邮箱',
                btnText: '添加邮箱',
                values: emailAccounts.value,
                onChanged: (v) => emailAccounts.value = v,
              ),
              const SizedBox(height: 16),
              MultiInput(
                label: 'LinkedIn',
                btnText: '添加 LinkedIn',
                values: linkedInAccounts.value,
                onChanged: (v) => linkedInAccounts.value = v,
              ),
              const SizedBox(height: 16),
              MultiInput(
                label: 'WhatsApp',
                btnText: '添加 WhatsApp',
                values: whatsAppAccounts.value,
                onChanged: (v) => whatsAppAccounts.value = v,
              ),
              const SizedBox(height: 16),
              MultiInput(
                label: 'Facebook',
                btnText: '添加 Facebook',
                values: faceBookAccounts.value,
                onChanged: (v) => faceBookAccounts.value = v,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: isSubmitting.value
                  ? null
                  : () async {
                      if (name.value.isEmpty) {
                        EasyLoading.showInfo('请输入客户名称');
                        return;
                      }

                      isSubmitting.value = true;
                      try {
                        final payload = {
                          'name': name.value,
                          'address': address.value,
                          'location': country.value,
                          'industry': industry.value,
                          'source': source.value,
                          'domain': domain.value,
                          'email': emailAccounts.value
                              .where((e) => e.trim().isNotEmpty)
                              .toList(),
                          'linkedin': linkedInAccounts.value
                              .where((e) => e.trim().isNotEmpty)
                              .toList(),
                          'whatsapp': whatsAppAccounts.value
                              .where((e) => e.trim().isNotEmpty)
                              .toList(),
                          'facebook': faceBookAccounts.value
                              .where((e) => e.trim().isNotEmpty)
                              .toList(),
                        };

                        await onSubmit(payload);
                      } finally {
                        isSubmitting.value = false;
                      }
                    },
              child: isSubmitting.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(initial == null ? "创建" : "保存修改"),
            ),
          ),
        ),
      ],
    );
  }
}
