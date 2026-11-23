import 'dart:convert';

import 'package:ronditrack_app/core/concurrency/concurrency_token.dart';
import 'package:ronditrack_app/core/money/cents.dart';
import 'package:ronditrack_app/core/time/calendar_date.dart';
import 'package:ronditrack_app/features/home/data/home_codec.dart';
import 'package:ronditrack_app/features/stokvels/domain/membership.dart';
import 'package:ronditrack_app/features/stokvels/domain/statuses.dart';
import 'package:ronditrack_app/features/stokvels/domain/stokvel_detail.dart';

/// A stokvel's detail and a cycle, to and from the text kept in
/// `stokvel_cache` and `cycle_cache`. Members' names, roles, amounts and
/// statuses: no email, no proof of payment (README "Offline").
abstract final class StokvelCodec {
  /// Encodes [detail].
  static String encodeDetail(StokvelDetail detail) => jsonEncode({
    'stokvel': _stokvel(detail.stokvel),
    'role': detail.membership.role.name,
    'cycle': detail.currentCycle == null ? null : _cycle(detail.currentCycle!),
    'contributions': [for (final c in detail.contributions) _contribution(c)],
  });

  /// Decodes what [encodeDetail] wrote.
  static StokvelDetail decodeDetail(String text) {
    final json = jsonDecode(text) as Map<String, Object?>;
    final stokvel = _readStokvel(json['stokvel']! as Map<String, Object?>);
    return StokvelDetail(
      stokvel: stokvel,
      membership: Membership(
        stokvelId: stokvel.id,
        role: enumByName(StokvelRole.values, json['role'], StokvelRole.unknown),
      ),
      currentCycle: switch (json['cycle']) {
        final Map<String, Object?> cycle => _readCycle(cycle),
        _ => null,
      },
      contributions: _readContributions(json['contributions']),
    );
  }

  /// Encodes [detail].
  static String encodeCycle(CycleDetail detail) => jsonEncode({
    'stokvel': _stokvel(detail.stokvel),
    'cycle': _cycle(detail.cycle),
    'contributions': [for (final c in detail.contributions) _contribution(c)],
  });

  /// Decodes what [encodeCycle] wrote.
  static CycleDetail decodeCycle(String text) {
    final json = jsonDecode(text) as Map<String, Object?>;
    return CycleDetail(
      stokvel: _readStokvel(json['stokvel']! as Map<String, Object?>),
      cycle: _readCycle(json['cycle']! as Map<String, Object?>),
      contributions: _readContributions(json['contributions']),
    );
  }

  static Map<String, Object?> _stokvel(Stokvel s) => {
    'id': s.id,
    'name': s.name,
    'amount': s.contributionAmount.value,
    'members': s.memberCount,
    'etag': s.concurrencyToken?.value,
  };

  static Stokvel _readStokvel(Map<String, Object?> s) => Stokvel(
    id: s['id']! as String,
    name: s['name']! as String,
    contributionAmount: Cents(s['amount']! as int),
    memberCount: s['members']! as int,
    concurrencyToken: switch (s['etag']) {
      final String etag => ConcurrencyToken(etag),
      _ => null,
    },
  );

  static Map<String, Object?> _cycle(StokvelCycle c) => {
    'id': c.id,
    'period': c.period,
    'status': c.status.name,
    'dueDate': c.dueDate?.toString(),
    'membersPaid': c.membersPaid,
    'collected': c.collected.value,
    'target': c.target.value,
    'etag': c.concurrencyToken?.value,
  };

  static StokvelCycle _readCycle(Map<String, Object?> c) => StokvelCycle(
    id: c['id']! as String,
    period: c['period']! as String,
    status: enumByName(CycleStatus.values, c['status'], CycleStatus.unknown),
    dueDate: switch (c['dueDate']) {
      final String date => CalendarDate.parse(date),
      _ => null,
    },
    membersPaid: c['membersPaid']! as int,
    collected: Cents(c['collected']! as int),
    target: Cents(c['target']! as int),
    concurrencyToken: switch (c['etag']) {
      final String etag => ConcurrencyToken(etag),
      _ => null,
    },
  );

  static Map<String, Object?> _contribution(Contribution c) => {
    'id': c.id,
    'userId': c.userId,
    'name': c.memberName,
    'role': c.memberRole.name,
    'amount': c.amount.value,
    'status': c.status.name,
    'recordedAt': instantToJson(c.recordedAt),
  };

  static List<Contribution> _readContributions(Object? list) => [
    for (final c in (list! as List).cast<Map<String, Object?>>())
      Contribution(
        id: c['id']! as String,
        userId: c['userId']! as String,
        memberName: c['name']! as String,
        memberRole: enumByName(
          StokvelRole.values,
          c['role'],
          StokvelRole.unknown,
        ),
        amount: Cents(c['amount']! as int),
        status: enumByName(
          ContributionStatus.values,
          c['status'],
          ContributionStatus.unknown,
        ),
        recordedAt: instantFromJson(c['recordedAt'])!,
      ),
  ];
}
