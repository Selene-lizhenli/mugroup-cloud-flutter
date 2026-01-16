import 'package:cloud/pages/quote/quote_detail/providers/quote_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cloud/models/sample/quotation_sample.dart';
import 'package:cloud/pages/widgets/input.dart';
import 'package:cloud/providers/exchange.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductEditDialog extends HookConsumerWidget {
  final QuotationSample row;
  final int quotationId;
  const ProductEditDialog({
    super.key,
    required this.row,
    required this.quotationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shortName = row.supplyQuote?.supplier?.shortName ?? '-';
    final colorScheme = Theme.of(context).colorScheme;
    final exchangeNotifier = ref.read(exchangeProvider.notifier);
    final exchangeAsync = ref.watch(exchangeProvider);
    final quotationInfo = ref.watch(quoteDetailProvider);
    final currency = quotationInfo.baseInfo?.curreny ?? ''; //报价单货币
    final isConverting = useState(false);

    final shippingQty = useState(row.qty?.toString() ?? ''); //采购数量
    final supplierPrice = useState(row.price?.toString() ?? ''); //供应商报价
    final customerPrice = useState<String>(
        row.supplyQuote?.customerPrice?.toString() ?? ''); //客户报价
    final internalSku = useState(row.supplyQuote?.internalSku ?? ''); //公司货号
    final supplierSku = useState(row.supplyQuote?.supplierSku ?? ''); //供应商货号
    final customerSku = useState(row.supplyQuote?.customerSku ?? ''); //客户货号

    // 页面加载后，如果供应商报价不为空且客户报价为空，自动换算
    useEffect(() {
      final initialPurchaseCost = supplierPrice.value.trim();
      final initialCustomerPrice = customerPrice.value.trim();

      // 判断条件：供应商报价不为空且客户报价为空
      if (initialPurchaseCost.isNotEmpty && initialCustomerPrice.isEmpty) {
        final purchaseValue = double.tryParse(initialPurchaseCost);
        if (purchaseValue != null && purchaseValue > 0 && currency.isNotEmpty) {
          // 货币数据已经加载完成，直接进行换算
          exchangeAsync.whenData((rates) {
            if (rates.isNotEmpty) {
              final converted = exchangeNotifier.convertCurrency(
                purchaseValue,
                'CNY',
                currency,
              );
              if (converted != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  customerPrice.value = converted.toStringAsFixed(2);
                });
              }
            }
          });
        }
      }
      return null;
    }, [exchangeAsync, currency, supplierPrice]);

    // 供应商报价变化时，自动计算客户报价
    void onPurchaseCostChanged(String value) {
      supplierPrice.value = value;
      if (isConverting.value) return; // 防止循环更新

      final purchaseValue = double.tryParse(value);
      if (purchaseValue == null || purchaseValue == 0) {
        customerPrice.value = '';
        return;
      }
      if (currency.isEmpty) {
        // 如果没有货币信息，直接使用供应商报价
        customerPrice.value = value;
        return;
      }

      exchangeAsync.when(
        data: (rates) {
          if (rates.isEmpty) {
            customerPrice.value = value;
            return;
          }

          // 供应商报价是CNY，需要转换为报价单货币
          final converted = exchangeNotifier.convertCurrency(
            purchaseValue,
            'CNY',
            currency,
          );

          if (converted != null) {
            isConverting.value = true;
            customerPrice.value = converted.toStringAsFixed(2);
            Future.microtask(() => isConverting.value = false);
          } else {
            // 如果换算失败，直接使用供应商报价
            customerPrice.value = value;
          }
        },
        loading: () {
          // 加载中时，不进行换算
        },
        error: (_, __) {
          // 如果加载失败，直接使用供应商报价
          customerPrice.value = value;
        },
      );
    }

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
                '供应商：$shortName',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade700,
                    ),
              ),
              const SizedBox(height: 12),
              Input(
                label: '采购数量',
                value: shippingQty.value,
                keyboardType: TextInputType.number,
                onChanged: (v) => shippingQty.value = v,
              ),
              const SizedBox(height: 10),
              Input(
                label: '供应商报价 (CNY)',
                value: supplierPrice.value,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: onPurchaseCostChanged,
              ),
              const SizedBox(height: 10),
              Input(
                label: '客户报价（$currency）',
                value: customerPrice.value,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (v) => customerPrice.value = v,
              ),
              const SizedBox(height: 10),
              Input(
                label: '公司货号',
                value: internalSku.value,
                onChanged: (v) => internalSku.value = v,
              ),
              const SizedBox(height: 10),
              Input(
                label: '供应商货号',
                value: supplierSku.value,
                onChanged: (v) => supplierSku.value = v,
              ),
              const SizedBox(height: 10),
              Input(
                label: '客户货号 (选填)',
                value: customerSku.value,
                onChanged: (v) => customerSku.value = v,
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
                              'shipping_qty': shippingQty.value,
                              'purchase_cost': supplierPrice.value,
                              'customer_price': customerPrice.value,
                              'internal_sku': internalSku.value,
                              'supplier_sku': supplierSku.value,
                              'customer_sku': customerSku.value,
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
