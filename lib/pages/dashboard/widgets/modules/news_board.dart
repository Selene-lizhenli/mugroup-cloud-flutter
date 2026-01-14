import 'package:cloud/helper/helper.dart';
import 'package:cloud/pages/widgets/image_show.dart';
import 'package:flutter/material.dart';
import 'package:cloud/services/dashboard.dart';
import 'package:cloud/models/dashboard/public_news_article.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_html/flutter_html.dart';

class NewsBoard extends StatefulWidget {
  const NewsBoard({super.key});

  @override
  State<NewsBoard> createState() => _NewsBoardState();
}

class _NewsBoardState extends State<NewsBoard> {
  List<PublicNewsArticle>? _articles;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  /// 加载新闻文章列表
  Future<void> _loadArticles() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final articles = await getNewsArticles();

      if (articles == null || articles.isEmpty) {
        setState(() {
          _isLoading = false;
          _error = '暂无新闻';
        });
        return;
      }

      setState(() {
        _articles = articles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = '加载失败: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_isLoading) {
      return Container(
        height: 70,
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Container(
        height: 70,
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Center(
          child: Text(
            _error!,
            style: TextStyle(color: colorScheme.surfaceContainerHighest),
          ),
        ),
      );
    }

    if (_articles == null || _articles!.isEmpty) {
      return Container(
        height: 70,
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Center(
          child: Text(
            '暂无数据',
            style: TextStyle(color: colorScheme.surfaceContainerHighest),
          ),
        ),
      );
    }

    // 遍历显示所有文章
    return Column(
      children: _articles!.asMap().entries.map((entry) {
        final index = entry.key;
        final article = entry.value;
        final isLast = index == _articles!.length - 1;
        final isFirst = index == 0;
        logger.d('article.media: ${article}');
        // 获取第一张图片URL（优先使用thumb_url，其次url）
        final imageUrl = _getImageUrl(article);
        logger.d('imageUrl: ${article},${imageUrl}');
        return GestureDetector(
          onTap: () {
            context.router.push(NewsRoute(article: article));
          },
          child: Container(
              margin:
                  EdgeInsets.fromLTRB(8, isFirst ? 10 : 0, 8, isLast ? 10 : 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 图片 
                      if (imageUrl != null && imageUrl.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: ImageShow(
                            imageUrl: imageUrl,
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                            errorIconSize: 32,
                          ),
                        ), 
                      const SizedBox(width: 10),
                      // 标题和内容
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              article.title ?? '',
                              style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .fontSize,
                                color: colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            // 使用富文本加载器，限制2行显示
                            SizedBox(
                              height: (Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .fontSize! *
                                  4), // 3行高度 + 行间距
                              child: ClipRect(
                                child: Html(
                                  data: article.content ?? '',
                                  style: {
                                    'body': Style(
                                      margin: Margins.zero,
                                      padding: HtmlPaddings.zero,
                                      fontSize: FontSize(
                                        Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .fontSize!,
                                      ),
                                      color:
                                          colorScheme.surfaceContainerHighest,
                                      display: Display.block,
                                    ),
                                    'p': Style(
                                      margin: Margins.zero,
                                      padding: HtmlPaddings.zero,
                                      fontSize: FontSize(
                                        Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .fontSize!,
                                      ),
                                      color:
                                          colorScheme.surfaceContainerHighest,
                                      display: Display.block,
                                    ),
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (!isLast)
                    const SizedBox(
                      height: 12,
                    ),
                  if (!isLast)
                    Divider(
                        height: 0.5,
                        color: colorScheme.outline.withOpacity(0.15))
                ],
              )

              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     // 图片
              //     if (imageUrl != null && imageUrl.isNotEmpty)
              //         ImageShow(
              //         imageUrl: imageUrl,
              //         width: 80,
              //         fit: BoxFit.cover,
              //         errorIconSize: 32,
              //       ),
              //     const SizedBox(width: 10),
              //     // 标题和内容
              //     Expanded(
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         mainAxisSize: MainAxisSize.min,
              //         children: [
              //           Text(
              //             article.title ?? '',
              //             style: TextStyle(
              //               fontSize:
              //                   Theme.of(context).textTheme.bodyMedium!.fontSize,
              //               color: colorScheme.onSurface,
              //             ),
              //             maxLines: 1,
              //             overflow: TextOverflow.ellipsis,
              //           ),
              //           const SizedBox(height: 4),
              //           Text(
              //             article.content ?? '',
              //             style: TextStyle(
              //               fontSize:
              //                   Theme.of(context).textTheme.bodySmall!.fontSize,
              //               color: colorScheme.surfaceContainerHighest,
              //             ),
              //             maxLines: 2,
              //             overflow: TextOverflow.ellipsis,
              //             softWrap: true,
              //           ),
              //         ],
              //       ),
              //     ),

              //   ],
              // ),

              ),
        );
      }).toList(),
    );
  }

  /// 获取文章的第一张图片URL
  String? _getImageUrl(PublicNewsArticle article) {
    if (article.media == null || article.media!.isEmpty) {
      return null;
    }

    final firstMedia = article.media!.first;
    // 优先使用缩略图，其次使用原始URL
    final res = firstMedia.thumbUrl ?? firstMedia.url ?? firstMedia.whiteUrl;

    return res;
  }
}
