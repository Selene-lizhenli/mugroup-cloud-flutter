import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ConfirmTabbar extends HookConsumerWidget {
  const ConfirmTabbar({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 60,
      color: Colors.white,
      child: const Row(
        children: [Text('确认')],
      ),
    );
  }
}
