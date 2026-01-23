import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:flutter/material.dart';

/// 可复用的图片展示组件
/// 支持网络图片和本地资源，自动处理加载状态和错误
class ImageShow extends StatelessWidget {
  /// 图片URL（网络或本地资源路径）
  final String imageUrl;

  /// 图片宽度，如果为 null 则根据 height 和 fit 自动计算
  final double? width;

  /// 图片高度，如果为 null 则根据 width 和 fit 自动计算
  final double? height;

  /// 图片适配方式，默认为 BoxFit.fitHeight
  final BoxFit fit;

  /// 占位符widget构建器
  final Widget Function(BuildContext context, String url)? placeholderBuilder;

  /// 错误widget构建器
  final Widget Function(BuildContext context, String url, dynamic error)?
      errorWidgetBuilder;

  /// 错误图标大小
  final double errorIconSize;

  /// 是否显示错误文本
  final bool showErrorText;

  /// 是否允许点击预览大图
  final bool enablePreview;

  final int? memCacheWidth;
  final int? memCacheHeight;

  final double errorTextSize;

  const ImageShow({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.placeholderBuilder,
    this.errorWidgetBuilder,
    this.errorIconSize = 12,
    this.showErrorText = true,
    this.enablePreview = false,
    this.memCacheWidth,
    this.memCacheHeight,
    this.errorTextSize = 9,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    logger.d('imageUrlinner${imageUrl}');

    // 构建错误 widget（必须在前面定义）
    Widget buildErrorWidget(dynamic error) {
      if (errorWidgetBuilder != null) {
        return errorWidgetBuilder!(context, imageUrl, error);
      }
      return Container(
        color: Colors.grey.shade200,
        width: width ?? height,
        height: height ?? width,
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.image_not_supported,
              color: Colors.grey.shade400,
              size: errorIconSize,
            ),
            if (showErrorText) ...[
              const SizedBox(height: 5),
              Text(
                '图片加载失败',
                style: TextStyle(
                  color: colorScheme.outline,
                  fontSize: errorTextSize,
                ),
              ),
            ],
          ],
        ),
      );
    }

    // 验证 URL 是否有效
    if (imageUrl.isEmpty) {
      return buildErrorWidget(null);
    }

    // 判断是否为网络 URL
    final isNetworkUrl =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

    // 构建占位符widget
    Widget buildPlaceholder() {
      if (placeholderBuilder != null) {
        return placeholderBuilder!(context, imageUrl);
      }
      // 如果有固定尺寸，使用固定尺寸的占位符
      if (width != null && height == null) {
        return SizedBox(
          width: width,
          child: const Center(
            child: MuProgressIndicator(muBarWidth: 4),
          ),
        );
      } else if (width == null && height != null) {
        return SizedBox(
          height: height,
          child: const Center(
            child: MuProgressIndicator(muBarWidth: 4),
          ),
        );
      } else if (width != null && height != null) {
        return SizedBox(
          width: width,
          height: height,
          child: const Center(
            child: MuProgressIndicator(muBarWidth: 4),
          ),
        );
      } else {
        return const AspectRatio(
          aspectRatio: 1,
          child: Center(
            child: MuProgressIndicator(muBarWidth: 4),
          ),
        );
      }
      // 否则使用 AspectRatio
    }

    // 构建实际展示的图片 widget
    Widget buildImage() {
      if (isNetworkUrl) {
        // 网络图片
        final networkImage = CachedNetworkImage(
          imageUrl: imageUrl,
          fit: fit,
          memCacheWidth: memCacheWidth,
          memCacheHeight: memCacheHeight,
          placeholder: (context, url) => buildPlaceholder(),
          errorWidget: (context, url, error) => buildErrorWidget(error),
        );

        if (width != null && height != null) {
          return SizedBox(
            width: width ,
            height: height  ,
            child: networkImage,
          );
        } else if (width != null && height == null) {
          return SizedBox(
            width: width,
            child: networkImage,
          );
        } else if (width == null && height != null) {
          return SizedBox(
            height: height,
            child: networkImage,
          );
        }

        return networkImage;
      } else {
        // 本地资源
        final imageWidget = Image.asset(
          imageUrl,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => buildErrorWidget(error),
        );

        if (width != null && height != null) {
          return SizedBox(
            width: width,
            height: height,
            child: imageWidget,
          );
        }

        return imageWidget;
      }
    }

    // 默认展示内容
    final imageContent = buildImage();

    // 不需要预览，直接返回
    if (!enablePreview) {
      return imageContent;
    }

    // 需要预览，包一层手势并弹出大图
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierColor: Colors.black87,
          builder: (context) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).pop(),
              child: Center(
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: isNetworkUrl
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.contain,
                          errorWidget: (context, url, error) =>
                              buildErrorWidget(error),
                        )
                      : Image.asset(
                          imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              buildErrorWidget(error),
                        ),
                ),
              ),
            );
          },
        );
      },
      child: imageContent,
    );
  }
}
