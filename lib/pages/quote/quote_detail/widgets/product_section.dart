import 'package:auto_route/auto_route.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/pages/quote/quote_detail/models/quote_detail_state.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/action_pill_button.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/product_pagination.dart';
import 'package:cloud/router/router.gr.dart';
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
          child: Column(
            children: [
              // ===== 头部 =====
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text('产品列表', style: theme.textTheme.titleMedium),
                      ],
                    ),
                    Row(
                      children: [
                        ActionPillButton(
                          label: '批量导入',
                          icon: Icons.upload_outlined,
                          backgroundColor: const Color(0xFFFF5A8A), // 粉色
                          textColor: Colors.white,
                          onTap: () {
                            // TODO 批量导入
                          },
                        ),
                        const SizedBox(width: 8),
                        ActionPillButton(
                          label: '新增产品',
                          icon: Icons.add,
                          backgroundColor: colorScheme.secondary, // 蓝色
                          textColor: colorScheme.onSecondary,
                          onTap: () {
                            context.router.push(ShowroomSampleCreateRoute());
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: _buildBody(context, state, colorScheme, notifier),
              ),
              // ===== 分页（固定高度）=====
              PaginationBar(
                currentPage: state.productPage,
                totalPages: state.productTotalPages,
                onPageChanged: (page) {
                  notifier.fetchProductsPage(quoteId!, page);
                },
              ),
            ],
          ),
        ));
  }

  Widget _buildBody(BuildContext context, QuoteDetailState state,
      ColorScheme colorScheme, notifier) {
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
            color: colorScheme.secondary.withOpacity(0.06),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _KeyValue(
                    label: '供应商',
                    value: row.supplyQuote?.supplier?.name ?? '-',
                  ),
                  const Spacer(),
                  InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: () {
                      // context.router.push(
                      //     // ShowroomSampleDetailRoute(id: sample.id!, userId: 0)
                      //     );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.edit_outlined,
                        size: 16,
                        color: colorScheme.secondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: () {
                      // context.router.push(
                      //     // ShowroomSampleDetailRoute(id: sample.id!, userId: 0)
                      //     );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.delete_outline,
                        size: 16,
                        color: colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 1),
              const SizedBox(height: 6),
              Row(
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
                          label: '品名',
                          value: sample.nameCn ?? sample.nameEn ?? '-',
                        ),
                        _KeyValue(
                          label: '产品编码',
                          value: sample.productNo ?? '-',
                          highlight: true,
                        ),
                        Row(children: [
                          if ((sample.spec ?? '').isNotEmpty)
                            _KeyValue(label: '规格', value: sample.spec!),
                          const SizedBox(width: 16),
                          // if ((sample.packing ?? '').isNotEmpty)
                          //   _KeyValue(label: '包装', value: sample.packing!),
                        ]),
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
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.secondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
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
