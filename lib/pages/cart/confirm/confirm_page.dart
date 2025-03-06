import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/wms/inventory.dart';
import 'package:cloud/models/wms/inventory_item.dart';
import 'package:cloud/models/wms/warehouse.dart';
import 'package:cloud/pages/cart/models/state.dart';
import 'package:cloud/pages/cart/confirm/widgets/confirm_card.dart';
import 'package:cloud/pages/cart/confirm/widgets/confirm_item.dart';
import 'package:cloud/pages/cart/confirm/widgets/confirm_tabbar.dart';
import 'package:cloud/pages/cart/providers/cart_provider.dart';
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
    final inventory = useState<Inventory?>(null);
    final xx = ref.read(cartProvider.notifier);

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
          var resp = await previewInventory(data);

          inventory.value = resp;
        } finally {
          EasyLoading.dismiss();
        }
      }

      getInventories();
      return null;
    }, []);

    void onPressed() async {
      if (inventory.value != null) {
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
        await confirmInventory(data);
        EasyLoading.showSuccess("手动盘点成功!");
        xx.clear();
      }
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }

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
                  children: items?.map((item) {
                        final matchedInventoryItem = inventory.value?.items
                            ?.firstWhere(
                                (inventoryItem) =>
                                    inventoryItem.productId == item.sample.id,
                                orElse: () => const InventoryItem(
                                      id: 0,
                                      inventoryId: 0,
                                      productId: 0,
                                      previousQty: 0,
                                      newQty: 0,
                                    ));

                        return InkWell(
                          child: ConfirmCard(
                            child: ConfirmItem(
                              item: item,
                              inventoryItem: matchedInventoryItem,
                            ),
                          ),
                        );
                      }).toList() ??
                      [],
                )
              ])
            ],
          )),
          ConfirmTabbar(onPressed: onPressed),
        ],
      )),
    );
  }
}
