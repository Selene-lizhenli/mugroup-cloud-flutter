import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flant/components/image_preview.dart';
import 'package:cloud/pages/quote/batch_import/providers/product_batch_import_provider.dart';
import 'package:cloud/pages/widgets/search_bar.dart';

class ProductListSheet extends HookConsumerWidget {
  const ProductListSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productBatchImportProvider);
    final notifier = ref.read(productBatchImportProvider.notifier);
    final searchController = useTextEditingController();
    final products = state.products;
    final selectedIds = state.selected.map((e) => e.id).toSet();
    final validIds =
        products.where((s) => s.id != null).map((s) => s.id!).toList();
    final allSelected =
        validIds.isNotEmpty && validIds.every((id) => selectedIds.contains(id));
    final colorScheme = Theme.of(context).colorScheme;
    Future<void> handleSearch() async {
      await notifier.fetchProducts(search: searchController.text.trim());
    }

    final selectedCount = state.selected.length;

    void handleConfirm() {
      Navigator.pop(context);
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
                        checkColor: colorScheme.onSecondary,
                        fillColor: WidgetStateProperty.resolveWith<Color?>(
                          (Set<WidgetState> states) {
                            if (states.contains(WidgetState.selected)) {
                              return colorScheme.secondary;
                            }
                            return null;
                          },
                        ),
                        focusColor: colorScheme.secondary,
                        hoverColor: colorScheme.secondary,
                        overlayColor: WidgetStateProperty.resolveWith<Color?>(
                          (Set<WidgetState> states) {
                            if (!states.contains(WidgetState.selected)) {
                              return colorScheme.secondary.withOpacity(0.04);
                            }
                            return null;
                          },
                        ),
                        side: BorderSide(
                          color: colorScheme.secondary,
                          width: 1.5,
                        ),
                        onChanged: (checked) {
                          if (validIds.isEmpty) return;
                          final setIds = selectedIds.toSet();
                          if (checked == true) {
                            for (final s in products) {
                              if (s.id != null && !setIds.contains(s.id)) {
                                notifier.toggleSelect(s);
                              }
                            }
                          } else {
                            for (final s in products) {
                              if (s.id != null && setIds.contains(s.id)) {
                                notifier.toggleSelect(s);
                              }
                            }
                          }
                        },
                      ),
                      const Text('全选当前列表'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: _buildProductList(
                      state: state,
                      products: products,
                      selectedIds: selectedIds,
                      colorScheme: colorScheme,
                      notifier: notifier,
                      context: context,
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
                            color: colorScheme.secondary,
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
                        backgroundColor: colorScheme.secondary,
                        foregroundColor: colorScheme.onSecondary,
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
    required ProductBatchImportState state,
    required List products,
    required Set<int> selectedIds,
    required ColorScheme colorScheme,
    required ProductBatchImportNotifier notifier,
    required BuildContext context,
  }) {
    if (state.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(strokeWidth: 2),
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
    } else if (products.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('暂无产品'),
        ),
      );
    } else {
      return ListView.separated(
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(height: 0),
        itemBuilder: (_, index) {
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
                color: Color.fromARGB(255, 248, 248, 248),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => notifier.toggleSelect(item),
                    child: Checkbox(
                      value: isSelected,
                      checkColor: colorScheme.onSecondary,
                      fillColor: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.selected)) {
                            return colorScheme.secondary;
                          }
                          return null;
                        },
                      ),
                      focusColor: colorScheme.secondary,
                      hoverColor: colorScheme.secondary,
                      onChanged: (_) => notifier.toggleSelect(item),
                      side: BorderSide(
                        color: colorScheme.secondary,
                        width: 1.5,
                      ),
                      overlayColor: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                          if (!states.contains(WidgetState.selected)) {
                            return colorScheme.secondary.withOpacity(0.04);
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
                      onTap: () => notifier.toggleSelect(item),
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
                      onTap: () => notifier.toggleSelect(item),
                      child: Text(
                        item.purchaseCost ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.secondary,
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
