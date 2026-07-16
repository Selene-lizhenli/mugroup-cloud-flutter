import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class MarketProductPage extends HookConsumerWidget {
  const MarketProductPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = [
      const BottomNavigationBarItem(icon: Icon(Icons.home, size: 22), label: "市场产品"),
      const BottomNavigationBarItem(
          icon: Icon(Icons.assignment_outlined, size: 22), label: "带客记录"),
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