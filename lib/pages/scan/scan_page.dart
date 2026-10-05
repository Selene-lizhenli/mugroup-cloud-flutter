import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

@RoutePage()
class ScanPage extends HookConsumerWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final didPop = useRef(false);
    final controller = useMemoized(
      () => MobileScannerController(
        detectionSpeed: DetectionSpeed.noDuplicates,
      ),
    );

    useEffect(() {
      return controller.dispose;
    }, [controller]);

    return Scaffold(
      appBar: AppBar(
        title: const Text("扫一扫"),
      ),
      body: MobileScanner(
        controller: controller,
        onDetect: (barcodes) async {
          if (didPop.value) {
            return;
          }
          final codes = <String>[];

          for (var element in barcodes.barcodes) {
            final value = element.displayValue;
            if (value != null) {
              codes.add(value.trim());
            }
          }

          if (codes.isNotEmpty) {
            didPop.value = true;
            await controller.stop();
            if (context.mounted && context.router.canPop()) {
              await context.router.maybePop<List<String>>(codes);
            }
          }
        },
      ),
    );
  }
}
