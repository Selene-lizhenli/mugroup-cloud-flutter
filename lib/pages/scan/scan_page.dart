import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

@RoutePage()
class ScanPage extends HookConsumerWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("扫一扫"),
      ),
      body: MobileScanner(
        onDetect: (barcodes) {
          final codes = <String>[];

          for (var element in barcodes.barcodes) {
            final value = element.displayValue;
            if (value != null) {
              codes.add(value.trim());
            }
          }

          if (codes.isNotEmpty) {
            context.router.maybePop<List<String>>(codes);
          }
        },
      ),
    );
  }
}
