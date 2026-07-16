import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/crm/contact.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/crm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CrmContactPage extends HookConsumerWidget {
  final int companyId;
  const CrmContactPage({super.key, required this.companyId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = useState<List<Contact>?>(null);
    final isLoading = useState(true);

    useEffect(() {
      () async {
        try {
          final resp =
              await getCrmContacts(queryParameters: {'company_id': companyId});
          if (context.mounted) {
            contacts.value = resp.data;
          }
        } finally {
          if (context.mounted) {
            isLoading.value = false;
          }
        }
      }();
    }, [companyId]);

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
                  await context.router
                      .push(CrmContactCreateRoute(companyId: companyId));
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
                        '添加联系人',
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
                itemCount: contacts.value?.length,
                itemBuilder: (_, index) {
                  final c = contacts.value?[index];

                  final name = (c?.name ?? '').trim();
                  final mobile = (c?.mobile ?? '').trim();

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
                                    _row("姓名", name.isEmpty ? '未填写' : name),
                                    const SizedBox(height: 6),
                                    _row("电话", mobile.isEmpty ? '未填写' : mobile),
                                  ],
                                ),
                              ),
                              InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () async {
                                  if (c?.id != null) {
                                    await context.router.push(
                                      CrmContactEditRoute(id: c!.id!),
                                    );
                                  }
                                },
                                child: const Icon(
                                  Icons.edit,
                                  size: 20,
                                  color: Colors.grey,
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
