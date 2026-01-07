import 'package:cloud/pages/widgets/Input_horizontal.dart';
import 'package:flant/components/image_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/product_batch_import_provider.dart';

class SelectedProductCard extends StatelessWidget {
  final SelectedProduct item;
  final ValueChanged<String> onQtyChanged;
  final ValueChanged<String> onPriceChanged;
  final VoidCallback onDelete;

  const SelectedProductCard({
    super.key,
    required this.item,
    required this.onQtyChanged,
    required this.onPriceChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.25,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onDelete(),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: '删除',
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        decoration: BoxDecoration(
          color: colorScheme.surfaceTint.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //  图片和SKU（上下布局）
            Expanded(
              flex: 2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (item.image.isNotEmpty) {
                        showFlanImagePreview(
                          context,
                          images: [item.image],
                          startPosition: 0,
                          loop: false,
                        );
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: _buildCover(item.image),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'SKU: ${item.sku}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // 数量输入和供应商报价输入（上下布局）
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  HorizontalInput(
                    label: '数量',
                    value: item.qty,
                    keyboardType: TextInputType.number,
                    onChanged: onQtyChanged,
                    contentPaddingHorizontal: 10, 
                    contentPaddingVertical: 8, 
                  ),
                  const SizedBox(height: 12),
                  HorizontalInput(
                    label: '供应商报价 (CNY)', 
                    contentPaddingHorizontal: 10, 
                    contentPaddingVertical: 8,
                    value: item.supplierPrice,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onChanged: onPriceChanged,
                  ),
                ],
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
    return const Icon(Icons.image_not_supported_outlined,size: 50,color: Colors.grey,);
  }
  return Image.network(
    url,
    fit: BoxFit.cover,
    errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
  );
}


