import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/inspection/views/inspection_view.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class InspectionPage extends HookConsumerWidget {
  const InspectionPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final refreshFnRef = useRef<Future<void> Function()>(() async {});
    return Scaffold(
        appBar: AppBar(
          title: const Text('验货任务列表'),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          actions: [
            TextButton(
              onPressed: () {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  await refreshFnRef.value();
                });
              },
              child: const Text(
                "刷新",
                style: TextStyle(
                  color: Color(0xFF999999),
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 4),
            TextButton(
              onPressed: () async {
                final result = await context.router.push<bool>(
                  const InspectionAddRoute(),
                );
                if (result == true) {
                  await refreshFnRef.value();
                }
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
                children: [
                  InspectionView(
                    setRefreshFn: (fn) => refreshFnRef.value = fn,
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
