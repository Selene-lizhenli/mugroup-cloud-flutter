import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cloud/models/sample/quotation_sample.dart';
import 'package:cloud/pages/widgets/input.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ProductEditDialog extends HookWidget {
  final QuotationSample row;
  final int quotationId;
  const ProductEditDialog({
    super.key,
    required this.row,
    required this.quotationId,
  });

  @override
  Widget build(BuildContext context) {
    final supplierName = row.supplyQuote?.supplier?.name ?? '-';
    final colorScheme = Theme.of(context).colorScheme;
    final qty = useState(row.qty?.toString() ?? '');
    final customerPrice = useState(row.price ?? '');
    final customerProductNo = useState(row.customerProductNo ?? '');

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  '编辑产品信息',
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '供应商: $supplierName',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade700,
                    ),
              ),
              const SizedBox(height: 12),
              Input(
                label: '采购数量',
                value: qty.value,
                keyboardType: TextInputType.number,
                onChanged: (v) => qty.value = v,
              ),
              const SizedBox(height: 10),
              Input(
                label: '客户报价(JPY)',
                value: customerPrice.value,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (v) => customerPrice.value = v,
              ),
              const SizedBox(height: 10),
              Input(
                label: '客户货号(选填)',
                value: customerProductNo.value,
                onChanged: (v) => customerProductNo.value = v,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: colorScheme.onSurface,
                        backgroundColor: colorScheme.surface,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('取消',
                          style: TextStyle(color: colorScheme.primary)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        try {
                          EasyLoading.showSuccess('保存成功');
                          if (context.mounted) {
                            Navigator.of(context).pop(<String, String>{
                              'qty': qty.value,
                              'price': customerPrice.value,
                              'customer_sku': customerProductNo.value,
                            });
                          }
                        } finally {
                          EasyLoading.dismiss();
                        }
                      },
                      child: const Text('确定'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
