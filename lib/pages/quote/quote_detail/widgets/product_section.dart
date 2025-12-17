import 'package:cloud/pages/quote/quote_detail/models/quote_detail_state.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/product_pagination.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:cloud/pages/quote/quote_detail/providers/quote_detail_provider.dart';

class ProductSection extends ConsumerWidget {
  final int? quoteId;
  const ProductSection({super.key, this.quoteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quoteDetailProvider);
    final notifier = ref.read(quoteDetailProvider.notifier);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
        color: colorScheme.surface,
        padding: const EdgeInsets.fromLTRB(14, 3, 14, 3),
        child: SizedBox(
            height: 320,
            child: Column(
              children: [
                // ===== 头部 =====
                Padding(
                  padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('产品列表', style: theme.textTheme.titleMedium),
                      // ElevatedButton.icon( //todo
                      //   onPressed: () {}, //todo
                      //   icon: const Icon(Icons.add, size: 12),
                      //   label: Text(
                      //     '添加产品',
                      //     style: TextStyle(
                      //         color: colorScheme.primary, fontSize: 12),
                      //   ),
                      //   style: ElevatedButton.styleFrom(
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 12, vertical: 8),
                      //     minimumSize: Size.zero, // 关键：取消最小高度
                      //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                Expanded(
                  child: _buildBody(context, state, colorScheme),
                ),

                PaginationBar(
                  currentPage: state.productPage,
                  totalPages: state.productTotalPages,
                  onPageChanged: (page) {
                    notifier.fetchProductsPage(quoteId!, page);
                  },
                ),
              ],
            )));
  }

  Widget _buildBody(
    BuildContext context,
    QuoteDetailState state,
    ColorScheme colorScheme,
  ) {
    if (state.isProductLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.productError != null) {
      return Center(
        child: Text(
          '产品加载失败',
          style: TextStyle(color: colorScheme.error),
        ),
      );
    }

    if (state.products.isEmpty) {
      return Center(
          child: Text(
        '暂无产品',
        style: TextStyle(color: colorScheme.surfaceContainerHighest),
      ));
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      itemCount: state.products.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final row = state.products[index];
        final sample = row.showroomSample;

        final imageUrl = sample?.image?.isNotEmpty == true
            ? sample!.image!.first.thumbUrl
            : null;
        if (sample == null) {
          return const SizedBox.shrink();
        }
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colorScheme.secondary.withOpacity(0.04),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== 图片 =====
              _ProductImage(imageUrl: imageUrl),
              const SizedBox(width: 12),
              // ===== 文本信息 =====
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _KeyValue(
                      label: '产品编码',
                      value: sample.productNo ?? '-',
                      highlight: true,
                    ),
                    _KeyValue(
                      label: '品名',
                      value: sample.nameCn ?? sample.nameEn ?? '-',
                    ),
                    if ((sample.spec ?? '').isNotEmpty)
                      _KeyValue(label: '规格', value: sample.spec!),
                    if ((sample.packing ?? '').isNotEmpty)
                      _KeyValue(label: '包装', value: sample.packing!),
                    _KeyValue(
                      label: '客户报价',
                      value: row.price != null ? row.price.toString() : '-',
                    ),
                  ],
                ),
              ),

              // ===== 数量 =====
              if (row.qty != null)
                Column(
                  children: [
                    Text(
                      'x${row.qty}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ProductImage extends StatelessWidget {
  final String? imageUrl;

  const _ProductImage({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(6),
      ),
      clipBehavior: Clip.hardEdge,
      child: imageUrl != null
          ? Image.network(imageUrl!, fit: BoxFit.cover)
          : const Icon(Icons.image_not_supported),
    );
  }
}

class _KeyValue extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _KeyValue({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: RichText(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        text: TextSpan(
          style: theme.textTheme.bodySmall,
          children: [
            TextSpan(
              text: '$label：',
              style: TextStyle(
                fontSize: 9,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                fontSize: 9,
                color:
                    highlight ? colorScheme.secondary : colorScheme.onSurface,
                fontWeight: highlight ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
