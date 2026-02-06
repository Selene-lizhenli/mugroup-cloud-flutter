import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/quote/quotation_list.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/baseInfo/base_info_section.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/product/product.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/quotation_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class QuoteDetailBody extends StatelessWidget {
  final QuotationList? item;

  const QuoteDetailBody({super.key, this.item});

  Future<void> _handleEdit(BuildContext context) async {
    if (item == null || item!.id == null) return;
    // 跳转到报价单创建页面（编辑模式），传递报价单ID
    context.router.push(QuoteCreateRoute(quoteId: item!.id));
  }

  Future<void> _handleDelete(BuildContext context) async {
    if (item?.id == null) return;
    await deleteQuotation(item!.id!);
    EasyLoading.showSuccess('删除成功');
    // 通知上一个页面执行刷新逻辑
    context.router.maybePop(true);
  }

  @override
  Widget build(BuildContext context) {
    if (item == null) {
      return const Center(child: Text('无详情数据'));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              BaseInfoSection(
                item: item,
                onEdit: () => _handleEdit(context),
                onDelete: () => _handleDelete(context),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ProductSection(quoteId: item!.id),
        ),
      ],
    );
  }
}
