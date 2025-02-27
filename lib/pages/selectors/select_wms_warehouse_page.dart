import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/wms.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class SelectWmsWarehousePage extends HookConsumerWidget {
  const SelectWmsWarehousePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.router.maybePop(const Warehouse(id: 1, name: "仓库"));
        },
      ),
    );
  }
}
