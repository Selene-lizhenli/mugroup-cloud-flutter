import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/wms/warehouse.dart';
import 'package:cloud/pages/cart/cart_page.dart';
import 'package:cloud/pages/confirm/widgets/confirm_card.dart';
import 'package:cloud/pages/confirm/widgets/confirm_item.dart';
import 'package:cloud/pages/confirm/widgets/confirm_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

@RoutePage()
class ConfirmPage extends HookConsumerWidget {
  final List<CartItem>? items;

  final Warehouse? warehouse;

  const ConfirmPage(this.items, this.warehouse, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          const ConfirmTabbar()
        ],
      )),
    );
  }
}
