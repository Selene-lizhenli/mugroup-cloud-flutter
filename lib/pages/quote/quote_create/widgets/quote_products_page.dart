import 'package:cloud/pages/quote/quote_create/provider/quote_create_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class QuoteProductsPage extends ConsumerWidget {
  const QuoteProductsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    final state = ref.watch(quoteCreateProvider);
    final notifier = ref.read(quoteCreateProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              _HeaderCard(),

              const SizedBox(height: 12),

              // ================= 主体（左右两列） =================
              Expanded(
                child: Row(
                  children: [
                    // 左：产品列表
                    Expanded(
                      flex: 3,
                      child: _buildBody(context, state, colorScheme),
                    ),
                    const SizedBox(width: 12),
                    // 右：供应商列表
                    // Expanded(
                    //   flex: 2,
                    //   child: _buildBody(context, state, colorScheme),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // ===== 第一行：标题 + 操作按钮 =====
            Row(
              children: [
                // const Icon(Icons.shopping_cart_outlined, size: 18),
                const SizedBox(width: 6),
                const Text(
                  '报价产品',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.upload, size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          "批量导入",
                          style: TextStyle(
                            color: colorScheme.onPrimary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.secondary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.add, size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          "新增产品",
                          style: TextStyle(
                            color: colorScheme.onSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(height: 1),

            // ===== 第二行：切换提示 =====
            const Row(
              children: [
                Icon(Icons.store_mall_directory_outlined, size: 16),
                SizedBox(width: 4),
                Text('供应商列表/验货'),
                Spacer(),
                Icon(Icons.list_alt_outlined, size: 16),
                SizedBox(width: 4),
                Text(
                  '产品清单',
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildBody(
  BuildContext context,
  QuoteCreateState state,
  ColorScheme colorScheme,
) {
  if (state.productList.isEmpty) {
    return Center(
        child: Text(
      '暂无产品',
      style: TextStyle(color: colorScheme.surfaceContainerHighest),
    ));
  }

  return ListView.separated(
    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
    itemCount: state.productList.length,
    separatorBuilder: (_, __) => const SizedBox(height: 10),
    itemBuilder: (context, index) {
      final row = state.productList[index];
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
            Container(
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
            ),

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
            // if (row.qty != null)
            //   Column(
            //     children: [
            //       Text(
            //         'x${row.qty}',
            //         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            //               color: colorScheme.secondary,
            //               fontWeight: FontWeight.w600,
            //             ),
            //       ),
            //     ],
            //   ),
          ],
        ),
      );
    },
  );
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
