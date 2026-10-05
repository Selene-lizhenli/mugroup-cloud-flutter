import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SampleCard extends HookConsumerWidget {
  final Widget? child;

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  final Color? color;

  const SampleCard(
      {super.key, this.child, this.margin, this.padding, this.color});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: color ?? Colors.white,
      ),
      margin: margin ?? const EdgeInsets.all(10),
      padding: padding ?? const EdgeInsets.all(10),
      child: child,
    );
  }
}
