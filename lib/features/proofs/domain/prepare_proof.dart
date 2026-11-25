import 'dart:isolate';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

/// The API's proof limit: 5 MB, JPEG, PNG or PDF (README "Notifications",
/// question 5). A photo is always sent as JPEG.
const int proofByteLimit = 5 * 1024 * 1024;

/// No side longer than this: plenty to read a bank slip, and a phone photo
/// of 4000 px shrinks to well under the limit.
const proofLongestSide = 2000;

/// The JPEG qualities tried, best first, until one fits under the limit.
const proofQualities = [85, 75, 65, 55, 45];

/// What preparing a photo came to.
sealed class PreparedProof {
  const new();
}

/// Ready to send: upright, no side over [proofLongestSide], no metadata.
final class ProofReady extends PreparedProof {
  /// Wraps the JPEG.
  const new(this.jpeg, {required this.quality});

  /// The JPEG to upload.
  final Uint8List jpeg;

  /// The quality it fitted at.
  final int quality;
}

/// The file isn't an image the phone can read.
final class ProofUnreadable extends PreparedProof {
  /// Creates the outcome.
  const new();
}

/// Even at the lowest quality it is over [limit] bytes.
final class ProofTooBig extends PreparedProof {
  /// Creates the outcome.
  const new(this.limit);

  /// The limit it couldn't get under.
  final int limit;
}

/// Prepares [photo] on another isolate, so the screen never freezes.
Future<PreparedProof> prepareProofInBackground(Uint8List photo) =>
    Isolate.run(() => prepareProof(photo));

/// Turns [photo] upright, shrinks it so no side is over [longestSide],
/// clears every bit of metadata (the location included: the `image`
/// package writes back the EXIF it read, GPS and all), and encodes JPEG at
/// falling [qualities] until it is under [limit] bytes.
PreparedProof prepareProof(
  Uint8List photo, {
  int longestSide = proofLongestSide,
  int limit = proofByteLimit,
  List<int> qualities = proofQualities,
}) {
  final decoded = img.decodeImage(photo);
  if (decoded == null) return const ProofUnreadable();

  // Upright first: bakeOrientation reads the EXIF orientation.
  var image = img.bakeOrientation(decoded);
  final longest = image.width > image.height ? image.width : image.height;
  if (longest > longestSide) {
    image = image.width >= image.height
        ? img.copyResize(image, width: longestSide)
        : img.copyResize(image, height: longestSide);
  }

  // On purpose: re-encoding alone keeps the EXIF, location included.
  image.exif = img.ExifData();

  for (final quality in qualities) {
    final jpeg = img.encodeJpg(image, quality: quality);
    if (jpeg.length <= limit) return ProofReady(jpeg, quality: quality);
  }
  return ProofTooBig(limit);
}
