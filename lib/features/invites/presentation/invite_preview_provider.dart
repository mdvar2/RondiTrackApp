import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/core/state/view_state.dart';
import 'package:ronditrack_app/features/home/presentation/home_controller.dart';
import 'package:ronditrack_app/features/invites/domain/invite_preview.dart';
import 'package:ronditrack_app/features/invites/domain/invite_repository.dart';

part 'invite_preview_provider.g.dart';

/// One invite's preview, keyed by its code. Lifetime: autoDispose.
@riverpod
Future<InvitePreview> invitePreview(Ref ref, String code) =>
    ref.watch(inviteRepositoryProvider).fetchInvite(code);

/// The words for an invite that can't be shown.
const inviteNotFoundMessage = "We couldn't find that invite.";

/// The preview screen's view state. An invite is never "empty".
ViewState<InvitePreview> inviteViewState(AsyncValue<InvitePreview> value) =>
    viewStateFrom(
      value,
      isEmpty: (_) => false,
      describeError: (error) => error is InviteNotFoundException
          ? inviteNotFoundMessage
          : genericFailureMessage,
    );

/// Joining one invite: `null` until joined, then the stokvel's id.
///
/// Lifetime: autoDispose, keyed by code, like the preview it sits beside.
@riverpod
class InviteJoiner extends _$InviteJoiner {
  @override
  AsyncValue<String?> build(String code) => const AsyncData<String?>(null);

  /// Joins and returns the stokvel's id, reloading Home so the new stokvel
  /// is on it. Returns `null` if joining failed; the failure is in `state`.
  Future<String?> join() async {
    state = const AsyncLoading<String?>();
    try {
      final stokvelId = await ref.read(inviteRepositoryProvider).join(code);
      ref.invalidate(homeControllerProvider);
      if (ref.mounted) state = AsyncData<String?>(stokvelId);
      return stokvelId;
    } on Object catch (error, stack) {
      if (ref.mounted) state = AsyncError<String?>(error, stack);
      return null;
    }
  }
}
