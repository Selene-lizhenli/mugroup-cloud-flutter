import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class MarketProductPage extends HookConsumerWidget {
  const MarketProductPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: "首页"),
      const BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: "报价单"),
      const BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline), label: "验货"),
    ];
    return AutoTabsRouter(
      builder: (context, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: context.tabsRouter.activeIndex,
            onTap: (index) {
              context.tabsRouter.setActiveIndex(index);
            },
            items: items,
          ),
        );
      },
    );
  }
}
