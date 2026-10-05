import 'package:cloud/models/quote/quotation_list.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/timeline_item.dart';

class QuoteTimelineState {
  final List<QuotationList> list;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int page;

  const QuoteTimelineState({
    required this.list,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasMore,
    required this.page,
  });

  factory QuoteTimelineState.initial() {
    return const QuoteTimelineState(
      list: [],
      isLoading: false,
      isLoadingMore: false,
      hasMore: true,
      page: 1,
    );
  }

  QuoteTimelineState copyWith({
    List<QuotationList>? list,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? page,
  }) {
    return QuoteTimelineState(
      list: list ?? this.list,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
    );
  }
}
