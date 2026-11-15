/// An answer that will never change by asking again: the thing doesn't
/// exist, or the person isn't allowed to know it does (the API's `404`).
///
/// The app's retry policy (`appRetry`) never retries one of these, so a
/// link to someone else's stokvel says "not found" at once instead of
/// sitting on a spinner while Riverpod retries.
abstract interface class NotFoundException implements Exception;
