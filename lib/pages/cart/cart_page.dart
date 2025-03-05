import 'package:auto_route/auto_route.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/models/user.dart';
import 'package:cloud/models/wms.dart';
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
import 'widgets/sample_item.dart';

class CartItem {
  final Sample sample;
  int count;

  CartItem({required this.sample, required this.count});

  @override
  String toString() {
    return {"sample": sample, "count": count}.toString();
  }
}

enum CartType {
  /// 借样
  borrowOut,

  /// 还样
  borrowIn,

  /// 调拨出库
  transferOut,

  /// 调拨入库
  transferIn,

  /// 手动盘点
  inout,
}

class Cart {
  final CartType type;

  Cart(this.type);

  String get name {
    if (type == CartType.borrowOut) {
      return "借样选样车";
    }

    if (type == CartType.borrowIn) {
      return "还样选样车";
    }

    if (type == CartType.transferOut) {
      return "调拨出库选样车";
    }

    if (type == CartType.transferIn) {
      return "调拨入库选样车";
    }

    if (type == CartType.inout) {
      return "手动盘点";
    }

    return "选样车";
  }

  bool get disabled {
    if (type == CartType.borrowOut) {
      return false;
    }

    if (type == CartType.borrowIn) {
      return false;
    }

    if (type == CartType.transferOut) {
      return false;
    }

    if (type == CartType.transferIn) {
      return false;
    }

    if (type == CartType.inout) {
      return false;
    }

    return true;
  }
}

