import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/quote/quote_product_add/quote_product_add_adaptive_page.dart';
import 'package:cloud/pages/quote/quote_product_ai_add/quote_product_ai_add_floor_page.dart';
import 'package:cloud/pages/quote/quote_product_ai_add/quote_product_ai_add_notepad_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class QuoteProductNewAddPage extends HookConsumerWidget {
  final int? quoteId;
  final String? supplierId;

  const QuoteProductNewAddPage({
    super.key,
    this.quoteId,
    this.supplierId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    final tabController = useTabController(initialLength: 3);

    return Scaffold(
      appBar: AppBar(
        title: const Text('添加报价产品'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        bottom: TabBar(
          controller: tabController,
          labelColor: colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: colorScheme.primary,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const [
            Tab(text: "商品图"),
            Tab(text: "白板"),
            Tab(text: "记事本"),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          QuoteProductAddAdaptivePage(
            initialMode: 0,
            supplierId: supplierId,
          ),

          // --- Tab 2: 白板 ---
          QuoteProductAiAddFloorPage(
            quoteId: quoteId,
          ),

          // --- Tab 3: 记事本 ---
          QuoteProductAiAddNotepadPage(
            quoteId: quoteId,
          ),
        ],
      ),
    );
  }
}
