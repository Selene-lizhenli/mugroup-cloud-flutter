import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flant/components/image_preview.dart';
import 'package:cloud/pages/selectors/select_product/providers/product_selector_provider.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/pages/widgets/search_bar.dart';
import 'package:cloud/models/sample/sample.dart';

class ProductListSheet extends HookConsumerWidget {
  final int? supplierId;
  final Function(List<Sample> selected)? onConfirm;
  final Set<int>? initialSelectedIds;

  const ProductListSheet({
    super.key,
    this.supplierId,
    this.onConfirm,
    this.initialSelectedIds,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productSelectorProvider(supplierId));
    final notifier = ref.read(productSelectorProvider(supplierId).notifier);
    final searchController = useTextEditingController();
    final scrollController = useScrollController();
    final colorScheme = Theme.of(context).colorScheme;
    
    // 初始化选中状态
    useEffect(() {
      if (initialSelectedIds != null && initialSelectedIds!.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifier.selectAll(initialSelectedIds!.toList());
        });
      }
      return null;
    }, []);

    // 监听滚动，实现上拉加载更多（节流逻辑在 notifier.loadMore 内部处理）
    useEffect(() {
      void onScroll() {
        if (!scrollController.hasClients) return;
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          notifier.loadMore();
        }
      }

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, [scrollController]);

    final products = state.products;
    final selectedIds = state.selectedIds;
    final validIds =
        products.where((s) => s.id != null).map((s) => s.id!).toList();
    final allSelected =
        validIds.isNotEmpty && validIds.every((id) => selectedIds.contains(id));

    Future<void> handleSearch() async {
      await notifier.fetchProducts(search: searchController.text.trim(), reset: true);
    }

    Future<void> handleRefresh() async {
      await notifier.fetchProducts(search: state.currentSearch, reset: true);
    }

    final selectedCount = selectedIds.length;

    void handleConfirm() {
      if (onConfirm != null) {
        final selectedProducts = products
            .where((p) => p.id != null && selectedIds.contains(p.id))
            .toList();
        onConfirm!(selectedProducts);
      } else {
        // 如果没有提供 onConfirm，通过 Navigator 返回结果
        final selectedProducts = products
            .where((p) => p.id != null && selectedIds.contains(p.id))
            .toList();
        Navigator.pop(context, selectedProducts);
      }
    }

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        '选择产品',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  MuSearchBar(
                    controller: searchController,
                    hintText: '搜索产品编码/名称',
                    buttonText: '搜索',
                    onSearch: handleSearch,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Checkbox(
                        value: allSelected && validIds.isNotEmpty,
                        checkColor: colorScheme.onPrimary,
                        fillColor: WidgetStateProperty.resolveWith<Color?>(
                          (Set<WidgetState> states) {
                            if (states.contains(WidgetState.selected)) {
                              return colorScheme.primary;
                            }
                            return null;
                          },
                        ),
                        focusColor: colorScheme.primary,
                        hoverColor: colorScheme.primary,
                        overlayColor: WidgetStateProperty.resolveWith<Color?>(
                          (Set<WidgetState> states) {
                            if (!states.contains(WidgetState.selected)) {
                              return colorScheme.primary.withOpacity(0.04);
                            }
                            return null;
                          },
                        ),
                        side: BorderSide(
                          color: colorScheme.primary,
                          width: 1.5,
                        ),
                        onChanged: (checked) {
                          if (validIds.isEmpty) return;
                          if (checked == true) {
                            notifier.selectAll(validIds);
                          } else {
                            notifier.deselectAll();
                          }
                        },
                      ),
                      const Text('全选当前列表'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: handleRefresh,
                      child: _buildProductList(
                        state: state,
                        products: products,
                        selectedIds: selectedIds,
                        colorScheme: colorScheme,
                        notifier: notifier,
                        context: context,
                        scrollController: scrollController,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '已选中 ',
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: '$selectedCount',
                          style: TextStyle(
                            fontSize: 15,
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: ' 个产品',
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 40,
                    child: FilledButton(
                      onPressed: handleConfirm,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(3),
                          ),
                        ),
                      ),
                      child: const Text('确定'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList({
    required ProductSelectorState state,
    required List<Sample> products,
    required Set<int> selectedIds,
    required ColorScheme colorScheme,
    required ProductSelectorNotifier notifier,
    required BuildContext context,
    required ScrollController scrollController,
  }) {
    if (state.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: MuProgressIndicator(muBarWidth: 2),
        ),
      );
    } else if (state.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '加载失败：${state.error}',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    } else if (products.isEmpty && !state.isLoading) {
      return ListView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Center(
              child:
                  Text('暂无产品', style: TextStyle(color: colorScheme.outline)),
            ),
          ),
        ],
      );
    } else {
      return ListView.separated(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: products.length + 1, // +1 用于显示加载更多或没有更多
        separatorBuilder: (_, __) => const SizedBox(height: 0),
        itemBuilder: (_, index) {
          // 最后一项显示加载更多或没有更多
          if (index >= products.length) {
            if (state.isLoadingMore) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: MuProgressIndicator(
                    muBarWidth: 4, 
                  ),
                ),
              );
            } else if (!state.hasMore && products.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    '没有更多了',
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.outline,
                    ),
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }
          final item = products[index];
          if (item.id == null) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 236, 236, 236),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(item.productNo ?? ''),
                  subtitle: Text(item.name),
                  trailing: const Text(
                    '无ID',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ),
            );
          }
          final isSelected = selectedIds.contains(item.id);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 248, 248, 248),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => notifier.toggleSelect(item.id!),
                    child: Checkbox(
                      value: isSelected,
                      checkColor: colorScheme.onPrimary,
                      fillColor: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.selected)) {
                            return colorScheme.primary;
                          }
                          return null;
                        },
                      ),
                      focusColor: colorScheme.primary,
                      hoverColor: colorScheme.primary,
                      onChanged: (_) => notifier.toggleSelect(item.id!),
                      side: BorderSide(
                        color: colorScheme.primary,
                        width: 1.5,
                      ),
                      overlayColor: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                          if (!states.contains(WidgetState.selected)) {
                            return colorScheme.primary.withOpacity(0.04);
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (item.cover != null &&
                          item.cover!.isNotEmpty &&
                          (item.cover!.startsWith('http://') ||
                              item.cover!.startsWith('https://'))) {
                        showFlanImagePreview(
                          context,
                          images: [item.cover!],
                          startPosition: 0,
                          loop: false,
                        );
                      }
                    },
                    child: SizedBox(
                      width: 70,
                      height: 70,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: _buildCover(item.cover),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => notifier.toggleSelect(item.id!),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.productNo ?? '',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.surfaceContainerHighest,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (item.purchaseCost != null &&
                      item.purchaseCost!.isNotEmpty)
                    GestureDetector(
                      onTap: () => notifier.toggleSelect(item.id!),
                      child: Text(
                        item.purchaseCost ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}

Widget _buildCover(String? url) {
  if (url == null ||
      url.isEmpty ||
      !(url.startsWith('http://') || url.startsWith('https://'))) {
    return const Icon(
      Icons.image_not_supported_outlined,
      size: 50,
      color: Color.fromARGB(255, 180, 180, 180),
    );
  }
  return Image.network(
    url,
    fit: BoxFit.cover,
    errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
  );
}
