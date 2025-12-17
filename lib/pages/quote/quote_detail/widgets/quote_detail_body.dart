import 'package:cloud/models/quote/quotation_list.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/base_info_section.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/export_section.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/product_section.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/supplier_section.dart';
import 'package:flutter/material.dart';

class QuoteDetailBody extends StatelessWidget {
  final QuotationList? item;

  const QuoteDetailBody({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    if (item == null) {
      return const Center(child: Text('无详情数据'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ExportActionBar(item: item),
          const SizedBox(height: 12),
          BaseInfoSection(item: item),
          const SizedBox(height: 12),
          ProductSection(quoteId: item!.id),
          const SizedBox(height: 12),
          SupplierSection(quoteId: item!.id),
        ],
      ),
    );
  }
}
