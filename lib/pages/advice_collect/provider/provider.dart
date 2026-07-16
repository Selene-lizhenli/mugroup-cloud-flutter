import 'package:cloud/models/advice_collect/advice_collect_item.dart';
import 'package:cloud/pages/widgets/list.dart';
import 'package:cloud/services/advice_collect.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

/// 留言收集页状态（实现 MuListState 供 MuListView 使用）
class AdviceCollectState implements MuListState {
  const AdviceCollectState({
    this.bookList = const [],
    this.searchKeyword = '',
    this.isLoading = false,
    this.errorMessage,
    this.selectedBook,
    this.bookListMyself = const [],
    this.hasMore = false,
  });

  final List<AdviceCollectBook> bookList;
  final String searchKeyword;
  final bool isLoading;
  final String? errorMessage;
  final AdviceCollectBook? selectedBook;
  final List<AdviceCollectBook>? bookListMyself;
  @override
  final bool hasMore;

  AdviceCollectState copyWith({
    List<AdviceCollectBook>? bookList,
    String? searchKeyword,
    bool? isLoading,
    String? errorMessage,
    AdviceCollectBook? selectedBook,
    List<AdviceCollectBook>? bookListMyself,
    bool? hasMore,
  }) {
    return AdviceCollectState(
      bookList: bookList ?? this.bookList,
      searchKeyword: searchKeyword ?? this.searchKeyword,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      selectedBook: selectedBook,
      bookListMyself: bookListMyself ?? this.bookListMyself,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

@Riverpod(keepAlive: false)
class AdviceCollect extends _$AdviceCollect {
  @override
  AdviceCollectState build() => const AdviceCollectState();

  void setSearchKeyword(String keyword) {
    state = state.copyWith(searchKeyword: keyword);
  }

  void setSelectedBook(AdviceCollectBook? book) {
    state = state.copyWith(selectedBook: book);
  }

  Future<void> loadBooks({bool refresh = true}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final resp = await getAdviceCollectBooks({
        'page': 1,
        'pageSize': 50,
        'anonymous': false,
      });
      final data = resp.data;
      state = state.copyWith(
        bookList: data,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> loadBooksMyself({bool refresh = true}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final resp = await getAdviceCollectBooksMyself({
        'page': 1,
        'pageSize': 50,
      });
      final data = resp.data;
      state = state.copyWith(
        bookListMyself: data,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> sendMyAdvice(Map<String, dynamic> params) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final resp = await sendAdvice(params);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> sendMyComments(int id, Map<String, dynamic> params) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final resp = await sendAdviceComments(id, params);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }


  Future<void> sendMyCommentsComment(int id, Map<String, dynamic> params) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final resp = await sendCommentsComment(id, params);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}
