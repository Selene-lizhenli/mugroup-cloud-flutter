import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/quote/quotation_list.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/baseInfo/base_info_section.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/export/export_section.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/product/product_section.dart';
import 'package:cloud/pages/widgets/confirm_dialog.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';

class QuoteDetailBody extends StatelessWidget {
  final QuotationList? item;

  const QuoteDetailBody({super.key, this.item});

  Future<void> _handleEdit(BuildContext context) async {
    if (item == null || item!.id == null) return;
    // 跳转到报价单创建页面（编辑模式），传递报价单ID
    context.router.push(QuoteCreateRoute(quoteId: item!.id));
  }

  Future<void> _handleDelete(BuildContext context) async {
 
    final confirmed = await ConfirmDialog.show(
      context,
      title: '提示',
      content: '抱歉，目前暂时不支持报价单删除操作。',
      cancelText: '取消',
      confirmText: '确定',
    );
    if (confirmed && context.mounted) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (item == null) {
      return const Center(child: Text('无详情数据'));
    }
    return Scaffold(
      body: Column(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(12,0, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ExportActionBar(item: item),
                const SizedBox(height: 12),
                BaseInfoSection(                                                                                                                                                                                                                     
                  item: item,
                  onEdit: () => _handleEdit(context),
                  onDelete: () => _handleDelete(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(                                                                                                                                                                                                                                                                                                                                                                                                              
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ProductSection(quoteId: item!.id),
            ),
          ),
        ],
      ),
    );
  }
}
