import 'package:auto_route/auto_route.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          var router = context.router;
          const routes = [HomeRoute(), CartRoute()];

          router.replace(routes[value]);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "首页"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: "选样车"),
        ],
      ),
    );
  }
}
