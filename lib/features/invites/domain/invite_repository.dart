import 'package:ronditrack_app/features/invites/domain/invite_preview.dart';

/// Thrown for an invite code that doesn't exist (or has expired).
class InviteNotFoundException implements Exception {
  /// Creates the exception. It carries no code, so it is safe to log.
  const new();

  @override
  String toString() => 'InviteNotFoundException';
}

/// Reads and accepts invites.
abstract interface class InviteRepository {
  /// `GET /invites/{code}`. Throws [InviteNotFoundException] for an unknown
  /// code.
  Future<InvitePreview> fetchInvite(String code);

  /// `POST /invites/{code}/join`: the signed-in person becomes a Member.
  /// Joining a stokvel I'm already in changes nothing. Returns the
  /// stokvel's id.
  Future<String> join(String code);
}
