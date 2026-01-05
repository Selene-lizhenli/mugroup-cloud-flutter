import 'package:flutter/material.dart';
import 'package:cloud/models/quote/quotation_list.dart';
import 'package:cloud/pages/quote/widgets/quote_card.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: onRefresh,
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: list.length + 1, // 最后一条用于显示加载或没有更多
                itemBuilder: (context, index) {
                  if (index < list.length) {
                    final item = list[index];
                    return QuoteCard(
                      item: item,
                      tabIndex: tabIndex,
                      onTap: () => onItemTap(item),
                    );
                  } else {
                    if (isLoadingMore) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (!hasMore) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: Text(
                            '没有更多了',
                            style: TextStyle(
                                color: colorScheme.surfaceContainerHighest),
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox.shrink(); // 占位，什么也不显示
                    }
                  }
                },
              ),
            ),
    );
  }
}
