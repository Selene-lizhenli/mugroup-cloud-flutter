import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/wms.dart';
import 'package:cloud/models/wms/transfer_item.dart';
import 'package:cloud/pages/cart/models/state.dart';
import 'package:cloud/pages/cart/providers/cart_provider.dart';
import 'package:cloud/pages/wms/widgets/wms_transfer_items_card.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/wms.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

import 'widgets/wms_transfrt_operate_bar.dart';
import 'widgets/wms_transfer_text_card.dart';

class LoadMoreView extends StatelessWidget {
  const LoadMoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(18.0),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Padding(padding: EdgeInsets.all(10)),
            Text('加载中...')
          ],
        ),
      ),
    );
  }
}

@RoutePage()
class WmsTransferPage extends HookConsumerWidget {
  final String code;

  const WmsTransferPage({super.key, @pathParam required this.code});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final transfer = useState<Transfer?>(null);
    final transferItems = useState<List<TransferItem>?>([]);
    final isLoading = useState<bool>(false);
    final currentPage = useState<int>(1);
    final totalPages = useState<int>(1);
    final searchKeyword = useState<String>('');

    final debouncedInput =
        useDebounced(searchKeyword.value, const Duration(milliseconds: 500));

    Map<TransferStatus, String> statusMap = {
      TransferStatus.draft: "待出库",
      TransferStatus.processing: "运输中",
      TransferStatus.finished: "调拨完成",
      TransferStatus.cancelled: "已取消",
    };

    void loadData() async {
      if (isLoading.value) return;
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2), () async {
        if (currentPage.value <= totalPages.value) {
          final res = await getTransferItems(
              id: transfer.value!.id!,
              queryParameters: {
                'pageSize': 20,
                'page': currentPage.value,
                'search': debouncedInput
              });

          totalPages.value = res.meta!.pagination!.totalPages;
          transferItems.value = [...?transferItems.value, ...res.data];
          currentPage.value++;
        }
        isLoading.value = false;
      });
    }

    final transferFetch = useCallback(() async {
      transfer.value = await fetchTransferByOrederNo(code);
      transferItems.value = [];
      currentPage.value = 1;
      totalPages.value = 1;
      loadData();
    }, []);

    useEffect(() {
      transferFetch();
      loadData();
      scrollController.addListener(() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 100) {
          loadData();
        }
      });
      return null;
    }, []);

    useEffect(() {
      transferItems.value = [];
      currentPage.value = 1;
      totalPages.value = 1;
      loadData();
      return null;
    }, [debouncedInput]);

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
                  transferFetch();
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
        title: GestureDetector(
          onDoubleTap: () {
            scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          child: const Text('调拨单详情'),
        ),
      ),
      body: Column(
        children: [
          // 让产品列表滚动
          Expanded(
            child: EasyRefresh(
              onRefresh: () async {
                await transferFetch();
              },
              child: CustomScrollView(
                controller: scrollController,
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
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 8, 0),
                                  child: Text(
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                    transfer.value?.orderNo ?? "",
                                  ),
                                ),
                                if (transfer.value != null)
                                  Text(
                                      '(${statusMap[transfer.value?.status]})'),
                              ],
                            ),
                          ),
                          WmsTransferTextCard(
                            title: "出库方",
                            lable: Text(
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                                transfer.value?.outWarehouse?.name ?? ""),
                          ),
                          WmsTransferTextCard(
                            title: '入库方',
                            lable: Text(
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                                transfer.value?.inWarehouse?.name ?? ""),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6.0, vertical: 10),
                            child: Row(
                              children: [
                                const Text(
                                  '产品信息',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextField(
                                    onChanged: (value) => {
                                      searchKeyword.value = value,
                                    },
                                    decoration: InputDecoration(
                                      hintText: '搜索产品名/条码/编码',
                                      prefixIcon:
                                          const Icon(Icons.search, size: 20),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 0),
                                      isDense: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (transferItems.value!.isEmpty && isLoading.value)
                            const LoadMoreView(),
                        ],
                      ),
                    ],
                  ),
                  // 滚动的产品列表
                  if (transferItems.value != null)
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index == transferItems.value!.length - 1 &&
                              currentPage.value < totalPages.value) {
                            return const LoadMoreView();
                          } else {
                            return WmsTransferItemsCard(
                                transferItems.value![index]);
                          }
                        },
                        childCount: transferItems.value!.length,
                      ),
                    ),
                ],
              ),
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
              context.pushRoute(WmsTransferConfirmRoute(code: code));
            },
          ),
        ],
      ),
    );
  }
}
