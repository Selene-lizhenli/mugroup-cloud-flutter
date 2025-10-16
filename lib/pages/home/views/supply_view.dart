import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SupplyView extends HookConsumerWidget {
  const SupplyView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: const Text(
                  "敬请期待",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
