import 'package:ronditrack_app/features/stokvels/domain/statuses.dart';

/// Something a person can do in a stokvel's current cycle.
enum StokvelAction {
  /// Record a payment towards my own contribution.
  pay,

  /// Upload proof of payment for my own contribution.
  uploadProof,

  /// Confirm members' contributions (Treasurer or Chairperson).
  confirmContributions,

  /// Close the cycle (Treasurer or Chairperson).
  closeCycle,

  /// Record the cycle's payout (Treasurer or Chairperson).
  recordPayout,
}

/// What [allowedActions] decides on: my role in *this* stokvel, the current
/// cycle's status, and my own contribution's status (`null` when I have
/// recorded nothing in this cycle).
typedef ActionContext = ({
  StokvelRole role,
  CycleStatus cycle,
  ContributionStatus? mine,
});

const _none = <StokvelAction>{};
const Set<StokvelAction> _treasurerActions = {
  StokvelAction.confirmContributions,
  StokvelAction.closeCycle,
  StokvelAction.recordPayout,
};

/// "What can I do here?"
///
/// One exhaustive match over the record. No pattern uses a wildcard (`_`) or
/// a catch-all variable, so a new role or status anywhere is a compile error
/// here until someone decides what it allows.
///
/// The rules follow RondiTrack API commit 3d04a52 (see README "Contract
/// notes"):
/// * Nothing is possible unless the cycle is `Open`: recording a
///   contribution, uploading proof, closing and paying out all refuse a cycle
///   that isn't open.
/// * Treasurer and Chairperson have the same rights (`StokvelManage`); a
///   Member has only their own contribution (`RecordContribution` for self).
/// * Pay is offered until my contribution is `Confirmed` (the API adds
///   partial payments together). Proof needs a contribution to attach to.
/// * An unknown role, or an unknown contribution status, grants nothing.
Set<StokvelAction> allowedActions(ActionContext context) => switch (context) {
  // A cycle that isn't open: nothing for anyone.
  (
    role: StokvelRole.member ||
        StokvelRole.treasurer ||
        StokvelRole.chairperson ||
        StokvelRole.unknown,
    cycle: CycleStatus.closed || CycleStatus.paidOut || CycleStatus.unknown,
    mine: null ||
        ContributionStatus.pending ||
        ContributionStatus.paid ||
        ContributionStatus.confirmed ||
        ContributionStatus.unknown,
  ) =>
    _none,

  // A role this app doesn't know grants nothing, even in an open cycle.
  (
    role: StokvelRole.unknown,
    cycle: CycleStatus.open,
    mine: null ||
        ContributionStatus.pending ||
        ContributionStatus.paid ||
        ContributionStatus.confirmed ||
        ContributionStatus.unknown,
  ) =>
    _none,

  // Member, open cycle.
  (role: StokvelRole.member, cycle: CycleStatus.open, mine: null) => {
    StokvelAction.pay,
  },
  (
    role: StokvelRole.member,
    cycle: CycleStatus.open,
    mine: ContributionStatus.pending || ContributionStatus.paid,
  ) =>
    {StokvelAction.pay, StokvelAction.uploadProof},
  (
    role: StokvelRole.member,
    cycle: CycleStatus.open,
    mine: ContributionStatus.confirmed || ContributionStatus.unknown,
  ) =>
    _none,

  // Treasurer or Chairperson, open cycle: their own contribution, plus the
  // stokvel's management actions.
  (
    role: StokvelRole.treasurer || StokvelRole.chairperson,
    cycle: CycleStatus.open,
    mine: null,
  ) =>
    {StokvelAction.pay, ..._treasurerActions},
  (
    role: StokvelRole.treasurer || StokvelRole.chairperson,
    cycle: CycleStatus.open,
    mine: ContributionStatus.pending || ContributionStatus.paid,
  ) =>
    {StokvelAction.pay, StokvelAction.uploadProof, ..._treasurerActions},
  (
    role: StokvelRole.treasurer || StokvelRole.chairperson,
    cycle: CycleStatus.open,
    mine: ContributionStatus.confirmed || ContributionStatus.unknown,
  ) =>
    _treasurerActions,
};

/// The words on each action's button.
String stokvelActionLabel(StokvelAction action) => switch (action) {
  StokvelAction.pay => 'Pay',
  StokvelAction.uploadProof => 'Upload proof',
  StokvelAction.confirmContributions => 'Confirm contributions',
  StokvelAction.closeCycle => 'Close cycle',
  StokvelAction.recordPayout => 'Record payout',
};
