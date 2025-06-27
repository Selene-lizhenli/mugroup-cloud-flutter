import 'package:cloud/models/wms/delivery.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WmsDeliveryOperateBar extends HookConsumerWidget {
  final DeliveryStatus? status;
  final void Function()? addDeliveryItems;
  final void Function()? deliveryInBox;
  final void Function()? deliveryOut;

  const WmsDeliveryOperateBar({
    super.key,
    this.status,
    this.addDeliveryItems,
    this.deliveryInBox,
    this.deliveryOut,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: status == DeliveryStatus.shipping ? 0 : 80,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (status == DeliveryStatus.pending)
              Expanded(
                child: TextButton(
                    onPressed: addDeliveryItems,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green[700], // 设置背景颜色
                      foregroundColor: Colors.white, // 设置文字颜色
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16), // 设置内边距
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // 圆角
                      ),
                    ),
                    child: const Text(
                      "添加",
                    )),
              ),
            const SizedBox(
              width: 8,
            ),
            if (status == DeliveryStatus.pending)
              Expanded(
                child: TextButton(
                    onPressed: deliveryInBox,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue[700], // 设置背景颜色
                      foregroundColor: Colors.white, // 设置文字颜色
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16), // 设置内边距
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // 圆角
                      ),
                    ),
                    child: const Text(
                      "确认装箱",
                    )),
              ),
            if (status == DeliveryStatus.finished)
              Expanded(
                child: TextButton(
                    onPressed: deliveryOut,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue[700], // 设置背景颜色
                      foregroundColor: Colors.white, // 设置文字颜色
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16), // 设置内边距
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // 圆角
                      ),
                    ),
                    child: const Text(
                      "确认出运",
                    )),
              ),
          ],
        ),
      ),
    );
  }
}
