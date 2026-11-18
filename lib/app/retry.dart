import 'package:ronditrack_app/core/errors/failure.dart';

/// How many times a provider asks again after no answer.
const maxNoAnswerRetries = 3;

/// The app's retry policy for every provider: the `retry` of the root
/// `ProviderScope` in `main`, and of the whole-app test harness.
///
/// A rule over [Failure] types, not over status codes (README "Decisions"):
///
/// * [NoAnswerFailure] is retried, up to [maxNoAnswerRetries] times, after
///   1, 2 and 4 seconds: a dropped connection may come back.
/// * Every answer the API gave is final: every `4xx` (not found, forbidden,
///   a rule, a rate limit, a session that ended), because asking again
///   can't change it, and a `5xx`, because the API already retried its
///   database before answering (measured: about 20 s for a 500), so three
///   more tries here would be a minute of spinner.
/// * Anything else is a bug, and retrying a bug only hides it.
///
/// Only providers retry, and every provider reads: no write is retried.
Duration? appRetry(int retryCount, Object error) => switch (error) {
  NoAnswerFailure() when retryCount < maxNoAnswerRetries => Duration(
    seconds: 1 << retryCount,
  ),
  _ => null,
};
