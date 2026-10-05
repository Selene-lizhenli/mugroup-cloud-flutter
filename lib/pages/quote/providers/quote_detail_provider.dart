import 'package:cloud/models/quote/quotation_list.dart';
import 'package:cloud/services/quotation_list.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud/models/user.dart';

part 'quote_detail_provider.g.dart';

@riverpod
class QuoteDetail extends _$QuoteDetail {
  @override
  FutureOr<QuotationList> build(int quoteId) async {
    return _fetchquoteDetail(quoteId);
  }

  Future<QuotationList> _fetchquoteDetail(int id) async {
    final resp = await getQuotationListById(id);

    return resp;
  }

  /// 添加协作人
  Future<void> addCollaborator(User user) async {
    final currentquote = state.value;
    if (currentquote == null) return;

    if (currentquote.collaborators?.any((u) => u.id == user.id) ?? false) {
      return;
    }

    state = const AsyncLoading<QuotationList>().copyWithPrevious(state);

    try {
      await addQuoteCollaborators(quoteId, {
        'user_ids': [user.id]
      });

      final newCollaborators = [...?currentquote.collaborators, user];

      final newquote = currentquote.copyWith(
        collaborators: newCollaborators,
      );

      state = AsyncData(newquote);
    } catch (e, stack) {
      state = AsyncError<QuotationList>(e, stack).copyWithPrevious(state);
      rethrow;
    }
  }

  Future<void> removeCollaborator(User user) async {
    final currentquote = state.value;
    if (currentquote == null) return;

    state = const AsyncLoading<QuotationList>().copyWithPrevious(state);

    try {
      await removeQuoteCollaborators(quoteId, {
        'user_ids': [user.id]
      });

      final newCollaborators =
          currentquote.collaborators?.where((u) => u.id != user.id).toList() ??
              [];

      final newquote = currentquote.copyWith(
        collaborators: newCollaborators,
      );

      state = AsyncData(newquote);
    } catch (e, stack) {
      state = AsyncError<QuotationList>(e, stack).copyWithPrevious(state);
      rethrow;
    }
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
