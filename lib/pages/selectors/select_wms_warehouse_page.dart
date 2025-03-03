import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/wms.dart';
import 'package:cloud/pages/selectors/widgets/warehouse_card.dart';
import 'package:cloud/services/wms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

import 'widgets/warehouse_item.dart';

@RoutePage()
class SelectWmsWarehousePage extends HookConsumerWidget {
  const SelectWmsWarehousePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final warehouses = useState<List<Warehouse>?>([]);
    useEffect(() {
      Future fetchWarehouses() async {
        final resp = await getWarehouses();
        warehouses.value = resp.data;
      }

      fetchWarehouses();
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: const Text('仓库列表'),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                MultiSliver(children: [
                  Column(
                    children: warehouses.value
                            ?.map(
                              (warehouseItem) => InkWell(
                                child: WarehouseCard(
                                  child: WarehouseItem(
                                    warehouse: warehouseItem,
                                  ),
                                ),
                                onTap: () =>
                                    {context.router.maybePop(warehouseItem)},
                              ),
                            )
                            .toList() ??
                        [],
                  )
                ])
              ],
            ),
          ),
        ],
      )),
    );
  }
}
