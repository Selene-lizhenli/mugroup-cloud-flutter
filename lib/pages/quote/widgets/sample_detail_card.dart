import 'package:auto_route/auto_route.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/sample/quotation_sample.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/product/product_edit_dialog.dart';
import 'package:cloud/pages/widgets/confirm_dialog.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/quotation_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

/// 样品详情卡片组件
///
/// 用于显示样品的基本信息，包括产品图片、公司货号、客户报价、供应商报价和采购数量
class ProductDetailCard extends StatelessWidget {
  /// 样品ID，用于点击后导航到详情页
  final int? sampleId;

  /// 公司货号
  final QuotationSample? data;

  /// 产品图片URL
  final String? imageUrl;
  final int? quoteId;

  /// 自定义点击回调，如果提供则使用此回调，否则使用默认的路由导航
  final VoidCallback? onTap;
  //删除之后的回调
  final Function? refreshCallback;

  final bool? supplierShow;

  const ProductDetailCard({
    super.key,
    this.sampleId,
    required this.data,
    this.onTap,
    this.imageUrl,
    this.quoteId,
    this.supplierShow,
    this.refreshCallback,
  });

  @override
  Widget build(BuildContext context) {
    final sample = data?.showroomSample;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final imageUrlDefault = sample?.image?.isNotEmpty == true
        ? sample!.image!.first.thumbUrl
        : null;
    final id = sample?.id;

    final supplierNo = data?.supplyQuote?.supplier?.supplierNo ?? '';
    final supplierName = data?.supplyQuote?.supplier?.name ?? '';
    final supplierDisplay = supplierNo.isNotEmpty
        ? '供应商:$supplierNo'
        : (supplierName.isNotEmpty ? '供应商:$supplierName' : '供应商:-');

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorScheme.outlineVariant.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== 供应商信息和操作按钮 =====
          Row(
            children: [
              Text(
                supplierShow == true
                    ? supplierDisplay
                    : sample?.productNo ?? '',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  color: colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () async {
                  await _handleEditProduct(
                    context: context,
                    quoteId: quoteId,
                    data: data,
                    onRefresh: refreshCallback,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // 移除产品
              InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () async {
                  await _handleDeleteProduct(context, id, refreshCallback);
                },
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // ===== 产品信息 =====
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: onTap ??
                  () {
                    if (sampleId == null && id == null) return;
                    if (!context.mounted) return;
                    logger.d('ididdi${sampleId }${id}');
                    context.router
                        .push(ShowroomSampleDetailRoute(id: sampleId ?? id!));
                  },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== 产品图片 =====
                  _ProductImage(imageUrl: imageUrl ?? imageUrlDefault),
                  const SizedBox(width: 12),
                  // ===== 产品信息 =====
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _KeyValue(
                          label: '公司货号',
                          value:
                              (data?.supplyQuote?.internalSku ?? 0).toString(),
                          highlight: false,
                        ),
                        const SizedBox(height: 4),
                        _KeyValue(
                          label: '客户报价(CNY)',
                          value: (data?.supplyQuote?.customerPrice ?? 0)
                              .toString(),
                          highlight: false,
                        ),
                        const SizedBox(height: 4),
                        _KeyValue(
                          label: '供应商报价(CNY)',
                          value:
                              (data?.price ?? 0).toString(),
                          highlight: false,
                        ),
                        const SizedBox(height: 4),
                        _KeyValue(
                          label: '采购数量',
                          value:
                              (data?.qty ?? 0).toString(),
                          highlight: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _handleDeleteProduct(
      BuildContext context, int? productId, Function? onRefresh) async {
    if (productId == null) return;
    final confirmed = await ConfirmDialog.show(
      context,
      title: '确认删除',
      content: '确定要删除该产品吗？',
      cancelText: '取消',
      confirmText: '确定',
    );
    if (!confirmed || !context.mounted) return;

    EasyLoading.show(status: '删除中...');
    final params = {
      'ids': [productId],
      "quotation_id": quoteId,
    };
    logger.d('${params}params');
    try {
      await removeQuotationSamples(params);
      EasyLoading.showSuccess('删除成功');
      if (onRefresh != null) onRefresh();
    } catch (e) {
      EasyLoading.showError('删除失败：$e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  /// 处理编辑产品
  Future<void> _handleEditProduct({
    required BuildContext context,
    required int? quoteId,
    required QuotationSample? data,
    required Function? onRefresh,
  }) async {
    if (quoteId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('报价单ID不能为空')),
      );
      return;
    }
    final Map<String, String>? editData = await showDialog(
      context: context,
      builder: (_) => ProductEditDialog(
        row: data!,
        quotationId: quoteId,
      ),
    );

    if (editData != null && data != null) {
      final values = {
        "supply_quote": {
          "shipping_qty": editData['shipping_qty'],
          "purchase_cost": editData['purchase_cost'],
          "customer_price": editData['customer_price'],
          "internal_sku": editData['internal_sku'],
          "supplier_sku": editData['supplier_sku'],
          "customer_sku": editData['customer_sku']
        }
      };

      await updateShowroomQuotationSample(data.id!, values);
      if (onRefresh != null) onRefresh();
    }
  }
}

/// 产品图片组件
class _ProductImage extends StatelessWidget {
  final String? imageUrl;

  const _ProductImage({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      clipBehavior: Clip.hardEdge,
      child: imageUrl != null
          ? Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image_not_supported, size: 24),
                      SizedBox(height: 4),
                      Text(
                        'IMAGE\nNOT AVAILABLE',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 8),
                      ),
                    ],
                  ),
                );
              },
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_not_supported,
                      size: 24, color: colorScheme.outline),
                  const SizedBox(height: 4),
                  Text(
                    'IMAGE NOT AVAILABLE',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 8, color: colorScheme.outline),
                  ),
                ],
              ),
            ),
    );
  }
}

/// 键值对显示组件
class _KeyValue extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;
  final bool priceStyle;

  const _KeyValue({
    required this.label,
    required this.value,
    this.highlight = false,
    this.priceStyle = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
      text: TextSpan(
        style: theme.textTheme.bodySmall,
        children: [
          TextSpan(
            text: '$label: ',
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              fontSize: 12,
              color: priceStyle
                  ? colorScheme.primary
                  : (highlight ? colorScheme.primary : colorScheme.onSurface),
              fontWeight: (priceStyle || highlight)
                  ? FontWeight.w600
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
