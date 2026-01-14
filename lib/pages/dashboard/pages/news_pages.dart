import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/dashboard/public_news_article.dart';
import 'package:cloud/pages/widgets/image_show.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

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
    final contextWidth = MediaQuery.of(context).size.width; 
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
                      if (media != null && media.isNotEmpty) ...[
                        ...media.where((m) => m.type == 'image').map((media) {
                          final imageUrl =
                              media.url ?? media.whiteUrl ?? media.thumbUrl;
                          if (imageUrl == null || imageUrl.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: ImageShow(
                                imageUrl: imageUrl, 
                                enablePreview:true, 
                                width: contextWidth,
                                fit: BoxFit.contain,
                                errorIconSize: 38,
                              ),
                            ),
                          );
                        }),
                      
                      ],
                      const SizedBox(height: 10,),
                      // 文章内容（富文本）
                      Html(
                        data: article.content ?? '',
                        style: {
                          'body': Style(
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                            fontSize:   FontSize(16),
                            lineHeight: const LineHeight(1.8),
                            color: colorScheme.onSurface,
                            fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", "PingFang SC", "Microsoft YaHei", Arial, sans-serif',
                          ),
                          'p': Style(
                            margin: Margins.only(bottom: 12),
                            fontSize: FontSize(16),
                            lineHeight: LineHeight(1.8),
                            color: colorScheme.onSurface,
                          ),
                          'strong': Style(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                          'br': Style(
                            height: Height(0),
                          ),
                          'em': Style(
                            fontStyle: FontStyle.italic,
                          ),
                          'hr': Style(
                            margin: Margins.symmetric(vertical: 32),
                            border: Border(
                              top: BorderSide(
                                color: colorScheme.outline.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                          ),
                        },
                        extensions: [
                            ImageExtension(),
                        ],
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
