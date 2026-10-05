import 'package:cloud/pages/widgets/input.dart';
import 'package:flant/components/image_preview.dart';
import 'package:flant/components/stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
      key: ValueKey(item.sku),
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
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceTint.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  width: 90,
                  height: 90,
                  child: _buildCover(item.image),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'SKU: ${item.sku}',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Input(
                          label: '供应商报价(CNY)',
                          value: item.purchaseCost ?? '',
                          keyboardType: TextInputType.number,
                          onChanged: onPriceChanged,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // 数量部分：label 和 FlanStepper 竖向排列
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '数量',
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey.shade700),
                          ),
                          const SizedBox(height: 8),
                          Transform.scale(
                            scale: 1.1,
                            child: FlanStepper(
                              value: int.tryParse(item.qty) ?? 1,
                              min: 1,
                              onChange: (v, _) {
                                final qtyStr =
                                    v is int ? v.toString() : v.toString();
                                // 延迟更新，避免在构建期间修改 provider
                                Future.microtask(() {
                                  onQtyChanged(qtyStr);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      // 供应商报价部分：横向排列
                    ],
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
    return Container(
      color: Colors.grey[200],
      child: const Icon(Icons.image_not_supported_outlined,
          size: 30, color: Colors.grey),
    );
  }
  return Image.network(
    url,
    fit: BoxFit.cover,
    errorBuilder: (_, __, ___) => Container(
        color: Colors.grey[200],
        child: const Icon(Icons.broken_image, size: 30, color: Colors.grey)),
  );
}
