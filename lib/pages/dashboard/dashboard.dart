import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/dashboard/widgets/entry_grid_module.dart';
import 'package:cloud/pages/dashboard/widgets/hot_product_module.dart';
import 'package:cloud/pages/dashboard/widgets/market_product_module.dart';
import 'package:cloud/pages/dashboard/widgets/quote_overview_module.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class DashboardPage extends HookConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: colorScheme.surfaceTint,
      appBar: AppBar(
        title: const Text('看板'),
        centerTitle: true,
        elevation: 0,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          children: [
            // SizedBox(height: statusBarHeight),
            EntryGridModule(),
            SizedBox(height: 12),
            HotProductModule(),
            SizedBox(height: 12),
            MarketProductModule(),
            SizedBox(height: 12),
            QuoteOverviewModule(),
          ],
        ),
      ),
    );
  }
}
