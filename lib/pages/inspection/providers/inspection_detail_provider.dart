import 'package:cloud/models/inspection/inspection.dart';
import 'package:cloud/models/user.dart';
import 'package:cloud/pages/inspection/execute/widgets/dynamic_template_schema.dart';
import 'package:cloud/pages/inspection/models/add_sku_submit_data.dart';
import 'package:cloud/pages/inspection/models/inspection_detail_state.dart';
import 'package:cloud/services/inspection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'inspection_detail_provider.g.dart';

@Riverpod(keepAlive: true)
class InspectionDetail extends _$InspectionDetail {
  @override
  InspectionDetailState build() {
    state = const InspectionDetailState(
      inspectionId: null,
      inspection: null, //任务详情
      errorMessage: null,
      addSkuDraft: null,
      dynamicZonesNodes: null,
      templateLoading: false, //加载验货中...
      templateLoadError: null, //验货error状态
      templateKeys: [], //验货的有权限的模板
      loading: false,
      useNormalTemplate: true, //是否使用集团基础验货模板
      reportPerSku: false, //是否1个sku生成1个验货报告 仅在搭建的验货模板下有效
    );
    return state;
  }

  void setAddSkuDraft(AddSkuSubmitData? data) {
    state = state.copyWith(addSkuDraft: data);
  }

  void clearAddSkuDraft() {
    state = state.copyWith(addSkuDraft: null);
  }

  void setDynamicZonesNode(Map<String, List<Map<String, dynamic>>> zones) {
    state = state.copyWith(dynamicZonesNodes: zones);
  }

  void clearDynamicMedias() {
    state = state.copyWith(dynamicZonesNodes: const {});
  }

// 查询可用的搭建的验货模板
  Future<void> loadTemplateKeys({bool force = false}) async {
    state = state.copyWith(
      templateLoading: true,
      templateLoadError: null,
    );

    try {
      final keys = await getInspectionTemplateKeys();
      state = state.copyWith(
        templateKeys: keys,
        templateLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        templateLoadError: '模板加载失败！',
        templateLoading: false,
      );
    }
  }

  List<User> _currentCollaborators(Inspection inspection) {
    return [...inspection.collaborators ?? []];
  }

  void setInspectionTask(Inspection inspection) {
    state = state.copyWith(inspection: inspection);
  }

  void setInspectionTaskUseNormalTemplate(bool useNormalTemplate) {
    state = state.copyWith(useNormalTemplate: useNormalTemplate);
  }

  void setInspectionTaskReportPerSku(bool reportPerSku) {
    state = state.copyWith(reportPerSku: reportPerSku);
  }

  // 加载验货任务详情
  Future<void> load(int inspectionId, {bool silent = false}) async {
    if (!silent == true) {
      state = state.copyWith(loading: true);
    }
    try {
      final inspection = await showInspection(inspectionId);

      if (inspection == null) {
        throw Exception('Inspection not found (ID: $inspectionId)');
      }
      final schema = DynamicTemplateSchema.extract(
        inspection.inspectionDynamicTemplateJson,
      );

      setDynamicZonesNode(
        schema == null ? const {} : DynamicTemplateSchema.zoneNodes(schema),
      );

      final useNormalTemplate =
          inspection.inspectionDynamicTemplateId == null ||
              inspection.inspectionDynamicTemplateId.toString() == '0';
      setInspectionTaskUseNormalTemplate(useNormalTemplate);
      setInspectionTaskReportPerSku(!useNormalTemplate &&
          inspection.inspectionDynamicTemplate?.inspectionScope == 'sku');

      state = state.copyWith(
        inspectionId: inspectionId,
        inspection: inspection,
        loading: false,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        inspectionId: inspectionId,
        errorMessage: e.toString(),
        loading: false,
      );
    }
  }

  void setFromList(Inspection inspection) {
    final schema = DynamicTemplateSchema.extract(
      inspection.inspectionDynamicTemplateJson,
    );

    final useNormalTemplate = inspection.inspectionDynamicTemplateId == null ||
        inspection.inspectionDynamicTemplateId.toString() == '0';
    setDynamicZonesNode(
      schema == null ? const {} : DynamicTemplateSchema.zoneNodes(schema),
    );
    setInspectionTaskUseNormalTemplate(useNormalTemplate);
    setInspectionTaskReportPerSku(!useNormalTemplate &&
        inspection.inspectionDynamicTemplate?.inspectionScope == 'sku');

    state = state.copyWith(
      inspectionId: inspection.id,
      inspection: inspection,
      loading: false,
      errorMessage: null,
    );
  }

  void setSearchKeyword(String? keyword) {
    state = state.copyWith(searchKeyword: keyword);
  }

  Future<void> loadItems(int taskId, {bool init = false}) async {
    if (init) {
      state = state.copyWith(itemsPage: 1, items: []);
    }
    state = state.copyWith(itemsLoading: true);

    try {
      final queryParams = <String, dynamic>{
        'page': state.itemsPage,
        'pageSize': 20,
        if (state.searchKeyword != null && state.searchKeyword!.isNotEmpty)
          'item_no': state.searchKeyword,
      };

      final resp =
          await getInspectionTaskItems(taskId, queryParameters: queryParams);

      final newItems = init ? resp.data : [...state.items, ...resp.data];

      final totalPages = resp.meta?.pagination?.totalPages ?? 0;
      final total = resp.meta?.pagination?.total ?? state.itemsTotal;
      final hasMore = state.itemsPage < totalPages;

      state = state.copyWith(
        items: newItems,
        itemsPage: state.itemsPage + 1,
        itemsLoading: false,
        itemsHasMore: hasMore,
        itemsTotal: total,
      );
    } catch (e) {
      state = state.copyWith(itemsLoading: false);
    }
  }

  Future<void> refresh({bool silent = false}) async {
    final inspectionId = state.inspectionId;
    if (inspectionId == null) return;
    await load(inspectionId, silent: silent);
    await loadItems(inspectionId, init: true);
  }

  Future<void> addCollaborator(User user) async {
    final inspectionId = state.inspectionId;
    final currentInspection = state.inspection;
    if (inspectionId == null || currentInspection == null) return;

    final collaborators = _currentCollaborators(currentInspection);
    if (collaborators.any((u) => u.id == user.id)) return;

    state = state.copyWith(errorMessage: null);

    try {
      await addCollaborators(inspectionId, {
        'user_ids': [user.id],
      });

      state = state.copyWith(
        inspection: currentInspection.copyWith(
          collaborators: [...collaborators, user],
        ),
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> removeCollaborator(User user) async {
    final inspectionId = state.inspectionId;
    final currentInspection = state.inspection;
    if (inspectionId == null || currentInspection == null) return;

    state = state.copyWith(errorMessage: null);

    try {
      await removeCollaborators(inspectionId, {
        'user_ids': [user.id],
      });

      final collaborators = _currentCollaborators(currentInspection);
      final newCollaborators =
          collaborators.where((u) => u.id != user.id).toList();

      state = state.copyWith(
        inspection: currentInspection.copyWith(
          collaborators: newCollaborators,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }
}
