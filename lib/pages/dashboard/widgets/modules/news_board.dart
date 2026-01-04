import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud/services/dashboard.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';

class NewsBoard extends StatefulWidget {
  const NewsBoard({super.key});

  @override
  State<NewsBoard> createState() => _NewsBoardState();
}

class _NewsBoardState extends State<NewsBoard> {
  List<NewsArticle>? _articles;
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
        margin: const  EdgeInsets.fromLTRB(10,10, 10, 10),
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
        
        return GestureDetector(
          onTap: () {
            context.router.push(NewsRoute(article: article));
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(12,  12, 12, isLast ? 12 : 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.fromLTRB(12, 6, 12,6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 图片
                if (article.imageUrl != null && article.imageUrl!.isNotEmpty)
                  _buildImage(article.imageUrl!, 50, 50)
                else
                  Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey.shade200,
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.grey.shade400,
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
                        article.title,
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodyMedium!.fontSize,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        article.content,
                        style: TextStyle(
                          fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                          color: colorScheme.surfaceContainerHighest,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  /// 构建图片组件，支持网络图片和本地资源
  Widget _buildImage(String imageUrl, double width, double height) {
    // 判断是否为网络 URL
    final isNetworkUrl =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

    if (isNetworkUrl) {
      // 网络图片
      return CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: BoxFit.contain,
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color: Colors.grey.shade100,
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          color: Colors.grey.shade200,
          child: Icon(
            Icons.image_not_supported,
            color: Colors.grey.shade400,
          ),
        ),
      );
    } else {
      // 本地资源
      return Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey.shade200,
            child: Icon(
              Icons.image_not_supported,
              color: Colors.grey.shade400,
            ),
          );
        },
      );
    }
  }
}
