import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flant/components/image_preview.dart';
import 'package:cloud/pages/quote/batch_import/providers/product_batch_import_provider.dart';

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

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text(
                  '选择产品',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => handleSearch(),
                    decoration: InputDecoration(
                      hintText: '搜索产品编码/名称',
                      prefixIcon: const Icon(Icons.search),
                      isDense: true,
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: handleSearch,
                  child: const Text('搜索'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Checkbox(
                  value: allSelected && validIds.isNotEmpty,
                  focusColor: colorScheme.primary,
                  hoverColor: colorScheme.primary,
                  checkColor: Colors.white,
                  overlayColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                      return colorScheme.outlineVariant;
                    },
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
            if (state.isLoading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else if (state.error != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '加载失败：${state.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              )
            else if (products.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('暂无产品'),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: products.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, index) {
                    final item = products[index];
                    if (item.id == null) {
                      return ListTile(
                        title: Text(item.productNo ?? ''),
                        subtitle: Text(item.name),
                        trailing: const Text(
                          '无ID',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      );
                    }
                    final isSelected = selectedIds.contains(item.id);
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => notifier.toggleSelect(item),
                            child: Checkbox(
                              value: isSelected,
                              checkColor: Colors.white,
                              onChanged: (_) => notifier.toggleSelect(item),
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
                              width: 60,
                              height: 60,
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
                                      color:
                                          colorScheme.surfaceContainerHighest,
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
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
        
          ],
        ),
      ),
    );
  }
}

Widget _buildCover(String? url) {
  if (url == null ||
      url.isEmpty ||
      !(url.startsWith('http://') || url.startsWith('https://'))) {
    return const Icon(Icons.image_not_supported_outlined,size:60,color: Color.fromARGB(255, 129, 129, 129),);
  }
  return Image.network(
    url,
    fit: BoxFit.cover,
    errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
  );
}
