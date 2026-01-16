import 'package:cloud/models/quote/quote_supplier_group.dart';
import 'package:cloud/models/sample/quotation_sample.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/supplier/supplier_card.dart'; 
import 'package:flutter/material.dart';

class SupplierListWidget extends StatelessWidget {
  final List<QuoteSupplierGroup> suppliers;
  final List<QuotationSample> products;
  final Set<int> selectedSupplierIds;
  final ValueChanged<int?> onSupplierToggle;
  final ValueChanged<QuoteSupplierGroup>? onSupplierTap;

  const SupplierListWidget({
    super.key,
    required this.suppliers,
    required this.products,
    required this.selectedSupplierIds,
    required this.onSupplierToggle,
    this.onSupplierTap,
  });

  // 计算供应商的总金额（EUR）
  double _calculateTotalAmount(QuoteSupplierGroup supplier) {
    if (supplier.supplier?.id == null) return 0.0;
    
    double total = 0.0;
    for (final product in products) {
      if (product.supplyQuote?.supplierId == supplier.supplier?.id) {
        final price = double.tryParse(product.price ?? '0') ?? 0.0;
        final qty = product.qty ?? 0;
        total += price * qty;
      }
    }
    return total;
  }

  // 获取当前供应商下第一个产品的 ID，作为“当前产品 id”
  int? _findFirstProductIdForSupplier(QuoteSupplierGroup supplier) {
    if (supplier.supplier?.id == null) return null;
    for (final product in products) {
      if (product.supplyQuote?.supplierId == supplier.supplier?.id) {
        return product.id;
      }
    }
    return null;
  }

  // 计算总的产品种类数
  int _calculateTotalProductTypes() {
    return suppliers.fold(0, (sum, supplier) => sum + (supplier.count ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    if (suppliers.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            '暂无供应商数据',
            style: TextStyle(color: colorScheme.surfaceContainerHighest),
          ),
        ),
      );
    }

    final totalProductTypes = _calculateTotalProductTypes();

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: suppliers.length + 1, // +1 for summary footer
      separatorBuilder: (context, index) {
        // 如果是最后一项（汇总信息），不需要分隔符
        if (index == suppliers.length - 1) {
          return const SizedBox(height: 12);
        }
        // 如果是汇总信息项之前，添加分隔符
        if (index == suppliers.length) {
          return const SizedBox.shrink();
        }
        return const SizedBox(height: 12);
      },
      itemBuilder: (context, index) {
        // 如果是最后一项，显示汇总信息
        if (index == suppliers.length) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: colorScheme.outlineVariant.withOpacity(0.5),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '共${suppliers.length}个供应商, $totalProductTypes种产品',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }

        final supplier = suppliers[index];
        final supplierId = supplier.supplier?.id;
        final isSelected = supplierId != null && selectedSupplierIds.contains(supplierId);
        final totalAmount = _calculateTotalAmount(supplier);
        final productId = _findFirstProductIdForSupplier(supplier);

        return QuoteListSupplierCard(
          supplier: supplier,
          totalAmount: totalAmount,
          isSelected: isSelected,
          onToggle: () => onSupplierToggle(supplierId),
          onTap: onSupplierTap != null
              ? () => onSupplierTap!(supplier)
              : null,
          productId: productId,
        );
      },
    );
  }
}

