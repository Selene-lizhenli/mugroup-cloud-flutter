import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/wms.dart';
import 'package:cloud/services/wms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
        title: const Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.ideographic,
            children: [
              Text('请选择仓库'),
            ]),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: CustomScrollView(slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: warehouses.value
                          ?.map(
                            (warehouseItem) => Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: WarehouseItem(
                                warehouse: warehouseItem,
                              ),
                            ),
                          )
                          .toList() ??
                      [],
                ),
              )
            ]),
          ),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.router.maybePop(const Warehouse(id: 1, name: "仓库"));
        },
      ),
    );
  }
}
