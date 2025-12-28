import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/dashboard/widgets/banner_carousel.dart';
import 'package:cloud/pages/dashboard/widgets/entry_grid_module.dart';
import 'package:cloud/pages/dashboard/widgets/home_top_summary_card.dart';
import 'package:cloud/pages/dashboard/widgets/home_user_header.dart';
import 'package:cloud/pages/dashboard/widgets/hot_product_module.dart';
import 'package:cloud/pages/dashboard/widgets/market_product_module.dart';
import 'package:cloud/pages/dashboard/widgets/quote_overview_module.dart';
import 'package:cloud/pages/dashboard/widgets/selected_modules_widget.dart';
import 'package:cloud/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class DashboardPage extends HookConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceTint,
        ),
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            const HomeUserHeader(),
            const SizedBox(height: 12),
            const EntryGridModule(),
            const SizedBox(height: 12),
            const SelectedModulesWidget(),
          ],
        ),
      ),
    );
  }
}