@RoutePage()
class CartPage extends StatefulHookConsumerWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  List<CartItem> items = [];

  @override
  Widget build(BuildContext context) {
    final carts = [
      Cart(CartType.borrowOut),
      Cart(CartType.borrowIn),
      Cart(CartType.transferOut),
      Cart(CartType.transferIn),
      Cart(CartType.inout)
    ];

    final cart = useState<Cart?>(null);
    final warehouse = useState<Warehouse?>(null);
    final borrow = useState<Borrow?>(null);
    final transfer = useState<Transfer?>(null);
    final user = useState<User?>(null);

    final addItemByBarcode = useCallback((String barcode) async {
      bool exists = items.any((item) => item.sample.barcode == barcode);

      if (exists) {
        for (CartItem item in items) {
          if (item.sample.barcode == barcode) {
            setState(() {
              item.count = item.count + 1;
            });
            return;
          }
        }
      }

      try {
        EasyLoading.show(status: '加载中...');
        var sample = await getSampleByBarcode(barcode);
        if (sample == null) {
          EasyLoading.showInfo("库中未找到该样品!");
          return;
        }
        setState(() {
          items.add(CartItem(sample: sample, count: 1));
        });
      } finally {
        EasyLoading.dismiss();
      }
    }, []);

    final setTranferByOrderNo = useCallback((String orderNo) async {
      if (transfer.value?.orderNo == orderNo) {
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
        transfer.value = transfer1;
      } finally {
        EasyLoading.dismiss();
      }
    }, []);

    final header = useMemoized(() {
      if (cart.value?.type == CartType.borrowOut ||
          cart.value?.type == CartType.inout) {
        return GestureDetector(
          onTap: () async {
            final selectedWarehouse = await context.router
                .push<Warehouse>(const SelectWmsWarehouseRoute());

            warehouse.value = selectedWarehouse;
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(warehouse.value == null
                    ? "请选择仓库"
                    : warehouse.value!.name ?? "未设置仓库名称"),
                const Icon(Icons.chevron_right)
              ],
            ),
          ),
        );
      }

      if (cart.value?.type == CartType.borrowIn) {
        return GestureDetector(
          onTap: () async {
            final selectedBorrow =
                await context.router.push<Borrow>(const SelectWmsBorrowRoute());

            borrow.value = selectedBorrow;
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(borrow.value == null
                    ? "请选择借样单"
                    : borrow.value!.orderNo ?? "未设置借样单号"),
                const Icon(Icons.chevron_right)
              ],
            ),
          ),
        );
      }

      if (cart.value?.type == CartType.transferOut ||
          cart.value?.type == CartType.transferIn) {
        return GestureDetector(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(transfer.value == null
                    ? "请扫描调拨单二维码"
                    : transfer.value!.orderNo ?? "未设置调拨单号"),
                const Icon(Icons.chevron_right)
              ],
            ),
          ),
        );
      }

      return GestureDetector();
    }, [cart.value, warehouse.value, borrow.value, transfer.value]);

    Future fetchData() async {
      if (cart.value == null) {
        return;
      }

      var resp = await getSamples();

      setState(() {
        items.addAll(
            resp.data.map((sample) => CartItem(sample: sample, count: 1)));
      });
    }

    void selectCart(List<Cart> selectCarts) {
      showFlanActionSheet(
        context,
        description: "请选择一辆选样车",
        cancelText: "我再想想",
        actions: selectCarts
            .map((cart) =>
                FlanActionSheetAction(name: cart.name, disabled: cart.disabled))
            .toList(),
        closeOnClickAction: true,
        onSelect: (action, index) {
          cart.value = selectCarts[index];
          logger.d(cart.value?.type);
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
                    user.value = selectedUser;
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
                            user.value == null
                                ? "请选择用户"
                                : "${user.value!.name} (${user.value!.department?.name ?? '暂无部门'})",
                            style: TextStyle(
                              fontSize: 16,
                              color: user.value == null
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
                  if (user.value == null) {
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
                    "borrower_id": user.value?.id,
                    "warehouse_id": warehouse.value?.id,
                    "products": productData
                  };
                  try {
                    EasyLoading.show(status: '加载中...');
                    await storeBorrow(data);
                    EasyLoading.showSuccess("借样成功!");
                    user.value = null;
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
      if (cart.value?.type == CartType.borrowOut) {
        if (warehouse.value == null) {
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
      if (cart.value?.type == CartType.borrowIn) {
        if (borrow.value == null) {
          EasyLoading.showInfo("请先选择借样单!");
          return;
        }
        try {
          EasyLoading.show(status: '加载中...');
          final data = {"return_items": productData};
          await borrowIn(borrow.value!.id!, data);
          EasyLoading.showSuccess("还样成功!");
        } finally {
          EasyLoading.dismiss();
        }
      }

      // 调拨出库
      if (cart.value?.type == CartType.transferOut) {
        if (transfer.value == null) {
          EasyLoading.showInfo("请先扫描调拨单号!");
          return;
        }
        try {
          EasyLoading.show(status: '加载中...');
          final data = {"items": productData};
          await addTransferItems(transfer.value!.id!, data);
          EasyLoading.showSuccess("调拨出库成功!");
        } finally {
          EasyLoading.dismiss();
        }
      }

      // 调拨入库
      if (cart.value?.type == CartType.transferIn) {
        if (transfer.value == null) {
          EasyLoading.showInfo("请先扫描调拨单号!");
          return;
        }
        try {
          EasyLoading.show(status: '加载中...');
          final data = {"items": productData};
          await transferIn(transfer.value!.id!, data);
          EasyLoading.showSuccess("调拨入库成功!");
        } finally {
          EasyLoading.dismiss();
        }
      }

      //盘点
      if (cart.value?.type == CartType.inout) {
        if (warehouse.value == null) {
          EasyLoading.showInfo("请先选择仓库!");
          return;
        }
        if (context.mounted) {
          context.router
              .push(ConfirmRoute(items: (items), warehouse: warehouse.value));
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
              Text(cart.value != null ? cart.value!.name : '请选择选样车'),
              if (cart.value != null)
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
      ),
      body: Column(
        children: [
          Expanded(
            child: () {
              return CustomScrollView(
                slivers: [
                  MultiSliver(
                    children: [
                      if (cart.value == null)
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
                                                  "${cart.value!.name}空咯，请扫码添加",
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
                                                      setState(() {
                                                        items.removeWhere(
                                                            (item) =>
                                                                item.sample
                                                                    .id ==
                                                                cartItem
                                                                    .sample.id);
                                                      });
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

                                                    setState(() {
                                                      cartItem.count = value;
                                                    });
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
              items: items,
              cart: cart.value,
              onPressed: onPressed,
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Text("测试"),
        onPressed: () {
          logger.d(items.toString());
          fetchData();
        },
      ),
    );
  }
}
