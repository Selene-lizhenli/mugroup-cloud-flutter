import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/home/providers/home_provider.dart';
import 'package:cloud/pages/home/views/product_view.dart';
import 'package:cloud/pages/home/views/supply_view.dart';
import 'package:cloud/pages/home/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeProvider);

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            PageView(
              controller: home.pageController,
              allowImplicitScrolling: false,
              children: const [ProductView(), SupplyView()],
            ),
            const HomeAppBar(),
          ],
        ),
      ),
    );
  }
}
