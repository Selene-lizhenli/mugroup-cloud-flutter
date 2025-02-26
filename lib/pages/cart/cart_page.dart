import 'package:auto_route/auto_route.dart';
import 'package:bruno/bruno.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/http/api.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/services/sample.dart';
import 'package:cloud/widgets/wigets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
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

@RoutePage()
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
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

  Future fetchData() async {
    var resp = await getSamples();

    setState(() {
      items.addAll(
          resp.data.map((sample) => CartItem(sample: sample, count: 1)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      child: items.isEmpty
                          ? const Center(
                              child: Text("选样车空咯，请扫码添加"),
                            )
                          : Column(
                              children: items
                                  .map(
                                    (cartItem) => Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
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
                                  .toList(),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            BrnBottomButtonPanel(
              mainButtonName: '数量模拟',
              mainButtonOnTap: () async {
                setState(() {
                  items[0].count++;
                });
              },
              secondaryButtonName: "借样",
              secondaryButtonOnTap: () async {
                final productData = items
                    .map((item) =>
                        {"model_id": item.sample.id, "inout_qty": item.count})
                    .toList();
                final data = {
                  "borrower_id": 2, // 借样人ID
                  "warehouse_id": 1, // 仓库ID
                  "remark": "备注",
                  "products": productData
                };
                // 生成报价单
                await api.post("api/tenant/wms/stock/borrows", data: data);
                logger.d(data);
              },
            )
          ],
        ),
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
