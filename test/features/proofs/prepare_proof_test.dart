import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:ronditrack_app/features/proofs/domain/prepare_proof.dart';

/// A phone photo, as a camera writes it: noisy pixels (so it compresses
/// like a photo, not a flat colour), the camera's make, the orientation,
/// and where it was taken.
Uint8List _photo({
  required int width,
  required int height,
  int orientation = 1,
  bool withLocation = true,
}) {
  final random = Random(7);
  final image = img.Image(width: width, height: height);
  for (final pixel in image) {
    pixel
      ..r = random.nextInt(256)
      ..g = random.nextInt(256)
      ..b = random.nextInt(256);
  }
  image.exif.imageIfd['Make'] = 'TestPhone';
  image.exif.imageIfd['Orientation'] = orientation;
  if (withLocation) {
    // Bloemfontein: 29°07' S, 26°13' E.
    image.exif.gpsIfd['GPSLatitudeRef'] = img.IfdValueAscii('S');
    image.exif.gpsIfd['GPSLatitude'] = img.IfdValueRational(2912, 100);
    image.exif.gpsIfd['GPSLongitudeRef'] = img.IfdValueAscii('E');
    image.exif.gpsIfd['GPSLongitude'] = img.IfdValueRational(2622, 100);
  }
  return img.encodeJpg(image, quality: 95);
}

void main() {
  test('the test photo really carries a location', () {
    final exif = img.decodeJpgExif(_photo(width: 64, height: 48))!;
    expect(exif.gpsIfd.isEmpty, isFalse);
    // Latitude and longitude, each with its hemisphere.
    expect(exif.gpsIfd.values, hasLength(4));
  });

  test('the location is cleared, and every other bit of metadata', () {
    final ready = prepareProof(_photo(width: 64, height: 48)) as ProofReady;

    final exif = img.decodeJpgExif(ready.jpeg);
    expect(exif == null || exif.gpsIfd.isEmpty, isTrue, reason: 'GPS');
    expect(exif == null || exif.isEmpty, isTrue, reason: 'any EXIF');
  });

  test('turned upright: a sideways photo (orientation 6) comes out tall', () {
    final ready = prepareProof(
      _photo(width: 120, height: 80, orientation: 6),
    ) as ProofReady;

    final out = img.decodeJpg(ready.jpeg)!;
    expect((out.width, out.height), (80, 120));
  });

  test('no side over the longest side, keeping its shape', () {
    final ready = prepareProof(_photo(width: 4000, height: 3000)) as ProofReady;

    final out = img.decodeJpg(ready.jpeg)!;
    expect((out.width, out.height), (2000, 1500));
    expect(ready.jpeg.length, lessThanOrEqualTo(proofByteLimit));
  });

  test('falling quality until it fits under the limit', () {
    final photo = _photo(width: 600, height: 400);
    final best = prepareProof(photo, limit: 1 << 30) as ProofReady;
    expect(best.quality, 85);

    final tight =
        prepareProof(photo, limit: best.jpeg.length - 1) as ProofReady;
    expect(tight.quality, lessThan(85));
    expect(tight.jpeg.length, lessThan(best.jpeg.length));
  });

  test('never under the limit: says so, and sends nothing', () {
    expect(
      prepareProof(_photo(width: 600, height: 400), limit: 1000),
      isA<ProofTooBig>(),
    );
  });

  test('not an image at all: unreadable', () {
    expect(
      prepareProof(Uint8List.fromList([1, 2, 3, 4])),
      isA<ProofUnreadable>(),
    );
  });
}
