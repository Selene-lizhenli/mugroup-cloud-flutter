import 'package:auto_route/auto_route.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: const BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          child: const Text(
            "敬请期待",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Text("测试"),
        onPressed: () {
          context.pushRoute(WmsTransferRoute(code: 'SF202503070012'));
        },
      ),
    );
  }
}
