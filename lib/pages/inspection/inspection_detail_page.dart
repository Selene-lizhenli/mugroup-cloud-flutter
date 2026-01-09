import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/inspection/inspection.dart';
import 'package:cloud/models/inspection/inspection_item.dart';
import 'package:cloud/pages/inspection/widgets/inspection_add_sku.dart';
import 'package:cloud/pages/widgets/confirm_dialog.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/inspection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

@RoutePage()
class InspectionDetailPage extends HookConsumerWidget {
  final int id;
  const InspectionDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inspection = useState<Inspection?>(null);
    final isLoading = useState(true);
    final currentTab = useState(0);
    final searchController = useTextEditingController();

    const Color primaryBlue = Color(0xFF3B66F5);
    const Color bgGrey = Color(0xFFF5F7FA);
    const Color textDark = Color(0xFF333333);
    const Color textGrey = Color(0xFF999999);

    useListenable(searchController);

    Future<void> refreshData({bool isSilent = false}) async {
      try {
        if (!isSilent) isLoading.value = true;

        final data = await showInspection(id);
        inspection.value = data;
      } finally {
        isLoading.value = false;
      }
    }

    // 初始加载
    useEffect(() {
      refreshData();
      return null;
    }, []);

    final allItems = inspection.value?.items ?? [];
    final filteredItems = allItems.where((item) {
      // Tab 过滤
      bool tabMatch = true;
      if (currentTab.value == 1) {
        tabMatch = item.status == 1; // 已验货
      } else if (currentTab.value == 2) {
        tabMatch = item.status == 0 || item.status == null; // 未验货
      }

      // 搜索过滤
      bool searchMatch = true;
      final keyword = searchController.text.trim().toLowerCase();
      if (keyword.isNotEmpty) {
        searchMatch = (item.itemNo?.toLowerCase() ?? '').contains(keyword);
      }

      return tabMatch && searchMatch;
    }).toList();

    // 进度计算
    final items = inspection.value?.items ?? [];
    final int total = items.length;
    final int finished = items.where((item) => item.status == 1).length;
    final double progress = total > 0 ? (finished / total) : 0.0;
    final String progressText = '$finished/$total';

    return Scaffold(
      backgroundColor: bgGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: textDark, size: 20),
          onPressed: () => Navigator.of(context).pop(),
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
          // 1. 刷新按钮
          TextButton(
            onPressed: () => refreshData(),
            child: const Text(
              '刷新',
              style: TextStyle(color: textGrey, fontSize: 16),
            ),
          ),

