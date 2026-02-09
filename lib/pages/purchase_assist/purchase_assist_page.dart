import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/purchase_assist.dart';
import 'package:cloud/pages/purchase_assist/provider/provider.dart';
import 'package:cloud/pages/widgets/list.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class PurchaseAssistPage extends HookConsumerWidget {
  const PurchaseAssistPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(purchaseAssistProvider);
    final notifier = ref.read(purchaseAssistProvider.notifier);
    final searchController =
        useTextEditingController(text: state.searchKeyword);
    useEffect(() {
      if (state.searchKeyword != searchController.text) {
        searchController.text = state.searchKeyword;
      }
      return null;
    }, [state.searchKeyword]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('比价助手'),
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.task_alt),
            tooltip: '任务管理',
            onPressed: () {
              context.router.push(const BatchImageSearchResultRoute());
            },
          ),
        ],
      ),
      body: state.hasSearched
          ? _SearchResultBody(
              state: state,
              notifier: notifier,
              searchController: searchController,
            )
          : _BigSearchBody(notifier: notifier, state: state),
    );
  }
}

/// 未搜索时：中间大搜索框（带添加图片）
class _BigSearchBody extends StatelessWidget {
  const _BigSearchBody({required this.notifier, required this.state});

  final PurchaseAssist notifier;
  final PurchaseAssistState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: '输入关键词或上传图片搜索',
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                      ),
                      onChanged: notifier.setSearchKeyword,
                      onSubmitted: (_) => notifier.doSearch(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_photo_alternate_outlined),
                    tooltip: '添加图片',
                    onPressed: () {
                      // TODO: 打开图片选择，选择后 notifier.setSearchImagePaths(paths); 接口补充后实现
                    },
                  ),
                ],
              ),
            ),
            if (state.searchImagePaths.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: state.searchImagePaths.map((path) {
                  return Chip(
                    label: Text(path),
                    onDeleted: () {
                      notifier.setSearchImagePaths(
                        state.searchImagePaths.where((p) => p != path).toList(),
                      );
                    },
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => notifier.doSearch(),
              icon: const Icon(Icons.search, size: 20),
              label: const Text('搜索'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 已搜索时：顶部搜索栏 + 下方商品列表
class _SearchResultBody extends StatelessWidget {
  const _SearchResultBody({
    required this.state,
    required this.notifier,
    required this.searchController,
  });

  final PurchaseAssistState state;
  final PurchaseAssist notifier;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 顶部收缩的搜索框
        Material(
          color: theme.colorScheme.surface,
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: '关键词或图片',
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    onChanged: notifier.setSearchKeyword,
                    onSubmitted: (_) => notifier.loadProducts(refresh: true),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add_photo_alternate_outlined),
                  tooltip: '添加图片',
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => notifier.loadProducts(refresh: true),
                ),
              ],
            ),
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: MuListView<PurchaseAssistSearchProduct>(
            state: state,
            list: state.productList,
            onRefresh: () => notifier.loadProducts(refresh: true),
            onLoadMore: () => notifier.loadProducts(refresh: false),
            refreshOnStart: false,
            itemBuilder: (context, item) => ListTile(
              title: Text(item.name ?? ''),
              subtitle: item.id != null ? Text('ID: ${item.id}') : null,
            ),
          ),
        ),
      ],
    );
  }
}
