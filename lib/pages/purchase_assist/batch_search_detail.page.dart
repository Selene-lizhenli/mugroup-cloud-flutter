import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud/constants/theme_config.dart';
import 'package:cloud/models/purchase_assist/purchase_assist.dart';
import 'package:cloud/pages/purchase_assist/provider/provider.dart';
import 'package:cloud/pages/purchase_assist/widgets/task_detail_product_card.dart';
import 'package:cloud/pages/purchase_assist/widgets/task_detail_info.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const columnPaddingRightWidth = 5.00;

@RoutePage()
class BatchSearchDetailPage extends HookConsumerWidget {
  const BatchSearchDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(purchaseAssistProvider);
    final notifier = ref.read(purchaseAssistProvider.notifier);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (state.taskId != null) {
          notifier.loadTaskDetail(refresh: true);
        }
      });
      return null;
    }, []);

    final list = state.taskDetail;
    final platform = state.taskDetailMeta?.platform ?? '';
    final count = state.taskDetailMeta?.pagination?.count.toString() ?? '0';
    final isLoading = state.isLoading;
    final errorMessage = state.errorMessage;

    final originPhotoLength = list?.length ?? 0;
    final screenWidth = MediaQuery.of(context).size.width;
    final columnWidth = originPhotoLength >= 4
        ? (screenWidth / 3) - (columnPaddingRightWidth * 4)
        : (screenWidth -
                pageHorizontalPadding * 2 -
                columnPaddingRightWidth * originPhotoLength * 2) /
            originPhotoLength;

    return Scaffold(
        appBar: AppBar(
          title: const Text('图搜结果'),
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: isLoading
            ? const Center(child: MuProgressIndicator())
            : errorMessage != null
                ? Center(child: Text(errorMessage))
                : list == null
                    ? const Center(child: Text('暂无数据'))
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: pageHorizontalPadding),
                        child: Column(
                          children: [
                            TaskDetailInfoCard(
                              platform: platform,
                              count: count,
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: list
                                          .where((e) => e != null)
                                          .map(
                                            (item) => _DetailColumn(
                                              item: item!,
                                              columnWidth: columnWidth,
                                              platform: platform,
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ));
  }
}

/// 单列：顶部源图 + 下方相似商品列表（无独立纵向滚动，整体跟随外层滚动）
class _DetailColumn extends StatelessWidget {
  const _DetailColumn({
    required this.item,
    required this.columnWidth,
    required this.platform,
  });

  final PurchaseAssistTaskDetailItem item;
  final double columnWidth;
  final String platform;

  @override
  Widget build(BuildContext context) {
    final results = item.results ?? [];
    final imageUrl = item.media?.thumbUrl ?? item.media?.url;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(
          right: columnPaddingRightWidth,
          left: columnPaddingRightWidth,
          bottom: 12),
      child: SizedBox(
        width: columnWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Container(
                width: columnWidth,
                height: columnWidth,
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.primary, width: 4),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _SourceImage(url: imageUrl),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 20,
                        color: colorScheme.primary.withOpacity(0.8),
                        alignment: Alignment.center,
                        child: const Text(
                          '源图片',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // 相似商品列表：直接纵向堆叠，由外层垂直滚动统一控制
            for (final product in results)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TaskResultProductCard(
                  product: product,
                  columnWidth: columnWidth,
                  platform: platform,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SourceImage extends StatelessWidget {
  const _SourceImage({
    required this.url,
  });

  final String? url;

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return Image.asset(
        'assets/icons/no_image.png',
        fit: BoxFit.cover,
      );
    }
    return CachedNetworkImage(
      imageUrl: url!,
      fit: BoxFit.cover,
      placeholder: (_, __) => ColoredBox(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      errorWidget: (_, __, ___) => Image.asset(
        'assets/icons/no_image.png',
        fit: BoxFit.cover,
      ),
    );
  }
}
