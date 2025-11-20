import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/services/openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ContactCardUploader extends HookConsumerWidget {
  final TemporaryMedia? image; // 名片图片地址
  final bool isUploading; // 上传状态 (外部传入)
  final VoidCallback onTap; // 点击卡片的回调(上传/重拍)
  final void Function(dynamic resp)? onSuccess;

  const ContactCardUploader({
    super.key,
    this.image,
    this.isUploading = false,
    required this.onTap,
    this.onSuccess,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final isHasImage = image != null;

    final isAnalyzing = useState(false);

    final isBusy = isUploading || isAnalyzing.value;

    // 处理智能识别点击
    Future<void> handleIdentify() async {
      if (!isHasImage) {
        EasyLoading.showInfo("请先上传名片!");
        return;
      }

      // 1. 开始 Loading
      isAnalyzing.value = true;

      try {
        // 2. 调用接口
        final resp = await identifyCompanyCard({
          "image": [image],
        });

        onSuccess?.call(resp);
        logger.d(resp);
        EasyLoading.showSuccess("识别完成");
      } finally {
        if (context.mounted) {
          isAnalyzing.value = false;
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "名片识别",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Opacity(
              opacity: isUploading ? 0.5 : 1.0,
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  // 忙碌状态下禁止点击
                  onTap: isBusy ? null : handleIdentify,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1), // 背景色淡一点
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: colorScheme.primary.withOpacity(0.3),
                          width: 0.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 根据状态显示图标 或 Loading
                        if (isAnalyzing.value)
                          SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colorScheme.primary,
                            ),
                          )
                        else
                          Icon(
                            Icons.auto_awesome,
                            size: 14,
                            color: colorScheme.primary,
                          ),

                        const SizedBox(width: 6),

                        Text(
                          isAnalyzing.value ? "识别中..." : "智能识别",
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: isBusy ? null : onTap,
          child: AspectRatio(
            aspectRatio: 1.75, // 稍微扁一点好看
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: isHasImage ? Colors.black : const Color(0xFFF7F8FA),
                borderRadius: BorderRadius.circular(12),
                border: isHasImage
                    ? null
                    : Border.all(color: Colors.grey.shade300, width: 1.5),
                image: isHasImage && !isUploading
                    ? DecorationImage(
                        image: NetworkImage(image!.url),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.1),
                          BlendMode.darken,
                        ),
                      )
                    : null,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 1. 空状态内容
                  if (!isHasImage && !isBusy)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Icon(
                            Icons.filter_center_focus,
                            size: 32,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "点击拍摄/上传名片",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),

                  if (isBusy)
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            isUploading ? "上传中..." : "AI 正在分析名片...",
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),

                  if (isHasImage && !isBusy)
                    Positioned(
                      right: 12,
                      bottom: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.camera_alt_outlined,
                                color: Colors.white, size: 14),
                            SizedBox(width: 6),
                            Text("重拍",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
