import 'package:auto_route/auto_route.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/advice_collect/advice_collect_item.dart';
import 'package:cloud/pages/advice_collect/provider/provider.dart';
import 'package:cloud/pages/widgets/list.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class MyAdvicePage extends HookConsumerWidget {
  const MyAdvicePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adviceCollectProvider);
    final notifier = ref.read(adviceCollectProvider.notifier);
    final list = state.bookListMyself ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的留言'),
      ),
      body: MuListView<AdviceCollectBook>(
        state: state,
        list: list,
        hPadding: 16,
        onRefresh: () => notifier.loadBooksMyself(refresh: true),
        onLoadMore: () => notifier.loadBooksMyself(refresh: false),
        itemBuilder: (context, item) => _MyAdviceItemCard(item: item),
      ),
    );
  }
}

class _MyAdviceItemCard extends StatelessWidget {
  const _MyAdviceItemCard({required this.item});

  final AdviceCollectBook item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.content != null && item.content!.isNotEmpty)
              Text(
                item.content!,
                style: theme.textTheme.bodyMedium,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (item.status != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item.status == 'pending' ? '待处理' : '',
                      style: theme.textTheme.labelSmall,
                    ),
                  ),
                const SizedBox(width: 8),
                if (item.createdAt != null)
                  Text(
                    formatDateTimeFull(item.createdAt!),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
            if (item.message != null && item.message!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '回复：',
                    style: theme.textTheme.bodySmall?.copyWith(),
                  ),
                  Expanded(
                    child: Text(
                      '${item.message}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ],
        ),
      ),
    );
  }
}