          TextButton(
            onPressed: () async {
              await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => InspectionAddSku(id: id),
              );

              refreshData(isSilent: true);
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
                  _buildInfoCard(context, inspection.value, primaryBlue,
                      textDark, progress, progressText),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        _buildListHeader(
                            context,
                            filteredItems.length,
                            allItems.length,
                            textDark,
                            textGrey,
                            primaryBlue,
                            searchController,
                            currentTab),
                        Divider(
                            height: 1, thickness: 1, color: Colors.grey[100]),
                        if (filteredItems.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(32),
                            child: const Text('暂无相关数据',
                                style: TextStyle(color: Colors.grey)),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: filteredItems.map((item) {
                                return _InspectionListItem(
                                  item: item,
                                  primaryBlue: primaryBlue,
                                  onRefresh: () => refreshData(isSilent: true),
                                );
                              }).toList(),
                            ),
                          ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: _buildBottomBar(context, id, primaryBlue),
    );
  }

  Widget _buildInfoCard(BuildContext context, Inspection? inspection,
      Color primaryBlue, Color textDark, double progress, String progressText) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.check_circle_outline, color: primaryBlue, size: 20),
              const SizedBox(width: 8),
              Text('任务信息',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textDark)),
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 1, thickness: 1, color: Colors.grey[100]),
          const SizedBox(height: 16),
          Row(
            children: [
              Text('${inspection?.name}',
                  style: const TextStyle(
                      fontSize: 15, color: Color(0xFF333333))), // 修复颜色引用
              const Spacer(),
              Text(
                (inspection?.createdAt != null &&
                        inspection!.createdAt!.length >= 10)
                    ? inspection.createdAt!.substring(0, 10)
                    : '${inspection?.createdAt}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(width: 12),
              if (inspection?.type == 1)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: const Color(0xFFF3E5F5),
                      borderRadius: BorderRadius.circular(4)),
                  child: const Text('手动创建',
                      style: TextStyle(color: Colors.purple, fontSize: 12)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // 进度条
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 24,
              width: double.infinity,
              color: const Color(0xFFE0E0E0),
              child: Stack(
                children: [
                  LayoutBuilder(builder: (context, constraints) {
                    return Container(
                      width: constraints.maxWidth * progress,
                      color: const Color(0xFF3B68D8),
                    );
                  }),
                  Center(
                    child: Text(progressText,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            height: 1.1)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListHeader(
      BuildContext context,
      int filteredCount,
      int totalCount,
      Color textDark,
      Color textGrey,
      Color primaryBlue,
      TextEditingController controller,
      ValueNotifier<int> currentTab) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.format_list_bulleted,
                  color: Color(0xFF3B66F5), size: 20),
              const SizedBox(width: 8),
              const Text('验货SKU列表',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333))),
              const Spacer(),
              RichText(
                text: TextSpan(
                  text: '共 ',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  children: [
                    TextSpan(
                        text: '$filteredCount',
                        style: const TextStyle(
                            color: Color(0xFF333333),
                            fontWeight: FontWeight.bold)),
                    TextSpan(text: '/$totalCount 个SKU'),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, thickness: 1, color: Colors.grey[100]),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: '搜索SKU',
              hintStyle:
                  const TextStyle(color: Color(0xFF999999), fontSize: 14),
              prefixIcon:
                  const Icon(Icons.search, color: Color(0xFF999999), size: 20),
              suffixIcon: controller.text.isNotEmpty
                  ? IconButton(
                      icon:
                          const Icon(Icons.clear, size: 16, color: Colors.grey),
                      onPressed: () => controller.clear(),
                    )
                  : null,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: Colors.grey[300]!)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: Colors.grey[300]!)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: Color(0xFF3B66F5))),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTabItem('全部',
                  isSelected: currentTab.value == 0,
                  onTap: () => currentTab.value = 0),
              _buildTabItem('已验货',
                  isSelected: currentTab.value == 1,
                  onTap: () => currentTab.value = 1),
              _buildTabItem('未验货',
                  isSelected: currentTab.value == 2,
                  onTap: () => currentTab.value = 2),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context, int id, Color primaryBlue) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, -2),
              blurRadius: 4)
        ],
      ),
      child: SizedBox(
        height: 48,
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => ExportInspectionDialog(id: id),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            elevation: 0,
          ),
          child: const Text('导出验货清单',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildTabItem(String text,
      {required bool isSelected, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: isSelected
            ? const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Color(0xFF3B66F5), width: 2)))
            : null,
        child: Text(text,
            style: TextStyle(
                color: isSelected ? const Color(0xFF3B66F5) : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14)),
      ),
    );
  }
}

