import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/inspection/inspection_item.dart';
import 'package:cloud/pages/inspection/detail/widgets/inspection_detail_list_header.dart';

import 'package:cloud/pages/inspection/tool/inspection_tool.dart';
import 'package:cloud/pages/inspection/widgets/inspection_add_sku.dart';
import 'package:cloud/pages/widgets/confirm_dialog.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/inspection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// 验货sku列表 整个模块
class InspectionDetailSkuList extends StatelessWidget {
  const InspectionDetailSkuList({
    super.key,
    required this.inspectionId,
    required this.filteredItems,
    required this.totalCount,
    required this.passedCount,
    required this.failedCount,
    required this.reworkCount,
    required this.pendingCount,
    required this.searchController,
    required this.currentTab,
    required this.useNormalTemplate,
    required this.onRefresh,
    this.batchStatusMap = const {},
    this.batchRoundMap = const {},
    this.isYunDianInspection = false,
    this.itemsHasMore = false,
    this.itemsLoading = false,
    this.onLoadMore,
  });

  final int inspectionId;
  final List<InspectionItem> filteredItems;
  final int totalCount;
  final int passedCount;
  final int failedCount;
  final int reworkCount;
  final int pendingCount;
  final TextEditingController searchController;
  final ValueNotifier<int> currentTab;
  final bool useNormalTemplate;
  final VoidCallback onRefresh;
  final Map<int?, int> batchStatusMap;
  final Map<int?, int> batchRoundMap;
  final bool isYunDianInspection;
  final bool itemsHasMore;
  final bool itemsLoading;
  final VoidCallback? onLoadMore;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.fromLTRB(6, 12, 6, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InspectionDetailListHeader(
            filteredCount: filteredItems.length,
            totalCount: totalCount,
            passedCount: passedCount,
            failedCount: failedCount,
            reworkCount: reworkCount,
            pendingCount: pendingCount,
            searchController: searchController,
            currentTab: currentTab,
            onAddTap: () async {
              await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                builder: (context) => InspectionAddSku(id: inspectionId),
              );
              onRefresh();
            },
          ),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorScheme.surface,
                  colorScheme.primary.withOpacity(0.1),
                  colorScheme.primary.withOpacity(0.1),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _TabItem(
                    text: '全部',
                    selectedValue: currentTab.value,
                    currentTabValue: 0,
                    onTap: () => currentTab.value = 0,
                    primaryColor: colorScheme.primary,
                  ),
                ),
                Expanded(
                  child: _TabItem(
                    text: '不合格',
                    selectedValue: currentTab.value,
                    currentTabValue: 2,
                    onTap: () => currentTab.value = 2,
                    primaryColor: colorScheme.primary,
                  ),
                ),
                Expanded(
                  child: _TabItem(
                    text: '返工',
                    selectedValue: currentTab.value,
                    currentTabValue: 3,
                    onTap: () => currentTab.value = 3,
                    primaryColor: colorScheme.primary,
                  ),
                ),
                Expanded(
                  child: _TabItem(
                    text: '未验',
                    selectedValue: currentTab.value,
                    currentTabValue: 4,
                    onTap: () => currentTab.value = 4,
                    primaryColor: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          if (filteredItems.isEmpty)
            Container(
              height: 200,
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(0)),
                color: colorScheme.primary.withOpacity(0.1),
              ),
              child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(0)),
                    color: colorScheme.surface,
                  ),
                  child: const Center(
                    child: Text('暂无数据', style: TextStyle(color: Colors.grey)),
                  )),
            )
          else ...[
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 11, 20),
              decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(0)),
                  color: colorScheme.primary.withOpacity(0.1)),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredItems.length +
                    (itemsHasMore || itemsLoading ? 1 : 0) +
                    (!itemsHasMore && filteredItems.isNotEmpty ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < filteredItems.length) {
                    final item = filteredItems[index];
                    return _InspectionListItem(
                      id: inspectionId,
                      item: item,
                      useNormalTemplate: useNormalTemplate,
                      onRefresh: onRefresh,
                      batchStatusMap: batchStatusMap,
                      batchRoundMap: batchRoundMap,
                      isYunDianInspection: isYunDianInspection,
                    );
                  }
                  if (index == filteredItems.length &&
                      (itemsHasMore || itemsLoading)) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: itemsLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const SizedBox.shrink(),
                      ),
                    );
                  }
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: Text(
                        '已加载全部',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ]
        ],
      ),
    );
  }
}

