import 'package:auto_route/auto_route.dart';
import 'package:cloud/widgets/wigets.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SafeArea(
        child: Text("首页"),
      ),
      bottomNavigationBar: AppTabbar(),
    );
  }
}
