// The API's exact spellings, from RondiTrack API commit 3d04a52:
//   Domain/Entities/ContributionCycle.cs  "Open", "Closed", "PaidOut"
//   Domain/Entities/Contribution.cs       "Pending", "Paid", "Confirmed"
//   Domain/Entities/Roles.cs              "Member", "Treasurer", "Chairperson"
// openapi/v1.json types all three as plain `string`, so a value the API adds
// later reaches the app as a string it has never seen. It becomes `unknown`.

/// A contribution cycle's status, as the API spells it.
enum CycleStatus {
  /// `Open`: contributions are being collected.
  open('Open'),

  /// `Closed`: the cycle has closed and arrears are recorded.
  closed('Closed'),

  /// `PaidOut`: the payout for the cycle has been recorded.
  paidOut('PaidOut'),

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

/// A contribution's status, as the API spells it.
enum ContributionStatus {
  /// `Pending`: recorded, not yet paid.
  pending('Pending'),

  /// `Paid`: the member has paid.
  paid('Paid'),

  /// `Confirmed`: a treasurer has confirmed the payment.
  confirmed('Confirmed'),

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

/// A person's role in one stokvel, as the API spells it.
///
/// A role belongs to a membership, never to a user or a token.
enum StokvelRole {
  /// `Member`.
  member('Member'),

  /// `Treasurer`.
  treasurer('Treasurer'),

  /// `Chairperson`.
  chairperson('Chairperson'),

  /// A role this version of the app does not know. It grants nothing.
  unknown(null);

  new(this.apiValue);

  /// Maps the API's string, exactly (case included). Anything else is
  /// [unknown], never an exception.
  factory fromApi(String? value) {
    for (final role in values) {
      if (role.apiValue != null && role.apiValue == value) return role;
    }
    return unknown;
  }

  /// The API's spelling, or `null` for [unknown].
  final String? apiValue;
}
