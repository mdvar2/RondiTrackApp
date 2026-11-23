import 'package:ronditrack_app/core/money/rand_parser.dart';
import 'package:ronditrack_app/core/time/sast.dart';
import 'package:ronditrack_app/features/payments/domain/payment_outbox.dart';
import 'package:ronditrack_app/l10n/generated/app_localizations.dart';
import 'package:ronditrack_app/l10n/locale_dates.dart';

/// What a member reads about [outcome], in their language. A refusal is
/// in words a member understands, not always the API's.
String paymentOutcomeMessage(
  AppLocalizations l10n,
  String localeName,
  PaymentOutcome outcome,
) => switch (outcome) {
  PaymentAccepted() => l10n.payPaid,
  PaymentRefused(reason: PaymentRefusal.alreadyPaid) => l10n.payAlreadyPaid,
  PaymentRefused(reason: PaymentRefusal.cycleClosed) => l10n.payCycleClosed,
  PaymentRefused(:final detail) => l10n.payRefused(detail ?? ''),
  PaymentWaiting(:final wait) => l10n.payWaiting(
    (wait.inMilliseconds / 1000).ceil(),
  ),
  PaymentStillPending() => l10n.paySavedOffline,
  PaymentExpired(:final createdAt) => l10n.payExpired(
    formatDay(localeName, Sast.dayOf(createdAt)),
  ),
};

/// Why [error] isn't an amount, in the member's language.
String randErrorMessage(AppLocalizations l10n, RandParseError error) =>
    switch (error) {
      RandParseError.empty => l10n.amountRequired,
      RandParseError.invalidCharacters => l10n.amountInvalid,
      RandParseError.misplacedGroupSpace => l10n.amountGroups,
      RandParseError.missingDecimals => l10n.amountCents,
      RandParseError.tooManyDecimals => l10n.amountTooManyCents,
      RandParseError.tooLarge => l10n.amountTooLarge,
    };
