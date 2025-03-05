import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/wms/inventory.dart';
import 'package:cloud/models/wms/warehouse.dart';
import 'package:cloud/pages/cart/cart_page.dart';
import 'package:cloud/pages/confirm/widgets/confirm_card.dart';
import 'package:cloud/pages/confirm/widgets/confirm_item.dart';
import 'package:cloud/pages/confirm/widgets/confirm_tabbar.dart';
import 'package:cloud/services/wms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

@RoutePage()
class ConfirmPage extends HookConsumerWidget {
  final List<CartItem>? items;

  final Warehouse? warehouse;

  const ConfirmPage(this.items, this.warehouse, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventories = useState<List<Inventory>?>(null);

    useEffect(() {
      getInventories() async {
        try {
          EasyLoading.show(status: '加载中...');
          final data = {
            "warehouse_id": warehouse?.id,
            "items": items
                    ?.map((item) => {
                          "product_id": item.sample.id,
                          "new_qty": item.count,
                        })
                    .toList() ??
                []
          };
          var resp = await storeInventory(data);

          print(resp);
        } finally {
          EasyLoading.dismiss();
        }
      }

      getInventories();
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('盘点明细'),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
              child: CustomScrollView(
            slivers: [
              MultiSliver(children: [
                Column(
                  children: items
                          ?.map((item) => InkWell(
                                child: ConfirmCard(
                                  child: ConfirmItem(item: item),
                                ),
                              ))
                          .toList() ??
                      [],
                )
              ])
            ],
          )),
          // const ConfirmTabbar(inventory);
        ],
      )),
    );
  }
}
