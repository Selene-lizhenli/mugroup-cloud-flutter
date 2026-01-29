import 'package:auto_route/auto_route.dart';
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
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'widgets/sample_item.dart';

@RoutePage()
class CartPage extends HookConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cartProvider);
    final cart = ref.read(cartProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final barcodeTextController = useTextEditingController();

    final items = state.items;
    final carts = state.carts;
    final cartType = state.type;
    final cartName = state.cartName;
    final warehouse = state.warehouse;
    final borrow = state.borrow;
    final transfer = state.transfer;
    final delivery = state.delivery;
    final quotationInfo = state.quotationInfo;

    final borrower = useState<User?>(null);
    const warningColor = Color(0xFFFFD75E);
    final user = useState<User?>(null);

    final borrowReasons = [
      const FlanActionSheetAction(name: "客户会议用"),
      const FlanActionSheetAction(name: "客户选中，核价报价用"),
      const FlanActionSheetAction(name: "展会使用"),
      const FlanActionSheetAction(name: "本组出货样"),
      const FlanActionSheetAction(name: "其他")
    ];

    final currencies = [
      const FlanActionSheetAction(name: "CNY"),
      const FlanActionSheetAction(name: "USD"),
      const FlanActionSheetAction(name: "EUR"),
      const FlanActionSheetAction(name: "GBP")
    ];

    final stockInOptions = [
      {'stockInName': '交样入库', 'type': 'submission_in'},
      {'stockInName': '采购入库', 'type': 'purchase'},
      {'stockInName': '移除入库', 'type': 'remove'},
      {'stockInName': '退货入库', 'type': 'return'},
      {'stockInName': '其他入库', 'type': 'other'},
      {'stockInName': '客户取消订单', 'type': 'cancel'},
      {'stockInName': '调拨入库', 'type': 'transfer_in'},
      {'stockInName': '还样入库', 'type': 'borrow_in'},
      {'stockInName': '盘点入库', 'type': 'inventory_in'},
    ];

    final exchangeFieldKey = GlobalKey();
    final commissionRateFieldKey = GlobalKey();

    void scrollToField(GlobalKey key) {
      Future.delayed(const Duration(milliseconds: 300), () {
        final context = key.currentContext;
        if (context != null) {
          Scrollable.ensureVisible(
            context,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: 0.8, // 越小越靠上
          );
        }
      });
    }

    String getStockInOptionText(String? stockInOption) {
      if (stockInOption == null) {
        return "请选择入库类型";
      }

      try {
        final option = stockInOptions.firstWhere(
          (element) => element['type'] == stockInOption,
        );
        return option['stockInName'] ?? "未设置入库类型";
      } catch (e) {
        return "未设置入库类型";
      }
    }

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
            final selectedUser =
                await context.router.push<User>(const SelectUserRoute());

            borrower.value = selectedUser;
            logger.d(borrower.value?.name);
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(borrower.value == null
                    ? "请选择借样人"
                    : "${borrower.value!.name}(${borrower.value!.jobNumber})"),
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

      if (cartType == CartType.deliveryOut) {
        return GestureDetector(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(delivery == null
                    ? "请扫描出货单二维码"
                    : delivery.orderNo ?? "未设置出货单号"),
                const Icon(Icons.chevron_right)
              ],
            ),
          ),
        );
      }

      if (cartType == CartType.stockIn) {
        return Column(
          children: [
            GestureDetector(
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
                    Text(warehouse == null
                        ? "请选择仓库"
                        : warehouse.name ?? "未设置仓库名称"),
                    const Icon(Icons.chevron_right)
                  ],
                ),
              ),
            ),
          ],
        );
      }
      return GestureDetector(
        child: const SizedBox(),
      );
    }, [
      cartType,
      warehouse,
      borrow,
      transfer,
      borrower.value,
    ]);

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

    Future<void> borrowDialog(BuildContext context) async {
      final reasonController = TextEditingController();

      await showDialog(
        context: context,
        builder: (context) {
          String? borrowReason;
          List<int>? selectedDate = [
            DateTime.now()
                    .add(const Duration(days: 7))
                    .microsecondsSinceEpoch ~/
                1000
          ];

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
                content: SizedBox(
                  height: 270,
                  width: 300,
                  child: CustomScrollView(slivers: [
                    MultiSliver(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "借样人",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
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
                                  border:
                                      Border.all(color: Colors.grey.shade400),
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
                            const SizedBox(height: 10),
                            const Text(
                              "借样原因",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                showFlanActionSheet(
                                  context,
                                  description: "请选择借样原因",
                                  cancelText: "我再想想",
                                  actions: borrowReasons,
                                  closeOnClickAction: true,
                                  onSelect: (action, index) {
                                    borrowReason = borrowReasons[index].name;
                                    setState(() {});
                                  },
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 14),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey.shade100,
                                ),
                                child: borrowReason == '其他'
                                    ? TextField(
                                        controller: reasonController,
                                        decoration: const InputDecoration(
                                          hintText: "请输入借样理由",
                                          border: InputBorder.none,
                                        ),
                                        maxLines: 2,
                                        minLines: 1,
                                      )
                                    : Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              borrowReason ?? "请选择借样原因",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: borrowReason == null
                                                    ? Colors.grey.shade600
                                                    : Colors.black87,
                                              ),
                                            ),
                                          ),
                                          const Icon(
                                            Icons.keyboard_arrow_right,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "预计归还时间",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => {
                                TDCalendarPopup(
                                  context,
                                  visible: true,
                                  onConfirm: (value) {
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
                                  border:
                                      Border.all(color: Colors.grey.shade400),
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
                      ],
                    ),
                  ]),
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
                      final reason = reasonController.text.isNotEmpty
                          ? reasonController.text
                          : borrowReason;

                      if (user.value == null) {
                        EasyLoading.showInfo("请先选择用户!");
                        return;
                      }
                      // 借样理由
                      if ((borrowReason == null || borrowReason == '其他') &&
                          reasonController.text.isEmpty) {
                        EasyLoading.showInfo(
                            "请先${borrowReason == null ? "选择" : "输入"}借样原因!");
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
                        "borrow_reason": reason,
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
                      backgroundColor: colorScheme.primary,
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

      reasonController.dispose();
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
                  try {
                    EasyLoading.show(status: '加载中...');
                    final data = {
                      "sample_items": items
                          .map((item) => {
                                "sample_id": item.sample.id,
                                "price": item.price,
                                "qty": item.count
                              })
                          .toList(),
                      "user_id": user.value?.id,
                      "curreny": quotationInfo?.curreny,
                      "exchange": quotationInfo?.exchange,
                      "commission_rate": quotationInfo?.commissionRate,
                      "is_tax_inclusive": quotationInfo?.showTaxRatePrice
                    };
                    await storeShowroomQuotation(data);
                    EasyLoading.showSuccess('创建报价单成功!'); 
                    cart.clear();
                    user.value = null;
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  } catch (e) {
                    EasyLoading.showError('创建报价单失败,$e');
                  } finally {}
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "提交",
                  style: TextStyle(color: colorScheme.onPrimary),
                ),
              ),
            ],
          );
        },
      );
    }

    void quotationInfoDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          bool? showPrice = quotationInfo?.showPrice;
          bool? showTaxRatePrice = quotationInfo?.showTaxRatePrice;
          String? currency = quotationInfo?.curreny;
          final exchangeController = TextEditingController();
          final commissionRateController = TextEditingController();

          exchangeController.text = quotationInfo?.exchange?.toString() ?? "";
          commissionRateController.text =
              quotationInfo?.commissionRate?.toString() ?? "";

          return StatefulBuilder(
            builder: (context, setState) {
              return Dialog(
                backgroundColor: colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                insetPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "报价单设置",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "以下设置将对选样车中的所有样品生效",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color:
                                        colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  "是否显示价格",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                Radio<bool>(
                                  value: true,
                                  groupValue: showPrice,
                                  fillColor: MaterialStateProperty.all(
                                    colorScheme.secondary,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      showPrice = value;
                                    });
                                  },
                                ),
                                Text(
                                  '是',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Radio<bool>(
                                  value: false,
                                  groupValue: showPrice,
                                  fillColor: MaterialStateProperty.all(
                                    colorScheme.secondary,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      showPrice = value;
                                    });
                                  },
                                ),
                                Text(
                                  '否',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '采购价是否含税',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                Radio<bool>(
                                  value: true,
                                  groupValue: showTaxRatePrice,
                                  fillColor: MaterialStateProperty.all(
                                    colorScheme.secondary,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      showTaxRatePrice = value;
                                    });
                                  },
                                ),
                                Text(
                                  '是',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Radio<bool>(
                                  value: false,
                                  groupValue: showTaxRatePrice,
                                  fillColor: MaterialStateProperty.all(
                                    colorScheme.secondary,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      showTaxRatePrice = value;
                                    });
                                  },
                                ),
                                Text(
                                  '否',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "报价币种",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                showFlanActionSheet(
                                  context,
                                  description: "请选择报价币种",
                                  cancelText: "我再想想",
                                  actions: currencies,
                                  closeOnClickAction: true,
                                  onSelect: (action, index) {
                                    currency = currencies[index].name;
                                    setState(() {});
                                  },
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        colorScheme.outline.withOpacity(0.30),
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  color: colorScheme.surfaceContainer,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        currency ?? "请选择报价币种",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: currency == null
                                              ? colorScheme.onSurface
                                                  .withOpacity(0.5)
                                              : colorScheme.onSurface,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_right,
                                      color: colorScheme.onSurface
                                          .withOpacity(0.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "汇率",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              key: exchangeFieldKey,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: colorScheme.outline.withOpacity(0.3),
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                color: colorScheme.surfaceContainer,
                              ),
                              child: TextField(
                                controller: exchangeController,
                                cursorColor: colorScheme.secondary,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}'),
                                  ),
                                ],
                                style: TextStyle(
                                  color: colorScheme.onSurface,
                                  fontSize: 14,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "请输入汇率",
                                  hintStyle: TextStyle(
                                    color:
                                        colorScheme.onSurface.withOpacity(0.5),
                                  ),
                                ),
                                onTap: () {
                                  scrollToField(exchangeFieldKey);
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "佣金比率(%)",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              key: commissionRateFieldKey,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: colorScheme.outline.withOpacity(0.3),
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                color: colorScheme.surfaceContainer,
                              ),
                              child: TextField(
                                controller: commissionRateController,
                                cursorColor: colorScheme.secondary,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}'),
                                  ),
                                ],
                                style: TextStyle(
                                  color: colorScheme.onSurface,
                                  fontSize: 14,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "请输入佣金比率",
                                  hintStyle: TextStyle(
                                    color:
                                        colorScheme.onSurface.withOpacity(0.5),
                                  ),
                                ),
                                onTap: () {
                                  scrollToField(commissionRateFieldKey);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// 固定底部按钮区域
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                            child: Text(
                              "取消",
                              style: TextStyle(
                                color: colorScheme.onSurface.withOpacity(0.7),
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {
                              cart.quotationInfo = null;
                              double? exchange =
                                  double.tryParse(exchangeController.text);
                              double? commissionRate = double.tryParse(
                                  commissionRateController.text);
                              cart.quotationInfo = QuotationInfo(
                                  showPrice,
                                  showTaxRatePrice,
                                  currency,
                                  exchange,
                                  commissionRate);
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.secondary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "提交",
                              style: TextStyle(
                                color: colorScheme.onSecondary,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      );
    }

    void setPriceDialog(BuildContext context, CartItem item) {
      showDialog(
        context: context,
        builder: (context) {
          final priceController = TextEditingController();
          priceController.text = item.price ?? "";
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            title: const Text(
              "调价",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "价格",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade100,
                  ),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    controller: priceController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
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
                  if (priceController.text == "") {
                    cart.setSamplePrice(item.sample, null);
                  } else {
                    cart.setSamplePrice(item.sample, priceController.text);
                  }

                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
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

    void handBarcodeDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            title: Text(
              "填写产品条码",
              style: TextStyle(
                fontSize: 20,
                color: colorScheme.onSurface,
              ),
            ),
            contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "产品条码",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: barcodeTextController,
                    autofocus: true,
                    cursorColor: colorScheme.secondary,
                    decoration: InputDecoration(
                      hintText: "请输入产品条码",
                      hintStyle: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          width: 0.5,
                          color: colorScheme.secondary,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          width: 0.5,
                          color: colorScheme.outline.withOpacity(0.5),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          width: 1,
                          color: colorScheme.secondary,
                        ),
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceContainer,
                    ),
                  ),
                ],
              ),
            ),
            actionsPadding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  barcodeTextController.clear();
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  "取消",
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.7),
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () async {
                  final input = barcodeTextController.text.trim();
                  if (input.isEmpty) {
                    EasyLoading.showInfo("请输入产品条码!");
                    return;
                  }

                  cart.addItemByBarcode(input);
                  barcodeTextController.clear();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.secondary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "提交",
                  style: TextStyle(
                    color: colorScheme.onSecondary,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    void transferDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          final text = cartType == CartType.transferIn ? "调入" : "调出";
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            title: Text(
              "确认$text",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  final productData = items
                      .map((item) => {
                            "product_id": item.sample.id,
                            "inout_qty": item.count,
                            "product_no": item.sample.productNo,
                            "barcode": item.sample.barcode
                          })
                      .toList();
                  final data = {"items": productData};

                  EasyLoading.show(status: '加载中...');

                  if (cartType == CartType.transferOut) {
                    await addTransferItems(transfer!.id!, data);
                    EasyLoading.showSuccess("调拨出库成功!");
                  }

                  if (cartType == CartType.transferIn) {
                    await transferIn(transfer!.id!, data);
                    EasyLoading.showSuccess("调拨入库成功!");
                  }

                  cart.clear();

                  if (context.mounted) {
                    //关闭弹窗
                    Navigator.of(context).pop();
                    //返回调拨详情页面(保证刷新)
                    context.router
                        .push(WmsTransferRoute(code: transfer!.orderNo!));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "确认",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    }

    void deliveryDialog(BuildContext context) {
      showDialog(
          context: context,
          builder: (context) {
            final text = cartType == CartType.deliveryOut ? "出货" : "未知";
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              title: Text(
                "确认$text",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    final productData = items
                        .map((item) => {
                              "product_id": item.sample.id,
                              "qty": item.count,
                              "product_no": item.sample.productNo,
                              "barcode": item.sample.barcode
                            })
                        .toList();
                    final data = {"items": productData};

                    EasyLoading.show(status: '加载中...');

                    if (cartType == CartType.deliveryOut) {
                      await addDeliveryItems(delivery!.id!, data);
                      EasyLoading.showSuccess("出货成功!");
                    }

                    cart.clear();

                    if (context.mounted) {
                      //关闭弹窗
                      Navigator.of(context).pop();
                      //返回出货详情页面(保证刷新)
                      context.router
                          .push(WmsDeliveryRoute(code: delivery!.orderNo!));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "确认",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          });
    }

    void stockInDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          final text = cartType == CartType.stockIn ? "入库" : "未知";
          final remarkController = TextEditingController();
          String? stockInOption;

          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                title: Text(
                  "确认$text",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                content: SizedBox(
                  width: 400,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 入库类型选择
                      const Text(
                        "入库类型",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          showFlanActionSheet(
                            context,
                            description: "请选择入库类型",
                            cancelText: "我再想想",
                            actions: stockInOptions
                                .map((option) => FlanActionSheetAction(
                                    name: option['stockInName']!))
                                .toList(),
                            closeOnClickAction: true,
                            onSelect: (action, index) {
                              setState(() {
                                stockInOption = stockInOptions[index]['type'];
                              });
                            },
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade400,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  getStockInOptionText(stockInOption),
                                  style: TextStyle(
                                    color: stockInOption == null
                                        ? Colors.grey.shade500
                                        : Colors.black,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey.shade500,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 备注输入
                      const Text(
                        "备注",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextField(
                          controller: remarkController,
                          decoration: const InputDecoration(
                            hintText: "请输入备注信息",
                            border: InputBorder.none, // 移除TextField自带边框
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                          maxLines: null,
                          minLines: 3,
                        ),
                      ),
                    ],
                  ),
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
                      // 验证入库类型是否选择
                      if (stockInOption == null) {
                        EasyLoading.showError("请选择入库类型");
                        return;
                      }

                      final productData = items
                          .map((item) => {
                                'model_type':
                                    "App\\Models\\Showroom\\ShowroomSample",
                                "model_id": item.sample.id,
                                "name": item.sample.name,
                                "product_no": item.sample.productNo,
                                "inout_qty": item.count
                              })
                          .toList();
                      final data = {
                        "products": productData,
                        "type": "in",
                        'operation_type': stockInOption,
                        'warehouse_id': warehouse?.id,
                        'remark': remarkController.text.trim(),
                      };

                      EasyLoading.show(status: '加载中...');

                      if (cartType == CartType.stockIn) {
                        await storeWmsStockInOut(data);
                        EasyLoading.showSuccess("入库成功!");
                      }

                      cart.clear();

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
                      "确认",
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

      // 调拨出/入库
      if (cartType == CartType.transferOut || cartType == CartType.transferIn) {
        if (transfer == null) {
          EasyLoading.showInfo("请先扫描调拨单号!");
          return;
        }
        transferDialog(context);
      }

      //出货
      if (cartType == CartType.deliveryOut) {
        if (delivery == null) {
          EasyLoading.showInfo("请先扫描出货单号!");
          return;
        }
        deliveryDialog(context);
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
        if (borrower.value == null) {
          EasyLoading.showInfo("请先选择借样人!");
          return;
        }

        EasyLoading.show(status: '加载中...');

        if (borrower.value != null) {
          final data = {
            "borrower_user_id": borrower.value!.id!,
            "return_items": productData,
          };
          final resp = await borrowInByUser(data);

          //根据返回的数据更新购物车
          cart.setSapleByProductId(
              (resp.data["abnormal"] as List).cast<Map<String, dynamic>>());
        }

        EasyLoading.showSuccess("还样成功!");
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

      //入库
      if (cartType == CartType.stockIn) {
        if (warehouse == null) {
          EasyLoading.showInfo("请先选择仓库!");
          return;
        }
        if (context.mounted) {
          stockInDialog(context);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: () => selectCart(carts),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(cartType != null ? cartName! : '请选择选样车'),
                const Icon(Icons.arrow_drop_down),
                if (cartType != null) const SizedBox(width: 5),
                if (items.isNotEmpty)
                  Text(
                    "(${items.length})",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
              ],
            ),
          ),
        ),
        actions: [
          if (cartType == CartType.quotation)
            IconButton(
                onPressed: () {
                  quotationInfoDialog(context);
                },
                icon: const Icon(Icons.settings_outlined)),
          MenuAnchor(
            alignmentOffset: const Offset(-80, -5),
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
                      if (true) {
                        // 处理调拨单
                        RegExp transferExp = RegExp(r'wms/transfer/(.*)');
                        final matchTransfer = transferExp.firstMatch(item);
                        if (matchTransfer != null) {
                          final orderNo = matchTransfer.group(1)!;
                          if (context.mounted) {
                            context.router
                                .push(WmsTransferRoute(code: orderNo));
                            return;
                          }
                        }
                      }
                      if (true) {
                        // 处理出货单
                        RegExp deliveryExp = RegExp(r'wms/delivery/(.*)');
                        final matchDelivery = deliveryExp.firstMatch(item);
                        if (matchDelivery != null) {
                          final orderNo = matchDelivery.group(1)!;
                          if (context.mounted) {
                            context.router
                                .push(WmsDeliveryRoute(code: orderNo));
                            return;
                          }
                        }
                      }
                      if (true) {
                        // 处理报价单
                        RegExp quotationExp =
                            RegExp(r'showroom/quotations/(.*)');
                        final matchQuotation = quotationExp.firstMatch(item);
                        if (matchQuotation != null) {
                          final quoteNo = matchQuotation.group(1)!;
                          if (context.mounted) {
                            context.router.push(
                                ShowroomQuotationsRoute(quoteNo: quoteNo));
                            return;
                          }
                        }
                      }

                      EasyLoading.showError("不支持该条码!");
                      return;
                    } else {
                      // 处理样品
                      cart.addItemByBarcode(item);
                    }
                  }
                },
                child: const Row(
                  children: [
                    SizedBox(width: 4),
                    Icon(Icons.camera_alt),
                    SizedBox(width: 8),
                    Text('扫一扫'),
                    SizedBox(width: 8),
                  ],
                ),
              ),
              MenuItemButton(
                onPressed: () async {
                  handBarcodeDialog(context);
                },
                child: const Row(
                  children: [
                    SizedBox(width: 4),
                    Icon(Icons.edit),
                    SizedBox(width: 8),
                    Text('手填条码'),
                    SizedBox(width: 8),
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
            child: CustomScrollView(
              slivers: [
                MultiSliver(
                  children: [
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
                                        const Center(
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 10, 0, 20),
                                            child: Text(
                                              "这里是空的，快去添加吧~",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                  height: 1.2),
                                            ),
                                          ),
                                        ),
                                      SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                          (context, index) {
                                            final cartItem = items[index];
                                            return Slidable(
                                              key: ValueKey(
                                                  cartItem.sample.productNo),
                                              endActionPane: ActionPane(
                                                extentRatio: cartType ==
                                                        CartType.quotation
                                                    ? 0.5
                                                    : 0.25,
                                                motion: const ScrollMotion(),
                                                children: [
                                                  if (cartType ==
                                                      CartType.quotation)
                                                    SlidableAction(
                                                      onPressed: (context) {
                                                        setPriceDialog(
                                                            context, cartItem);
                                                      },
                                                      backgroundColor:
                                                          Colors.blue,
                                                      foregroundColor:
                                                          Colors.white,
                                                      icon: Icons.attach_money,
                                                      label: '调价',
                                                    ),
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
                                              child: Stack(
                                                alignment: Alignment.topRight,
                                                children: [
                                                  Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 8,
                                                        horizontal: 10,
                                                      ),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          if (!context
                                                              .mounted) {
                                                            return;
                                                          }

                                                          context.router.push(
                                                            ShowroomSampleDetailRoute(
                                                              id: cartItem
                                                                  .sample.id!,
                                                            ),
                                                          );
                                                        },
                                                        child: SampleItem(
                                                          sample:
                                                              cartItem.sample,
                                                          price: cartItem.price,
                                                          quotationInfo:
                                                              quotationInfo,
                                                          cartType: cartType,
                                                          count: cartItem.count,
                                                          onChange: (value) {
                                                            if (cartItem
                                                                    .count ==
                                                                value) {
                                                              return;
                                                            }
                                                            cart.setSample(
                                                                cartItem.sample,
                                                                value);
                                                          },
                                                        ),
                                                      )),
                                                  if (cartType ==
                                                          CartType.quotation &&
                                                      cartItem.price != null)
                                                    const TDBadge(
                                                      TDBadgeType.subscript,
                                                      padding:
                                                          EdgeInsets.all(4),
                                                      message: '改',
                                                    ),
                                                ],
                                              ),
                                            );
                                          },
                                          childCount: items.length,
                                        ),
                                      ),
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
            ),
          ),
          if (cartType == null)
            InkWell(
              child: const SampleCard(
                  color: warningColor,
                  child: Center(
                    child: Text(
                      '请先选择您需要的选样车',
                      style: TextStyle(fontSize: 12),
                    ),
                  )),
              onTap: () => selectCart(carts),
            )
          else if (items.isNotEmpty)
            OperateBar(
              onPressed: onPressed,
            ),
        ],
      ),
    );
  }
}
