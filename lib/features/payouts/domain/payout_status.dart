// The API's exact spellings, from RondiTrack API commit da39b16:
//   API/DTOs/Payouts/PayoutOrderResponse.cs  PayoutStatuses: "Paid", "Next",
//   "Waiting". openapi/v1.json types `status` as plain `string`, so a value
//   the API adds later reaches the app as a string it has never seen. It
//   becomes `unknown`.

/// One member's place in the payout rotation, as the API spells it. The
/// API decides it; the app never works it out.
enum PayoutStatus {
  /// `Paid`: this member has been paid out.
  paid('Paid'),

  /// `Next`: the next payout goes to this member. The API marks at most one.
  next('Next'),

  /// `Waiting`: in the rotation, after the next member.
  waiting('Waiting'),

  /// A status this version of the app does not know.
  unknown(null);

  new(this.apiValue);

  /// Maps the API's string, exactly (case included). Anything else is
  /// [unknown], never an exception.
  factory fromApi(String? value) {
    for (final status in values) {
      if (status.apiValue != null && status.apiValue == value) return status;
    }
    return unknown;
  }

  /// The API's spelling, or `null` for [unknown].
  final String? apiValue;
}

/// The words shown for a payout status. Colour may add to them but never
/// replaces them.
///
/// Exhaustive, with no wildcard: a new status is a compile error here until
/// someone writes its words.
String payoutStatusLabel(PayoutStatus status) => switch (status) {
  PayoutStatus.paid => 'Paid',
  PayoutStatus.next => 'Next to be paid',
  PayoutStatus.waiting => 'Waiting',
  PayoutStatus.unknown => 'Status not recognised',
};
