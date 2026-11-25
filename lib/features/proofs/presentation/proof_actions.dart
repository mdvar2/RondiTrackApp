import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/features/proofs/domain/proofs.dart';
import 'package:ronditrack_app/features/proofs/presentation/proof_controller.dart';
import 'package:ronditrack_app/features/stokvels/presentation/stokvel_detail_provider.dart';

/// "Add proof": the camera or the photo picker, then the upload. The label
/// says what is happening, and it can't be pressed twice.
class ProofButton extends ConsumerWidget {
  /// Creates the button for [contributionId].
  const new({required this.contributionId, super.key});

  /// The member's own contribution.
  final String contributionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = proofUploadProvider(contributionId);
    final state = ref.watch(provider);
    final busy = state is ProofPreparing || state is ProofSending;
    final label = switch (state) {
      ProofIdle() || ProofFailed() => 'Add proof of payment',
      ProofPreparing() => 'Preparing photo…',
      ProofSending() => 'Sending proof…',
      ProofSent() => 'Proof sent',
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OutlinedButton.icon(
          key: Key('add-proof-$contributionId'),
          onPressed: busy || state is ProofSent
              ? null
              : () async {
                  final source = await showModalBottomSheet<ProofSource>(
                    context: context,
                    builder: (context) => SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.photo_camera),
                            title: const Text('Take a photo'),
                            onTap: () =>
                                Navigator.pop(context, ProofSource.camera),
                          ),
                          ListTile(
                            leading: const Icon(Icons.photo_library),
                            title: const Text('Choose a photo'),
                            onTap: () =>
                                Navigator.pop(context, ProofSource.photos),
                          ),
                        ],
                      ),
                    ),
                  );
                  if (source == null) return;
                  final photo = await pickProof(ref, source);
                  if (photo == null) return;
                  await ref.read(provider.notifier).send(photo);
                },
          icon: busy
              ? const SizedBox.square(
                  dimension: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(state is ProofSent ? Icons.check : Icons.receipt_long),
          label: Text(label),
        ),
        if (state case ProofFailed(:final message))
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              message,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
      ],
    );
  }
}

/// "Confirm": a treasurer says the money arrived. The API saves it, then
/// tells the member's phones; here the cycle is fetched again.
class ConfirmButton extends ConsumerStatefulWidget {
  /// Creates the button.
  const new({
    required this.stokvelId,
    required this.cycleId,
    required this.contributionId,
    super.key,
  });

  /// The stokvel.
  final String stokvelId;

  /// The cycle.
  final String cycleId;

  /// The contribution to confirm.
  final String contributionId;

  @override
  ConsumerState<ConfirmButton> createState() => _ConfirmButtonState();
}

class _ConfirmButtonState extends ConsumerState<ConfirmButton> {
  bool _busy = false;
  String? _error;

  Future<void> _confirm() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final result = await confirmContribution(
      ref,
      stokvelId: widget.stokvelId,
      cycleId: widget.cycleId,
      contributionId: widget.contributionId,
    );
    if (!mounted) return;
    switch (result) {
      case Ok():
        ref.invalidate(cycleDetailProvider(widget.stokvelId, widget.cycleId));
      case Err(:final failure):
        setState(() => _error = failure.message);
    }
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilledButton.tonal(
          key: Key('confirm-${widget.contributionId}'),
          onPressed: _busy ? null : _confirm,
          child: Text(_busy ? 'Confirming…' : 'Confirm payment'),
        ),
        if (_error case final error?)
          Text(
            error,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
      ],
    );
  }
}
