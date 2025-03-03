import 'package:auto_route/auto_route.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/models/wms.dart';
import 'package:cloud/pages/cart/widgets/sample_card.dart';
import 'package:cloud/pages/cart/widgets/total_record.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/sample.dart';
import 'package:cloud/widgets/wigets.dart';
import 'package:flant/components/action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
  borrow,

  /// 还样
  borrowIn,

  /// 手动盘点
  inout,
}

class Cart {
  final CartType type;

  Cart(this.type);

  String get name {
    if (type == CartType.borrow) {
      return "借样选样车";
    }

    if (type == CartType.borrowIn) {
      return "还样选样车";
    }

    if (type == CartType.inout) {
      return "手动盘点";
    }

    return "选样车";
  }

  bool get disabled {
    if (type == CartType.borrow) {
      return false;
    }

    if (type == CartType.borrowIn) {
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

  BroadcastReceiver receiver = BroadcastReceiver(
    names: [
      "com.android.decodewedge.decode_action",
    ],
  );

  @override
  void initState() {
    super.initState();
    receiver.start();
    receiver.messages.listen((message) {
      logger.d("接收到了消息");
      logger.d(message.data?['com.android.decode.intentwedge.barcode_string']);
    });
  }

  @override
  void dispose() {
    receiver.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final carts = [
      Cart(CartType.borrow),
      Cart(CartType.borrowIn),
      Cart(CartType.inout)
    ];
    final cart = useState<Cart?>(null);
    final warehouse = useState<Warehouse?>(null);
    final borrow = useState<Borrow?>(null);

    final header = useMemoized(() {
      if (cart.value?.type == CartType.borrow) {
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
                    : borrow.value!.orderNo ?? "未设置借样单"),
                const Icon(Icons.chevron_right)
              ],
            ),
          ),
        );
      }

      return GestureDetector();
    }, [cart.value, warehouse.value, borrow.value]);

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

    selectCart() {
      showFlanActionSheet(
        context,
        description: "请选择一辆选样车",
        cancelText: "我再想想",
        actions: carts
            .map((cart) =>
                FlanActionSheetAction(name: cart.name, disabled: cart.disabled))
            .toList(),
        closeOnClickAction: true,
        onSelect: (action, index) {
          cart.value = carts[index];
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () => selectCart(),
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
                          onTap: () => selectCart(),
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
                                            (cartItem) => Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 8,
                                                horizontal: 10,
                                              ),
                                              child: SampleItem(
                                                sample: cartItem.sample,
                                                count: cartItem.count,
                                                onChange: (value) {
                                                  setState(() {
                                                    cartItem.count = value;
                                                  });
                                                },
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
            ),
        ],
      ),
      bottomNavigationBar: AppTabbar(),
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
