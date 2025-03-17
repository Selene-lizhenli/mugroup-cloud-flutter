import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WmsTransferConfirmCard extends HookConsumerWidget {
  final Widget? child;

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const WmsTransferConfirmCard(
      {super.key, this.child, this.margin, this.padding});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      margin: margin ?? const EdgeInsets.all(1),
      padding: padding ?? const EdgeInsets.all(10),
      child: child,
    );
  }
}
