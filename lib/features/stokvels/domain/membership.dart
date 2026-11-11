import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ronditrack_app/features/stokvels/domain/statuses.dart';

part 'membership.freezed.dart';

/// A person's place in one stokvel.
///
/// The role lives here, and only here. There is no `User.role`, and nothing
/// reads a role from a token. The API sends it per stokvel (`role` on each
/// `/me/home` entry and on `GET /stokvels/{id}`), so one login can be
/// Treasurer of one stokvel and Member of another.
@freezed
abstract class Membership with _$Membership {
  /// Creates a membership.
  const factory({required String stokvelId, required StokvelRole role}) =
      _Membership;
}
