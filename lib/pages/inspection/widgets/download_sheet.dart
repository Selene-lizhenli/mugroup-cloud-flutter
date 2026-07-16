import 'package:cloud/models/inspection/inspection_item.dart';
import 'package:cloud/pages/inspection/providers/inspection_detail_provider.dart';
import 'package:cloud/pages/inspection/tool/inspection_export.dart';
import 'package:cloud/pages/inspection/tool/inspection_tool.dart';
import 'package:cloud/pages/inspection/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DownloadInspectionSheet extends HookConsumerWidget {
  final int id;

  const DownloadInspectionSheet({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const Color textDark = Color(0xFF333333);
    const Color textMuted = Color(0xFF666666);
    final colorScheme = Theme.of(context).colorScheme;

    final selectedSkuType = useState<String>('all');
    final isDownloading = useState(false);
    final selectedItemIds = useState<Set<int>>({});
    final searchKeyword = useState<String>('');
    final searchController = useTextEditingController();
    final selectedStatusFilter = useState<Set<int?>>({0, 1, 2, 3});

    final detailState = ref.watch(inspectionDetailProvider);
    final skuItems = detailState.inspection?.items ?? const <InspectionItem>[];

    // 获取键盘高度
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    List<InspectionItem> getFilteredItems() {
      List<InspectionItem> filtered = List.from(skuItems);
      final keyword = searchKeyword.value.toLowerCase();

      if (keyword.isNotEmpty) {
        filtered = filtered.where((item) {
          final itemNo = item.itemNo?.toLowerCase() ?? '';
          return itemNo.contains(keyword);
        }).toList();
      }

      filtered = filtered.where((item) {
        final status = item.status ?? 0;
        return selectedStatusFilter.value.contains(status);
      }).toList();

      return filtered;
    }

    final filteredItems = getFilteredItems();

    Widget buildOption({
      required String label,
      required String value,
      required String selectedValue,
      required ValueChanged<String> onChanged,
    }) {
      final isSelected = selectedValue == value;
      return InkWell(
        onTap: () => onChanged(value),
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? Icons.radio_button_checked : Icons.circle_outlined,
                size: 18,
                color: isSelected ? colorScheme.primary : colorScheme.outline,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      );
    }

    bool isAllFilteredSelected() {
      final filteredIds =
          filteredItems.map((item) => item.id).whereType<int>().toSet();
      if (filteredIds.isEmpty) return false;
      return selectedItemIds.value.containsAll(filteredIds);
    }

    void toggleSelectAll() {
      final allFilteredSelected = isAllFilteredSelected();
      final filteredIds =
          filteredItems.map((item) => item.id).whereType<int>().toSet();
      if (allFilteredSelected) {
        final next = Set<int>.from(selectedItemIds.value);
        next.removeAll(filteredIds);
        selectedItemIds.value = next;
      } else {
        final next = Set<int>.from(selectedItemIds.value);
        next.addAll(filteredIds);
        selectedItemIds.value = next;
      }
    }

    void clearSelection() {
      selectedItemIds.value = {};
    }

    return PopScope(
      canPop: !isDownloading.value,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                color: colorScheme.primary,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      '下载验货清单',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        Icons.close,
                        color: colorScheme.onPrimary,
                        size: 24,
                      ),
                      onPressed: isDownloading.value
                          ? null
                          : () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(bottom: bottomPadding),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 48,
                                    child: Text(
                                      'SKU :',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: textDark,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  if (skuItems.isEmpty)
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 4),
                                        height: 56,
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              128, 237, 237, 237),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: const Text(
                                          '暂无 SKU',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: textMuted,
                                          ),
                                        ),
                                      ),
                                    )
                                  else ...[
                                    buildOption(
                                      label: '全部',
                                      value: 'all',
                                      selectedValue: selectedSkuType.value,
                                      onChanged: (value) {
                                        selectedSkuType.value = value;
                                        if (value != 'some') {
                                          selectedItemIds.value = {};
                                        }
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    buildOption(
                                      label: '从列表中选择',
                                      value: 'some',
                                      selectedValue: selectedSkuType.value,
                                      onChanged: (value) {
                                        selectedSkuType.value = value;
                                      },
                                    ),
                                  ]
                                ],
                              ),
                            ],
                          ),
                          if (selectedSkuType.value == 'some') ...[
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 48, right: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(90, 237, 237, 237),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 5),
                                    TextField(
                                      controller: searchController,
                                      onChanged: (value) {
                                        searchKeyword.value = value;
                                      },
                                      style: const TextStyle(fontSize: 12),
                                      decoration: InputDecoration(
                                        hintText: '搜索SKU编号...',
                                        hintStyle:
                                            const TextStyle(fontSize: 12),
                                        prefixIcon:
                                            const Icon(Icons.search, size: 16),
                                        suffixIcon: searchKeyword
                                                .value.isNotEmpty
                                            ? IconButton(
                                                icon: const Icon(Icons.clear,
                                                    size: 18),
                                                onPressed: () {
                                                  searchController.clear();
                                                  searchKeyword.value = '';
                                                },
                                              )
                                            : null,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 0,
                                        ),
                                        isDense: true,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          ...inspectionStatusLabelMap.entries
                                              .map((entry) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 4),
                                              child: FilterChip(
                                                label: Text(entry.value,
                                                    style: const TextStyle(
                                                        fontSize: 12)),
                                                selected: selectedStatusFilter
                                                    .value
                                                    .contains(entry.key),
                                                onSelected: (selected) {
                                                  final next = Set<int?>.from(
                                                      selectedStatusFilter
                                                          .value);
                                                  selected
                                                      ? next.add(entry.key)
                                                      : next.remove(entry.key);
                                                  selectedStatusFilter.value =
                                                      next;
                                                },
                                                showCheckmark: false,
                                                visualDensity:
                                                    VisualDensity.compact,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4),
                                                labelStyle: TextStyle(
                                                  color: selectedStatusFilter
                                                          .value
                                                          .contains(entry.key)
                                                      ? colorScheme.onPrimary
                                                      : getStatusColor(
                                                          entry.key),
                                                ),
                                                backgroundColor:
                                                    Colors.transparent,
                                                selectedColor:
                                                    getStatusColor(entry.key),
                                              ),
                                            );
                                          }).toList(),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 4),
                                            child: FilterChip(
                                              label: const Text('未验货',
                                                  style:
                                                      TextStyle(fontSize: 12)),
                                              selected: selectedStatusFilter
                                                  .value
                                                  .contains(0),
                                              onSelected: (selected) {
                                                final next = Set<int?>.from(
                                                    selectedStatusFilter.value);
                                                selected
                                                    ? next.add(0)
                                                    : next.remove(0);
                                                selectedStatusFilter.value =
                                                    next;
                                              },
                                              showCheckmark: false,
                                              visualDensity:
                                                  VisualDensity.compact,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4),
                                              labelStyle: TextStyle(
                                                color: selectedStatusFilter
                                                        .value
                                                        .contains(0)
                                                    ? colorScheme.onPrimary
                                                    : getStatusColor(0),
                                              ),
                                              backgroundColor:
                                                  Colors.transparent,
                                              selectedColor: getStatusColor(0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (filteredItems.isNotEmpty)
                                      Row(
                                        children: [
                                          TextButton.icon(
                                            onPressed: toggleSelectAll,
                                            icon: Icon(
                                              isAllFilteredSelected()
                                                  ? Icons.check_box
                                                  : Icons
                                                      .check_box_outline_blank,
                                              size: 20,
                                              color: colorScheme.primary,
                                            ),
                                            label: Text(
                                              isAllFilteredSelected()
                                                  ? '取消全选'
                                                  : '全选当前 (${filteredItems.length})',
                                              style: TextStyle(
                                                  color: colorScheme.primary),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: clearSelection,
                                            child: Text(
                                              '清空所有',
                                              style: TextStyle(
                                                  color: colorScheme.error),
                                            ),
                                          ),
                                          const Text('   当前已选:',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: textMuted)),
                                          Text(
                                              selectedItemIds.value.length
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 13,
                                              )),
                                        ],
                                      ),
                                    const Divider(
                                        height: 1,
                                        color:
                                            Color.fromARGB(55, 158, 158, 158)),
                                    if (filteredItems.isEmpty)
                                      const Padding(
                                        padding: EdgeInsets.only(left: 0),
                                        child: Text(
                                          '无匹配SKU',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: textMuted,
                                          ),
                                        ),
                                      )
                                    else
                                      Padding(
                                        padding: const EdgeInsets.only(left: 0),
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxHeight: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.32,
                                          ),
                                          child: ListView.separated(
                                            shrinkWrap: true,
                                            padding: EdgeInsets.zero,
                                            itemCount: filteredItems.length,
                                            separatorBuilder: (_, __) =>
                                                const SizedBox(height: 2),
                                            itemBuilder: (context, index) {
                                              final item = filteredItems[index];
                                              final itemId = item.id;
                                              if (itemId == null) {
                                                return const SizedBox.shrink();
                                              }
                                              final isChecked = selectedItemIds
                                                  .value
                                                  .contains(itemId);

                                              void toggleChecked(
                                                  bool? checked) {
                                                final next = Set<int>.from(
                                                    selectedItemIds.value);
                                                if (checked == true) {
                                                  next.add(itemId);
                                                } else {
                                                  next.remove(itemId);
                                                }
                                                selectedItemIds.value = next;
                                              }

                                              return Material(
                                                color: const Color(0xFFF9F9F9),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                child: InkWell(
                                                  onTap: () =>
                                                      toggleChecked(!isChecked),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 8,
                                                      vertical: 2,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Checkbox(
                                                          value: isChecked,
                                                          onChanged:
                                                              toggleChecked,
                                                          materialTapTargetSize:
                                                              MaterialTapTargetSize
                                                                  .shrinkWrap,
                                                          visualDensity:
                                                              VisualDensity
                                                                  .compact,
                                                          activeColor:
                                                              colorScheme
                                                                  .primary,
                                                          side: BorderSide(
                                                            color: colorScheme
                                                                .primary,
                                                            width: 1.5,
                                                          ),
                                                        ),
                                                        Text(
                                                          item.itemNo ?? '无编号',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 15),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        const SizedBox(
                                                            width: 4),
                                                        InspectionStatusTag(
                                                          status: item.status,
                                                          needIcon: false,
                                                          fontSize: 12,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: isDownloading.value
                                      ? null
                                      : () => downloadInspectionImagePackage(
                                            context: context,
                                            inspectionTaskId: id,
                                            selectedSkuType:
                                                selectedSkuType.value,
                                            selectedItemIds:
                                                selectedItemIds.value,
                                            skuItems: skuItems,
                                            isWithFolder: true,
                                            isDownloading: isDownloading,
                                          ),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    backgroundColor: colorScheme.secondary,
                                  ),
                                  child: Text(
                                    isDownloading.value ? '下载中...' : 'SKU为文件夹',
                                    style: TextStyle(
                                        color: colorScheme.onSecondary,
                                        fontSize: 13),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: isDownloading.value
                                      ? null
                                      : () => downloadInspectionImagePackage(
                                            context: context,
                                            inspectionTaskId: id,
                                            selectedSkuType:
                                                selectedSkuType.value,
                                            selectedItemIds:
                                                selectedItemIds.value,
                                            skuItems: skuItems,
                                            isWithFolder: false,
                                            isDownloading: isDownloading,
                                          ),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: colorScheme.onPrimary,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    backgroundColor: colorScheme.primary,
                                  ),
                                  child: Text(
                                    isDownloading.value ? '下载中...' : '无文件夹',
                                    style: TextStyle(
                                        color: colorScheme.onSecondary,
                                        fontSize: 13),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '· SKU为文件夹：下载图片以SKU为文件夹分类，同时对图片重命名',
                                  style: TextStyle(
                                      color: colorScheme.outline, fontSize: 11),
                                  softWrap: true,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '· 无文件夹：下载图片放在一个文件夹，同时对图片重命名',
                                  style: TextStyle(
                                      color: colorScheme.outline, fontSize: 11),
                                  softWrap: true,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                        ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> downloadInspectionImagePackage({
  required BuildContext context,
  required int inspectionTaskId,
  required String selectedSkuType,
  required Set<int> selectedItemIds,
  required List<InspectionItem> skuItems,
  required bool isWithFolder,
  required ValueNotifier<bool> isDownloading,
}) async {
  if (isDownloading.value == true ||
      (selectedSkuType == 'some' && selectedItemIds.isEmpty)) {
    return;
  }
  isDownloading.value = true;
  final ids = selectedSkuType == 'all'
      ? skuItems.map((item) => item.id).whereType<int>().toList()
      : selectedItemIds.toList();
  try {
    await exportInspectionImagePackageWithSelectedSkus(
      context,
      inspectionTaskId,
      ids,
      isWithFolder: isWithFolder,
      onDownloadComplete: () {
        isDownloading.value = false;
      },
    );
  } finally {
    isDownloading.value = false;
  }
}

class DownloadInspectionReportSheet extends HookConsumerWidget {
  final int id; //整张验货任务id

  const DownloadInspectionReportSheet({
    super.key,
    required this.id, //整张验货任务id
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const Color textDark = Color(0xFF333333);
    const Color textMuted = Color(0xFF666666);
    final selectedSkuType = useState<String>('all');
    final selectedFormat = useState<String>('pdf');
    final isDownloading = useState(false);
    final selectedItemIds = useState<Set<int>>({});
    final colorScheme = Theme.of(context).colorScheme;
    final detailState = ref.watch(inspectionDetailProvider);
    final reportPerSku = detailState.reportPerSku;
    final skuItems =
        detailState.inspection?.items ?? const <InspectionItem>[]; //验货的sku列表

    // 获取键盘高度
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    Widget buildOption({
      required String label,
      required String value,
      required String selectedValue,
      required ValueChanged<String> onChanged,
    }) {
      final isSelected = selectedValue == value;
      return InkWell(
        onTap: () => onChanged(value),
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? Icons.radio_button_checked : Icons.circle_outlined,
                size: 18,
                color: isSelected ? colorScheme.primary : colorScheme.outline,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return PopScope(
        canPop: !isDownloading.value,
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  color: colorScheme.primary,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '下载验货清单',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          Icons.close,
                          color: colorScheme.onPrimary,
                          size: 24,
                        ),
                        onPressed: isDownloading.value
                            ? null
                            : () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: bottomPadding),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 64,
                                    child: Text(
                                      'SKU :',
                                      style: TextStyle(
                                          fontSize: 15, color: textDark),
                                    ),
                                  ),
                                  buildOption(
                                    label: '全部',
                                    value: 'all',
                                    selectedValue: selectedSkuType.value,
                                    onChanged: (value) {
                                      selectedSkuType.value = value;
                                      if (value != 'some') {
                                        selectedItemIds.value = {};
                                      }
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  if (reportPerSku) //每个sku可以生成一个报告
                                    buildOption(
                                      label: '从列表中选择',
                                      value: 'some',
                                      selectedValue: selectedSkuType.value,
                                      onChanged: (value) {
                                        selectedSkuType.value = value;
                                      },
                                    ),
                                ],
                              ),
                              if (selectedSkuType.value == 'some') ...[
                                const SizedBox(height: 8),
                                if (skuItems.isEmpty)
                                  const Padding(
                                    padding: EdgeInsets.only(left: 64),
                                    child: Text(
                                      '暂无 SKU',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: textMuted,
                                      ),
                                    ),
                                  )
                                else
                                  Padding(
                                    padding: const EdgeInsets.only(left: 64),
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxHeight:
                                            MediaQuery.of(context).size.height *
                                                0.35,
                                      ),
                                      child: ListView.separated(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        itemCount: skuItems.length,
                                        separatorBuilder: (_, __) =>
                                            const SizedBox(height: 4),
                                        itemBuilder: (context, index) {
                                          final item = skuItems[index];
                                          final itemId = item.id;
                                          if (itemId == null) {
                                            return const SizedBox.shrink();
                                          }
                                          final isChecked = selectedItemIds
                                              .value
                                              .contains(itemId);

                                          void toggleChecked(bool? checked) {
                                            final next = Set<int>.from(
                                                selectedItemIds.value);
                                            if (checked == true) {
                                              next.add(itemId);
                                            } else {
                                              next.remove(itemId);
                                            }
                                            selectedItemIds.value = next;
                                          }

                                          return Material(
                                            color: const Color(0xFFF9F9F9),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            child: InkWell(
                                              onTap: () =>
                                                  toggleChecked(!isChecked),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Checkbox(
                                                      value: isChecked,
                                                      onChanged: toggleChecked,
                                                      materialTapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                      visualDensity:
                                                          VisualDensity.compact,
                                                      activeColor:
                                                          colorScheme.primary,
                                                      side: BorderSide(
                                                        color:
                                                            colorScheme.primary,
                                                        width: 1.5,
                                                      ),
                                                    ),
                                                    Text(
                                                      item.itemNo ?? '无编号',
                                                      style: const TextStyle(
                                                          fontSize: 15),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    InspectionStatusTag(
                                                      status: item.status,
                                                      needIcon: false,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const SizedBox(
                                width: 64,
                                child: Text(
                                  '格式 :',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              buildOption(
                                label: 'PDF',
                                value: 'pdf',
                                selectedValue: selectedFormat.value,
                                onChanged: (value) =>
                                    selectedFormat.value = value,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => {
                                    if (reportPerSku == true)
                                      {
                                        downloadInspectionCustomReportBySkuSelection(
                                          context: context,
                                          inspectionTaskId: id,
                                          selectedSkuType:
                                              selectedSkuType.value,
                                          skuItems: skuItems,
                                          selectedItemIds:
                                              selectedItemIds.value,
                                          reportPerSku: reportPerSku,
                                          isDownloading: isDownloading,
                                        ),
                                      }
                                    else
                                      {
                                        downloadInspectionCustomReportByTask(
                                          context: context,
                                          inspectionTaskId: id,
                                          reportPerSku: reportPerSku,
                                          isDownloading: isDownloading,
                                        ),
                                      }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    disabledBackgroundColor:
                                        colorScheme.surface,
                                    backgroundColor: colorScheme.surface,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    side: BorderSide(
                                      color: colorScheme.primary,
                                      width: 1,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  child: Text(
                                    isDownloading.value == true
                                        ? '下载中...'
                                        : '确定',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

Future<void> downloadInspectionCustomReportBySkuSelection({
  required BuildContext context,
  required int inspectionTaskId,
  required String selectedSkuType,
  required List<InspectionItem> skuItems,
  required Set<int> selectedItemIds,
  required bool reportPerSku,
  required ValueNotifier<bool> isDownloading,
}) async {
  if (isDownloading.value == true ||
      (selectedSkuType == 'some' && selectedItemIds.isEmpty) ||
      (selectedSkuType == 'all' && skuItems.isEmpty)) {
    return;
  }
  isDownloading.value = true;
  final ids = selectedSkuType == 'all'
      ? skuItems.map((item) => item.id).whereType<int>().toList()
      : selectedItemIds.toList();
  try {
    await exportInspectionCustomReport(
      context,
      inspectionTaskId,
      ids,
      reportPerSku: reportPerSku,
      onDownloadComplete: () {
        isDownloading.value = false;
      },
    );
  } finally {
    isDownloading.value = false;
  }
}

Future<void> downloadInspectionCustomReportByTask({
  required BuildContext context,
  required int inspectionTaskId,
  required bool reportPerSku,
  required ValueNotifier<bool> isDownloading,
}) async {
  if (isDownloading.value == true) {
    return;
  }
  isDownloading.value = true;
  try {
    await exportInspectionCustomReportByTask(
      context,
      inspectionTaskId,
      onDownloadComplete: () {
        isDownloading.value = false;
      },
    );
  } finally {
    isDownloading.value = false;
  }
}
