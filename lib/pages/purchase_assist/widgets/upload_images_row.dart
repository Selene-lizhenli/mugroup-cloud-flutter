import 'package:cloud/pages/purchase_assist/provider/provider.dart';
import 'package:cloud/pages/purchase_assist/purchase_assist_page.dart';
import 'package:flant/components/image_preview.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// 已上传的搜索图片横向列表（首项为加号，点击执行 openGallery）
class UploadedImagesRow extends ConsumerWidget {
  const UploadedImagesRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(purchaseAssistProvider);
    final notifier = ref.read(purchaseAssistProvider.notifier);
    final list = state.searchMediaList;
    if (list.isEmpty) return const SizedBox.shrink();

    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .surfaceContainerHighest
              .withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: SizedBox(
            height: 76,
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: list.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  // 第一项：加号，点击打开相册
                  if (index == list.length) {
                    return GestureDetector(
                      onTap: () => openGalleryForPurchaseAssist(context, ref),
                      child: Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest
                              .withOpacity(0.26),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .outline
                                .withOpacity(0.5),
                          ),
                        ),
                        child: Icon(
                          Icons.add,
                          size: 32,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant
                              .withOpacity(0.4),
                        ),
                      ),
                    );
                  }
                  final media = list[index];
                  final imageUrl = media.thumbUrl ?? media.url;
                  final isSelected = state.searchMedia?.id == media.id;
                  return GestureDetector(
                    onTap: () {
                      notifier.setSearchMedia(media);
                      notifier.loadProducts(params: {"media_id": media.id});
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.transparent,
                              width: 3,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.3),
                                      blurRadius: 6,
                                      spreadRadius: 0,
                                    ),
                                  ]
                                : null,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              if (isSelected) {
                                showFlanImagePreview(
                                  context,
                                  images: [media.url],
                                  startPosition: 0,
                                  loop: false,
                                );
                              } else {
                                notifier.setSearchMedia(media);
                                notifier.loadProducts(
                                    params: {"media_id": media.id});
                              }
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: CachedNetworkImage(
                                imageUrl: imageUrl,
                                width: 72,
                                height: 72,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: -4,
                          top: -4,
                          child: GestureDetector(
                            onTap: () => notifier.removeSearchMedia(index),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 1),
                              ),
                              child: const Icon(Icons.close,
                                  size: 14, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )));
  }
}
