import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:ronditrack_app/app/providers.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/features/proofs/data/proof_services.dart';
import 'package:ronditrack_app/features/proofs/domain/prepare_proof.dart';
import 'package:ronditrack_app/features/proofs/domain/proofs.dart';
import 'package:ronditrack_app/features/proofs/presentation/proof_controller.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';

import '../../helpers/app_harness.dart';
import '../../helpers/test_database.dart';

const _cycle =
    '/stokvels/${FakeSeed.mabenaFamilyId}/cycles/${FakeSeed.mabenaCycleId}';

/// An uploader that answers [answer] and counts its calls.
class _Uploader implements ProofUploader {
  new([this.answer = const Ok(null)]);

  final Result<void> answer;
  final List<String> ids = [];

  @override
  Future<Result<void>> upload(String contributionId, Uint8List jpeg) async {
    ids.add(contributionId);
    return answer;
  }
}

/// Hands over [photo] for either source.
class _Picker implements ProofPicker {
  new(this.photo);

  final Uint8List photo;

  @override
  Future<Uint8List?> pick(ProofSource source) async => photo;
}

Uint8List _jpeg() =>
    img.encodeJpg(img.Image(width: 40, height: 30), quality: 90);

void main() {
  group('the upload, step by step', () {
    ProviderContainer containerWith(ProofUploader uploader) {
      // An autoDispose provider: listened to, so it isn't disposed halfway.
      return ProviderContainer.test(
        overrides: [
          inMemoryDatabase(),
          proofUploaderProvider.overrideWithValue(uploader),
        ],
      )..listen(proofUploadProvider('c1'), (_, _) {});
    }

    test('preparing, then sending, then sent; a second press while busy '
        'sends nothing more', () async {
      final uploader = _Uploader();
      final container = containerWith(uploader);
      final notifier = container.read(proofUploadProvider('c1').notifier);
      final prepared = Completer<PreparedProof>();

      final first = notifier.send(_jpeg(), prepare: (_) => prepared.future);
      expect(container.read(proofUploadProvider('c1')), isA<ProofPreparing>());
      await notifier.send(_jpeg(), prepare: (_) => prepared.future);

      prepared.complete(ProofReady(_jpeg(), quality: 85));
      await first;

      expect(container.read(proofUploadProvider('c1')), isA<ProofSent>());
      expect(uploader.ids, ['c1']);
    });

    test(
      'a refusal from the API: in words, through the failure mapping',
      () async {
        final container = containerWith(
          _Uploader(const Err(RuleFailure(detail: 'Proof is locked.'))),
        );

        await container
            .read(proofUploadProvider('c1').notifier)
            .send(_jpeg(), prepare: (b) async => ProofReady(b, quality: 85));

        expect(
          container.read(proofUploadProvider('c1')),
          isA<ProofFailed>().having((s) => s.message, 'message', isNotEmpty),
        );
      },
    );

    test(
      'too big even made smaller: a clear message, and nothing sent',
      () async {
        final uploader = _Uploader();
        final container = containerWith(uploader);

        await container
            .read(proofUploadProvider('c1').notifier)
            .send(_jpeg(), prepare: (_) async => const ProofTooBig(5));

        expect(
          container.read(proofUploadProvider('c1')),
          isA<ProofFailed>().having(
            (s) => s.message,
            'message',
            contains('too big'),
          ),
        );
        expect(uploader.ids, isEmpty);
      },
    );
  });

  group('the cycle screen', () {
    testWidgets('her own contribution: Add proof, a photo made to fit on '
        'another isolate, then Proof sent', (tester) async {
      final uploader = FakeProofUploader();
      await pumpApp(
        tester,
        as: FakeSeed.lerato,
        size: phone,
        coldStart: _cycle,
        overrides: [
          proofUploaderProvider.overrideWithValue(uploader),
          proofPickerProvider.overrideWithValue(_Picker(_jpeg())),
        ],
      );
      final add = find.text('Add proof of payment');
      await tester.scrollUntilVisible(add, 200);

      await tester.tap(add);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Take a photo'));
      // Isolate.run doesn't finish on the test clock: alternate.
      for (
        var i = 0;
        i < 100 && find.text('Proof sent').evaluate().isEmpty;
        i++
      ) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 20)),
        );
        await tester.pump();
      }

      expect(find.text('Proof sent'), findsOneWidget);
      expect(uploader.sent.keys, ['7a6b5c4d-3e2f-4a1b-9c8d-7e6f5a4b0301']);
    });

    testWidgets("a treasurer confirms a member's paid contribution; then "
        'there is nothing left to confirm', (tester) async {
      await pumpApp(
        tester,
        as: FakeSeed.lerato,
        size: phone,
        coldStart: _cycle,
      );
      final confirm = find.text('Confirm payment');
      await tester.scrollUntilVisible(confirm, 200);

      await tester.tap(confirm);
      await tester.pumpAndSettle();

      expect(find.text('Confirm payment'), findsNothing);
    });

    testWidgets('a member sees no Confirm, and no Add proof on a payment '
        "that isn't theirs", (tester) async {
      await pumpApp(tester, as: FakeSeed.sipho, size: phone, coldStart: _cycle);
      await tester.scrollUntilVisible(find.text('Contributions'), 200);
      await tester.pumpAndSettle();

      expect(find.text('Confirm payment'), findsNothing);
      expect(find.text('Add proof of payment'), findsNothing);
    });
  });
}
