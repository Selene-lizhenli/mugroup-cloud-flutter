import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/inspection/inspection.dart';
import 'package:cloud/pages/inspection/widgets/inspection_add_sku.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/inspection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class InspectionDetailPage extends HookConsumerWidget {
  final int id;
  const InspectionDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inspection = useState<Inspection?>(null);
    final isLoading = useState(true);
    const Color primaryBlue = Color(0xFF3B66F5);
    const Color bgGrey = Color(0xFFF5F7FA);
    const Color textDark = Color(0xFF333333);
    const Color textGrey = Color(0xFF999999);

    Future loadInspection() async {
      try {
        final data = await showInspection(id);
        inspection.value = data;
      } finally {
        isLoading.value = false;
      }
    }

    useEffect(() {
      loadInspection();
      return null;
    }, []);

    return Scaffold(
      backgroundColor: bgGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: textDark, size: 20),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          '验货任务详情',
          style: TextStyle(
            color: textDark,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const InspectionAddSku(),
              );
            },
            child: const Text(
              '新增',
              style: TextStyle(color: primaryBlue, fontSize: 16),
            ),
          ),
        ],
      ),
      body: isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.check_circle_outline,
                                color: primaryBlue, size: 20),
                            SizedBox(width: 8),
                            Text(
                              '任务信息',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textDark),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Divider(
                            height: 1, thickness: 1, color: Colors.grey[100]),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text('${inspection.value?.name}',
                                style: const TextStyle(
                                    fontSize: 15, color: textDark)),
                            const Spacer(),
                            Text('${inspection.value?.createdAt}',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[600])),
                            const SizedBox(width: 12),
                            if (inspection.value?.type == 1)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3E5F5),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  '手动创建',
                                  style: TextStyle(
                                      color: Colors.purple, fontSize: 12),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Icon(Icons.format_list_bulleted,
                                  color: primaryBlue, size: 20),
                              const SizedBox(width: 8),
                              const Text(
                                '验货SKU列表',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: textDark),
                              ),
                              const Spacer(),
                              RichText(
                                text: TextSpan(
                                  text: '共 ',
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 13),
                                  children: const [
                                    TextSpan(
                                        text: '1 / 1',
                                        style: TextStyle(
                                            color: textDark,
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(text: ' 个SKU'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                            height: 1, thickness: 1, color: Colors.grey[100]),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: '搜索SKU',
                              hintStyle: const TextStyle(
                                  color: textGrey, fontSize: 14),
                              prefixIcon: const Icon(Icons.search,
                                  color: textGrey, size: 20),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide:
                                    BorderSide(color: Colors.grey[300]!),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide:
                                    BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide:
                                    const BorderSide(color: primaryBlue),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildTabItem('全部', isSelected: true),
                              _buildTabItem('已验货', isSelected: false),
                              _buildTabItem('未验货', isSelected: false),
                            ],
                          ),
                        ),
                        Divider(
                            height: 1, thickness: 1, color: Colors.grey[100]),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9F9F9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  '5555',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    Icon(Icons.check_circle_outline,
                                        size: 14, color: Colors.grey[400]),
                                    const SizedBox(width: 4),
                                    Text('未验货',
                                        style: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 13)),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton(
                                  onPressed: () {
                                    context.router.push(
                                        InspectionItemConfirmRoute(id: 1));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryBlue,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    minimumSize: const Size(60, 32),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text('验货',
                                      style: TextStyle(fontSize: 13)),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFEBEE),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(Icons.delete_outline,
                                        color: Colors.redAccent, size: 18),
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, -2),
              blurRadius: 4,
            ),
          ],
        ),
        child: SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              elevation: 0,
            ),
            child: const Text(
              '导出验货清单',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(String text, {required bool isSelected}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: isSelected
          ? const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFF3B66F5), width: 2),
              ),
            )
          : null,
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? const Color(0xFF3B66F5) : Colors.grey[600],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
        ),
      ),
    );
  }
}
