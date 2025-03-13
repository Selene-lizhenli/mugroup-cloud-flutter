import 'package:cloud/models/wms.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WmsTransferOperateBar extends HookConsumerWidget {
  final TransferStatus? status;
  final void Function()? addTransferItems;
  final void Function()? transferOut;
  final void Function()? transferIn;
  final void Function()? transferInAll;

  const WmsTransferOperateBar({
    super.key,
    this.status,
    this.addTransferItems,
    this.transferOut,
    this.transferIn,
    this.transferInAll,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 80,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (status == TransferStatus.draft)
              Expanded(
                child: TextButton(
                    onPressed: addTransferItems,
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
            if (status == TransferStatus.processing)
              Expanded(
                child: TextButton(
                    onPressed: transferIn,
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
                      "入库",
                    )),
              ),
            const SizedBox(
              width: 8,
            ),
            if (status == TransferStatus.draft)
              Expanded(
                child: TextButton(
                    onPressed: transferOut,
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
                      "确认出库",
                    )),
              ),
            if (status == TransferStatus.processing)
              Expanded(
                child: TextButton(
                    onPressed: transferInAll,
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
                      "整箱入库",
                    )),
              ),
          ],
        ),
      ),
    );
  }
}
