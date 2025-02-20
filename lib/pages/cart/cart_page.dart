import 'package:auto_route/auto_route.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/services/sample.dart';
import 'package:cloud/widgets/wigets.dart';
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
  List<Sample> samples = [
    const Sample(nameCn: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"),
  ];

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
      samples.addAll(resp.data);
    });
  }

  @override
  Widget build(BuildContext context) {
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
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: samples.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SampleItem(
                  sample: samples[index],
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: AppTabbar(),
      floatingActionButton: FloatingActionButton(
        child: const Text("测试"),
        onPressed: () => fetchData(),
      ),
    );
  }
}
