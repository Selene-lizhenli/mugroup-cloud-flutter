import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cloud/models/sample/quotation_sample.dart';
import 'package:cloud/pages/widgets/input.dart';

class ProductEditDialog extends HookWidget {
  final QuotationSample row;
  const ProductEditDialog({super.key, required this.row});

  @override
  Widget build(BuildContext context) {
    final sample = row.showroomSample;
    final supplierName = row.supplyQuote?.supplier?.name ?? '-';

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
              Center(
                child: Text(
                  '编辑产品信息',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.red.shade400,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '供应商: $supplierName',
                style: Theme.of(context).textTheme.bodyMedium,
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
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('取消'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.of(context).pop(<String, String>{
                          'qty': qty.value,
                          'supplierPrice': supplierPrice.value,
                          'customerPrice': customerPrice.value,
                          'companyNo': companyNo.value,
                          'supplierProductNo': supplierProductNo.value,
                          'customerProductNo': customerProductNo.value,
                        });
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
