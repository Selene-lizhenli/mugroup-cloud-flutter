import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud/services/dashboard.dart';

@RoutePage()
class NewsPage extends StatelessWidget {
  final NewsArticle article;

  const NewsPage({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          article.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: colorScheme.surface,
      ),
      body: Container(
        color: colorScheme.surface,
        child:    SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 文章图片
            if (article.imageUrl != null && article.imageUrl!.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _buildImage(article.imageUrl!, colorScheme),
              ),
              const SizedBox(height: 16),
            ],
            // 文章内容
            Text(
              article.content,
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
 
      ) 
    );
  }

  /// 构建图片组件，支持网络图片和本地资源
  Widget _buildImage(String imageUrl,colorScheme) {
    // 判断是否为网络 URL
    final isNetworkUrl = imageUrl.startsWith('http://') || 
                         imageUrl.startsWith('https://');
  
    if (isNetworkUrl) {
      // 网络图片
      return SizedBox(
        height: 150,
        child: Center(
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            height: 150,
            fit: BoxFit.fitHeight,
            placeholder: (context, url) => Container(
              width: double.infinity,
              height: 150, 
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            errorWidget: (context, url, error) => SizedBox(
              width: double.infinity,
              height: 150, 
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_not_supported,
                    color: colorScheme.outline,
                    size: 48,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '图片加载失败',
                    style: TextStyle(
                      color: colorScheme.outline,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      // 本地资源
      return SizedBox(
        height: 150,
        child: Center(
          child: Image.asset(
            imageUrl,
            height: 150,
            fit: BoxFit.fitHeight,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: 150,
                color: colorScheme.outline,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_not_supported,
                      color: colorScheme.outline,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '图片加载失败',
                      style: TextStyle(
                        color: colorScheme.outline,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    }
  }
}

