import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class AdviceCollectPage extends HookConsumerWidget {
  const AdviceCollectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('待上架页面'),
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: const Center(
          child: Text('暂未开放'),
        ));
  }
}
