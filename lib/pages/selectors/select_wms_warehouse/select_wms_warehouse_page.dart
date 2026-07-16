import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/wms.dart'; 
import 'package:cloud/services/wms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
    useEffect(() {
      Future fetchWarehouses() async {
        EasyLoading.show(status: '加载中...');
        try {
          final resp = await getWarehousesPublic();
          // 过滤掉废弃的样品间
          final filteredWarehouses = resp.data
              .where((warehouse) => warehouse.abandoned != true)
              .toList();
          EasyLoading.dismiss();
          warehouses.value = filteredWarehouses ?? [];
        } catch (e) {
          EasyLoading.dismiss();
          warehouses.value = [];
        }
      }

      fetchWarehouses();
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('仓库列表', style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: colorScheme.primary.withRed(89),
      body: SafeArea(
          child: Column(
        children: [
// 自定义尺寸、颜色、速度
          Expanded(
            child: CustomScrollView(
              slivers: [
                MultiSliver(children: [
                  Column(
                    children: warehouses.value
                            ?.map(
                              (warehouseItem) => InkWell(
                                child: WarehouseItem(
                                  warehouse: warehouseItem,
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
