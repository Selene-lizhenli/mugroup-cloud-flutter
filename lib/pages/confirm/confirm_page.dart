import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/wms/warehouse.dart';
import 'package:cloud/pages/cart/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
    );
  }
}
