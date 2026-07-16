import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud/constants/search_platform_l10n_helper.dart';
import 'package:cloud/l10n/l10n_extension.dart';
import 'package:cloud/constants/theme_config.dart';
import 'package:cloud/models/purchase_assist/purchase_assist.dart';
import 'package:cloud/pages/purchase_assist/provider/provider.dart';
import 'package:cloud/pages/purchase_assist/detail/task_detail_product_card.dart';
import 'package:cloud/pages/purchase_assist/detail/task_detail_info.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const columnPaddingRightWidth = 8.00;
const platformColumnGap = 8.0;
const List<Color> platformColors = <Color>[ 
  Color(0xFFFA338A), // meimei
  Color(0xFFFF9800), // orange
  Color(0xFF4CAF50), // green
  Color(0xFF9C27B0), // purple
  Color(0xFF355EBF), // cyan
];

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
    final List<dynamic> platform =
        state.taskDetailMeta?.platform ?? const <dynamic>[];

    final count = list?.length ?? 0;
    final isLoading = state.isLoading;
    final errorMessage = state.errorMessage;

    final screenWidth = MediaQuery.of(context).size.width;
    final platformColumnWidth =
        (screenWidth / 3) - (columnPaddingRightWidth * 4); // 单个平台列宽

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
                    ? Center(child: Text(context.l10n.noData))
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: pageHorizontalPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TaskDetailInfoCard(
                              platform: platform,
                              count: count.toString(),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: list
                                            .where((e) => e != null)
                                            .map(
                                              (item) => _DetailColumn(
                                                item: item!,
                                                columnWidth:
                                                    platformColumnWidth,
                                              ),
                                            )
                                            .toList(),
                                      ),
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
  });

  final PurchaseAssistTaskDetailItem item;
  final double columnWidth;

  @override
  Widget build(BuildContext context) {
    final platformResults =
        item.results ?? const <String, List<PurchaseAssistTaskResultProduct>>{};
    final imageUrl = item.media?.thumbUrl ?? item.media?.url;
    final colorScheme = Theme.of(context).colorScheme;
    final platformCount = platformResults.length;
    final groupWidth = platformCount == 0
        ? columnWidth
        : (columnWidth * platformCount) +
            (platformColumnGap * (platformCount - 1));
    final sourceImageSize = groupWidth > 96 ? 96.0 : groupWidth;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
      ),
      padding: const EdgeInsets.only(
        right: columnPaddingRightWidth,
        left: columnPaddingRightWidth,
        bottom: columnPaddingRightWidth,
        top: columnPaddingRightWidth,
      ),
      margin: const EdgeInsets.fromLTRB(
        columnPaddingRightWidth,
        0,
        columnPaddingRightWidth,
        0,
      ),
      child: SizedBox(
        width: groupWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  width: sourceImageSize,
                  height: sourceImageSize,
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
                            '源图',
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
            ),
            const SizedBox(height: 8),
            if (platformResults.isEmpty)
              Container(
                height: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: colorScheme.surfaceContainerHighest,
                ),
                child: const Text('暂无平台结果'),
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: platformResults.entries
                    .toList()
                    .asMap()
                    .entries
                    .map((item) {
                  final index = item.key;
                  final entry = item.value;
                  final priceColor =
                      platformColors[index % platformColors.length];
                  final platformName = searchPlatformLabel(context.l10n, entry.key);

                  final products = entry.value;
                  final isLast = index == platformResults.length - 1;
                  return Container(
                    width: columnWidth,
                    margin:
                        EdgeInsets.only(right: isLast ? 0 : platformColumnGap),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                            color: priceColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4), 
                          ),
                          child: Text(
                            platformName,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ), 
                        if (products.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Container(
                              height: 92,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8), 
                              ),
                              child: Text(
                                context.l10n.noData,
                                style: TextStyle(
                                  fontSize: 12, 
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          )
                        else
                          for (final product in products)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: TaskResultProductCard(
                                product: product,
                                columnWidth: columnWidth,
                                platform: [platformName],
                                priceColor: priceColor,
                              ),
                            ),
                      ],
                    ),
                  );
                }).toList(),
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
      fit: BoxFit.contain,
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
