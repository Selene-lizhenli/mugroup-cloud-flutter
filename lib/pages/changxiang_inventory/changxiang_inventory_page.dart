import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/changxiang_inventory/provider/provider.dart';
import 'package:cloud/pages/changxiang_inventory/widgets/inventory_list.dart';
import 'package:cloud/pages/widgets/search_bar.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class ChangexiangInventoryPage extends HookConsumerWidget {
  const ChangexiangInventoryPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final notifier = ref.read(cxInventoryProvider.notifier);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifier.load();
      });
      return null;
    }, const []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('在仓明细'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: MuSearchBar(
              controller: searchController,
              hintText: '请输入采购单号进行搜索',
              buttonText: '搜索',
              onSearch: (search) {
                final keyword = search ?? searchController.text;
                notifier.setStationSearchKeyword(keyword);
                notifier.load(params: {'PurchaseOrderNo': keyword});
              },
            ),
          ),
          const Expanded(child: InventoryList()),
        ],
      ),
    );
  }
}
