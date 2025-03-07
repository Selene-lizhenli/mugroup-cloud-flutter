import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/wms.dart';
import 'package:cloud/pages/transfer/widgets/operate_bar.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'widgets/transfer_text_card.dart';

@RoutePage()
class TransferPage extends HookConsumerWidget {
  const TransferPage({super.key});
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
                lable: transfer.orderNo,
              ),
              TransferTextCard(
                title: "出库方",
                lable: transfer.outWarehouse?.name,
              ),
              TransferTextCard(
                title: '入库方',
                lable: transfer.inWarehouse?.name,
              ),
              TransferTextCard(
                title: '状态',
                lable: statusMap[transfer.status],
              ),
            ],
          )),
          OperateBar(onPressed: onPressed)
        ],
      )),
    );
  }
}
