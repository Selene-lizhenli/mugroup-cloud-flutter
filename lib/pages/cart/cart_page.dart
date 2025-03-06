import 'package:auto_route/auto_route.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/user.dart';
import 'package:cloud/models/wms.dart';
import 'package:cloud/pages/cart/models/state.dart';
import 'package:cloud/pages/cart/providers/cart_provider.dart';
import 'package:cloud/pages/cart/widgets/sample_card.dart';
import 'package:cloud/pages/cart/widgets/total_record.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/sample.dart';
import 'package:cloud/services/wms.dart';
import 'package:flant/components/action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';
import '../../models/sample/sample.dart';
import 'widgets/sample_item.dart';

@RoutePage()
class CartPage extends HookConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cartProvider);
    final xx = ref.read(cartProvider.notifier);

    final items = state.items;
    final carts = state.carts;
    final cartType = state.type;
    final cartName = state.cartName;
    final warehouse = state.warehouse;
    final borrow = state.borrow;
    final transfer = state.transfer;
    final user = state.user;

    final addItemByBarcode = useCallback((String barcode) async {
      final Sample sample = Sample(barcode: barcode);
      var item = xx.getItemBySample(sample);

      if (item != null) {
        xx.addSample(sample, 1);
        return;
      }

      try {
        EasyLoading.show(status: '加载中...');
        var samples = await getSamples(queryParameters: {"barcode": barcode})
            .then((res) => res.data);
        if (samples.isEmpty) {
          EasyLoading.showInfo("库中未找到该样品!");
          return;
        }
        for (var item in samples) {
          xx.setSample(item, 1);
        }
      } finally {
        EasyLoading.dismiss();
      }
    }, []);

    final setTranferByOrderNo = useCallback((String orderNo) async {
      if (transfer?.orderNo == orderNo) {
        EasyLoading.showInfo("已选中该调拨单!");
        return;
      }
      try {
        EasyLoading.show(status: '加载中...');
        var transfer1 = await fetchTransferByOrederNo(orderNo);

        if (transfer1 == null) {
          EasyLoading.showInfo("系统中未找到该调拨单!");
          return;
        }
        xx.transfer = transfer1;
      } finally {
        EasyLoading.dismiss();
      }
    }, []);

    final header = useMemoized(() {
      if (cartType == CartType.borrowOut || cartType == CartType.inout) {
        return GestureDetector(
          onTap: () async {
            final selectedWarehouse = await context.router
                .push<Warehouse>(const SelectWmsWarehouseRoute());

            xx.warehouse = selectedWarehouse;
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(warehouse == null ? "请选择仓库" : warehouse.name ?? "未设置仓库名称"),
                const Icon(Icons.chevron_right)
              ],
            ),
          ),
        );
      }

      if (cartType == CartType.borrowIn) {
        return GestureDetector(
          onTap: () async {
            final selectedBorrow =
                await context.router.push<Borrow>(const SelectWmsBorrowRoute());

            xx.borrow = selectedBorrow;
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(borrow == null ? "请选择借样单" : borrow.orderNo ?? "未设置借样单号"),
                const Icon(Icons.chevron_right)
              ],
            ),
          ),
        );
      }

      if (cartType == CartType.transferOut || cartType == CartType.transferIn) {
        return GestureDetector(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(transfer == null
                    ? "请扫描调拨单二维码"
                    : transfer.orderNo ?? "未设置调拨单号"),
                const Icon(Icons.chevron_right)
              ],
            ),
          ),
        );
      }

      return GestureDetector();
    }, [cartType, warehouse, borrow, transfer]);

    void selectCart(List<CartSelect> selectCarts) {
      showFlanActionSheet(
        context,
        description: "请选择一辆选样车",
        cancelText: "我再想想",
        actions: selectCarts
            .map((cart) => FlanActionSheetAction(name: cart.name))
            .toList(),
        closeOnClickAction: true,
        onSelect: (action, index) {
          xx.type = selectCarts[index].type;
        },
      );
    }

    useEffect(() {
      BroadcastReceiver receiver = BroadcastReceiver(
        names: [
          "com.android.decodewedge.decode_action",
        ],
      );

      final sub = receiver.messages.listen((message) async {
        var barcodeString =
            message.data?["com.android.decode.intentwedge.barcode_string"];
        if (barcodeString == null) {
          return;
        }
        barcodeString = barcodeString.trim();
        if (isUrl(barcodeString)) {
          RegExp transferExp = RegExp(r'wms/transfer/SF\d{12}');

          /// 解析结果为调拨单
          if (transferExp.hasMatch(barcodeString)) {
            RegExp transferOrderNoExp = RegExp(r'SF\d{12}');
            Match? match = transferOrderNoExp.firstMatch(barcodeString);
            if (match == null) {
              EasyLoading.showError("未匹配到正确的调拨单号,请检查二维码");
              return;
            }
            var orderNo = match.group(0)!;
            setTranferByOrderNo(orderNo);
            return;
          }
          EasyLoading.showError("不支持该条码!");
          return;
        } else {
          // 处理样品
          addItemByBarcode(barcodeString);
        }
      });

      receiver.start();
      return () {
        sub.cancel();
        receiver.stop();
      };
    }, [addItemByBarcode]);

    void borrowDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            title: const Text(
              "确认借样",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "借样人",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final selectedUser = await context.router
                        .push<User>(const SelectUserRoute());
                    xx.user = selectedUser;
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade100,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            user == null
                                ? "请选择用户"
                                : "${user.name} (${user.department?.name ?? '暂无部门'})",
                            style: TextStyle(
                              fontSize: 16,
                              color: user == null
                                  ? Colors.grey.shade600
                                  : Colors.black87,
                            ),
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_right,
                            color: Colors.grey), // 添加右侧箭头
                      ],
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  "取消",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (user == null) {
                    EasyLoading.showInfo("请先选择用户!");
                    return;
                  }
                  final productData = items
                      .map((item) => {
                            "product_id": item.sample.id,
                            "inout_qty": item.count,
                          })
                      .toList();
                  final data = {
                    "borrower_id": user.id,
                    "warehouse_id": warehouse?.id,
                    "products": productData
                  };
                  try {
                    EasyLoading.show(status: '加载中...');
                    await storeBorrow(data);
                    EasyLoading.showSuccess("借样成功!");
                    xx.clear();
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  } finally {
                    EasyLoading.dismiss();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "提交",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    }

    void onPressed() async {
      // 借样
      if (cartType == CartType.borrowOut) {
        if (warehouse == null) {
          EasyLoading.showInfo("请先选择仓库!");
          return;
        }
        borrowDialog(context);
      }

      final productData = items
          .map(
              (item) => {"product_id": item.sample.id, "inout_qty": item.count})
          .toList();

      // 还样
      if (cartType == CartType.borrowIn) {
        if (borrow == null) {
          EasyLoading.showInfo("请先选择借样单!");
          return;
        }
        try {
          EasyLoading.show(status: '加载中...');
          final data = {"return_items": productData};
          await borrowIn(borrow.id!, data);
          EasyLoading.showSuccess("还样成功!");
          xx.clear();
        } finally {
          EasyLoading.dismiss();
        }
      }

      // 调拨出库
      if (cartType == CartType.transferOut) {
        if (transfer == null) {
          EasyLoading.showInfo("请先扫描调拨单号!");
          return;
        }
        try {
          EasyLoading.show(status: '加载中...');
          final data = {"items": productData};
          await addTransferItems(transfer.id!, data);
          xx.clear();
          EasyLoading.showSuccess("调拨出库成功!");
        } finally {
          EasyLoading.dismiss();
        }
      }

      // 调拨入库
      if (cartType == CartType.transferIn) {
        if (transfer == null) {
          EasyLoading.showInfo("请先扫描调拨单号!");
          return;
        }
        try {
          EasyLoading.show(status: '加载中...');
          final data = {"items": productData};
          await transferIn(transfer.id!, data);
          xx.clear();
          EasyLoading.showSuccess("调拨入库成功!");
        } finally {
          EasyLoading.dismiss();
        }
      }

      //盘点
      if (cartType == CartType.inout) {
        if (warehouse == null) {
          EasyLoading.showInfo("请先选择仓库!");
          return;
        }
        if (context.mounted) {
          context.router
              .push(ConfirmRoute(items: (items), warehouse: warehouse));
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () => selectCart(carts),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.ideographic,
            children: [
              Text(cartType != null ? cartName! : '请选择选样车'),
              if (cartType != null)
                const SizedBox(
                  width: 5,
                ),
              if (items.isNotEmpty)
                Text(
                  "(${items.length})",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
            ],
          ),
        ),
        actions: [
          MenuAnchor(
            builder: (BuildContext context, MenuController controller,
                Widget? child) {
              return IconButton(
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                icon: const Icon(Icons.add_circle_outline),
              );
            },
            menuChildren: [
              MenuItemButton(
                onPressed: () async {
                  final codes = await context.router
                      .push<List<String>>(const ScanRoute());
                  if (codes == null) {
                    EasyLoading.showError("未识别到有效信息!");
                    return;
                  }
                  for (var item in codes) {
                    if (isUrl(item)) {
                      RegExp transferExp = RegExp(r'wms/transfer/SF\d{12}');

                      /// 解析结果为调拨单
                      if (transferExp.hasMatch(item)) {
                        RegExp transferOrderNoExp = RegExp(r'SF\d{12}');
                        Match? match = transferOrderNoExp.firstMatch(item);
                        if (match == null) {
                          EasyLoading.showError("未匹配到正确的调拨单号,请检查二维码");
                          return;
                        }
                        var orderNo = match.group(0)!;
                        setTranferByOrderNo(orderNo);
                        return;
                      }
                      EasyLoading.showError("不支持该条码!");
                      return;
                    } else {
                      // 处理样品
                      addItemByBarcode(item);
                    }
                  }
                },
                child: const Row(
                  children: [
                    Icon(Icons.camera_alt),
                    SizedBox(width: 8),
                    Text('扫一扫'),
                  ],
                ),
              )
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: () {
              return CustomScrollView(
                slivers: [
                  MultiSliver(
                    children: [
                      if (cartType == null)
                        InkWell(
                          child: const SampleCard(
                            child: Center(
                              child: Text(
                                '请选择需要的选样车',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ),
                          ),
                          onTap: () => selectCart(carts),
                        )
                      else
                        SliverPadding(
                          padding: const EdgeInsets.only(
                            bottom: 10,
                            left: 10,
                            right: 10,
                          ),
                          sliver: SliverStack(
                            insetOnOverlap: true,
                            children: [
                              const SliverPositioned.fill(
                                top: 0,
                                child: SampleCard(
                                  margin: EdgeInsets.zero,
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                              SliverClip(
                                child: MultiSliver(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SliverPinnedHeader(child: header),
                                    SliverClip(
                                      child: MultiSliver(
                                        children: [
                                          if (items.isEmpty)
                                            Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: Text(
                                                  "$cartName空咯，请扫码添加",
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ),
                                          ...items.map(
                                            (cartItem) => Slidable(
                                              endActionPane: ActionPane(
                                                extentRatio: 0.25,
                                                motion: const ScrollMotion(),
                                                children: [
                                                  SlidableAction(
                                                    onPressed: (context) {
                                                      xx.removeSample(
                                                          cartItem.sample);
                                                    },
                                                    backgroundColor: Colors.red,
                                                    foregroundColor:
                                                        Colors.white,
                                                    icon: Icons.delete,
                                                    label: '移除',
                                                  ),
                                                ],
                                              ),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 8,
                                                  horizontal: 10,
                                                ),
                                                child: SampleItem(
                                                  sample: cartItem.sample,
                                                  count: cartItem.count,
                                                  onChange: (value) {
                                                    if (cartItem.count ==
                                                        value) {
                                                      return;
                                                    }
                                                    xx.setSample(
                                                        cartItem.sample, value);
                                                  },
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              );
            }(),
          ),
          if (items.isNotEmpty)
            TotalRecord(
              onPressed: onPressed,
            ),
        ],
      ),
    );
  }
}
