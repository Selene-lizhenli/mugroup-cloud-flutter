import 'package:auto_route/auto_route.dart';
import 'package:cloud/hooks/useEasyRefreshController/hook.dart';
import 'package:cloud/models/inspection/inspection.dart';
import 'package:cloud/pages/inspection/widgets/inspection_card.dart';
import 'package:cloud/pages/widgets/confirm_dialog.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/inspection.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

const pageSize = 20;

class InspectionView extends HookConsumerWidget {
  final void Function(Future<void> Function())? setRefreshFn;

  const InspectionView({super.key, this.setRefreshFn});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    final refreshController = useEasyRefreshController(
      controlFinishLoad: true,
      controlFinishRefresh: true,
    );

    final searchController = useTextEditingController();
    final search = useState<String?>(null);
    final filterDate = useState<DateTime?>(null);

    final page = useRef(1);
    final inspections = useState<List<Inspection>>([]);

    String? getCreatedMonth() {
      final date = filterDate.value;
      if (date == null) return null;
      return '${date.year}-${date.month.toString().padLeft(2, '0')}';
    }

    List<DateTime> getRecentMonths() {
      final now = DateTime.now();
      return [
        DateTime(now.year, now.month, 1),
        DateTime(now.year, now.month - 1, 1),
        DateTime(now.year, now.month - 2, 1),
      ];
    }

    Future<void> fetchPage({required bool init}) async {
      if (init) {
        page.value = 1;
        inspections.value = [];
      }

      final resp = await getInspections(
        queryParameters: {
          'search': search.value,
          'page': page.value,
          'pageSize': pageSize,
          'created_month': getCreatedMonth(),
        },
      );

      if (init) {
        inspections.value = resp.data;
      } else {
        inspections.value = [...inspections.value, ...resp.data];
      }

      if (resp.data.isNotEmpty) {
        page.value++;
      }

      if (init) {
        refreshController.finishRefresh();
        refreshController.resetFooter();
      } else {
        refreshController.finishLoad(
          resp.data.length >= pageSize
              ? IndicatorResult.success
              : IndicatorResult.noMore,
        );
      }
    }

    // 显示年月选择器
    void showYearMonthPicker() {
      final now = DateTime.now();
      // 当前选中时间，默认为当前时间
      final currentTime = filterDate.value ?? now;

      DatePicker.showPicker(
        context,
        showTitleActions: true,
        // 使用自定义 Model 只显示年月
        pickerModel: YearMonthModel(
          currentTime: currentTime,
          minTime: DateTime(2020, 1, 1),
          maxTime: DateTime(now.year + 1, 12, 31),
          locale: LocaleType.zh,
        ),
        theme: DatePickerTheme(
          headerColor: Colors.white,
          backgroundColor: Colors.white,
          itemStyle: const TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
          doneStyle: TextStyle(color: colorScheme.primary, fontSize: 16),
          cancelStyle: const TextStyle(color: Colors.grey, fontSize: 16),
        ),
        onConfirm: (date) async {
          // 更新状态并刷新
          filterDate.value = date;
          await fetchPage(init: true);
        },
        locale: LocaleType.zh,
      );
    }

    useEffect(() {
      setRefreshFn?.call(() async {
        await refreshController.callRefresh();
      });
      return null;
    }, []);

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      clipBehavior: Clip.hardEdge,
      child: EasyRefresh(
        controller: refreshController,
        refreshOnStart: true,
        onRefresh: () async {
          try {
            await fetchPage(init: true);
          } catch (_) {
            refreshController.finishRefresh(IndicatorResult.fail);
          }
        },
        onLoad: () async {
          await fetchPage(init: false);
        },
        child: CustomScrollView(
          slivers: [
            MultiSliver(
              children: [
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(top: 4, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: TextField(
                            controller: searchController,
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                              hintText: '搜索验货任务',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 16),
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onSubmitted: (value) async {
                              search.value = value.isEmpty ? null : value;
                              await fetchPage(init: true);
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              _buildFilterChip(
                                context: context,
                                label: '全部',
                                isSelected: filterDate.value == null,
                                onTap: () async {
                                  filterDate.value = null;
                                  await fetchPage(init: true);
                                },
                              ),
                              const SizedBox(width: 8),
                              ...getRecentMonths().map((date) {
                                final isSelected =
                                    filterDate.value?.year == date.year &&
                                        filterDate.value?.month == date.month;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: _buildFilterChip(
                                    context: context,
                                    label: '${date.month}月',
                                    isSelected: isSelected,
                                    onTap: () async {
                                      filterDate.value = date;
                                      await fetchPage(init: true);
                                    },
                                  ),
                                );
                              }),
                              // 日历选择器按钮
                              GestureDetector(
                                onTap: showYearMonthPicker,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: (filterDate.value != null &&
                                            !getRecentMonths().any((d) =>
                                                d.year ==
                                                    filterDate.value!.year &&
                                                d.month ==
                                                    filterDate.value!.month))
                                        ? colorScheme.primary.withOpacity(0.1)
                                        : Colors.grey[100],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.calendar_month_outlined,
                                    size: 20,
                                    color: (filterDate.value != null &&
                                            !getRecentMonths().any((d) =>
                                                d.year ==
                                                    filterDate.value!.year &&
                                                d.month ==
                                                    filterDate.value!.month))
                                        ? colorScheme.primary
                                        : Colors.grey[600],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 10)),
                if (inspections.value.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        '暂无数据',
                        style: TextStyle(
                          color: colorScheme.surfaceContainerHighest,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    sliver: SliverMasonryGrid.count(
                      crossAxisCount: 1,
                      mainAxisSpacing: 4,
                      childCount: inspections.value.length,
                      itemBuilder: (context, index) {
                        final inspection = inspections.value[index];
                        return InspectionCard(
                          inspection: inspection,
                          onTap: () {
                            context.router.push(
                              InspectionDetailRoute(id: inspection.id!),
                            );
                          },
                          onDelete: () async {
                            if (inspection.items!.isNotEmpty) {
                              await ConfirmDialog.show(
                                context,
                                content: '该验货任务下有任务项不得删除？',
                              );
                              return;
                            }
                            final bool isConfirmed = await ConfirmDialog.show(
                              context,
                              content: '确定要删除验货任务${inspection.name}？',
                            );
                            if (isConfirmed) {
                              await deleteInspection(inspection.id!);
                              EasyLoading.showSuccess('删除成功');
                              await refreshController.callRefresh();
                            }
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class YearMonthModel extends DatePickerModel {
  YearMonthModel({
    super.currentTime,
    super.minTime,
    super.maxTime,
    super.locale,
  });

  @override
  List<int> layoutProportions() {
    // 数组分别代表 [年, 月, 日] 的宽度比例
    // 将日设为 0 即可隐藏
    return [1, 1, 0];
  }
}
