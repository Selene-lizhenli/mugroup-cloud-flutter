import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/inspection/inspection.dart';
import 'package:cloud/models/inspection/inspection_item.dart';
import 'package:cloud/pages/inspection/widgets/inspection_add_sku.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/pages/widgets/confirm_dialog.dart';
import 'package:cloud/pages/widgets/progress.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
    final Color primaryColor = colorScheme.primary;

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
          IconButton(
            onPressed: () => refreshData(),
            icon: const Icon(Icons.refresh, size: 20),
          ),
        ],
      ),
      body: isLoading.value
          ? const Center(
              child: MuProgressIndicator(
              showText: true,
            ))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  _buildInfoCard(context, inspection.value, colorScheme,
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
                            colorScheme,
                            searchController,
                            currentTab, () async {
                          await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context)
                                  .size
                                  .width, // 底部抽屉宽度占满屏幕
                            ),
                            builder: (context) => InspectionAddSku(id: id),
                          );

                          refreshData(isSilent: true);
                        }),
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
                                  id: id,
                                  item: item,
                                  primaryColor: primaryColor,
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
      bottomNavigationBar: _buildBottomBar(context, id, primaryColor),
    );
  }

  Widget _buildInfoCard(
      BuildContext context,
      Inspection? inspection,
      ColorScheme colorScheme,
      Color textDark,
      double progress,
      String progressText) {
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
              Text('${inspection?.name}',
                  style:
                      const TextStyle(fontSize: 15, color: Color(0xFF333333))),
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
          MuProgressBar(
            progress: progress,
            progressText: progressText,
            height: 10,
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
      ColorScheme colorScheme,
      TextEditingController controller,
      ValueNotifier<int> currentTab,
      VoidCallback onTap) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          child: Row(
            children: [
              Icon(Icons.format_list_bulleted,
                  color: colorScheme.primary, size: 20),
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
              TextButton(
                onPressed: onTap,
                child: Text(
                  '新增',
                  style: TextStyle(color: colorScheme.primary, fontSize: 16),
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
              _buildTabItem(
                '全部',
                isSelected: currentTab.value == 0,
                onTap: () => currentTab.value = 0,
                primaryColor: colorScheme.primary,
              ),
              _buildTabItem(
                '已验货',
                isSelected: currentTab.value == 1,
                onTap: () => currentTab.value = 1,
                primaryColor: colorScheme.primary,
              ),
              _buildTabItem(
                '未验货',
                isSelected: currentTab.value == 2,
                onTap: () => currentTab.value = 2,
                primaryColor: colorScheme.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context, int id, Color primaryColor) {
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
              barrierDismissible: true,
              builder: (context) => ExportInspectionDialog(id: id),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
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
      {required bool isSelected,
      required VoidCallback onTap,
      required Color primaryColor}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: isSelected
            ? BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: primaryColor, width: 2)))
            : null,
        child: Text(text,
            style: TextStyle(
                color: isSelected ? primaryColor : Colors.grey[600],
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
    const Color textDark = Color(0xFF333333);
    final borderColor = Colors.grey[300]!;
    final colorScheme = Theme.of(context).colorScheme;
    final Color primaryColor = colorScheme.primary;
    final emailController = useTextEditingController();

    final isDownloading = useState(false);

    void showEmailNotSupportedTip() {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          child: Container(
            padding: const EdgeInsets.all(24),
            constraints: const BoxConstraints(maxWidth: 320),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 图标容器
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF3E0),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lightbulb_outline,
                    color: Color(0xFFFF9800),
                    size: 32,
                  ),
                ),
                const SizedBox(height: 20),
                // 标题
                const Text(
                  '暂不支持邮箱格式哦~',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1A1A1A),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                // 内容描述
                const Text(
                  'Comming Soon，敬请期待！',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF666666),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 28),
                // 按钮
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    child: const Text(
                      '我知道了',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return PopScope(
      canPop: !isDownloading.value,
      onPopInvoked: (didPop) {
        if (didPop) return;
      },
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '导出验货清单',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: textDark,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.close,
                          color: Color(0xFF999999), size: 24),
                      onPressed: isDownloading.value
                          ? null
                          : () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // const SizedBox(height: 24),
              // Row(
              //   children: [
              //     const Text(
              //       '邮箱',
              //       style: TextStyle(
              //         fontSize: 15,
              //         color: Color(0xFF666666),
              //         fontWeight: FontWeight.w500,
              //       ),
              //     ),
              //     const SizedBox(width: 16),
              //     Expanded(
              //       child: SizedBox(
              //         height: 40,
              //         child: TextField(
              //           controller: emailController,
              //           enabled: !isDownloading.value,
              //           style: const TextStyle(fontSize: 14),
              //           decoration: InputDecoration(
              //             hintText: '请输入接收验货清单的邮箱',
              //             hintStyle:
              //                 TextStyle(color: Colors.grey[400], fontSize: 13),
              //             contentPadding: const EdgeInsets.symmetric(
              //                 horizontal: 10, vertical: 0),
              //             enabledBorder: OutlineInputBorder(
              //               borderSide: BorderSide(color: borderColor),
              //               borderRadius: BorderRadius.circular(4),
              //             ),
              //             focusedBorder: OutlineInputBorder(
              //               borderSide: BorderSide(color: primaryColor),
              //               borderRadius: BorderRadius.circular(4),
              //             ),
              //             disabledBorder: OutlineInputBorder(
              //               borderSide: BorderSide(color: Colors.grey[200]!),
              //               borderRadius: BorderRadius.circular(4),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 16),
              // Align(
              //   alignment: Alignment.center,
              //   child: Text(
              //     '如果不需要发送到邮箱，请点击下载',
              //     style: TextStyle(color: Colors.grey[500], fontSize: 13),
              //   ),
              // ),
              // const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isDownloading.value
                          ? null
                          : () async {
                              isDownloading.value = true;
                              try {
                                EasyLoading.show(status: '正在下载图片包...');

                                var response = await exportInspectionImage(id);

                                List<int> bytes;
                                if (response.data is List<int>) {
                                  bytes = response.data;
                                } else if (response.data is List) {
                                  bytes = List<int>.from(response.data);
                                } else {
                                  throw Exception("数据格式错误: 预期为二进制流");
                                }

                                final directory = await getTemporaryDirectory();
                                final fileName =
                                    '验货图片_${id}_${DateTime.now().millisecondsSinceEpoch}.zip';
                                final filePath = '${directory.path}/$fileName';

                                final file = File(filePath);
                                await file.writeAsBytes(bytes);

                                EasyLoading.dismiss();

                                if (!context.mounted) return;
                                final box =
                                    context.findRenderObject() as RenderBox?;

                                await Share.shareXFiles(
                                  [XFile(filePath)],
                                  text: '这是验货任务 $id 的图片压缩包',
                                  subject: fileName,
                                  sharePositionOrigin:
                                      box!.localToGlobal(Offset.zero) &
                                          box.size,
                                );
                              } catch (e) {
                                EasyLoading.dismiss();
                                EasyLoading.showError('下载失败: $e');
                              } finally {
                                isDownloading.value = false;
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        backgroundColor: colorScheme.secondary,
                      ),
                      child: Text(
                        '导出图片',
                        style: TextStyle(color: colorScheme.onSecondary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isDownloading.value
                          ? null
                          : () async {
                              isDownloading.value = true;
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

                                if (!context.mounted) return;
                                final box =
                                    context.findRenderObject() as RenderBox?;

                                await Share.shareXFiles(
                                  [XFile(filePath)],
                                  text: '这是验货任务 $id 的清单文件',
                                  subject: fileName,
                                  sharePositionOrigin:
                                      box!.localToGlobal(Offset.zero) &
                                          box.size,
                                );

                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }
                              } catch (e) {
                                EasyLoading.dismiss();
                                EasyLoading.showError('导出失败: $e');
                              } finally {
                                isDownloading.value = false;
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.secondary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text('导出xlsx'),
                    ),
                  ),
                  // const SizedBox(width: 12),
                  // Expanded(
                  //   child: ElevatedButton(
                  //     onPressed: isDownloading.value
                  //         ? null
                  //         : () {
                  //             // final email = emailController.text;
                  //             showEmailNotSupportedTip();
                  //           },
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: primaryColor,
                  //       foregroundColor: Colors.white,
                  //       elevation: 0,
                  //       padding: const EdgeInsets.symmetric(vertical: 12),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(6),
                  //       ),
                  //     ),
                  //     child: Text(
                  //       '邮件发送',
                  //       style: TextStyle(color: colorScheme.onSecondary),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InspectionListItem extends HookWidget {
  final int id;
  final InspectionItem item;
  final Color primaryColor;
  final VoidCallback onRefresh;

  const _InspectionListItem({
    super.key,
    required this.id,
    required this.item,
    required this.primaryColor,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final isExpanded = useState(false);

    final colorScheme = Theme.of(context).colorScheme;
    final Color errorColor = colorScheme.error;

    final mediaList = item.media ?? [];

    bool hasMedia(String collectionName) {
      return mediaList.any((m) => m.collectionName == collectionName);
    }

    final int detailsCount =
        mediaList.where((m) => m.collectionName == 'details').length;

    // 4. 生成动态检查项数据
    final checkPoints = [
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
                _buildStatusTag(item.status),
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
                    backgroundColor: primaryColor,
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
                    icon:
                        Icon(Icons.delete_outline, color: errorColor, size: 18),
                    onPressed: () async {
                      final bool isConfirmed = await ConfirmDialog.show(
                        context,
                        content: '是否确定要删除SKU: ${item.itemNo}？',
                      );

                      if (!isConfirmed) return;

                      try {
                        EasyLoading.show(status: '删除中...');

                        if (item.id != null) {
                          await deleteInspectionItem(id, {
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

  Widget _buildStatusTag(int? status) {
    final label = {1: '合格', 2: '微瑕', 3: '不合格'}[status] ?? '未验货';

    final color = {1: Colors.green, 2: Colors.orange, 3: Colors.red}[status] ??
        Colors.grey;

    final icon = {
          1: Icons.check_circle,
          2: Icons.info,
          3: Icons.cancel
        }[status] ??
        Icons.radio_button_unchecked;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight:
                (status ?? 0) != 0 ? FontWeight.w500 : FontWeight.normal,
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
