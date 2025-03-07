import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WmsTransferOperateBar extends HookConsumerWidget {
  final void Function()? onPressed;

  const WmsTransferOperateBar({super.key, this.onPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
                onPressed: onPressed,
                child: const Text(
                  "确认",
                )),
            TextButton(
                onPressed: onPressed,
                child: const Text(
                  "确认",
                )),
            TextButton(
                onPressed: onPressed,
                child: const Text(
                  "确认",
                ))
          ],
        ),
      ),
    );
  }
}
