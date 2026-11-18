import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/errors/result.dart';

/// Matches a [Result] that failed with a [F].
Matcher failsWith<F extends Failure>() =>
    isA<Err<Object?>>().having((result) => result.failure, 'failure', isA<F>());
