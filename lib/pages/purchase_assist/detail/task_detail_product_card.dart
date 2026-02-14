import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud/models/purchase_assist/purchase_assist.dart';
import 'package:cloud/pages/purchase_assist/purchase_assist_page.dart';
import 'package:flutter/material.dart'; 
import 'package:url_launcher/url_launcher.dart';

/// 任务详情中的 相似商品 小卡片
class TaskResultProductCard extends StatelessWidget {
  const TaskResultProductCard({
    super.key,
    required this.columnWidth,
    required this.product,
    required this.platform,
  });

  final PurchaseAssistTaskResultProduct product;
  final double columnWidth;
  final String platform;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Future<void> openProductUrl(BuildContext context, String? url) async {
      if (url == null || url.isEmpty) return;
      final uri = Uri.tryParse(url);
      if (uri != null && await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }

    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () => openProductUrl(context, product.productUrl),
        borderRadius: BorderRadius.circular(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      width: columnWidth,
                      height: columnWidth,
                      fit: BoxFit.cover,
                      imageUrl: product.imageUrl!,
                      placeholder: (_, __) => AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                            color: colorScheme.surfaceContainerHighest),
                      ),
                      errorWidget: (_, __, ___) => _NoImagePlaceholder(
                        height: columnWidth,
                        colorScheme: colorScheme,
                      ),
                    )
                  : _NoImagePlaceholder(
                      height: columnWidth,
                      colorScheme: colorScheme,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => onProductTap(product, platform, context),
                    child: Text(
                      product.name ?? '—',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (product.price != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '¥${product.price}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoImagePlaceholder extends StatelessWidget {
  const _NoImagePlaceholder({
    required this.height,
    required this.colorScheme,
  });

  final double height;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Image.asset(
        'assets/icons/no_image.png',
        fit: BoxFit.contain,
      ),
    );
  }
}
