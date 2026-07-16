import 'package:cloud/l10n/l10n_extension.dart';
import 'package:cloud/pages/purchase_assist/provider/provider.dart';
import 'package:cloud/pages/purchase_assist/purchase_assist_page.dart';
import 'package:cloud/helper/camera_capture.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud/services/media.dart';

class SearchArea extends HookConsumerWidget {
  const SearchArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 白色圆角输入框 + 盒外阴影，右侧相机 + 加号
    ref.watch(purchaseAssistProvider);
    final notifier = ref.read(purchaseAssistProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    /// 打开相册，选择照片后上传并加入搜索图片列表
    Future<void> openGallery() async {
      await openGalleryForPurchaseAssist(context, ref);
    }

    /// 打开相机，拍一张后把文件路径加入搜索图片列表
    Future<void> openCamera() async {
      final file = await captureSinglePhotoFile();
      if (file == null || !context.mounted) return;
      final temporaryMedia = await upload(file: file);
      notifier.addSearchMedia(temporaryMedia);

      if (context.mounted) {
        await notifier.loadProducts(params: {"media_id": temporaryMedia.id});
      }
    }

    Widget getTnputArea() {
      return Expanded(
        child: TextField(
          decoration: InputDecoration(
            hintText: '${l10n.enterTheKeyword}...',
            hintStyle: const TextStyle(color: Colors.grey),
            border: InputBorder.none,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
          onChanged: notifier.setSearchKeyword,
          onSubmitted: (_) => notifier.loadProducts(),
        ),
      );
    }

    Widget getPicBtn() {
      return IconButton(
        icon: const Icon(Icons.add_outlined, color: Colors.black54, size: 27),
        tooltip: '从相册选择',
        onPressed: () => openGallery(),
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
        constraints: const BoxConstraints(),
        style: IconButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    }

    Widget getcaremaBtn() {
      return IconButton(
        icon: const Icon(Icons.camera_alt_outlined,
            color: Colors.black54, size: 25),
        tooltip: '拍照',
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
        constraints: const BoxConstraints(),
        style: IconButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () => openCamera(),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
        border: Border.all(color: colorScheme.primary, width: 0.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.09),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              getTnputArea(),
              getcaremaBtn(),
              getPicBtn(),
            ],
          ),
        ],
      ),
    );
  }
}
