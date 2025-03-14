import 'package:auto_route/auto_route.dart';
import 'package:cloud/controllers/scan_controller.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/user.dart';
import 'package:cloud/models/wms.dart';
import 'package:cloud/pages/cart/models/state.dart';
import 'package:cloud/pages/cart/providers/cart_provider.dart';
import 'package:cloud/pages/cart/widgets/sample_card.dart';
import 'package:cloud/pages/cart/widgets/operate_bar.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/sample.dart';
import 'package:cloud/services/wms.dart';
import 'package:flant/components/action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../models/sample/sample.dart';
import 'widgets/sample_item.dart';

@RoutePage()
class CartPage extends HookConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cartProvider);
    final cart = ref.read(cartProvider.notifier);

    final items = state.items;
    final carts = state.carts;
    final cartType = state.type;
    final cartName = state.cartName;
    final warehouse = state.warehouse;
    final borrow = state.borrow;
    final transfer = state.transfer;

    final user = useState<User?>(null);

    final addItemByBarcode = useCallback((String barcode) async {
      final Sample sample = Sample(barcode: barcode);
      var item = cart.getItemBySample(sample);

      if (item != null) {
        cart.addSample(sample, 1);
        return;
      }

      EasyLoading.show(status: '加载中...');
      var samples = await getSamples(queryParameters: {"barcode": barcode})
          .then((res) => res.data);
      EasyLoading.dismiss();
      if (samples.isEmpty) {
        EasyLoading.showInfo("库中未找到该样品!");
        return;
      }
      for (var item in samples) {
        cart.addSample(item, 1);
      }
    }, []);

    final header = useMemoized(() {
      if (cartType == CartType.borrowOut || cartType == CartType.inout) {
        return GestureDetector(
          onTap: () async {
            final selectedWarehouse = await context.router
                .push<Warehouse>(const SelectWmsWarehouseRoute());

            cart.warehouse = selectedWarehouse;
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

            cart.borrow = selectedBorrow;
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

      return GestureDetector(
        child: const SizedBox(),
      );
    }, [cartType, warehouse, borrow, transfer]);

    void selectCart(List<CartSelect> selectCarts) {
      showFlanActionSheet(
        context,
        description: "请选择一辆选样车",
        cancelText: "我再想想",
        actions: selectCarts
            .map((select) => FlanActionSheetAction(name: select.cartName))
            .toList(),
        closeOnClickAction: true,
        onSelect: (action, index) {
          cart.type = selectCarts[index].type;
        },
      );
    }

    useEffect(() {
      if (scanController.hasListener) {
        return null;
      }

      final sub = scanController.stream.listen((message) async {
        addItemByBarcode(message);
      });

      return () {
        sub.cancel();
      };
    }, []);

    void borrowDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          List<int>? selectedDate;

          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                title: const Text(
                  "确认借样",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "借样人",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
                                  fontSize: 14,
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
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "预计归还时间",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => {
                        TDCalendarPopup(
                          context,
                          visible: true,
                          onConfirm: (value) {
                            // TODO: 移除 cart
                            cart.selectedDate = value;
                            setState(() {
                              selectedDate = value;
                            });
                          },
                          child: TDCalendar(
                            title: '请选择日期',
                            value: selectedDate,
                          ),
                        ),
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
                            Text(
                              selectedDate == null
                                  ? '请选择日期'
                                  : '${DateTime.fromMillisecondsSinceEpoch(selectedDate![0]).year}-${DateTime.fromMillisecondsSinceEpoch(selectedDate![0]).month}-${DateTime.fromMillisecondsSinceEpoch(selectedDate![0]).day}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
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
                      if (selectedDate == null) {
                        EasyLoading.showInfo("请先选择预计归还时间!");
                        return;
                      }
                      final productData = items
                          .map((item) => {
                                "product_id": item.sample.id,
                                "inout_qty": item.count,
                                "product_no": item.sample.productNo
                              })
                          .toList();
                      final data = {
                        "borrower_id": user.value?.id,
                        "warehouse_id": warehouse?.id,
                        "products": productData,
                        "expected_returned_at":
                            DateFormat("yyyy-MM-dd HH:mm:ss").format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    selectedDate![0])),
                      };
                      EasyLoading.show(status: '加载中...');
                      await storeBorrow(data);
                      EasyLoading.showSuccess("借样成功!");
                      cart.clear();
                      user.value = null;
                      if (context.mounted) {
                        Navigator.of(context).pop();
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
        },
      );
    }

    void quotationDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            title: const Text(
              "确认创建报价单",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "外销员",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
                              fontSize: 14,
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
                  EasyLoading.show(status: '加载中...');
                  final sampleIds =
                      items.map((item) => item.sample.id).toList();
                  await storeShowroomQuotation(
                      {"sample_ids": sampleIds, "user_id": user.value?.id});
                  EasyLoading.showSuccess('创建报价单成功!');
                  cart.clear();
                  user.value = null;
                  if (context.mounted) {
                    Navigator.of(context).pop();
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

      //创建报价单
      if (cartType == CartType.quotation) {
        quotationDialog(context);
      }

      final productData = items
          .map((item) => {
                "product_id": item.sample.id,
                "inout_qty": item.count,
                "product_no": item.sample.productNo,
                "barcode": item.sample.barcode
              })
          .toList();

      // 还样
      if (cartType == CartType.borrowIn) {
        if (borrow == null) {
          EasyLoading.showInfo("请先选择借样单!");
          return;
        }
        EasyLoading.show(status: '加载中...');
        final data = {"return_items": productData};
        await borrowIn(borrow.id!, data);
        EasyLoading.showSuccess("还样成功!");
        cart.clear();
      }

      // 调拨出库
      if (cartType == CartType.transferOut) {
        if (transfer == null) {
          EasyLoading.showInfo("请先扫描调拨单号!");
          return;
        }
        EasyLoading.show(status: '加载中...');
        final data = {"items": productData};
        await addTransferItems(transfer.id!, data);
        cart.clear();
        EasyLoading.showSuccess("调拨出库成功!");
      }

      // 调拨入库
      if (cartType == CartType.transferIn) {
        if (transfer == null) {
          EasyLoading.showInfo("请先扫描调拨单号!");
          return;
        }
        EasyLoading.show(status: '加载中...');
        final data = {"items": productData};
        await transferIn(transfer.id!, data);
        cart.clear();
        EasyLoading.showSuccess("调拨入库成功!");
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
                    return;
                  }
                  for (var item in codes) {
                    if (isUrl(item)) {
                      RegExp transferExp = RegExp(r'wms/transfer/(.*)');
                      final match = transferExp.firstMatch(item);

                      /// 解析结果为调拨单
                      if (match != null) {
                        final orderNo = match.group(1)!;
                        if (context.mounted) {
                          context.router.push(WmsTransferRoute(code: orderNo));
                          return;
                        }
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
                                                      cart.removeSample(
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
                                                    cart.setSample(
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
            OperateBar(
              onPressed: onPressed,
            ),
        ],
      ),
    );
  }
}
