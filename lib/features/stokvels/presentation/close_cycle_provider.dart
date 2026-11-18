import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/core/state/view_state.dart';
import 'package:ronditrack_app/features/stokvels/domain/cycle_close_preview.dart';
import 'package:ronditrack_app/features/stokvels/presentation/stokvel_detail_provider.dart';

part 'close_cycle_provider.g.dart';

/// What closing cycle [cycleId] of stokvel [stokvelId] would record.
///
/// Lifetime: autoDispose, like the cycle it sits on: it holds other
/// members' names and shortfalls, and goes when the screen does.
@riverpod
Future<CycleClosePreview> closePreview(
  Ref ref,
  String stokvelId,
  String cycleId,
) async {
  final repository = ref.watch(stokvelRepositoryProvider);
  return (await repository.fetchClosePreview(stokvelId, cycleId)).valueOrThrow;
}

/// The close screen's view state. A Member's `403` arrives as a failure
/// with its own words ("Your role in this stokvel doesn't allow that…"),
/// and a non-member's `404` as the cycle's "not found".
ViewState<CycleClosePreview> closePreviewViewState(
  AsyncValue<CycleClosePreview> value,
) => viewStateFrom(
  value,
  isEmpty: (_) => false,
  notFoundMessage: cycleNotFoundMessage,
);
