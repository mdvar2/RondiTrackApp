import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';

/// The signed-in person (`UserResponse`), with no role. A role belongs to
/// a stokvel's membership, never to the person or their token.
@freezed
abstract class AuthUser with _$AuthUser {
  /// Creates a user.
  const factory({
    /// `id`.
    required String id,

    /// `name`.
    required String name,

    /// `email`.
    required String email,
  }) = _AuthUser;
}
