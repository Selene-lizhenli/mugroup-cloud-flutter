import 'package:auto_route/auto_route.dart';
import 'package:cloud/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'widgets/sample_item.dart';

@RoutePage()
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  BroadcastReceiver receiver = BroadcastReceiver(
    names: <String>[
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: const Text('选样车'),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.grey,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(10),
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: const SampleItem(),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: const SampleItem(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
