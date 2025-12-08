import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/supply/supplier_cert.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/supply.dart';
import 'package:flant/components/image_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class SupplySupplierCertPage extends HookConsumerWidget {
  final int supplierId;
  const SupplySupplierCertPage({super.key, required this.supplierId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supplierCerts = useState<List<SupplierCert>?>(null);
    final isLoading = useState(true);

    useEffect(() {
      () async {
        try {
          final resp = await getSupplySupplierCertsById(supplierId);
          supplierCerts.value = resp;
        } finally {
          isLoading.value = false;
        }
      }();
      return null;
    }, [supplierId]);

    if (isLoading.value) {
      return Scaffold(
        appBar: AppBar(title: const Text('供应商证书列表')),
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
                  await context.router.push(
                      SupplySupplierCertCreateRoute(supplierId: supplierId));
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
                        '添加证书',
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
                itemCount: supplierCerts.value!.length,
                itemBuilder: (_, index) {
                  final c = supplierCerts.value![index];

                  final cert = c.cert;
                  final createdAt = c.createdAt;
                  final remark = c.remark;
                  final media = c.media;

                  final createdAtStr = createdAt != null
                      ? DateFormat('yyyy-MM-dd HH:mm').format(createdAt!)
                      : '未填写';

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
                                    _row("名称", cert?.name ?? ""),
                                    _row("创建时间", createdAtStr),
                                    _row("备注", remark ?? ""),
                                    GestureDetector(
                                      onTap: () {
                                        if (media != null) {
                                          showFlanImagePreview(
                                            context,
                                            images: media
                                                .map((item) => item.url!)
                                                .toList(),
                                            startPosition: index,
                                            loop: false,
                                          );
                                        }
                                      },
                                      child: const Text(
                                        '附件',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    )
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
