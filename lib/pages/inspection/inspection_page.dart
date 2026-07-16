import 'package:auto_route/auto_route.dart';
import 'package:cloud/constants/theme_config.dart';
import 'package:cloud/l10n/l10n_extension.dart';
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
    final paddingTop = MediaQuery.of(context).padding.top; //刘海屏高度
    final l10n = context.l10n;

    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('${l10n.dashboardInspection} ${l10n.tasks}'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color.fromARGB(255, 35, 35, 35),
        actions: [
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
              "+${l10n.newlyAdded}",
              style: TextStyle(
                color: colorScheme.secondary,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Container(
              // color: colorScheme.surface,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, // 起点：右上角
                  end: Alignment.bottomCenter, // 终点：左下角
                  colors: [
                    Color.lerp(
                      colorScheme.secondary,
                      colorScheme.surface,
                      0.65,
                    )!,
                    colorScheme.surface,
                    colorScheme.surface,
                    colorScheme.surface,
                  ],
                  stops: const [0.0, 0.22, 0.32, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topRight,
              child: Image.asset(
                'assets/element/inspection.png',
                fit: BoxFit.contain,
                width: 220,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: paddingTop + appbarHeight,
            ),
            child: Column(
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
            ),
          ),
        ],
      ),
    );
  }
}
