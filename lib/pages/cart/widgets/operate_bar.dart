import 'package:cloud/l10n/l10n_extension.dart';
import 'package:cloud/pages/cart/cart_l10n_helper.dart';
import 'package:cloud/pages/cart/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OperateBar extends HookConsumerWidget {
  final void Function()? onPressed;

  const OperateBar({super.key, this.onPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final state = ref.watch(cartProvider);

    final items = state.items;
    final cartType = state.type;

    int totalCount = items.length;

    return Container(
      color: colorScheme.primary,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.ideographic,
                  children: [
                    Text(
                      l10n.cartSelectedCount(totalCount),
                      style:
                          TextStyle(fontSize: 16, color: colorScheme.onPrimary),
                    ),
                    const SizedBox(
                      width: 1,
                    ),
                  ],
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.primary,
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              padding: const EdgeInsets.symmetric(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 5,
            ),
            child: Text(
              cartOperateLabel(context, cartType),
              style: TextStyle(
                fontSize: 16.0,
                color: colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
