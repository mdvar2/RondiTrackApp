import 'package:ronditrack_app/core/errors/result.dart';
import 'package:ronditrack_app/core/money/cents.dart';
import 'package:ronditrack_app/features/invites/domain/invite_preview.dart';
import 'package:ronditrack_app/features/invites/domain/invite_repository.dart';
import 'package:ronditrack_app/features/stokvels/data/fake_seed.dart';
import 'package:ronditrack_app/features/stokvels/domain/statuses.dart';

/// An [InviteRepository] over [FakeSeed.invites]. Joining adds [userId] to
/// [stokvels] as a Member, owing the stokvel's contribution, so Home, the
/// stokvel and Activity see the new membership.
class FakeInviteRepository implements InviteRepository {
  /// Creates the fake. [stokvels] must be the same list the other fakes
  /// read (`FakeSeed.fresh()`), or a join is invisible to them.
  new({
    required this.userId,
    required this.stokvels,
    this.delay = const Duration(milliseconds: 600),
  });

  /// The signed-in person, `null` when nobody is.
  final String? userId;

  /// The fakes' shared, changeable copy of the seed.
  final List<FakeStokvel> stokvels;

  /// The pretend network delay.
  final Duration delay;

  @override
  Future<Result<InvitePreview>> fetchInvite(String code) async {
    await Future<void>.delayed(delay);
    final entry = _entryFor(code);
    if (entry == null) return const Err(InviteNotFoundException());
    final terms = FakeSeed.inviteTerms[entry.stokvel.id];
    return Ok(
      InvitePreview(
        code: code,
        stokvelId: entry.stokvel.id,
        stokvelName: entry.stokvel.name,
        contributionAmount: entry.stokvel.contributionAmount,
        schedule: terms?.schedule ?? '',
        rules: terms?.rules ?? '',
        memberCount: entry.stokvel.memberCount,
      ),
    );
  }

  @override
  Future<Result<String>> join(String code) async {
    await Future<void>.delayed(delay);
    final entry = _entryFor(code);
    if (entry == null) return const Err(InviteNotFoundException());
    final me = userId;
    if (me != null && !entry.roles.containsKey(me)) {
      entry.roles[me] = StokvelRole.member;
      entry.home[me] = (
        paid: Cents.zero,
        owed: entry.stokvel.contributionAmount,
        arrears: Cents.zero,
      );
    }
    return Ok(entry.stokvel.id);
  }

  FakeStokvel? _entryFor(String code) {
    final stokvelId = FakeSeed.invites[code];
    for (final entry in stokvels) {
      if (entry.stokvel.id == stokvelId) return entry;
    }
    return null;
  }
}
