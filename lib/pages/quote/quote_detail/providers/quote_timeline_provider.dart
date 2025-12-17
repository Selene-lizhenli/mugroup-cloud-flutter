import 'package:cloud/pages/quote/quote_detail/models/quote_timeline_state.dart';
import 'package:cloud/services/sample.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final quoteTimelineProvider = StateNotifierProvider.autoDispose
    .family<QuoteTimelineNotifier, QuoteTimelineState, int>(
  (ref, userId) {
    return QuoteTimelineNotifier(ref, userId);
  },
);

class QuoteTimelineNotifier extends StateNotifier<QuoteTimelineState> {
  QuoteTimelineNotifier(this.ref, this.userId)
      : super(QuoteTimelineState.initial());

  final Ref ref;
  final int userId;

  static const int pageSize = 20;

  String? search;
  String? quoteAt;

  Future<void> fetch({required bool reset}) async {
    if (state.isLoading || state.isLoadingMore) return;

    if (reset) {
      state = state.copyWith(
        isLoading: true,
        page: 1,
        hasMore: true,
      );
    } else {
      if (!state.hasMore) return;
      state = state.copyWith(
        isLoadingMore: true,
        page: state.page + 1,
      );
    }

    final paramsData = {
      "user_id": userId,
      "page": state.page,
      "pageSize": pageSize,
      // if (quoteAt != null) 'quote_at': quoteAt!,
    };
    final newData = await getShowroomQuotation(paramsData);
    final newList = newData.data ?? [];

    state = state.copyWith(
      list: reset ? newList : [...state.list, ...newList],
      isLoading: false,
      isLoadingMore: false,
      hasMore: newList.length >= pageSize,
    );

    // logger.d(paramsData);
    // logger.d(state.list);
    // logger.d(state.hasMore);
  }

  /// 对外暴露的语义化方法
  Future<void> refresh() => fetch(reset: true);

  Future<void> loadMore() => fetch(reset: false);

// fetchQuoteDetail

  void updateSearch(String value) {
    search = value;
    refresh();
  }

  void updateQuoteAt(String? value) {
    quoteAt = value;
    refresh();
  }

  void clear() {
    // state =  (); //todo
  }
}
