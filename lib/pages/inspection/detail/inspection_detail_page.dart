import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/inspection/const.dart';
import 'package:cloud/pages/inspection/detail/widgets/inspection_detail_info_card_with_expand.dart';
import 'package:cloud/pages/inspection/detail/widgets/inspection_detail_sku_list_simple.dart';
import 'package:cloud/pages/inspection/execute/widgets/dynamic_inspection.dart';
import 'package:cloud/pages/inspection/execute/widgets/dynamic_template_schema.dart';
import 'package:cloud/pages/inspection/execute/widgets/inspection_bottom_buttons.dart';
import 'package:cloud/pages/inspection/execute/widgets/inspection_remark.dart';
import 'package:cloud/pages/inspection/providers/inspection_detail_provider.dart';
import 'package:cloud/pages/inspection/widgets/download_sheet.dart';
import 'package:cloud/pages/inspection/detail/widgets/inspection_detail_info_card.dart';
import 'package:cloud/pages/inspection/detail/widgets/inspection_detail_sku_list.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/services/inspection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class InspectionDetailPage extends HookConsumerWidget {
  final int id;
  const InspectionDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(inspectionDetailProvider);
    final detailNotifier = ref.read(inspectionDetailProvider.notifier);
    final currentTab = useState(0);
    final isRefreshing = useState(false);
    final searchController = useTextEditingController();
    final colorScheme = Theme.of(context).colorScheme;

    const Color bgGrey = Color(0xFFF5F7FA);
    const Color textDark = Color(0xFF333333);
    useListenable(searchController);
    final isPageLoading = detailState.loading;

    final inspectionTaskDetail = detailState.inspection;
    final useNormalTemplate = detailState.useNormalTemplate;
    final reportPerSku = detailState.reportPerSku;

    final allItems = inspectionTaskDetail?.items ?? [];
    final int finishedCount = allItems
        .where((item) => inspectionStatusLabelMap.containsKey(item.status))
        .length;
    final int unfinishedCount = allItems
        .where((item) => !inspectionStatusLabelMap.containsKey(item.status))
        .length;
    final filteredItems = allItems.where((item) {
      // Tab 过滤
      bool tabMatch = true;
      if (currentTab.value == 1) {
        tabMatch = inspectionStatusLabelMap.containsKey(item.status); // 已验货
      } else if (currentTab.value == 2) {
        tabMatch = !inspectionStatusLabelMap.containsKey(item.status); // 未验货
      }

      // 搜索过滤
      bool searchMatch = true;
      final keyword = searchController.text.trim().toLowerCase();
      if (keyword.isNotEmpty) {
        searchMatch = (item.itemNo?.toLowerCase() ?? '').contains(keyword);
      }
      return tabMatch && searchMatch;
    }).toList();

    final remarkController =
        useTextEditingController(text: inspectionTaskDetail?.notes);
    final remarkHasError = useState(false);
    final isSubmitting = useState(false);
    final submittingStatus = useState<int>(0);

    useEffect(() {
      return () {
        remarkController.clear();
      };
    }, [remarkController]);

    // 进度计算
    final int total = allItems.length;
    final int finished = allItems
        .where((item) => inspectionStatusLabelMap.containsKey(item.status))
        .length;

    Future<void> refreshData({bool isSilent = false}) async {
      if (!isSilent) {
        isRefreshing.value = true;
      }
      try {
        await detailNotifier.load(id, silent: isSilent);
      } finally {
        if (!isSilent) {
          isRefreshing.value = false;
        }
      }
    }

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        refreshData(isSilent: false);
      });
      return null;
    }, [id]);

    Future<void> handleSubmitDynamic(int targetStatus) async {
      if (isSubmitting.value) return;

      if ((targetStatus == 2 || targetStatus == 3) &&
          remarkController.text.trim().isEmpty) {
        EasyLoading.showInfo('微瑕或不合格必须填写验货备注');
        remarkHasError.value = true;
        return;
      }

      submittingStatus.value = targetStatus;
      isSubmitting.value = true;

      try {
        final Map<String, dynamic> submitData = {};
        submitData['notes'] = remarkController.text;
        submitData['status'] = targetStatus;

        final currentTemplateJson = Map<String, dynamic>.from(
          inspectionTaskDetail?.inspectionDynamicTemplateJson ?? const {},
        );
        final dynamicZonesNodes = detailState.dynamicZonesNodes ?? const {};
        currentTemplateJson['zones'] = dynamicZonesNodes;
        submitData['inspection_dynamic_template_json'] = currentTemplateJson;

        final res = await submitInspectionTask(id, submitData);
        if (res == true) {
          EasyLoading.showSuccess('验货完成');
          if (context.mounted) Navigator.pop(context);
        }
      } on DioException catch (e) {
        final msg = e.response?.data is Map<String, dynamic>
            ? (e.response?.data['message']?.toString() ?? '提交失败，请重试')
            : (e.message ?? '提交失败，请重试');
        EasyLoading.showError(msg);
      } catch (_) {
        EasyLoading.showError('提交失败，请重试');
      } finally {
        isSubmitting.value = false;
      }
    }

    return Scaffold(
      backgroundColor: bgGrey,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
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
          IconButton(
            onPressed: () => {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                builder: (context) => FutureBuilder<List<String>>(
                  future: getInspectionExportTemplateKeys(),
                  builder: (context, snapshot) {
                    return useNormalTemplate == true
                        ? DownloadInspectionSheet(
                            id: id,
                          )
                        : DownloadInspectionReportSheet(
                            id: id,
                          );
                  },
                ),
              )
            },
            icon: Image.asset(
              "assets/icons/download.png",
              width: 18,
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            ),
          ),
          //  刷新按钮
          IconButton(
            onPressed: () => refreshData(isSilent: true),
            icon: Image.asset(
              "assets/icons/refresh.png",
              width: 16,
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          if (isPageLoading)
            const Positioned.fill(
              top: 0,
              child: ColoredBox(
                color: bgGrey,
                child: Center(
                  child: MuProgressIndicator(showText: true),
                ),
              ),
            )
          else
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (!useNormalTemplate) ...[
                        InspectionDetailInfoCardWithExpand(
                          inspectionTaskDetail: inspectionTaskDetail,
                          total: total,
                          finished: finished,
                          refreshData: refreshData,
                          reportPerSku: reportPerSku,
                        ),
                      ] else ...[
                        InspectionDetailInfoCard(
                          inspectionTaskDetail: inspectionTaskDetail,
                          total: total,
                          finished: finished,
                        ),
                      ],
                      const SizedBox(height: 12),
                      if (!useNormalTemplate && !reportPerSku) ...[
                        //case1  使用搭建的验货模板 且 整个任务是一个验货报告
                        InspectionDetailSkuListSimple(
                          items: filteredItems,
                        ),
                        const SizedBox(height: 12),
                        InspectionItemDynamicPage(
                          isLoading: false,
                          schema: DynamicTemplateSchema.extract(
                              inspectionTaskDetail
                                  ?.inspectionDynamicTemplateJson),
                        ),
                        const SizedBox(height: 12),
                        // 验货备注输入框
                        InspectionRemark(
                          blue: colorScheme.primary,
                          text: colorScheme.onSurface,
                          controller: remarkController,
                          hasError: remarkHasError.value,
                        ),
                        const SizedBox(height: 12),
                        // 验货底部提交按钮 ：合格 微瑕 不合格
                        InspectionBottomButtons(
                          onPressed: handleSubmitDynamic,
                          isSubmitting: isSubmitting.value,
                          submittingStatus: submittingStatus.value,
                        ),
                      ] else ...[
                        //case2 使用基础固定验货模板 且 根据sku进行验货
                        //case3 使用搭建的验货模板 且 根据sku进行验货
                        InspectionDetailSkuList(
                          inspectionId: id,
                          filteredItems: filteredItems,
                          totalCount: allItems.length,
                          finishedCount: finishedCount,
                          unfinishedCount: unfinishedCount,
                          searchController: searchController,
                          currentTab: currentTab,
                          useNormalTemplate: useNormalTemplate,
                          onRefresh: () => refreshData(isSilent: true),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ),
          if (isRefreshing.value)
            const Positioned.fill(
              child: ColoredBox(
                color: Color.fromARGB(158, 255, 255, 255),
                child: Center(
                  child: MuProgressIndicator(
                    showText: true,
                    text: '正在刷新...',
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
