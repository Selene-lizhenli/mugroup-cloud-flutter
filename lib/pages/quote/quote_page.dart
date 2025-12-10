import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:auto_route/auto_route.dart';

const pageSize = 20;

@RoutePage()
class QuotePage extends HookConsumerWidget {
  const QuotePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surface, // ← 你想要的颜色
        title: const Text("报价单列表"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset(
              'assets/coming.png',
              width: 180,
              height: 180,
              fit: BoxFit.contain,
            ),
            Text(
              '敬请期待',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.surfaceContainerHighest,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
