import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ConfirmCard extends HookConsumerWidget {
  final Widget child;

  const ConfirmCard({super.key, required this.child});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(6),
      child: child,
    );
  }
}
