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
  /// Returns the stokvel's id. The API refuses a second join with a `409`
  /// (a [RuleFailure]); the fake changes nothing instead. The join screen
  /// only offers Join to someone not in the stokvel.
  Future<Result<String>> join(String code);
}
