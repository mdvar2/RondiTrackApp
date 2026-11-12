import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ronditrack_app/core/money/cents.dart';

part 'invite_preview.freezed.dart';

/// What an invite shows before joining (`InvitePreviewResponse`).
@freezed
abstract class InvitePreview with _$InvitePreview {
  /// Creates an invite preview.
  const factory({
    /// The code in the link.
    required String code,

    /// `stokvelId`.
    required String stokvelId,

    /// `name`.
    required String stokvelName,

    /// `contributionAmountCents`.
    required Cents contributionAmount,

    /// `schedule`, in words.
    required String schedule,

    /// `rules`, in words.
    required String rules,

    /// `memberCount`.
    required int memberCount,
  }) = _InvitePreview;
}
