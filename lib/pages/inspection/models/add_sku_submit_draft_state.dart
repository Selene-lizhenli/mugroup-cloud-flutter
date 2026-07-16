import 'package:cloud/pages/inspection/models/add_sku_submit_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_sku_submit_draft_state.freezed.dart';

@freezed
abstract class AddSkuSubmitDraftState with _$AddSkuSubmitDraftState {
  const factory AddSkuSubmitDraftState({
    AddSkuSubmitData? data,
  }) = _AddSkuSubmitDraftState;
}
