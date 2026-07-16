import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/log.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/supply.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SupplySupplierActivityPage extends HookConsumerWidget {
  final int supplierId;
  const SupplySupplierActivityPage({super.key, required this.supplierId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = useState<List<Log>?>(null);
    final isLoading = useState(true);

    useEffect(() {
      () async {
        try {
          final resp = await getSupplySupplierActivitiesById(supplierId);
          logs.value = resp;
        } finally {
          isLoading.value = false;
        }
      }();
      return null;
    }, [supplierId]);

    if (isLoading.value) {
      return Scaffold(
        body: Skeleton(
            isLoading: true, skeleton: SkeletonListView(), child: Container()),
      );
    }
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 2,
              child: InkWell(
                onTap: () async {
                  await context.router.push(SupplySupplierActivityCreateRoute(
                      supplierId: supplierId));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        size: 28,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '添加动态',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: logs.value!.length,
                itemBuilder: (_, index) {
                  final c = logs.value![index];

                  final name = c.causer?.name ?? '未知用户';
                  final createdAt = c.createdAt ?? '';
                  final description = c.description ?? '';
                  final attachments = c.attachments;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _row("名称", name),
                                    _row("创建时间", createdAt),
                                    _row("备注", description),
                                    // _row("附件", media?[0].url ?? ''),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _row(String label, String value) {
  return Row(
    children: [
      Text(
        "$label：",
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      Expanded(
        child: Text(
          value,
          style: const TextStyle(fontSize: 15),
        ),
      ),
    ],
  );
}
