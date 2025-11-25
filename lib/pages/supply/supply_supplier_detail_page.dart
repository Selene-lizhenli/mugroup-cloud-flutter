import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/supply/supplier.dart';
import 'package:cloud/services/supply.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class SupplySupplierDetailPage extends HookConsumerWidget {
  final int id;
  const SupplySupplierDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 状态管理
    final supplier = useState<Supplier?>(null);
    final isLoading = useState(true);
    final colorScheme = Theme.of(context).colorScheme;

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
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (supplier.value == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5F7FA),
        body: Center(child: Text("未找到供应商数据")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("供应商详情"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          ((supplier.value?.name ??
                                      supplier.value?.shortName) ??
                                  '未')
                              .trim()
                              .substring(0, 1), // 获取第一个字符，并确保没有空格
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              supplier.value?.name ?? '暂无',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              supplier.value?.shortName ?? '暂无',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      // 核心供应商标签
                      buildTag(
                        (supplier.value?.isCore ?? false) ? '核心供应商' : '普通供应商',
                        (supplier.value?.isCore ?? false)
                            ? Colors.red
                            : Colors.orange,
                      ),
                      // 开票标签
                      buildTag(
                        (supplier.value?.canBill ?? false) ? '可开票' : '不可开票',
                        (supplier.value?.canBill ?? false)
                            ? Colors.green
                            : Colors.grey,
                      ),
                      // 地区标签
                      buildTag(
                        '${supplier.value?.province} ${supplier.value?.city}',
                        Colors.indigo,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// 基础信息
            buildSectionCard(
              title: "基础信息",
              children: [
                buildIconInfoRow(Icons.vpn_key_outlined, "供应商编号",
                    supplier.value?.supplierNo),
              ],
            ),

            const SizedBox(height: 16),

            /// 经营能力
            buildSectionCard(
              title: "经营能力与市场",
              children: [
                buildIconInfoRow(Icons.category_outlined, "主营范围",
                    supplier.value?.businessScope),
                buildIconInfoRow(Icons.trending_up_outlined, "累计出货总额",
                    supplier.value?.shippingAmount ?? '0'),
              ],
            ),

            const SizedBox(height: 16),

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
                          Icons.phone_iphone, "移动电话", contact.mobile),
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),
          ],
        ),
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

Widget buildIconInfoRow(IconData icon, String label, dynamic value) {
  String parseListOrString(dynamic value) {
    if (value == null) return "";
    if (value is List) return value.join(", ");
    if (value is String) return value;
    return value.toString();
  }

  final text = parseListOrString(value);
  if (text.isEmpty) return const SizedBox.shrink();

  return InkWell(
    onTap: () {
      Clipboard.setData(ClipboardData(text: text));
    },
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

Widget buildTag(String text, MaterialColor color) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    decoration: BoxDecoration(
      color: color.shade50,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: color.shade100),
    ),
    child: Text(
      text,
      style: TextStyle(fontSize: 12, color: color.shade700),
    ),
  );
}
