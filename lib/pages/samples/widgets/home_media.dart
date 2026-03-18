import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:flant/components/image_preview.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class HomeMeidaItem extends StatelessWidget {
  final TemporaryMedia media;
  final GestureTapCallback? onTapDelete;
  final VoidCallback? onTap;
  final bool active;
  const HomeMeidaItem({
    super.key,
    required this.media,
    required this.active,
    this.onTap,
    this.onTapDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                  color: active
                      ? colorScheme.primary
                      : const Color(
                          0xFFe5e5e5,
                        ),
                  width: 2),
            ),
            child: GestureDetector(
              onTap: () {
                if (active) {
                  showFlanImagePreview(
                    context,
                    images: [media.url],
                    startPosition: 0,
                    loop: false,
                  );
                } else {
                  // 如果未选中，点击执行【切换】
                  onTap?.call();
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: media.url,
                ),
              ),
            ),
          ),
          // 删除
          Positioned(
              right: 0,
              top: 0,
              child: GestureDetector(
                onTap: onTapDelete,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.only(
                        bottomLeft:
                            Radius.circular(TDTheme.of(context).radiusDefault),
                        topRight:
                            Radius.circular(TDTheme.of(context).radiusDefault)),
                  ),
                  child: const Center(
                      child: Icon(
                    TDIcons.close,
                    size: 16,
                    color: Colors.white,
                  )),
                ),
              ))
        ],
      ),
    );
  }
}

class HomeMedia extends StatelessWidget {
  final List<TemporaryMedia> media;
  final int currentMediaId;
  final GestureTapCallback? onTapUplod;
  final Function(TemporaryMedia temporaryMedia)? onTapMedia;
  final Function(TemporaryMedia temporaryMedia)? onDeleteMedia;

  const HomeMedia({
    super.key,
    required this.media,
    required this.currentMediaId,
    this.onTapUplod,
    this.onTapMedia,
    this.onDeleteMedia,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.all(8.0),
      color: Colors.white,
      child: SizedBox(
        height: 80,
        child: Row(
          children: [
            Flexible(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var item in media) ...[
                      HomeMeidaItem(
                        media: item,
                        onTap: () => onTapMedia?.call(item),
                        onTapDelete: () => onDeleteMedia?.call(item),
                        active: currentMediaId == item.id,
                      ),
                      const SizedBox(
                        width: 10,
                      )
                    ]
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: onTapUplod,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: TDTheme.of(context).grayColor1,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Center(
                  child: Icon(
                    TDIcons.add,
                    color: Color.fromRGBO(0, 0, 0, 0.4),
                    size: 28,
                  ),
                ),
              ),
            ),

            // SizedBox(
            //   width: 100,
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     children: [
            //       const Text('1'),
            //       Container(
            //         color: const Color(0xFF969799),
            //         height: 1,
            //       ),
            //       const Text('12'),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
