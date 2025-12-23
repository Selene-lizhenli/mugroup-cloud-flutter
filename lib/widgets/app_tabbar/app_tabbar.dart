import 'package:auto_route/auto_route.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';

class AppTabbar extends StatelessWidget {
  AppTabbar({super.key});

  final routes = [const HomeRoute(), const CartRoute()];

  @override
  Widget build(BuildContext context) {
    var router = context.router;
    const routes = [HomeRoute(), CartRoute(), MyRoute()];
    final currentIndex =
        routes.indexWhere((item) => item.routeName == router.current.name);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex < 0 ? 0 : currentIndex,
      onTap: (value) {
        router.replace(routes[value]);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "样品"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "我的"),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "选样车"),
      ],
    );
  }
}
