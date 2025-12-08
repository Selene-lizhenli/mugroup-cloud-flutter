import 'package:auto_route/auto_route.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class SupplySupplierDetailPage extends HookConsumerWidget {
  final int id;
  const SupplySupplierDetailPage({super.key, @pathParam required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final items = [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: "供应商"),
      const BottomNavigationBarItem(icon: Icon(Icons.people), label: "联系人列表"),
      const BottomNavigationBarItem(icon: Icon(Icons.view_list), label: "产品列表"),
    ];

    return AutoTabsRouter(
      builder: (context, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          appBar: AppBar(
            title: const Text("供应商详情"),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            actions: [
              TextButton(
                onPressed: () {
                  context.router.push(SupplySupplierEditRoute(id: id));
                },
                child: Text(
                  "编辑",
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),
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
