import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cloud/helper/helper.dart';
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
    final borrows = useState<List<Borrow>?>([]);
    final search = useState<String?>(null);

    Future fetchBorrows(String? search) async {
      EasyLoading.show(status: '加载中...');
      logger.d("搜索");
      final resp = await getBorrows(queryParameters: {"search": search});
      EasyLoading.dismiss();
      borrows.value = resp.data;
    }

    useEffect(() {
      final timer = Timer(const Duration(milliseconds: 300), () {
        fetchBorrows(search.value);
      });

      return () {
        timer.cancel();
      };
    }, [search.value]);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: const Text('借样单列表'),
      ),
      body: SafeArea(
          child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: '搜索(姓名/工号/借样单号)',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              search.value = value;
            },
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                MultiSliver(children: [
                  Column(
                    children: borrows.value
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
