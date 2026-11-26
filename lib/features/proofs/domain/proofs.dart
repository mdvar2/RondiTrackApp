import 'dart:typed_data';

import 'package:ronditrack_app/core/errors/result.dart';

/// Where a proof photo comes from.
enum ProofSource {
  /// The phone's camera app (it holds the camera permission, not us).
  camera,

  /// The photo picker.
  photos,
}

/// The camera or the photo picker, behind an interface: the plugin stays in
/// a thin file, and tests hand over bytes.
abstract interface class ProofPicker {
  /// The photo's bytes, or `null` if the member backed out.
  Future<Uint8List?> pick(ProofSource source);
}

/// Sends a prepared proof to the API.
abstract interface class ProofUploader {
  /// `POST /contributions/{id}/proof`, multipart, through the app's Dio.
  Future<Result<void>> upload(String contributionId, Uint8List jpeg);
}

/// A treasurer confirms a member's contribution.
abstract interface class ContributionConfirmer {
  /// `POST /stokvels/{s}/cycles/{c}/contributions/{id}/confirm`.
  Future<Result<void>> confirm({
    required String stokvelId,
    required String cycleId,
    required String contributionId,
  });
}
