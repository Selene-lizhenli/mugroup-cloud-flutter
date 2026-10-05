import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/wms/delivery.dart';
import 'package:cloud/models/wms/delivery_item.dart';
import 'package:cloud/pages/cart/models/state.dart';
import 'package:cloud/pages/cart/providers/cart_provider.dart';
import 'package:cloud/pages/wms/widgets/wms_delivery_items_card.dart';
import 'package:cloud/pages/wms/widgets/wms_delivery_operate_bar.dart';
import 'package:cloud/pages/wms/widgets/wms_delivery_text_card.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/wms.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

@RoutePage()
class WmsDeliveryPage extends HookConsumerWidget {
  final String code;

  const WmsDeliveryPage({super.key, @pathParam required this.code});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final delivery = useState<Delivery?>(null);
    final deliveryItems = useState<List<DeliveryItem>>([]);
    final currentPage = useState<int>(1);
    final pageSize = useState<int>(20);
    final searchKeyword = useState<String>('');

    final debouncedInput =
        useDebounced(searchKeyword.value, const Duration(milliseconds: 500));

    Map<DeliveryStatus, String> statusMap = {
      DeliveryStatus.pending: "待装箱",
      DeliveryStatus.finished: "已装箱",
      DeliveryStatus.shipping: "已出运"
    };

    loadData({int page = 1, String? search}) async {
      if (delivery.value == null || delivery.value!.id == null) {
        return <DeliveryItem>[];
      }

      final res = await getDeliveryItems(
          id: delivery.value!.id!,
          queryParameters: {
            'pageSize': pageSize.value,
            'page': page,
            'search': search ?? ""
          });

      deliveryItems.value = [...deliveryItems.value, ...res.data];

      return res.data;
    }

    void confirmDeliveryOut(BuildContext context) {
      if (deliveryItems.value.isEmpty) {
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
                  await deliveryOut(
                      delivery.value!.id!, {"status": 'shipping'});
                  delivery.value = await fetchDelivery({"order_no": code});
                  EasyLoading.showSuccess("出库成功!");
                },
                child: const Text("确认"),
              ),
            ],
          );
        },
      );
    }

    void confirmDeliveryInBox(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("确认装箱"),
            content: const Text("你确定要进行装箱操作吗？"),
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
                  await deliveryOut(
                      delivery.value!.id!, {"status": 'finished'});
                  delivery.value = await fetchDelivery({"order_no": code});
                  EasyLoading.showSuccess("装箱成功!");
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
          child: const Text('出货单详情'),
        ),
      ),
      body: Column(
        children: [
          // 让产品列表滚动
          Expanded(
            child: EasyRefresh(
              refreshOnStart: true,
              onRefresh: () async {
                currentPage.value = 1;
                deliveryItems.value = [];
                delivery.value = await fetchDelivery({"order_no": code});
                loadData(
                  page: currentPage.value,
                  search: debouncedInput,
                );
              },
              onLoad: () async {
                final result = await loadData(
                  page: currentPage.value + 1,
                  search: debouncedInput,
                );

                if (result.length >= pageSize.value) {
                  currentPage.value++;
                } else {
                  return IndicatorResult.noMore;
                }
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
                          WmsDeliveryTextCard(
                            title: "出货单号",
                            lable: Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 8, 0),
                                  child: Text(
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                    delivery.value?.orderNo ?? "",
                                  ),
                                ),
                                if (delivery.value != null)
                                  Text(
                                      '(${statusMap[delivery.value?.status]})'),
                              ],
                            ),
                          ),
                          WmsDeliveryTextCard(
                            title: "出库方",
                            lable: Text(
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                                delivery.value?.warehouse?.name ?? ""),
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
                        ],
                      ),
                    ],
                  ),
                  // 滚动的产品列表
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return WmsDeliveryItemsCard(deliveryItems.value[index]);
                      },
                      childCount: deliveryItems.value.length,
                    ),
                  ),
                ],
              ),
            ),
          ),
          WmsDeliveryOperateBar(
            status: delivery.value?.status,
            addDeliveryItems: () {
              final cart = ref.read(cartProvider.notifier);
              cart.delivery = delivery.value;
              cart.type = CartType.deliveryOut;
              context.pushRoute(const CartRoute());
            },
            deliveryInBox: () async {
              confirmDeliveryInBox(context);
            },
            deliveryOut: () async {
              confirmDeliveryOut(context);
            },
          ),
        ],
      ),
    );
  }
}
