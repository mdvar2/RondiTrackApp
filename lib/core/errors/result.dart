import 'package:ronditrack_app/core/errors/failure.dart';

/// What a repository returns: the value, or the [Failure] that stopped it.
///
/// A sealed class rather than a record such as `(T?, Failure?)`: a record
/// can hold both or neither, and a switch over it can't prove every case
/// was handled. Here there are exactly two, and the compiler checks both
/// (README "Decisions").
sealed class Result<T> {
  const new();

  /// The value, or the failure thrown. A provider uses this, so Riverpod
  /// holds the [Failure] in an `AsyncError`.
  T get valueOrThrow => switch (this) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
}

/// It worked.
final class Ok<T> extends Result<T> {
  /// Wraps [value].
  const new(this.value);

  /// The value.
  final T value;
}

/// It failed, and [failure] says how.
final class Err<T> extends Result<T> {
  /// Wraps [failure].
  const new(this.failure);

  /// How it failed.
  final Failure failure;
}
