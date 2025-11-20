import 'package:auto_route/auto_route.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/crm/crm_company/widgets/contact_card_upload.dart';
import 'package:cloud/pages/crm/crm_company/widgets/multi_input.dart';
import 'package:cloud/services/media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flant/flant.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:cloud/pages/crm/crm_company/widgets/input.dart';

@RoutePage()
class CrmCompanyCreatePage extends HookConsumerWidget {
  const CrmCompanyCreatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    // --- 状态管理 ---
    final isUploading = useState(false); // 控制 Loading 状态
    final cardImage = useState<TemporaryMedia?>(null);

    final companyName = useState('');
    final address = useState('');
    final country = useState('');
    final industry = useState('');
    final source = useState('');
    final website = useState('');

    final wechatAccounts = useState<List<String>>(['']);
    final linkedInAccounts = useState<List<String>>(['']);
    final whatsAppAccounts = useState<List<String>>(['']);
    final faceBookAccounts = useState<List<String>>(['']);

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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("创建客户",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade100, height: 1),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                children: [
                  ContactCardUploader(
                    image: cardImage.value,
                    isUploading: isUploading.value,
                    onTap: handleUploadMedia,
                    onSuccess: (value) {
                      // 成功回调
                      logger.d(value);
                    },
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    "基本资料",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  // --- 表单输入 ---
                  Input(
                    label: '客户名称',
                    value: companyName.value,
                    onChanged: (v) => companyName.value = v,
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
                      const SizedBox(width: 16),
                      Expanded(
                        child: Input(
                          label: '公司网址',
                          value: website.value,
                          onChanged: (v) => website.value = v,
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  MultiInput(
                    label: '微信号',
                    btnText: '添加更多微信号', // 自定义按钮文字
                    values: wechatAccounts.value,
                    onChanged: (newValues) {
                      wechatAccounts.value = newValues;
                    },
                  ),
                  const SizedBox(height: 16),
                  MultiInput(
                    label: 'LinkedIn',
                    btnText: '添加更多LinkedIn', // 自定义按钮文字
                    values: linkedInAccounts.value,
                    onChanged: (newValues) {
                      linkedInAccounts.value = newValues;
                    },
                  ),
                  const SizedBox(height: 16),
                  MultiInput(
                    label: 'WhatsApp',
                    btnText: '添加更多WhatsApp', // 自定义按钮文字
                    values: whatsAppAccounts.value,
                    onChanged: (newValues) {
                      whatsAppAccounts.value = newValues;
                    },
                  ),
                  const SizedBox(height: 16),
                  MultiInput(
                    label: 'FaceBook',
                    btnText: '添加更多FaceBook', // 自定义按钮文字
                    values: faceBookAccounts.value,
                    onChanged: (newValues) {
                      faceBookAccounts.value = newValues;
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            // --- 底部保存按钮 ---
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, -4),
                    blurRadius: 10,
                  )
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shadowColor: colorScheme.primary.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    debugPrint("提交数据: Name=${companyName.value}");
                  },
                  child: const Text(
                    "保存",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
