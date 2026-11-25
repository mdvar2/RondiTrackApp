// The generated confirm method's name is the whole path, longer than a line.
// ignore_for_file: lines_longer_than_80_chars

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ronditrack_app/core/data/api_values.dart';
import 'package:ronditrack_app/core/data/generated/rondi_track_api.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/features/proofs/domain/proofs.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';
import 'package:ronditrack_app/features/stokvels/domain/statuses.dart';

/// [ProofPicker] over image_picker. Not covered by unit tests: it opens the
/// phone's camera app (README "What isn't tested").
class ImagePickerProofPicker implements ProofPicker {
  /// Creates the picker.
  const new();

  @override
  Future<Uint8List?> pick(ProofSource source) async {
    final file = await ImagePicker().pickImage(
      source: switch (source) {
        ProofSource.camera => ImageSource.camera,
        ProofSource.photos => ImageSource.gallery,
      },
      // The phone does no resizing of its own: prepareProof does it all,
      // and clears the metadata on purpose.
      requestFullMetadata: false,
    );
    return file == null ? null : await file.readAsBytes();
  }
}

/// [ProofUploader] on the API. One hand-written multipart call, through the
/// app's own Dio, so the session interceptor signs it: the generated client
/// can't describe an upload. The file name says nothing about anyone.
class ApiProofUploader implements ProofUploader {
  /// Creates the uploader over the app's [Dio].
  new(this._dio);

  final Dio _dio;

  @override
  Future<Result<void>> upload(String contributionId, Uint8List jpeg) => guard(
    () => _dio.post<void>(
      '/api/v1/contributions/$contributionId/proof',
      data: FormData.fromMap({
        'file': MultipartFile.fromBytes(
          jpeg,
          filename: 'proof.jpg',
          contentType: DioMediaType('image', 'jpeg'),
        ),
      }),
    ),
  );
}

/// [ContributionConfirmer] on the API.
class ApiContributionConfirmer implements ContributionConfirmer {
  /// Creates the confirmer.
  new(this._api);

  final RondiTrackApi _api;

  @override
  Future<Result<void>> confirm({
    required String stokvelId,
    required String cycleId,
    required String contributionId,
  }) => guard(
    () => _api.contributionConfirmation
        .postApiV1StokvelsStokvelIdCyclesCycleIdContributionsContributionIdConfirm(
          stokvelId: stokvelId,
          cycleId: cycleId,
          contributionId: contributionId,
        ),
  );
}

/// [ProofUploader] for the fakes: keeps what was sent.
class FakeProofUploader implements ProofUploader {
  /// What was sent, by contribution id.
  final Map<String, Uint8List> sent = {};

  @override
  Future<Result<void>> upload(String contributionId, Uint8List jpeg) async {
    sent[contributionId] = jpeg;
    return const Ok(null);
  }
}

/// [ContributionConfirmer] over the fakes' seed.
class FakeContributionConfirmer implements ContributionConfirmer {
  /// Creates the confirmer over [stokvels] (the fakes' shared copy).
  new({required this.stokvels});

  /// The fakes' shared, changeable seed.
  final List<FakeStokvel> stokvels;

  @override
  Future<Result<void>> confirm({
    required String stokvelId,
    required String cycleId,
    required String contributionId,
  }) async {
    final entry = stokvels.where((s) => s.stokvel.id == stokvelId).firstOrNull;
    final index =
        entry?.contributions.indexWhere((c) => c.id == contributionId) ?? -1;
    if (entry == null || index < 0) return const Err(NotFoundFailure());
    entry.contributions[index] = entry.contributions[index].copyWith(
      status: ContributionStatus.confirmed,
    );
    return const Ok(null);
  }
}
