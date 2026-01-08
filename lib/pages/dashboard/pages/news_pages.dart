import 'package:auto_route/auto_route.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/dashboard/public_news_article.dart';
import 'package:cloud/pages/widgets/image_show.dart';
import 'package:flutter/material.dart';

@RoutePage()
class NewsPage extends StatelessWidget {
  final PublicNewsArticle article;

  const NewsPage({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme; 
    final media = article.media;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            article.title ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          backgroundColor: colorScheme.surface,
        ),
        body: Container(
          color: colorScheme.surface,
          child: LayoutBuilder(
            builder: (context, constraints) {
              // 计算可用高度：屏幕高度 - AppBar高度 - 状态栏高度 - padding
              final availableHeight = MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top -
                  40; // padding 20 * 2
              
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: availableHeight,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // 文章图片（显示所有媒体中的图片）
                      // if (media != null && media.isNotEmpty) ...[
                      //   ...media.where((m) => m.type == 'image').map((media) {
                      //     final imageUrl =
                      //         media.url ?? media.whiteUrl ?? media.thumbUrl;
                      //     if (imageUrl == null || imageUrl.isEmpty) {
                      //       return const SizedBox.shrink();
                      //     }
                      //     return Padding(
                      //       padding: const EdgeInsets.symmetric(
                      //           vertical: 0, horizontal: 20),
                      //       child: ClipRRect(
                      //         borderRadius: BorderRadius.circular(8),
                      //         child: ImageShow(
                      //           imageUrl: imageUrl, 
                      //           enablePreview:true,
                      //           height: 100,
                      //           fit: BoxFit.contain,
                      //           errorIconSize: 38,
                      //         ),
                      //       ),
                      //     );
                      //   }),
                      // ],
                      // 文章内容
                      Text(
                        article.content ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }
}
