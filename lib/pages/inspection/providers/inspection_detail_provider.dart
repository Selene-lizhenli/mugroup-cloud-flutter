import 'package:cloud/models/inspection/inspection.dart';
import 'package:cloud/services/inspection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud/models/user.dart';

part 'inspection_detail_provider.g.dart';

@riverpod
class InspectionDetail extends _$InspectionDetail {
  @override
  FutureOr<Inspection> build(int inspectionId) async {
    return _fetchInspectionDetail(inspectionId);
  }

  Future<Inspection> _fetchInspectionDetail(int id) async {
    final resp = await showInspection(id);

    if (resp == null) {
      throw Exception('Inspection not found (ID: $id)');
    }

    return resp;
  }

  Future<void> addCollaborator(User user) async {
    final currentInspection = state.value;
    if (currentInspection == null) return;

    if (currentInspection.collaborators!.any((u) => u.id == user.id)) return;

    state = const AsyncLoading<Inspection>().copyWithPrevious(state);

    try {
      await addCollaborators(inspectionId, {
        'user_ids': [user.id]
      });

      final newCollaborators = [...?currentInspection.collaborators, user];

      final newInspection = currentInspection.copyWith(
        collaborators: newCollaborators,
      );

      state = AsyncData(newInspection);
    } catch (e, stack) {
      state = AsyncError<Inspection>(e, stack).copyWithPrevious(state);
      rethrow;
    }
  }

  Future<void> removeCollaborator(User user) async {
    final currentInspection = state.value;
    if (currentInspection == null) return;

    state = const AsyncLoading<Inspection>().copyWithPrevious(state);

    try {
      await removeCollaborators(inspectionId, {
        'user_ids': [user.id]
      });

      final newCollaborators = currentInspection.collaborators
              ?.where((u) => u.id != user.id)
              .toList() ??
          [];

      final newInspection = currentInspection.copyWith(
        collaborators: newCollaborators,
      );

      state = AsyncData(newInspection);
    } catch (e, stack) {
      state = AsyncError<Inspection>(e, stack).copyWithPrevious(state);
      rethrow;
    }
  }

  Future<void> refresh() async {
    ref.invalidateSelf();

    await future;
  }
}
