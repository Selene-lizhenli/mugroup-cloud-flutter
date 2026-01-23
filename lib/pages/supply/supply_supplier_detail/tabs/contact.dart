import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/supply/supplier.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/services/supply.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class SupplySupplierDetailContactPage extends HookConsumerWidget {
  final int id;
  const SupplySupplierDetailContactPage({
    super.key,
    @PathParam.inherit('id') required this.id,
  });

  Future<void> makePhoneCall(String phoneNumber) async {
    if (phoneNumber.isEmpty) return;
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supplier = useState<Supplier?>(null);
    final isLoading = useState(true);

    Future loadSupplier() async {
      try {
        final resp = await getSupplier(id);
        supplier.value = resp;
      } finally {
        isLoading.value = false;
      }
    }

    useEffect(() {
      loadSupplier();
      return null;
    }, []);

    if (isLoading.value) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5F7FA),
        body: Center(child: MuProgressIndicator()),
      );
    }

    if (supplier.value == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5F7FA),
        body: Center(child: Text("未找到供应商数据")),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSectionCard(
            title: "联系人 (${supplier.value?.contacts?.length} 人)",
            children: (supplier.value?.contacts ?? []).map((contact) {
              return Padding(
                padding:
                    const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 姓名 (用作标题，不带图标)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Text(
                        contact.name ?? "",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    buildIconInfoRow(
                      Icons.phone_iphone,
                      "移动电话",
                      contact.mobile,
                      onTap:
                          (contact.mobile != null && contact.mobile!.isNotEmpty)
                              ? () => makePhoneCall(contact.mobile!)
                              : null,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

Widget buildSectionCard({
  required String title,
  required List<Widget> children,
}) {
  final valid = children.whereType<Widget>().toList();
  if (valid.isEmpty) return const SizedBox.shrink();

  return Container(
    padding: const EdgeInsets.symmetric(vertical: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        ...valid,
      ],
    ),
  );
}

Widget buildIconInfoRow(IconData icon, String label, dynamic value,
    {VoidCallback? onTap}) {
  String parseListOrString(dynamic value) {
    if (value == null) return "";
    if (value is List) return value.join(", ");
    if (value is String) return value;
    return value.toString();
  }

  final text = parseListOrString(value);
  if (text.isEmpty) return const SizedBox.shrink();

  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[500]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
