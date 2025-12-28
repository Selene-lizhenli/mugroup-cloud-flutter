import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class SamplesPage extends HookConsumerWidget {
  const SamplesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: "样品"),
      const BottomNavigationBarItem(
          icon: Icon(Icons.assignment_outlined), label: "选样车"),
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
