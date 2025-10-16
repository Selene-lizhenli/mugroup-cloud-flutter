import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class HomeMeidaItem extends StatelessWidget {
  final TemporaryMedia media;
  final bool active;
  const HomeMeidaItem({
    super.key,
    required this.media,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
              color: active ? Colors.blue : TDTheme.of(context).grayColor1,
              width: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: media.url,
          ),
        ),
      ),
    );
  }
}

class HomeMedia extends StatelessWidget {
  final TemporaryMedia media;
  final GestureTapCallback? onTapUplod;

  const HomeMedia({
    super.key,
    required this.media,
    this.onTapUplod,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    HomeMeidaItem(
                      active: true,
                      media: media,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    HomeMeidaItem(
                      active: false,
                      media: media,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
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
