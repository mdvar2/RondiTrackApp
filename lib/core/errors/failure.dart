/// Every way a call can fail, as one sealed type: one case for each answer
/// the RondiTrack API gives, and one for no answer at all.
///
/// Each case decides its own words, once, in [message]. A screen shows
/// them and never compares a status code: it switches on the case, if it
/// needs to at all. `toFailure` (in `core/data`) is the only code that
/// turns what was thrown into one of these. README "Failures" has the
/// table.
///
/// Nothing here holds a name, an amount or a token: a failure is safe to
/// log.
sealed class Failure implements Exception {
  const new();

  /// What the person reads.
  String get message;

  /// The API's `correlationId` to quote, when the person should be able to
  /// find this failure in the API's logs: only for [ServerFailure].
  String? get reference => null;
}

/// `400`: the request broke a rule of its own shape, with the API's words
/// for it and, per field, what is wrong.
final class ValidationFailure extends Failure {
  /// Creates the failure.
  const new({this.detail, this.fieldErrors = const {}});

  /// The API's `detail`.
  final String? detail;

  /// The API's `errors`: each field's problems, by field name.
  final Map<String, List<String>> fieldErrors;

  @override
  String get message => detail ?? 'Some details need fixing.';

  @override
  String toString() => 'ValidationFailure';
}

/// `401`: nobody is signed in, or the session has ended.
///
/// Not final: the fake sign-in's own refusal extends it.
class UnauthorisedFailure extends Failure {
  /// Creates the failure. [atSignIn] is true when the sign-in itself was
  /// refused, rather than a session ending.
  const new({this.atSignIn = false});

  /// Whether the email and password were refused.
  final bool atSignIn;

  @override
  String get message => atSignIn
      ? "That email and password don't match an account."
      : 'Your session ended. Sign in again.';

  @override
  String toString() => 'UnauthorisedFailure';
}

/// `403`: a member asked for something their role here doesn't allow. The
/// person stays signed in.
final class ForbiddenFailure extends Failure {
  /// Creates the failure.
  const new();

  @override
  String get message =>
      "Your role in this stokvel doesn't allow that. Only its treasurer or "
      'chairperson can do it.';

  @override
  String toString() => 'ForbiddenFailure';
}

/// `404`: it doesn't exist, or the person isn't allowed to know it does.
/// The API gives both the same answer, and so does the app.
///
/// Asking again can't change it, so it is never retried. Not final: the
/// domain names its own not-found cases (a stokvel, a cycle, an invite).
class NotFoundFailure extends Failure {
  /// Creates the failure.
  const new();

  @override
  String get message => "We couldn't find that.";

  @override
  String toString() => 'NotFoundFailure';
}

/// `412`: it changed elsewhere since it was read; the write carried a stale
/// concurrency token.
final class ConflictFailure extends Failure {
  /// Creates the failure.
  const new();

  @override
  String get message => 'This changed somewhere else. Reload it and try again.';

  @override
  String toString() => 'ConflictFailure';
}

/// `409` or `410`: a business rule refused it ("This contribution cycle is
/// already closed.", "This invite has expired."). The API's words are
/// written for people, so they are shown.
final class RuleFailure extends Failure {
  /// Creates the failure.
  const new({this.detail});

  /// The API's `detail`.
  final String? detail;

  @override
  String get message => detail ?? "That isn't allowed right now.";

  @override
  String toString() => 'RuleFailure';
}

/// `429`: too many requests. [wait] is the API's `Retry-After`, never a
/// number chosen by the app.
final class RateLimitedFailure extends Failure {
  /// Creates the failure.
  const new({this.wait});

  /// How long to wait, from `Retry-After`; `null` if the API didn't say.
  final Duration? wait;

  @override
  String get message {
    final seconds = wait?.inSeconds;
    if (seconds == null) {
      return 'Too many attempts. Wait a moment, then try again.';
    }
    return 'Too many attempts. Wait $seconds '
        '${seconds == 1 ? 'second' : 'seconds'}, then try again.';
  }

  @override
  String toString() => 'RateLimitedFailure';
}

/// A `5xx`, or an answer the app can't read (a proxy's HTML page, a body
/// that doesn't match the contract): the fault is on the server's side.
///
/// Never shows the API's message or a stack trace: an apology, and the
/// [reference] to quote.
final class ServerFailure extends Failure {
  /// Creates the failure.
  const new({this.correlationId});

  /// The API's `correlationId`, or the trace id the app sent, when known.
  final String? correlationId;

  @override
  String get message =>
      'Sorry, something went wrong on our side. If it keeps happening, '
      'quote the reference.';

  @override
  String? get reference => correlationId;

  @override
  String toString() => 'ServerFailure';
}

/// No answer at all: offline, the server unreachable, or a timeout. The
/// only failure worth asking again about.
final class NoAnswerFailure extends Failure {
  /// Creates the failure.
  const new();

  @override
  String get message => "You're offline, or we couldn't reach the server.";

  @override
  String toString() => 'NoAnswerFailure';
}

/// [error] as a [Failure]: itself if it is one, otherwise a
/// [ServerFailure] (an error nobody planned for is never shown raw).
Failure failureOf(Object error) =>
    error is Failure ? error : const ServerFailure();
