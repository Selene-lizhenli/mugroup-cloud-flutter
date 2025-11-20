import 'package:cloud/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ContactCardUploader extends HookConsumerWidget {
  final String? imageUrl; // 名片图片地址
  final bool isUploading;
  final VoidCallback onTap; // 点击回调

  const ContactCardUploader({
    super.key,
    this.imageUrl,
    this.isUploading = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final isHasImage = imageUrl != null && imageUrl!.isNotEmpty;

    final isAnalyzing = useState(false);


    logger.d(imageUrl);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 顶部引导文案
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "名片识别",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (!isUploading)
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () async {
                    // await onSmartDetect();
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      "智能识别",
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),

        // 卡片主体区域
        GestureDetector(
          onTap: isUploading ? null : onTap,
          child: AspectRatio(
            aspectRatio: 1.8,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: isHasImage ? Colors.black : const Color(0xFFF7F8FA),
                borderRadius: BorderRadius.circular(12),
                // 如果没有图片，显示虚线边框效果 (用 border 模拟)
                border: isHasImage
                    ? null
                    : Border.all(color: Colors.grey.shade300, width: 1.5),
                image: isHasImage && !isUploading
                    ? DecorationImage(
                        image: NetworkImage(imageUrl!),
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
                  if (!isHasImage && !isUploading)
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
                            Icons.filter_center_focus, // 扫描/对焦图标
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

                  // 2. 识别中状态 (覆盖层)
                  if (isUploading)
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
                          const SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(strokeWidth: 3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "上传中...",
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),

                  // 3. 已上传状态下的“重拍”按钮 (右上角)
                  if (isHasImage && !isUploading)
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
