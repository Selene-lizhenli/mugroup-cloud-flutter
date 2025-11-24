import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/crm/company.dart';
import 'package:cloud/services/crm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class CrmCompanyDetailPage extends HookConsumerWidget {
  final int id;
  const CrmCompanyDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final company = useState<Company?>(null);
    final isLoading = useState(true);
    final colorScheme = Theme.of(context).colorScheme;

    Future loadCompany() async {
      try {
        final data = await showCrmCompany(id);
        company.value = data;
      } finally {
        isLoading.value = false;
      }
    }

    useEffect(() {
      loadCompany();
      return null;
    }, []);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("公司详情"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : company.value == null
              ? const Center(child: Text("未找到数据"))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 顶部卡片
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
                                    (company.value?.name ?? "C")
                                        .substring(0, 1)
                                        .toUpperCase(),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        company.value?.name ?? "未命名公司",
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        company.value?.industry ?? "行业未填写",
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

                            /// Tags
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                if (company.value?.source != null)
                                  buildTag(
                                      company.value?.source ?? '', Colors.blue),
                                if (company.value?.location != null)
                                  buildTag(company.value?.location ?? '',
                                      Colors.orange),
                                if (company.value?.address != null)
                                  buildTag(company.value?.address ?? '',
                                      Colors.green),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// 联系方式
                      buildSectionCard(
                        title: "联系方式",
                        children: [
                          buildIconInfoRow(Icons.email_outlined, "Email",
                              company.value?.email),
                          buildIconInfoRow(Icons.phone_iphone, "Whatsapp",
                              company.value?.whatsapp),
                          buildIconInfoRow(
                              Icons.language, "Domain", company.value?.domain),
                        ],
                      ),

                      const SizedBox(height: 16),

                      /// 社交媒体
                      buildSectionCard(
                        title: "社交网络",
                        children: [
                          buildIconInfoRow(Icons.facebook, "Facebook",
                              company.value?.facebook),
                          buildIconInfoRow(Icons.business, "LinkedIn",
                              company.value?.linkedin),
                        ],
                      ),
                    ],
                  ),
                ),
    );
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
      onTap: () => Clipboard.setData(ClipboardData(text: text)),
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
}
