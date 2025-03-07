import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/wms.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'widgets/operate_bar.dart';
import 'widgets/transfer_text_card.dart';

@RoutePage()
class WmsTransferPage extends HookConsumerWidget {
  final String code;

  const WmsTransferPage({super.key, @pathParam required this.code});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<TransferStatus, String> statusMap = {
      TransferStatus.draft: "待生效",
      TransferStatus.processing: "运输中",
      TransferStatus.finished: "调拨完成",
      TransferStatus.cancelled: "已取消",
    };

    var transfer = Transfer(
        orderNo: "SF202503050016",
        outWarehouse: const Warehouse(name: "仓库1"),
        inWarehouse: const Warehouse(name: "仓库2"),
        status: TransferStatus.processing);

    void onPressed() {
      context.pushRoute(const CartRoute());
    }

    return Scaffold(
      appBar: AppBar(
          title: const InkWell(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.ideographic,
          children: [
            Text('调拨单详情'),
          ],
        ),
      )),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
              child: Column(
            children: [
              TransferTextCard(
                title: "调拨单号",
                lable: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                      child: Text(
                          style: const TextStyle(fontWeight: FontWeight.w600),
                          transfer.orderNo ?? ""),
                    ),

                    /// TODO: 优化状态显示效果
                    Text('(${statusMap[transfer.status]})')
                  ],
                ),
              ),
              TransferTextCard(
                title: "出库方",
                lable: Text(
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    transfer.outWarehouse?.name ?? ""),
              ),
              TransferTextCard(
                title: '入库方',
                lable: Text(
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    transfer.inWarehouse?.name ?? ""),
              ),
            ],
          )),
          OperateBar(onPressed: onPressed)
        ],
      )),
    );
  }
}
