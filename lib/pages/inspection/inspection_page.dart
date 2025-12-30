import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/inspection/views/inspection_view.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class InspectionPage extends HookConsumerWidget {
  const InspectionPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: AppBar(
          title: const Text('验货任务列表'),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          actions: [
            TextButton(
              onPressed: () {
                context.router.push(const InspectionAddRoute());
              },
              child: Text(
                "新增",
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 4),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: PageView(
                allowImplicitScrolling: false,
                children: const [InspectionView()],
              ),
            ),
          ],
        ));
  }
}
