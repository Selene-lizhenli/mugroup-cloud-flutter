import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/wms.dart';
import 'package:cloud/services/wms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

import 'widgets/borrow_card.dart';
import 'widgets/borrow_item.dart';

@RoutePage()
class SelectWmsBorrowPage extends HookConsumerWidget {
  const SelectWmsBorrowPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wborrows = useState<List<Borrow>?>([]);
    useEffect(() {
      Future fetchBorrows() async {
        EasyLoading.show(status: '加载中...');
        try {
          final resp = await getBorrows();
          wborrows.value = resp.data;
        } finally {
          EasyLoading.dismiss();
        }
      }

      fetchBorrows();
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: const Text('报价单列表'),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                MultiSliver(children: [
                  Column(
                    children: wborrows.value
                            ?.map(
                              (borrowItem) => InkWell(
                                child: BorrowCard(
                                  child: BorrowItem(
                                    borrow: borrowItem,
                                  ),
                                ),
                                onTap: () =>
                                    {context.router.maybePop(borrowItem)},
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
