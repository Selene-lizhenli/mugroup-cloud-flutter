import 'package:cloud/models/inspection/inspection.dart';
import 'package:cloud/pages/inspection/models/add_sku_submit_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'inspection_detail_state.freezed.dart';

@freezed
abstract class InspectionDetailState with _$InspectionDetailState {
  const factory InspectionDetailState({
    int? inspectionId,
    Inspection? inspection, 
    String? errorMessage,
    @Default(true) bool useNormalTemplate,
    AddSkuSubmitData? addSkuDraft,
    @Default(<String, List<Map<String, dynamic>>>{})
    Map<String, List<Map<String, dynamic>>?>? dynamicZonesNodes,
    @Default([]) List<Map<String, dynamic>> templateKeys,
    @Default(false) bool templateLoading,
    String? templateLoadError,
    @Default(false) bool loading,
    @Default(false) bool reportPerSku,
  }) = _InspectionDetailState;
}
