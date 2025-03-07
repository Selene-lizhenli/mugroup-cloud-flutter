import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class WmsTransferPage extends HookConsumerWidget {
  final String code;

  const WmsTransferPage({super.key, @pathParam required this.code});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [Text("调拨单$code")],
        ),
      ),
    );
  }
}
