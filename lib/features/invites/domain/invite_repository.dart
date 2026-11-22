import 'package:ronditrack_app/core/errors/failure.dart';
import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/features/invites/domain/invite_preview.dart';

/// Thrown for an invite code that doesn't exist (or has expired).
class InviteNotFoundException extends NotFoundFailure {
  /// Creates the failure. It carries no code, so it is safe to log.
  const new();

  @override
  String toString() => 'InviteNotFoundException';
}

/// Reads and accepts invites.
abstract interface class InviteRepository {
  /// `GET /invites/{code}`. Fails with a [NotFoundFailure] for an unknown
  /// code.
  Future<Result<InvitePreview>> fetchInvite(String code);

  /// `POST /invites/{code}/join`: the signed-in person becomes a Member.
  /// Returns the stokvel's id, also for someone already in it (the API's
  /// `409`; the fake changes nothing), so they land in it. A wrong code is
  /// a [NotFoundFailure], an expired one a [RuleFailure] with its words.
  Future<Result<String>> join(String code);
}
