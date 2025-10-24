import 'package:cloud/app/app.dart';
import 'package:cloud/pages/cart/models/state.dart';
import 'package:cloud/pages/cart/providers/cart_provider.dart';
import 'package:cloud/providers/core_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OperateBar extends HookConsumerWidget {
  final void Function()? onPressed;

  const OperateBar({super.key, this.onPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cartProvider);

    final items = state.items;
    final cartType = state.type;

    final core = app.container.read(coreProvider).value;
    final tenant = core?.currentTenant;
    final title = tenant?.title;
    final showPrice = title != '硬电';

    Map<CartType, String> buttonText = {
      CartType.borrowOut: "借样",
      CartType.borrowIn: "还样",
      CartType.transferIn: "调入",
      CartType.transferOut: "调出",
      CartType.quotation: "报价",
      CartType.inout: "盘点",
      CartType.deliveryOut: '出货'
    };

    double totalPrice = items.fold(0.0, (previousValue, item) {
          // 尝试将 purchaseCost 从 String 转换为 double
          double cost = double.tryParse(item.sample.purchaseCost ?? '0') ?? 0.0;
          return previousValue! + (cost * item.count);
        }) ??
        0.0;

    int totalCount = items.length;

    return Container(
      height: 60,
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.ideographic,
                    children: [
                      Text("已选: $totalCount 件"),
                      const SizedBox(
                        width: 1,
                      ),
                      if (cartType != CartType.quotation)
                        if (showPrice)
                          Row(
                            children: [
                              const Text("合计: "),
                              const Text(
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w400),
                                  '¥'),
                              Text(
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  totalPrice.toStringAsFixed(2)),
                            ],
                          ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(), // 设置内边距
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 5,
            ),
            child: Text(
              buttonText[cartType] ?? "确认",
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }
}
