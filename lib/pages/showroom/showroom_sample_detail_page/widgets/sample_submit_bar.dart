import 'package:flant/flant.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SampleSubmitBar extends HookConsumerWidget {
  const SampleSubmitBar({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.6),
            width: 0.5,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: SafeArea(
        top: false,
        bottom: true,
        child: Row(
          children: [
            const SubmitIcon("供应商"),
            const SizedBox(width: 5),
            const SubmitIcon("购物车"),
            const Spacer(),
            FlanButton(
              round: true,
              size: FlanButtonSize.small,
              color: colorScheme.secondary,
              child: const Text(
                "加入选样车",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SubmitIcon extends StatelessWidget {
  final String label;
  const SubmitIcon(
    this.label, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(
          Icons.shopping_cart,
          size: 15,
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
