import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/wms.dart';
import 'package:cloud/pages/cart/models/state.dart';
import 'package:cloud/pages/cart/providers/cart_provider.dart';
import 'package:cloud/pages/wms/widgets/wms_transfer_items_card.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/wms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

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

    void confirmTransferOut(BuildContext context) {
      if (transfer.value!.items!.isEmpty) {
        EasyLoading.showError("无可出库的物品");
        return;
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("确认出库"),
            content: const Text("你确定要进行出库操作吗？"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("取消"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  EasyLoading.show(status: '加载中...');
                  await transferOut(transfer.value!.id!);
                  transfer.value = await fetchTransferByOrederNo(code);
                  EasyLoading.showSuccess("出库成功!");
                },
                child: const Text("确认"),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('调拨单详情'),
      ),
      body: Column(
        children: [
          // 让产品列表滚动
          Expanded(
            child: CustomScrollView(
              slivers: [
                MultiSliver(
                  children: [
                    // 固定在顶部的订单信息
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WmsTransferTextCard(
                          title: "调拨单号",
                          lable: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                                child: Text(
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                  transfer.value?.orderNo ?? "",
                                ),
                              ),
                              if (transfer.value != null)
                                Text('(${statusMap[transfer.value?.status]})'),
                            ],
                          ),
                        ),
                        WmsTransferTextCard(
                          title: "出库方",
                          lable: Text(
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                              transfer.value?.outWarehouse?.name ?? ""),
                        ),
                        WmsTransferTextCard(
                          title: '入库方',
                          lable: Text(
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                              transfer.value?.inWarehouse?.name ?? ""),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                              top: 20, left: 8, bottom: 8, right: 8),
                          child: Text(
                            '产品信息',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // 滚动的产品列表
                if (transfer.value?.items != null)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return WmsTransferItemsCard(
                            transfer.value!.items![index]);
                      },
                      childCount: transfer.value!.items!.length,
                    ),
                  ),
              ],
            ),
          ),
          WmsTransferOperateBar(
            status: transfer.value?.status,
            addTransferItems: () {
              final cart = ref.read(cartProvider.notifier);
              cart.transfer = transfer.value;
              cart.type = CartType.transferOut;
              context.pushRoute(const CartRoute());
            },
            transferOut: () async {
              confirmTransferOut(context);
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
          ),
        ],
      ),
    );
  }
}
