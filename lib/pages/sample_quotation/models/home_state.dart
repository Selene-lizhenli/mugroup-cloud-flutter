import 'package:cloud/models/quote/export_template.dart';
import 'package:cloud/models/quote/quotation_list.dart';
import 'package:cloud/models/single_station/single_station_products.dart';
import 'package:cloud/pages/widgets/list.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
abstract class SampleQuotationState
    with _$SampleQuotationState
    implements MuListState {
  const SampleQuotationState._();
  const factory SampleQuotationState({
    // ----------  报价单列表 ----------
    @Default(<ExportTemplate>[]) List<ExportTemplate> dynamicTemplates,
    @Default(<QuotationList>[]) List<QuotationList> list,
    @Default(<SingleStationSample>[]) List<SingleStationSample> productsList,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    String? errorMessage,
    @Default(1) int page,
    @Default(true) bool hasMore,
    @Default('') String searchKeyword, // 搜索关键词
    QuotationList? baseInfo,
  }) = _SampleQuotationState;
}
