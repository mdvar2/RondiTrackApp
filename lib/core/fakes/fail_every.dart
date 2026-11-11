/// What a flaky fake throws: a stand-in for a dropped connection.
class FakeNetworkException implements Exception {
  /// Creates the exception.
  const new();

  @override
  String toString() => 'FakeNetworkException: the pretend network dropped';
}

/// Decides which calls a flaky fake fails: the first, then every [every]th
/// one after it. With 3, calls 1, 4, 7… fail; with 1, every call fails.
class FailEvery {
  /// Creates the counter. [every] must be at least 1; 1 fails every call.
  new(this.every) : assert(every >= 1, 'every must be at least 1');

  /// How often a call fails.
  final int every;

  int _calls = 0;

  /// Counts a call and returns whether it fails.
  bool next() => _calls++ % every == 0;
}
