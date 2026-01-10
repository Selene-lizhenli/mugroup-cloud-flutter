import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cloud/models/sample/quotation_sample.dart';
import 'package:cloud/pages/widgets/input.dart';
import 'package:cloud/services/quotation_list.dart';
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
    final sample = row.showroomSample;
    final supplierName = row.supplyQuote?.supplier?.name ?? '-';
    final colorScheme = Theme.of(context).colorScheme;
    final qty = useState(row.qty?.toString() ?? '');
    final supplierPrice = useState(row.supplyQuote?.purchaseCost ?? '');
    final customerPrice = useState(row.price ?? '');
    final companyNo = useState(sample?.productNo ?? '');
    final supplierProductNo =
        useState(row.supplyQuote?.supplierProductNo ?? '');
    final customerProductNo =
        useState(row.supplyQuote?.supplier?.supplierNo ?? '');

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
                label: '供应商报价(CNY)',
                value: supplierPrice.value,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (v) => supplierPrice.value = v,
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
                label: '公司货号',
                value: companyNo.value,
                onChanged: (v) => companyNo.value = v,
              ),
              const SizedBox(height: 10),
              Input(
                label: '供应商货号',
                value: supplierProductNo.value,
                onChanged: (v) => supplierProductNo.value = v,
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
                          style: TextStyle(color: colorScheme.secondary)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.secondary,
                        foregroundColor: colorScheme.onSecondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        final sampleId = row.showroomSample?.id;
                        if (sampleId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('产品ID不能为空')),
                          );
                          return;
                        }

                        EasyLoading.show(status: '保存中...');
                        try {
                          final qtyValue = int.tryParse(qty.value) ?? 1;

                          final data = {
                            'quotation_id': quotationId,
                            'sample_items': [
                              {
                                'sample_id': sampleId,
                                'qty': qtyValue,
                                // TODO: 如果需要传递其他字段，在这里添加
                                // 'supplier_price': double.tryParse(supplierPrice.value),
                                // 'customer_price': double.tryParse(customerPrice.value),
                              }
                            ],
                          };

                          final result = await addQuotationSamples(data);
                          EasyLoading.dismiss();

                          if (result) {
                            EasyLoading.showSuccess('保存成功');
                            if (context.mounted) {
                              Navigator.of(context).pop(<String, String>{
                                'qty': qty.value,
                                'supplierPrice': supplierPrice.value,
                                'customerPrice': customerPrice.value,
                                'companyNo': companyNo.value,
                                'supplierProductNo': supplierProductNo.value,
                                'customerProductNo': customerProductNo.value,
                              });
                            }
                          } else {
                            EasyLoading.showError('保存失败');
                          }
                        } catch (e) {
                          EasyLoading.dismiss();
                          EasyLoading.showError('保存失败：$e');
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
