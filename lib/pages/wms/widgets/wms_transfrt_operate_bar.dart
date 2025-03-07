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
      height: 60,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (status == TransferStatus.draft)
              TextButton(
                  onPressed: addTransferItems,
                  child: const Text(
                    "添加",
                  )),
            if (status == TransferStatus.draft)
              TextButton(
                  onPressed: transferOut,
                  child: const Text(
                    "确认出库",
                  )),
            if (status == TransferStatus.processing)
              TextButton(
                  onPressed: transferIn,
                  child: const Text(
                    "入库",
                  )),
            if (status == TransferStatus.processing)
              TextButton(
                  onPressed: transferInAll,
                  child: const Text(
                    "整箱入库",
                  ))
          ],
        ),
      ),
    );
  }
}
