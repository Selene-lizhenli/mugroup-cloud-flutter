import 'package:cloud/pages/cart/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ConfirmItem extends HookWidget {
  final CartItem? item;

  const ConfirmItem({super.key, this.item});
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            height: 80,
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${item?.sample.id}'),
                Text('${item?.count}'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
