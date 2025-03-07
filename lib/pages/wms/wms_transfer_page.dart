import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/wms.dart';
import 'package:cloud/pages/cart/models/state.dart';
import 'package:cloud/pages/cart/providers/cart_provider.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/wms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'widgets/wms_transfrt_operate_bar.dart';
import 'widgets/wms_transfer_text_card.dart';

@RoutePage()
class WmsTransferPage extends HookConsumerWidget {
  final String code;

  const WmsTransferPage({super.key, @pathParam required this.code});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transfer = useState<Transfer?>(null);
    Map<TransferStatus, String> statusMap = {
      TransferStatus.draft: "待出库",
      TransferStatus.processing: "运输中",
      TransferStatus.finished: "调拨完成",
      TransferStatus.cancelled: "已取消",
    };

    useEffect(() {
      transferFetch() async {
        transfer.value = await fetchTransferByOrederNo(code);
      }

      transferFetch();
      return null;
    }, []);

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
              WmsTransferTextCard(
                title: "调拨单号",
                lable: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                      child: Text(
                          style: const TextStyle(fontWeight: FontWeight.w600),
                          transfer.value?.orderNo ?? ""),
                    ),

                    /// TODO: 优化状态显示效果
                    Text('(${statusMap[transfer.value?.status]})')
                  ],
                ),
              ),
              WmsTransferTextCard(
                title: "出库方",
                lable: Text(
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    transfer.value?.outWarehouse?.name ?? ""),
              ),
              WmsTransferTextCard(
                title: '入库方',
                lable: Text(
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    transfer.value?.inWarehouse?.name ?? ""),
              ),
            ],
          )),
          WmsTransferOperateBar(
            status: transfer.value?.status,
            addTransferItems: () {
              final cart = ref.read(cartProvider.notifier);
              cart.transfer = transfer.value;
              cart.type = CartType.transferOut;
              context.pushRoute(const CartRoute());
            },
            transferOut: () async {
              EasyLoading.show(status: '加载中...');
              await transferOut(transfer.value!.id!);
              transfer.value = await fetchTransferByOrederNo(code);
              EasyLoading.showSuccess("出库成功!");
            },
            transferIn: () {
              final cart = ref.read(cartProvider.notifier);
              cart.transfer = transfer.value;
              cart.type = CartType.transferIn;
              context.pushRoute(const CartRoute());
            },
            transferInAll: () async {
              EasyLoading.show(status: '加载中...');
              await transferInAll(transfer.value!.id!);
              transfer.value = await fetchTransferByOrederNo(code);
              EasyLoading.showSuccess("整箱入库成功!");
            },
          )
        ],
      )),
    );
  }
}