class ExportInspectionDialog extends HookWidget {
  final int id;
  const ExportInspectionDialog({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF3B66F5);
    const Color textDark = Color(0xFF333333);
    final borderColor = Colors.grey[300]!;

    final emailController = useTextEditingController();

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '导出验货清单',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textDark,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text(
                  '邮箱',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF666666),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      controller: emailController,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: '请输入接收验货清单的邮箱',
                        hintStyle:
                            TextStyle(color: Colors.grey[400], fontSize: 13),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: borderColor),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: primaryBlue),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '如果不需要发送到邮箱，请点击下载',
              style: TextStyle(color: Colors.grey[500], fontSize: 13),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: textDark,
                      side: BorderSide(color: Colors.grey[200]!),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      backgroundColor: const Color(0xFFFAFAFA),
                    ),
                    child: const Text('取消'),
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        EasyLoading.show(status: '正在导出...');

                        var response = await exportInspection(id);
                        List<int> bytes;
                        if (response.data is List<int>) {
                          bytes = response.data;
                        } else if (response.data is List) {
                          bytes = List<int>.from(response.data);
                        } else {
                          throw Exception("数据格式错误");
                        }

                        final directory = await getTemporaryDirectory();
                        final fileName =
                            '验货清单_${id}_${DateTime.now().millisecondsSinceEpoch}.xlsx';
                        final filePath = '${directory.path}/$fileName';
                        final file = File(filePath);
                        await file.writeAsBytes(bytes);

                        EasyLoading.dismiss();

                        final box = context.findRenderObject() as RenderBox?;

                        await Share.shareXFiles(
                          [XFile(filePath)],
                          text: '这是验货任务 $id 的清单文件',
                          subject: fileName,
                          sharePositionOrigin:
                              box!.localToGlobal(Offset.zero) & box.size,
                        );

                        // 4. 分享窗口关闭后，关闭当前的导出弹窗
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      } catch (e) {
                        EasyLoading.dismiss();
                        EasyLoading.showError('导出失败: $e');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text('下载'),
                  ),
                ),
                const SizedBox(width: 12),

                // 邮件发送按钮
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final email = emailController.text;
                      Navigator.of(context).pop();
                      // TODO: 处理发送逻辑
                      // print('Send to: $email');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text('邮件发送'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InspectionListItem extends HookWidget {
  final InspectionItem item;
  final Color primaryBlue;
  final VoidCallback onRefresh;

  const _InspectionListItem({
    super.key,
    required this.item,
    required this.primaryBlue,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final isExpanded = useState(false);
    final isVerified = item.status == 1;

    final mediaList = item.media ?? [];

    bool hasMedia(String collectionName) {
      return mediaList.any((m) => m.collectionName == collectionName);
    }

    final int detailsCount =
        mediaList.where((m) => m.collectionName == 'details').length;

    // 4. 生成动态检查项数据
    final checkPoints = [
      {'label': '验货', 'checked': isVerified},
      {'label': '重量', 'checked': hasMedia('weight_proof')},
      {'label': '条码', 'checked': hasMedia('barcode_label')},
      {'label': '开箱', 'checked': hasMedia('unboxing')},
      {'label': '正唛', 'checked': hasMedia('shipping_mark_front')},
      {'label': '侧唛', 'checked': hasMedia('shipping_mark_side')},
      {'label': '主图', 'checked': hasMedia('cover')},
      {'label': '其他($detailsCount)', 'checked': detailsCount > 0},
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  item.itemNo ?? '无编号',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )),
                InkWell(
                  onTap: () => isExpanded.value = !isExpanded.value,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: AnimatedRotation(
                      turns: isExpanded.value ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(Icons.keyboard_arrow_down,
                          color: Color(0xFF666666), size: 20),
                    ),
                  ),
                ),
                _buildStatusTag(isVerified),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () async {
                    if (item.id != null) {
                      await context.router.push(
                        InspectionItemConfirmRoute(id: item.id!),
                      );
                      onRefresh();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B66F5),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    minimumSize: const Size(64, 32),
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    item.status == 1 ? '查看' : '验货',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0F0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.delete_outline,
                        color: Color(0xFFFF4D4F), size: 18),
                    onPressed: () async {
                      final bool isConfirmed = await ConfirmDialog.show(
                        context,
                        content: '是否确定要删除SKU: ${item.itemNo}？',
                      );

                      if (!isConfirmed) return;

                      try {
                        EasyLoading.show(status: '删除中...');

                        if (item.id != null) {
                          await deleteInspectionItem(item.id!, {
                            'item_ids': [item.id]
                          });
                          onRefresh();
                          EasyLoading.showSuccess('删除成功');
                        }
                      } catch (e) {
                        EasyLoading.showError('删除失败');
                      } finally {
                        EasyLoading.dismiss();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          if (isExpanded.value)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
              child: Wrap(
                spacing: 16,
                runSpacing: 12,
                children: checkPoints.map((point) {
                  return _buildCheckPointItem(
                    point['label'] as String,
                    point['checked'] as bool,
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusTag(bool isVerified) {
    return Row(
      children: [
        Icon(
          isVerified ? Icons.check_circle : Icons.check_circle_outline,
          size: 16,
          color: isVerified ? const Color(0xFF52C41A) : Colors.grey[400],
        ),
        const SizedBox(width: 4),
        Text(
          isVerified ? '已验货' : '未验货',
          style: TextStyle(
            color: isVerified ? const Color(0xFF52C41A) : Colors.grey[500],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckPointItem(String label, bool isChecked) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isChecked ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 16,
          color: isChecked ? const Color(0xFF52C41A) : const Color(0xFFCCCCCC),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color:
                isChecked ? const Color(0xFF333333) : const Color(0xFF999999),
          ),
        ),
      ],
    );
  }
}
