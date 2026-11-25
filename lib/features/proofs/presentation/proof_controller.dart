import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/features/proofs/domain/prepare_proof.dart';
import 'package:ronditrack_app/features/proofs/domain/proofs.dart';

part 'proof_controller.g.dart';

/// Where a proof upload is.
sealed class ProofState {
  const new();
}

/// Nothing yet.
final class ProofIdle extends ProofState {
  /// Creates the state.
  const new();
}

/// Being made to fit, on another isolate.
final class ProofPreparing extends ProofState {
  /// Creates the state.
  const new();
}

/// On its way to the API.
final class ProofSending extends ProofState {
  /// Creates the state.
  const new();
}

/// Received.
final class ProofSent extends ProofState {
  /// Creates the state.
  const new();
}

/// Not sent, and why, in words.
final class ProofFailed extends ProofState {
  /// Creates the state.
  const new(this.message);

  /// What to tell the member.
  final String message;
}

/// One contribution's proof upload. On screen the button watches it; a
/// test listens to it (an autoDispose provider can be disposed halfway).
@riverpod
class ProofUpload extends _$ProofUpload {
  @override
  ProofState build(String contributionId) => const ProofIdle();

  /// Makes [photo] fit (upright, shrunk, no metadata) off the main isolate,
  /// then sends it. Pressing again while busy does nothing.
  Future<void> send(
    Uint8List photo, {
    Future<PreparedProof> Function(Uint8List) prepare =
        prepareProofInBackground,
  }) async {
    if (state is ProofPreparing || state is ProofSending) return;
    state = const ProofPreparing();
    final prepared = await prepare(photo);
    if (!ref.mounted) return;
    switch (prepared) {
      case ProofUnreadable():
        state = const ProofFailed("That file isn't a photo we can read.");
        return;
      case ProofTooBig():
        state = const ProofFailed(
          'That photo is too big to send, even made smaller. Try a closer '
          'photo of the slip.',
        );
        return;
      case ProofReady(:final jpeg):
        state = const ProofSending();
        final result = await ref
            .read(proofUploaderProvider)
            .upload(contributionId, jpeg);
        if (!ref.mounted) return;
        state = switch (result) {
          Ok() => const ProofSent(),
          // Through the app's failure mapping, in words.
          Err(:final failure) => ProofFailed(failure.message),
        };
    }
  }
}

/// The camera or the photo picker, for the proof button.
Future<Uint8List?> pickProof(WidgetRef ref, ProofSource source) =>
    ref.read(proofPickerProvider).pick(source);

/// A treasurer confirms a contribution (the API then tells the member).
Future<Result<void>> confirmContribution(
  WidgetRef ref, {
  required String stokvelId,
  required String cycleId,
  required String contributionId,
}) => ref
    .read(contributionConfirmerProvider)
    .confirm(
      stokvelId: stokvelId,
      cycleId: cycleId,
      contributionId: contributionId,
    );
