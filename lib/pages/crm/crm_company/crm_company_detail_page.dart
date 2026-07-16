import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/crm/company.dart';
import 'package:cloud/providers/app_provider.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/crm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class CrmCompanyDetailPage extends HookConsumerWidget {
  final int id;
  const CrmCompanyDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).user;
    final permissions = user?.permissions ?? [];
    final company = useState<Company?>(null);
    final isLoading = useState(true);

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
      appBar: AppBar(
        title: const Text("客户详情"),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : company.value == null
              ? _buildEmptyState()
              : SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      _buildHeaderCard(
                        context,
                        company.value!,
                        onEdit: permissions.contains('crm.company.update')
                            ? () async {
                                final shouldRefresh = await context.router.push(
                                    CrmCompanyEditRoute(
                                        id: company.value!.id!));
                                if (shouldRefresh == true) {
                                  loadCompany();
                                }
                              }
                            : null,
                      ),

                      const SizedBox(height: 16),

                      _buildInfoSection(
                        title: "联系信息",
                        children: [
                          _buildInfoTile(
                            icon: Icons.email_rounded,
                            color: Colors.blue,
                            label: "电子邮箱",
                            value: company.value?.email,
                          ),
                          _buildInfoTile(
                            icon: Icons.phone_iphone_rounded,
                            color: Colors.green,
                            label: "WhatsApp",
                            value: company.value?.whatsapp,
                          ),
                          _buildInfoTile(
                            icon: Icons.language_rounded,
                            color: Colors.purple,
                            label: "官方网站",
                            value: company.value?.domain,
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      _buildInfoSection(
                        title: "社交网络",
                        children: [
                          _buildInfoTile(
                            icon: Icons.facebook,
                            color: const Color(0xFF1877F2),
                            label: "Facebook",
                            value: company.value?.facebook,
                          ),
                          _buildInfoTile(
                            icon: Icons.business,
                            color: const Color(0xFF0077B5),
                            label: "LinkedIn",
                            value: company.value?.linkedin,
                          ),
                        ],
                      ),

                      const SizedBox(height: 40), // 底部留白
                    ],
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text("未找到客户数据", style: TextStyle(color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(
    BuildContext context,
    Company data, {
    Future<void> Function()? onEdit,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final shortName = (data.name ?? "C").substring(0, 1).toUpperCase();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 大头像
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  shortName,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // 名字
              Text(
                data.name ?? "未命名公司",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 6),
              // 行业
              Text(
                data.industry ?? "行业未填写",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              // 标签
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  if (data.source != null)
                    _buildPillTag(data.source!, Colors.blue),
                  if (data.location != null)
                    _buildPillTag(data.location!, Colors.orange),
                  if (data.address != null)
                    _buildPillTag(data.address!, Colors.teal),
                ],
              ),
            ],
          ),
        ),
        if (onEdit != null)
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => onEdit(),
              style: IconButton.styleFrom(
                foregroundColor: colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPillTag(String text, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(20), // 完全圆角
        border: Border.all(color: color.shade100.withOpacity(0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color.shade700,
        ),
      ),
    );
  }

  Widget _buildInfoSection(
      {required String title, required List<Widget> children}) {
    // 过滤掉空的小部件
    final validChildren = children.where((c) => c is! SizedBox).toList();
    if (validChildren.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
          const Divider(
              height: 1, indent: 20, endIndent: 20, color: Color(0xFFF0F0F0)),
          ...validChildren,
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required Color color,
    required String label,
    required dynamic value,
  }) {
    if (value == null) return const SizedBox.shrink();

    final text = value is List ? value.join(', ') : value.toString();

    if (text.isEmpty) return const SizedBox.shrink();

    return InkWell(
      onTap: () {
        Clipboard.setData(ClipboardData(text: text));
        EasyLoading.showSuccess("复制成功");
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF333333),
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.copy_rounded, size: 16, color: Colors.grey[300]),
          ],
        ),
      ),
    );
  }
}
