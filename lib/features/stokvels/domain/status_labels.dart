import 'package:ronditrack_app/features/stokvels/domain/statuses.dart';

// Every status has words. Colour may add to a label but never replaces it.
// Each switch is exhaustive with no wildcard, so a new value is a compile
// error here until someone writes its words.

/// The words shown for a cycle's status.
String cycleStatusLabel(CycleStatus status) => switch (status) {
  CycleStatus.open => 'Open',
  CycleStatus.closed => 'Closed',
  CycleStatus.paidOut => 'Paid out',
  CycleStatus.unknown => 'Status not recognised',
};

/// The words shown for a contribution's status.
String contributionStatusLabel(ContributionStatus status) => switch (status) {
  ContributionStatus.pending => 'Pending',
  ContributionStatus.paid => 'Paid',
  ContributionStatus.confirmed => 'Confirmed',
  ContributionStatus.unknown => 'Status not recognised',
};

/// The words shown for a role.
String stokvelRoleLabel(StokvelRole role) => switch (role) {
  StokvelRole.member => 'Member',
  StokvelRole.treasurer => 'Treasurer',
  StokvelRole.chairperson => 'Chairperson',
  StokvelRole.unknown => 'Role not recognised',
};
