import 'package:auto_route/auto_route.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/wms.dart';
import 'package:cloud/providers/count_provider.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/widgets/wigets.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: const SafeArea(
        child: Text("首页"),
      ),
      bottomNavigationBar: AppTabbar(),
      floatingActionButton: FloatingActionButton(
        child: Text("${ref.watch(counterProvider)}"),
        onPressed: () async {
          // ref.read(counterProvider.notifier).increment();
          final wmswarehouse = await context.router
              .push<Warehouse>(const SelectWmsWarehouseRoute());

          logger.d(wmswarehouse);
        },
      ),
    );
  }
}
