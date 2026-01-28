import 'package:flutter/material.dart';
import 'package:cloud/models/quote/quotation_list.dart';
import 'package:cloud/pages/quote/widgets/quote_card.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';

class BuildQuoteList extends StatelessWidget {
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final List<QuotationList> list;
  final int tabIndex;
  final ScrollController scrollController;
  final Future<void> Function() onRefresh;
  final void Function(QuotationList item) onItemTap;

  const BuildQuoteList({
    super.key,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasMore,
    required this.list,
    required this.tabIndex,
    required this.scrollController,
    required this.onRefresh,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && list.isEmpty) {
      return const Center(child: MuProgressIndicator());
    }

    if (!isLoading && list.isEmpty) {
      return _buildEmptyView(context);
    }

    return Expanded(
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView.separated(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
            top: 10,
            bottom: MediaQuery.of(context).padding.bottom + 20,
          ),
          itemCount: list.length + 1,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            if (index == list.length) {
              return _buildFooter(context);
            }

            // 渲染卡片
            final item = list[index];
            return QuoteCard(
              item: item,
              tabIndex: tabIndex,
              onTap: () => onItemTap(item),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: MuProgressIndicator()),
      );
    }

    if (!hasMore) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 40, height: 1, color: colorScheme.outlineVariant),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                '没有更多了',
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.outline,
                ),
              ),
            ),
            Container(width: 40, height: 1, color: colorScheme.outlineVariant),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildEmptyView(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: Theme.of(context).disabledColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '暂无数据',
                    style: TextStyle(
                      color: Theme.of(context).disabledColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
