import 'package:cloud/pages/cart/models/state.dart';
import 'package:cloud/pages/cart/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OperateBar extends HookConsumerWidget {
  final void Function()? onPressed;

  const OperateBar({super.key, this.onPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final state = ref.watch(cartProvider);

    final items = state.items;
    final cartType = state.type;

    Map<CartType, String> buttonText = {
      CartType.borrowOut: "借样",
      CartType.borrowIn: "还样",
      CartType.transferIn: "调入",
      CartType.transferOut: "调出",
      CartType.quotation: "报价",
      CartType.inout: "盘点",
      CartType.deliveryOut: '出货'
    };

    int totalCount = items.length;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
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
                      "已选: $totalCount 件",
                      style: const TextStyle(fontSize: 16),
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
              foregroundColor: Colors.white,
              backgroundColor: colorScheme.primary,
              padding: const EdgeInsets.symmetric(), // 设置内边距
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 5,
            ),
            child: Text(
              buttonText[cartType] ?? "确认",
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
