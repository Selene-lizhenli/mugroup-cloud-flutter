import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/dashboard/public_news_article.dart';
import 'package:cloud/pages/widgets/image_show.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:cloud/router/router.gr.dart';

@RoutePage()
class NewsPage extends StatelessWidget {
  final int currentIndex;
  final int totalLength;
  final List<PublicNewsArticle>? articleList;

  const NewsPage({
    super.key,
    required this.currentIndex,
    required this.totalLength,
    this.articleList,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final contextWidth = MediaQuery.of(context).size.width;
    final article = articleList?[currentIndex];
    return Scaffold(
        appBar: AppBar(
          title: Text(
            article?.title ?? '',
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

               return Scrollbar(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: availableHeight,
                    ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [  
                      // 文章内容（富文本）
                      Html(
                        data:
                            article?.content?.replaceAll('< img', '<img') ?? '',
                        style: {
                          'body': Style(
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                            fontSize: FontSize(16),
                            lineHeight: const LineHeight(1.8),
                            color: colorScheme.onSurface,
                            fontFamily:
                                '-apple-system, BlinkMacSystemFont, "Segoe UI", "PingFang SC", "Microsoft YaHei", Arial, sans-serif',
                          ),
                          'p': Style(
                            margin: Margins.only(bottom: 12),
                            fontSize: FontSize(16),
                            lineHeight: const LineHeight(1.8),
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
                          ImageExtension(
                            builder: (extensionContext) {
                              final src = extensionContext.attributes['src'];
                              if (src == null || src.trim().isEmpty) {
                                // 如果 src 为空，显示调试信息
                                return Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(8),
                                  color: Colors.grey[200],
                                  child: const Text('图片URL为空或无效',
                                      style: TextStyle(color: Colors.red)),
                                );
                              }

                              String imageUrl = src.trim();

                              if (!imageUrl.startsWith('http://') &&
                                  !imageUrl.startsWith('https://')) {
                                // 如果是相对路径，可以在这里添加基础 URL
                                imageUrl =
                                    'https://www.mugroup.com.cn$imageUrl';
                              }

                              if (imageUrl.startsWith('//')) {
                                imageUrl = 'https:$imageUrl';
                              }

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: ImageShow(
                                    imageUrl: imageUrl,
                                    enablePreview: true,
                                    width: contextWidth,
                                    fit: BoxFit.contain,
                                    errorIconSize: 38,
                                    showErrorText: true, // 确保显示错误文本
                                    errorTextSize: 10, // 可以调整大小
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              onPressed: currentIndex > 0
                                  ? () {
                                      context.router.replace(
                                        NewsRoute(
                                          currentIndex: currentIndex - 1,
                                          totalLength: totalLength,
                                          articleList: articleList,
                                        ),
                                      );
                                    }
                                  : null,
                              child: Text(
                                '上一篇',
                                style: TextStyle(
                                    color: currentIndex > 0
                                        ? colorScheme.primary
                                        : Colors.grey),
                              ),
                            ),
                            TextButton(
                              onPressed: currentIndex < totalLength - 1
                                  ? () {
                                      context.router.replace(
                                        NewsRoute(
                                          currentIndex: currentIndex + 1,
                                          totalLength: totalLength,
                                          articleList: articleList,
                                        ),
                                      );
                                    }
                                  : null,
                              child: Text(
                                '下一篇',
                                style: TextStyle(
                                    color: currentIndex < totalLength - 1
                                        ? colorScheme.primary
                                        : Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ));
            },
          ),
        ));
  }
}