class _InspectionListItem extends HookWidget {
  const _InspectionListItem({
    required this.id,
    required this.item,
    required this.onRefresh,
    required this.useNormalTemplate,
    this.batchStatusMap = const {},
    this.batchRoundMap = const {},
    this.isYunDianInspection = false,
  });

  final int id;
  final InspectionItem item;
  final VoidCallback onRefresh;
  final bool useNormalTemplate;
  final Map<int?, int> batchStatusMap;
  final Map<int?, int> batchRoundMap;
  final bool isYunDianInspection;

  @override
  Widget build(BuildContext context) {
    final isExpanded = useState(false);

    final colorScheme = Theme.of(context).colorScheme;
    final Color errorColor = colorScheme.error;

    final int effectiveStatus = isYunDianInspection
        ? (batchStatusMap[item.id] ?? 0)
        : (item.status ?? 0);

    final mediaList = item.media ?? [];

    bool hasMedia(String collectionName) {
      return mediaList.any((m) => m.collectionName == collectionName);
    }

    final int detailsCount =
        mediaList.where((m) => m.collectionName == 'details').length;

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
      margin: const EdgeInsets.only(bottom: 4, top: 4),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 11),
            child: Row(
              children: [
                const SizedBox(width: 9),
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
                  ),
                ),
                // if (useNormalTemplate == true) ...[
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
                // ],
                InspectionStatusTag(status: effectiveStatus),
                if (isYunDianInspection &&
                    (batchRoundMap[item.id] ?? 0) > 1) ...[
                  const SizedBox(width: 6),
                  _RoundBadge(round: batchRoundMap[item.id]!),
                ],
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () async {
                    if (item.id != null) {
                      await context.router.push(
                        InspectionItemExecuteRoute(id: item.id!),
                      );
                      onRefresh();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    elevation: 0,
                    minimumSize: const Size(64, 32),
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    effectiveStatus == 0 ? '验货' : '查看',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    // color: const Color(0xFFFFF0F0),
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
          if (isExpanded.value && useNormalTemplate == true)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
              child: Wrap(
                spacing: 16,
                runSpacing: 12,
                children: checkPoints.map((point) {
                  return _CheckPointItem(
                    label: point['label'] as String,
                    isChecked: point['checked'] as bool,
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class _CheckPointItem extends StatelessWidget {
  const _CheckPointItem({
    required this.label,
    required this.isChecked,
  });

  final String label;
  final bool isChecked;

  @override
  Widget build(BuildContext context) {
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

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.text,
    required this.selectedValue,
    required this.currentTabValue,
    required this.onTap,
    required this.primaryColor,
  });

  final String text;
  final int selectedValue;
  final VoidCallback onTap;
  final Color primaryColor;
  final int currentTabValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(0),
            topRight: const Radius.circular(0),
            bottomLeft:
                Radius.circular(selectedValue == currentTabValue ? 0 : 8),
            bottomRight:
                Radius.circular(selectedValue == currentTabValue ? 0 : 8),
          ),
          color:
              selectedValue == currentTabValue ? Colors.white : Colors.white),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: selectedValue == currentTabValue
              ? BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                  ),
                  color: primaryColor.withOpacity(0.1))
              : selectedValue - currentTabValue == 1
                  ? const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(8),
                      ),
                      color: Colors.white)
                  : currentTabValue - selectedValue > 1 ||
                          selectedValue - currentTabValue > 1
                      ? const BoxDecoration(
                          borderRadius: BorderRadius.only(),
                          color: Colors.white)
                      : const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(0),
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(0),
                          ),
                          color: Colors.white),
          child: Text(
            text,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: selectedValue == currentTabValue
                  ? primaryColor
                  : Colors.grey[600],
              fontWeight: selectedValue == currentTabValue
                  ? FontWeight.bold
                  : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

class _RoundBadge extends StatelessWidget {
  const _RoundBadge({required this.round});

  final int round;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.blue.withOpacity(0.3), width: 0.5),
      ),
      child: Text(
        '第$round轮',
        style: const TextStyle(
          fontSize: 11,
          color: Colors.blue,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
