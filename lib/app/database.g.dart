// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $HomeCacheTableTable extends HomeCacheTable
    with TableInfo<$HomeCacheTableTable, HomeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HomeCacheTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _slotMeta = const VerificationMeta('slot');
  @override
  late final GeneratedColumn<int> slot = GeneratedColumn<int>(
    'slot',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _entriesMeta = const VerificationMeta(
    'entries',
  );
  @override
  late final GeneratedColumn<String> entries = GeneratedColumn<String>(
    'entries',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [slot, entries, fetchedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'home_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<HomeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('slot')) {
      context.handle(
        _slotMeta,
        slot.isAcceptableOrUnknown(data['slot']!, _slotMeta),
      );
    }
    if (data.containsKey('entries')) {
      context.handle(
        _entriesMeta,
        entries.isAcceptableOrUnknown(data['entries']!, _entriesMeta),
      );
    } else if (isInserting) {
      context.missing(_entriesMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {slot};
  @override
  HomeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HomeRow(
      slot: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}slot'],
      )!,
      entries: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entries'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
    );
  }

  @override
  $HomeCacheTableTable createAlias(String alias) {
    return $HomeCacheTableTable(attachedDatabase, alias);
  }
}

class HomeRow extends DataClass implements Insertable<HomeRow> {
  /// Always 0: Home is one thing per signed-in person, and the database is
  /// emptied at sign-out.
  final int slot;

  /// The entries, encoded.
  final String entries;

  /// When the server answered with them (UTC).
  final DateTime fetchedAt;
  const HomeRow({
    required this.slot,
    required this.entries,
    required this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['slot'] = Variable<int>(slot);
    map['entries'] = Variable<String>(entries);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  HomeCacheTableCompanion toCompanion(bool nullToAbsent) {
    return HomeCacheTableCompanion(
      slot: Value(slot),
      entries: Value(entries),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory HomeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HomeRow(
      slot: serializer.fromJson<int>(json['slot']),
      entries: serializer.fromJson<String>(json['entries']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'slot': serializer.toJson<int>(slot),
      'entries': serializer.toJson<String>(entries),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  HomeRow copyWith({int? slot, String? entries, DateTime? fetchedAt}) =>
      HomeRow(
        slot: slot ?? this.slot,
        entries: entries ?? this.entries,
        fetchedAt: fetchedAt ?? this.fetchedAt,
      );
  HomeRow copyWithCompanion(HomeCacheTableCompanion data) {
    return HomeRow(
      slot: data.slot.present ? data.slot.value : this.slot,
      entries: data.entries.present ? data.entries.value : this.entries,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HomeRow(')
          ..write('slot: $slot, ')
          ..write('entries: $entries, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(slot, entries, fetchedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HomeRow &&
          other.slot == this.slot &&
          other.entries == this.entries &&
          other.fetchedAt == this.fetchedAt);
}

class HomeCacheTableCompanion extends UpdateCompanion<HomeRow> {
  final Value<int> slot;
  final Value<String> entries;
  final Value<DateTime> fetchedAt;
  const HomeCacheTableCompanion({
    this.slot = const Value.absent(),
    this.entries = const Value.absent(),
    this.fetchedAt = const Value.absent(),
  });
  HomeCacheTableCompanion.insert({
    this.slot = const Value.absent(),
    required String entries,
    required DateTime fetchedAt,
  }) : entries = Value(entries),
       fetchedAt = Value(fetchedAt);
  static Insertable<HomeRow> custom({
    Expression<int>? slot,
    Expression<String>? entries,
    Expression<DateTime>? fetchedAt,
  }) {
    return RawValuesInsertable({
      if (slot != null) 'slot': slot,
      if (entries != null) 'entries': entries,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
    });
  }

  HomeCacheTableCompanion copyWith({
    Value<int>? slot,
    Value<String>? entries,
    Value<DateTime>? fetchedAt,
  }) {
    return HomeCacheTableCompanion(
      slot: slot ?? this.slot,
      entries: entries ?? this.entries,
      fetchedAt: fetchedAt ?? this.fetchedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (slot.present) {
      map['slot'] = Variable<int>(slot.value);
    }
    if (entries.present) {
      map['entries'] = Variable<String>(entries.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HomeCacheTableCompanion(')
          ..write('slot: $slot, ')
          ..write('entries: $entries, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }
}

class $StokvelCacheTableTable extends StokvelCacheTable
    with TableInfo<$StokvelCacheTableTable, StokvelRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StokvelCacheTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _stokvelIdMeta = const VerificationMeta(
    'stokvelId',
  );
  @override
  late final GeneratedColumn<String> stokvelId = GeneratedColumn<String>(
    'stokvel_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detailMeta = const VerificationMeta('detail');
  @override
  late final GeneratedColumn<String> detail = GeneratedColumn<String>(
    'detail',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [stokvelId, detail, fetchedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stokvel_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<StokvelRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('stokvel_id')) {
      context.handle(
        _stokvelIdMeta,
        stokvelId.isAcceptableOrUnknown(data['stokvel_id']!, _stokvelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_stokvelIdMeta);
    }
    if (data.containsKey('detail')) {
      context.handle(
        _detailMeta,
        detail.isAcceptableOrUnknown(data['detail']!, _detailMeta),
      );
    } else if (isInserting) {
      context.missing(_detailMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {stokvelId};
  @override
  StokvelRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StokvelRow(
      stokvelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stokvel_id'],
      )!,
      detail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detail'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
    );
  }

  @override
  $StokvelCacheTableTable createAlias(String alias) {
    return $StokvelCacheTableTable(attachedDatabase, alias);
  }
}

class StokvelRow extends DataClass implements Insertable<StokvelRow> {
  /// The stokvel's id.
  final String stokvelId;

  /// The detail, encoded (`stokvel_codec.dart`).
  final String detail;

  /// When the server answered with it (UTC).
  final DateTime fetchedAt;
  const StokvelRow({
    required this.stokvelId,
    required this.detail,
    required this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['stokvel_id'] = Variable<String>(stokvelId);
    map['detail'] = Variable<String>(detail);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  StokvelCacheTableCompanion toCompanion(bool nullToAbsent) {
    return StokvelCacheTableCompanion(
      stokvelId: Value(stokvelId),
      detail: Value(detail),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory StokvelRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StokvelRow(
      stokvelId: serializer.fromJson<String>(json['stokvelId']),
      detail: serializer.fromJson<String>(json['detail']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'stokvelId': serializer.toJson<String>(stokvelId),
      'detail': serializer.toJson<String>(detail),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  StokvelRow copyWith({
    String? stokvelId,
    String? detail,
    DateTime? fetchedAt,
  }) => StokvelRow(
    stokvelId: stokvelId ?? this.stokvelId,
    detail: detail ?? this.detail,
    fetchedAt: fetchedAt ?? this.fetchedAt,
  );
  StokvelRow copyWithCompanion(StokvelCacheTableCompanion data) {
    return StokvelRow(
      stokvelId: data.stokvelId.present ? data.stokvelId.value : this.stokvelId,
      detail: data.detail.present ? data.detail.value : this.detail,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StokvelRow(')
          ..write('stokvelId: $stokvelId, ')
          ..write('detail: $detail, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(stokvelId, detail, fetchedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StokvelRow &&
          other.stokvelId == this.stokvelId &&
          other.detail == this.detail &&
          other.fetchedAt == this.fetchedAt);
}

class StokvelCacheTableCompanion extends UpdateCompanion<StokvelRow> {
  final Value<String> stokvelId;
  final Value<String> detail;
  final Value<DateTime> fetchedAt;
  final Value<int> rowid;
  const StokvelCacheTableCompanion({
    this.stokvelId = const Value.absent(),
    this.detail = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StokvelCacheTableCompanion.insert({
    required String stokvelId,
    required String detail,
    required DateTime fetchedAt,
    this.rowid = const Value.absent(),
  }) : stokvelId = Value(stokvelId),
       detail = Value(detail),
       fetchedAt = Value(fetchedAt);
  static Insertable<StokvelRow> custom({
    Expression<String>? stokvelId,
    Expression<String>? detail,
    Expression<DateTime>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (stokvelId != null) 'stokvel_id': stokvelId,
      if (detail != null) 'detail': detail,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StokvelCacheTableCompanion copyWith({
    Value<String>? stokvelId,
    Value<String>? detail,
    Value<DateTime>? fetchedAt,
    Value<int>? rowid,
  }) {
    return StokvelCacheTableCompanion(
      stokvelId: stokvelId ?? this.stokvelId,
      detail: detail ?? this.detail,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (stokvelId.present) {
      map['stokvel_id'] = Variable<String>(stokvelId.value);
    }
    if (detail.present) {
      map['detail'] = Variable<String>(detail.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StokvelCacheTableCompanion(')
          ..write('stokvelId: $stokvelId, ')
          ..write('detail: $detail, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CycleCacheTableTable extends CycleCacheTable
    with TableInfo<$CycleCacheTableTable, CycleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CycleCacheTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _stokvelIdMeta = const VerificationMeta(
    'stokvelId',
  );
  @override
  late final GeneratedColumn<String> stokvelId = GeneratedColumn<String>(
    'stokvel_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cycleIdMeta = const VerificationMeta(
    'cycleId',
  );
  @override
  late final GeneratedColumn<String> cycleId = GeneratedColumn<String>(
    'cycle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detailMeta = const VerificationMeta('detail');
  @override
  late final GeneratedColumn<String> detail = GeneratedColumn<String>(
    'detail',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [stokvelId, cycleId, detail, fetchedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cycle_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<CycleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('stokvel_id')) {
      context.handle(
        _stokvelIdMeta,
        stokvelId.isAcceptableOrUnknown(data['stokvel_id']!, _stokvelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_stokvelIdMeta);
    }
    if (data.containsKey('cycle_id')) {
      context.handle(
        _cycleIdMeta,
        cycleId.isAcceptableOrUnknown(data['cycle_id']!, _cycleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cycleIdMeta);
    }
    if (data.containsKey('detail')) {
      context.handle(
        _detailMeta,
        detail.isAcceptableOrUnknown(data['detail']!, _detailMeta),
      );
    } else if (isInserting) {
      context.missing(_detailMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {stokvelId, cycleId};
  @override
  CycleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CycleRow(
      stokvelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stokvel_id'],
      )!,
      cycleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cycle_id'],
      )!,
      detail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detail'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
    );
  }

  @override
  $CycleCacheTableTable createAlias(String alias) {
    return $CycleCacheTableTable(attachedDatabase, alias);
  }
}

class CycleRow extends DataClass implements Insertable<CycleRow> {
  /// The stokvel's id.
  final String stokvelId;

  /// The cycle's id.
  final String cycleId;

  /// The cycle, encoded.
  final String detail;

  /// When the server answered with it (UTC).
  final DateTime fetchedAt;
  const CycleRow({
    required this.stokvelId,
    required this.cycleId,
    required this.detail,
    required this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['stokvel_id'] = Variable<String>(stokvelId);
    map['cycle_id'] = Variable<String>(cycleId);
    map['detail'] = Variable<String>(detail);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  CycleCacheTableCompanion toCompanion(bool nullToAbsent) {
    return CycleCacheTableCompanion(
      stokvelId: Value(stokvelId),
      cycleId: Value(cycleId),
      detail: Value(detail),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory CycleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CycleRow(
      stokvelId: serializer.fromJson<String>(json['stokvelId']),
      cycleId: serializer.fromJson<String>(json['cycleId']),
      detail: serializer.fromJson<String>(json['detail']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'stokvelId': serializer.toJson<String>(stokvelId),
      'cycleId': serializer.toJson<String>(cycleId),
      'detail': serializer.toJson<String>(detail),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  CycleRow copyWith({
    String? stokvelId,
    String? cycleId,
    String? detail,
    DateTime? fetchedAt,
  }) => CycleRow(
    stokvelId: stokvelId ?? this.stokvelId,
    cycleId: cycleId ?? this.cycleId,
    detail: detail ?? this.detail,
    fetchedAt: fetchedAt ?? this.fetchedAt,
  );
  CycleRow copyWithCompanion(CycleCacheTableCompanion data) {
    return CycleRow(
      stokvelId: data.stokvelId.present ? data.stokvelId.value : this.stokvelId,
      cycleId: data.cycleId.present ? data.cycleId.value : this.cycleId,
      detail: data.detail.present ? data.detail.value : this.detail,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CycleRow(')
          ..write('stokvelId: $stokvelId, ')
          ..write('cycleId: $cycleId, ')
          ..write('detail: $detail, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(stokvelId, cycleId, detail, fetchedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CycleRow &&
          other.stokvelId == this.stokvelId &&
          other.cycleId == this.cycleId &&
          other.detail == this.detail &&
          other.fetchedAt == this.fetchedAt);
}

class CycleCacheTableCompanion extends UpdateCompanion<CycleRow> {
  final Value<String> stokvelId;
  final Value<String> cycleId;
  final Value<String> detail;
  final Value<DateTime> fetchedAt;
  final Value<int> rowid;
  const CycleCacheTableCompanion({
    this.stokvelId = const Value.absent(),
    this.cycleId = const Value.absent(),
    this.detail = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CycleCacheTableCompanion.insert({
    required String stokvelId,
    required String cycleId,
    required String detail,
    required DateTime fetchedAt,
    this.rowid = const Value.absent(),
  }) : stokvelId = Value(stokvelId),
       cycleId = Value(cycleId),
       detail = Value(detail),
       fetchedAt = Value(fetchedAt);
  static Insertable<CycleRow> custom({
    Expression<String>? stokvelId,
    Expression<String>? cycleId,
    Expression<String>? detail,
    Expression<DateTime>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (stokvelId != null) 'stokvel_id': stokvelId,
      if (cycleId != null) 'cycle_id': cycleId,
      if (detail != null) 'detail': detail,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CycleCacheTableCompanion copyWith({
    Value<String>? stokvelId,
    Value<String>? cycleId,
    Value<String>? detail,
    Value<DateTime>? fetchedAt,
    Value<int>? rowid,
  }) {
    return CycleCacheTableCompanion(
      stokvelId: stokvelId ?? this.stokvelId,
      cycleId: cycleId ?? this.cycleId,
      detail: detail ?? this.detail,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (stokvelId.present) {
      map['stokvel_id'] = Variable<String>(stokvelId.value);
    }
    if (cycleId.present) {
      map['cycle_id'] = Variable<String>(cycleId.value);
    }
    if (detail.present) {
      map['detail'] = Variable<String>(detail.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CycleCacheTableCompanion(')
          ..write('stokvelId: $stokvelId, ')
          ..write('cycleId: $cycleId, ')
          ..write('detail: $detail, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaymentOutboxTableTable extends PaymentOutboxTable
    with TableInfo<$PaymentOutboxTableTable, OutboxRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentOutboxTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _idempotencyKeyMeta = const VerificationMeta(
    'idempotencyKey',
  );
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
    'idempotency_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _stokvelIdMeta = const VerificationMeta(
    'stokvelId',
  );
  @override
  late final GeneratedColumn<String> stokvelId = GeneratedColumn<String>(
    'stokvel_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cycleIdMeta = const VerificationMeta(
    'cycleId',
  );
  @override
  late final GeneratedColumn<String> cycleId = GeneratedColumn<String>(
    'cycle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _waitUntilMeta = const VerificationMeta(
    'waitUntil',
  );
  @override
  late final GeneratedColumn<DateTime> waitUntil = GeneratedColumn<DateTime>(
    'wait_until',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    idempotencyKey,
    stokvelId,
    cycleId,
    userId,
    amountCents,
    createdAt,
    attempts,
    waitUntil,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payment_outbox';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
        _idempotencyKeyMeta,
        idempotencyKey.isAcceptableOrUnknown(
          data['idempotency_key']!,
          _idempotencyKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('stokvel_id')) {
      context.handle(
        _stokvelIdMeta,
        stokvelId.isAcceptableOrUnknown(data['stokvel_id']!, _stokvelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_stokvelIdMeta);
    }
    if (data.containsKey('cycle_id')) {
      context.handle(
        _cycleIdMeta,
        cycleId.isAcceptableOrUnknown(data['cycle_id']!, _cycleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cycleIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('wait_until')) {
      context.handle(
        _waitUntilMeta,
        waitUntil.isAcceptableOrUnknown(data['wait_until']!, _waitUntilMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OutboxRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      idempotencyKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}idempotency_key'],
      )!,
      stokvelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stokvel_id'],
      )!,
      cycleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cycle_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      waitUntil: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}wait_until'],
      ),
    );
  }

  @override
  $PaymentOutboxTableTable createAlias(String alias) {
    return $PaymentOutboxTableTable(attachedDatabase, alias);
  }
}

class OutboxRow extends DataClass implements Insertable<OutboxRow> {
  /// The row's own id.
  final int id;

  /// The `Idempotency-Key`, a v4 UUID made at the tap.
  final String idempotencyKey;

  /// The stokvel.
  final String stokvelId;

  /// The cycle being paid for.
  final String cycleId;

  /// Whose contribution it is (the signed-in member).
  final String userId;

  /// The amount, in cents. Never a double.
  final int amountCents;

  /// When Pay was tapped (UTC). The outbox's maximum age counts from here.
  final DateTime createdAt;

  /// How many times it was sent.
  final int attempts;

  /// Not to be sent before this (UTC): the API's `Retry-After`.
  final DateTime? waitUntil;
  const OutboxRow({
    required this.id,
    required this.idempotencyKey,
    required this.stokvelId,
    required this.cycleId,
    required this.userId,
    required this.amountCents,
    required this.createdAt,
    required this.attempts,
    this.waitUntil,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['stokvel_id'] = Variable<String>(stokvelId);
    map['cycle_id'] = Variable<String>(cycleId);
    map['user_id'] = Variable<String>(userId);
    map['amount_cents'] = Variable<int>(amountCents);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || waitUntil != null) {
      map['wait_until'] = Variable<DateTime>(waitUntil);
    }
    return map;
  }

  PaymentOutboxTableCompanion toCompanion(bool nullToAbsent) {
    return PaymentOutboxTableCompanion(
      id: Value(id),
      idempotencyKey: Value(idempotencyKey),
      stokvelId: Value(stokvelId),
      cycleId: Value(cycleId),
      userId: Value(userId),
      amountCents: Value(amountCents),
      createdAt: Value(createdAt),
      attempts: Value(attempts),
      waitUntil: waitUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(waitUntil),
    );
  }

  factory OutboxRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxRow(
      id: serializer.fromJson<int>(json['id']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      stokvelId: serializer.fromJson<String>(json['stokvelId']),
      cycleId: serializer.fromJson<String>(json['cycleId']),
      userId: serializer.fromJson<String>(json['userId']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      attempts: serializer.fromJson<int>(json['attempts']),
      waitUntil: serializer.fromJson<DateTime?>(json['waitUntil']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'stokvelId': serializer.toJson<String>(stokvelId),
      'cycleId': serializer.toJson<String>(cycleId),
      'userId': serializer.toJson<String>(userId),
      'amountCents': serializer.toJson<int>(amountCents),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'attempts': serializer.toJson<int>(attempts),
      'waitUntil': serializer.toJson<DateTime?>(waitUntil),
    };
  }

  OutboxRow copyWith({
    int? id,
    String? idempotencyKey,
    String? stokvelId,
    String? cycleId,
    String? userId,
    int? amountCents,
    DateTime? createdAt,
    int? attempts,
    Value<DateTime?> waitUntil = const Value.absent(),
  }) => OutboxRow(
    id: id ?? this.id,
    idempotencyKey: idempotencyKey ?? this.idempotencyKey,
    stokvelId: stokvelId ?? this.stokvelId,
    cycleId: cycleId ?? this.cycleId,
    userId: userId ?? this.userId,
    amountCents: amountCents ?? this.amountCents,
    createdAt: createdAt ?? this.createdAt,
    attempts: attempts ?? this.attempts,
    waitUntil: waitUntil.present ? waitUntil.value : this.waitUntil,
  );
  OutboxRow copyWithCompanion(PaymentOutboxTableCompanion data) {
    return OutboxRow(
      id: data.id.present ? data.id.value : this.id,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      stokvelId: data.stokvelId.present ? data.stokvelId.value : this.stokvelId,
      cycleId: data.cycleId.present ? data.cycleId.value : this.cycleId,
      userId: data.userId.present ? data.userId.value : this.userId,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      waitUntil: data.waitUntil.present ? data.waitUntil.value : this.waitUntil,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxRow(')
          ..write('id: $id, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('stokvelId: $stokvelId, ')
          ..write('cycleId: $cycleId, ')
          ..write('userId: $userId, ')
          ..write('amountCents: $amountCents, ')
          ..write('createdAt: $createdAt, ')
          ..write('attempts: $attempts, ')
          ..write('waitUntil: $waitUntil')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    idempotencyKey,
    stokvelId,
    cycleId,
    userId,
    amountCents,
    createdAt,
    attempts,
    waitUntil,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxRow &&
          other.id == this.id &&
          other.idempotencyKey == this.idempotencyKey &&
          other.stokvelId == this.stokvelId &&
          other.cycleId == this.cycleId &&
          other.userId == this.userId &&
          other.amountCents == this.amountCents &&
          other.createdAt == this.createdAt &&
          other.attempts == this.attempts &&
          other.waitUntil == this.waitUntil);
}

class PaymentOutboxTableCompanion extends UpdateCompanion<OutboxRow> {
  final Value<int> id;
  final Value<String> idempotencyKey;
  final Value<String> stokvelId;
  final Value<String> cycleId;
  final Value<String> userId;
  final Value<int> amountCents;
  final Value<DateTime> createdAt;
  final Value<int> attempts;
  final Value<DateTime?> waitUntil;
  const PaymentOutboxTableCompanion({
    this.id = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.stokvelId = const Value.absent(),
    this.cycleId = const Value.absent(),
    this.userId = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.attempts = const Value.absent(),
    this.waitUntil = const Value.absent(),
  });
  PaymentOutboxTableCompanion.insert({
    this.id = const Value.absent(),
    required String idempotencyKey,
    required String stokvelId,
    required String cycleId,
    required String userId,
    required int amountCents,
    required DateTime createdAt,
    this.attempts = const Value.absent(),
    this.waitUntil = const Value.absent(),
  }) : idempotencyKey = Value(idempotencyKey),
       stokvelId = Value(stokvelId),
       cycleId = Value(cycleId),
       userId = Value(userId),
       amountCents = Value(amountCents),
       createdAt = Value(createdAt);
  static Insertable<OutboxRow> custom({
    Expression<int>? id,
    Expression<String>? idempotencyKey,
    Expression<String>? stokvelId,
    Expression<String>? cycleId,
    Expression<String>? userId,
    Expression<int>? amountCents,
    Expression<DateTime>? createdAt,
    Expression<int>? attempts,
    Expression<DateTime>? waitUntil,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (stokvelId != null) 'stokvel_id': stokvelId,
      if (cycleId != null) 'cycle_id': cycleId,
      if (userId != null) 'user_id': userId,
      if (amountCents != null) 'amount_cents': amountCents,
      if (createdAt != null) 'created_at': createdAt,
      if (attempts != null) 'attempts': attempts,
      if (waitUntil != null) 'wait_until': waitUntil,
    });
  }

  PaymentOutboxTableCompanion copyWith({
    Value<int>? id,
    Value<String>? idempotencyKey,
    Value<String>? stokvelId,
    Value<String>? cycleId,
    Value<String>? userId,
    Value<int>? amountCents,
    Value<DateTime>? createdAt,
    Value<int>? attempts,
    Value<DateTime?>? waitUntil,
  }) {
    return PaymentOutboxTableCompanion(
      id: id ?? this.id,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      stokvelId: stokvelId ?? this.stokvelId,
      cycleId: cycleId ?? this.cycleId,
      userId: userId ?? this.userId,
      amountCents: amountCents ?? this.amountCents,
      createdAt: createdAt ?? this.createdAt,
      attempts: attempts ?? this.attempts,
      waitUntil: waitUntil ?? this.waitUntil,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (stokvelId.present) {
      map['stokvel_id'] = Variable<String>(stokvelId.value);
    }
    if (cycleId.present) {
      map['cycle_id'] = Variable<String>(cycleId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (waitUntil.present) {
      map['wait_until'] = Variable<DateTime>(waitUntil.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentOutboxTableCompanion(')
          ..write('id: $id, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('stokvelId: $stokvelId, ')
          ..write('cycleId: $cycleId, ')
          ..write('userId: $userId, ')
          ..write('amountCents: $amountCents, ')
          ..write('createdAt: $createdAt, ')
          ..write('attempts: $attempts, ')
          ..write('waitUntil: $waitUntil')
          ..write(')'))
        .toString();
  }
}

class $LastUserTableTable extends LastUserTable
    with TableInfo<$LastUserTableTable, LastUserRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LastUserTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _slotMeta = const VerificationMeta('slot');
  @override
  late final GeneratedColumn<int> slot = GeneratedColumn<int>(
    'slot',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [slot, userId, name, email];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'last_user';
  @override
  VerificationContext validateIntegrity(
    Insertable<LastUserRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('slot')) {
      context.handle(
        _slotMeta,
        slot.isAcceptableOrUnknown(data['slot']!, _slotMeta),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {slot};
  @override
  LastUserRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LastUserRow(
      slot: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}slot'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
    );
  }

  @override
  $LastUserTableTable createAlias(String alias) {
    return $LastUserTableTable(attachedDatabase, alias);
  }
}

class LastUserRow extends DataClass implements Insertable<LastUserRow> {
  /// Always 0: one person at a time.
  final int slot;

  /// The user's id.
  final String userId;

  /// Their name.
  final String name;

  /// Their email.
  final String email;
  const LastUserRow({
    required this.slot,
    required this.userId,
    required this.name,
    required this.email,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['slot'] = Variable<int>(slot);
    map['user_id'] = Variable<String>(userId);
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    return map;
  }

  LastUserTableCompanion toCompanion(bool nullToAbsent) {
    return LastUserTableCompanion(
      slot: Value(slot),
      userId: Value(userId),
      name: Value(name),
      email: Value(email),
    );
  }

  factory LastUserRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LastUserRow(
      slot: serializer.fromJson<int>(json['slot']),
      userId: serializer.fromJson<String>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'slot': serializer.toJson<int>(slot),
      'userId': serializer.toJson<String>(userId),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
    };
  }

  LastUserRow copyWith({
    int? slot,
    String? userId,
    String? name,
    String? email,
  }) => LastUserRow(
    slot: slot ?? this.slot,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    email: email ?? this.email,
  );
  LastUserRow copyWithCompanion(LastUserTableCompanion data) {
    return LastUserRow(
      slot: data.slot.present ? data.slot.value : this.slot,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LastUserRow(')
          ..write('slot: $slot, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('email: $email')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(slot, userId, name, email);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LastUserRow &&
          other.slot == this.slot &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.email == this.email);
}

class LastUserTableCompanion extends UpdateCompanion<LastUserRow> {
  final Value<int> slot;
  final Value<String> userId;
  final Value<String> name;
  final Value<String> email;
  const LastUserTableCompanion({
    this.slot = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
  });
  LastUserTableCompanion.insert({
    this.slot = const Value.absent(),
    required String userId,
    required String name,
    required String email,
  }) : userId = Value(userId),
       name = Value(name),
       email = Value(email);
  static Insertable<LastUserRow> custom({
    Expression<int>? slot,
    Expression<String>? userId,
    Expression<String>? name,
    Expression<String>? email,
  }) {
    return RawValuesInsertable({
      if (slot != null) 'slot': slot,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
    });
  }

  LastUserTableCompanion copyWith({
    Value<int>? slot,
    Value<String>? userId,
    Value<String>? name,
    Value<String>? email,
  }) {
    return LastUserTableCompanion(
      slot: slot ?? this.slot,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (slot.present) {
      map['slot'] = Variable<int>(slot.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LastUserTableCompanion(')
          ..write('slot: $slot, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('email: $email')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HomeCacheTableTable homeCacheTable = $HomeCacheTableTable(this);
  late final $StokvelCacheTableTable stokvelCacheTable =
      $StokvelCacheTableTable(this);
  late final $CycleCacheTableTable cycleCacheTable = $CycleCacheTableTable(
    this,
  );
  late final $PaymentOutboxTableTable paymentOutboxTable =
      $PaymentOutboxTableTable(this);
  late final $LastUserTableTable lastUserTable = $LastUserTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    homeCacheTable,
    stokvelCacheTable,
    cycleCacheTable,
    paymentOutboxTable,
    lastUserTable,
  ];
}

typedef $$HomeCacheTableTableCreateCompanionBuilder =
    HomeCacheTableCompanion Function({
      Value<int> slot,
      required String entries,
      required DateTime fetchedAt,
    });
typedef $$HomeCacheTableTableUpdateCompanionBuilder =
    HomeCacheTableCompanion Function({
      Value<int> slot,
      Value<String> entries,
      Value<DateTime> fetchedAt,
    });

class $$HomeCacheTableTableFilterComposer
    extends Composer<_$AppDatabase, $HomeCacheTableTable> {
  $$HomeCacheTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get slot => $composableBuilder(
    column: $table.slot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entries => $composableBuilder(
    column: $table.entries,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HomeCacheTableTableOrderingComposer
    extends Composer<_$AppDatabase, $HomeCacheTableTable> {
  $$HomeCacheTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get slot => $composableBuilder(
    column: $table.slot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entries => $composableBuilder(
    column: $table.entries,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HomeCacheTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $HomeCacheTableTable> {
  $$HomeCacheTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get slot =>
      $composableBuilder(column: $table.slot, builder: (column) => column);

  GeneratedColumn<String> get entries =>
      $composableBuilder(column: $table.entries, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$HomeCacheTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HomeCacheTableTable,
          HomeRow,
          $$HomeCacheTableTableFilterComposer,
          $$HomeCacheTableTableOrderingComposer,
          $$HomeCacheTableTableAnnotationComposer,
          $$HomeCacheTableTableCreateCompanionBuilder,
          $$HomeCacheTableTableUpdateCompanionBuilder,
          (
            HomeRow,
            BaseReferences<_$AppDatabase, $HomeCacheTableTable, HomeRow>,
          ),
          HomeRow,
          PrefetchHooks Function()
        > {
  $$HomeCacheTableTableTableManager(
    _$AppDatabase db,
    $HomeCacheTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HomeCacheTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HomeCacheTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HomeCacheTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> slot = const Value.absent(),
                Value<String> entries = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
              }) => HomeCacheTableCompanion(
                slot: slot,
                entries: entries,
                fetchedAt: fetchedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> slot = const Value.absent(),
                required String entries,
                required DateTime fetchedAt,
              }) => HomeCacheTableCompanion.insert(
                slot: slot,
                entries: entries,
                fetchedAt: fetchedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HomeCacheTableTable, HomeRow>(table),
                  BaseReferences<_$AppDatabase, $HomeCacheTableTable, HomeRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HomeCacheTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HomeCacheTableTable,
      HomeRow,
      $$HomeCacheTableTableFilterComposer,
      $$HomeCacheTableTableOrderingComposer,
      $$HomeCacheTableTableAnnotationComposer,
      $$HomeCacheTableTableCreateCompanionBuilder,
      $$HomeCacheTableTableUpdateCompanionBuilder,
      (HomeRow, BaseReferences<_$AppDatabase, $HomeCacheTableTable, HomeRow>),
      HomeRow,
      PrefetchHooks Function()
    >;
typedef $$StokvelCacheTableTableCreateCompanionBuilder =
    StokvelCacheTableCompanion Function({
      required String stokvelId,
      required String detail,
      required DateTime fetchedAt,
      Value<int> rowid,
    });
typedef $$StokvelCacheTableTableUpdateCompanionBuilder =
    StokvelCacheTableCompanion Function({
      Value<String> stokvelId,
      Value<String> detail,
      Value<DateTime> fetchedAt,
      Value<int> rowid,
    });

class $$StokvelCacheTableTableFilterComposer
    extends Composer<_$AppDatabase, $StokvelCacheTableTable> {
  $$StokvelCacheTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get stokvelId => $composableBuilder(
    column: $table.stokvelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detail => $composableBuilder(
    column: $table.detail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StokvelCacheTableTableOrderingComposer
    extends Composer<_$AppDatabase, $StokvelCacheTableTable> {
  $$StokvelCacheTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get stokvelId => $composableBuilder(
    column: $table.stokvelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detail => $composableBuilder(
    column: $table.detail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StokvelCacheTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $StokvelCacheTableTable> {
  $$StokvelCacheTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get stokvelId =>
      $composableBuilder(column: $table.stokvelId, builder: (column) => column);

  GeneratedColumn<String> get detail =>
      $composableBuilder(column: $table.detail, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$StokvelCacheTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StokvelCacheTableTable,
          StokvelRow,
          $$StokvelCacheTableTableFilterComposer,
          $$StokvelCacheTableTableOrderingComposer,
          $$StokvelCacheTableTableAnnotationComposer,
          $$StokvelCacheTableTableCreateCompanionBuilder,
          $$StokvelCacheTableTableUpdateCompanionBuilder,
          (
            StokvelRow,
            BaseReferences<_$AppDatabase, $StokvelCacheTableTable, StokvelRow>,
          ),
          StokvelRow,
          PrefetchHooks Function()
        > {
  $$StokvelCacheTableTableTableManager(
    _$AppDatabase db,
    $StokvelCacheTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StokvelCacheTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StokvelCacheTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StokvelCacheTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> stokvelId = const Value.absent(),
                Value<String> detail = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StokvelCacheTableCompanion(
                stokvelId: stokvelId,
                detail: detail,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String stokvelId,
                required String detail,
                required DateTime fetchedAt,
                Value<int> rowid = const Value.absent(),
              }) => StokvelCacheTableCompanion.insert(
                stokvelId: stokvelId,
                detail: detail,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StokvelCacheTableTable, StokvelRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $StokvelCacheTableTable,
                    StokvelRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StokvelCacheTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StokvelCacheTableTable,
      StokvelRow,
      $$StokvelCacheTableTableFilterComposer,
      $$StokvelCacheTableTableOrderingComposer,
      $$StokvelCacheTableTableAnnotationComposer,
      $$StokvelCacheTableTableCreateCompanionBuilder,
      $$StokvelCacheTableTableUpdateCompanionBuilder,
      (
        StokvelRow,
        BaseReferences<_$AppDatabase, $StokvelCacheTableTable, StokvelRow>,
      ),
      StokvelRow,
      PrefetchHooks Function()
    >;
typedef $$CycleCacheTableTableCreateCompanionBuilder =
    CycleCacheTableCompanion Function({
      required String stokvelId,
      required String cycleId,
      required String detail,
      required DateTime fetchedAt,
      Value<int> rowid,
    });
typedef $$CycleCacheTableTableUpdateCompanionBuilder =
    CycleCacheTableCompanion Function({
      Value<String> stokvelId,
      Value<String> cycleId,
      Value<String> detail,
      Value<DateTime> fetchedAt,
      Value<int> rowid,
    });

class $$CycleCacheTableTableFilterComposer
    extends Composer<_$AppDatabase, $CycleCacheTableTable> {
  $$CycleCacheTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get stokvelId => $composableBuilder(
    column: $table.stokvelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cycleId => $composableBuilder(
    column: $table.cycleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detail => $composableBuilder(
    column: $table.detail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CycleCacheTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CycleCacheTableTable> {
  $$CycleCacheTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get stokvelId => $composableBuilder(
    column: $table.stokvelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cycleId => $composableBuilder(
    column: $table.cycleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detail => $composableBuilder(
    column: $table.detail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CycleCacheTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CycleCacheTableTable> {
  $$CycleCacheTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get stokvelId =>
      $composableBuilder(column: $table.stokvelId, builder: (column) => column);

  GeneratedColumn<String> get cycleId =>
      $composableBuilder(column: $table.cycleId, builder: (column) => column);

  GeneratedColumn<String> get detail =>
      $composableBuilder(column: $table.detail, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$CycleCacheTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CycleCacheTableTable,
          CycleRow,
          $$CycleCacheTableTableFilterComposer,
          $$CycleCacheTableTableOrderingComposer,
          $$CycleCacheTableTableAnnotationComposer,
          $$CycleCacheTableTableCreateCompanionBuilder,
          $$CycleCacheTableTableUpdateCompanionBuilder,
          (
            CycleRow,
            BaseReferences<_$AppDatabase, $CycleCacheTableTable, CycleRow>,
          ),
          CycleRow,
          PrefetchHooks Function()
        > {
  $$CycleCacheTableTableTableManager(
    _$AppDatabase db,
    $CycleCacheTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CycleCacheTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CycleCacheTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CycleCacheTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> stokvelId = const Value.absent(),
                Value<String> cycleId = const Value.absent(),
                Value<String> detail = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CycleCacheTableCompanion(
                stokvelId: stokvelId,
                cycleId: cycleId,
                detail: detail,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String stokvelId,
                required String cycleId,
                required String detail,
                required DateTime fetchedAt,
                Value<int> rowid = const Value.absent(),
              }) => CycleCacheTableCompanion.insert(
                stokvelId: stokvelId,
                cycleId: cycleId,
                detail: detail,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CycleCacheTableTable, CycleRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CycleCacheTableTable,
                    CycleRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CycleCacheTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CycleCacheTableTable,
      CycleRow,
      $$CycleCacheTableTableFilterComposer,
      $$CycleCacheTableTableOrderingComposer,
      $$CycleCacheTableTableAnnotationComposer,
      $$CycleCacheTableTableCreateCompanionBuilder,
      $$CycleCacheTableTableUpdateCompanionBuilder,
      (
        CycleRow,
        BaseReferences<_$AppDatabase, $CycleCacheTableTable, CycleRow>,
      ),
      CycleRow,
      PrefetchHooks Function()
    >;
typedef $$PaymentOutboxTableTableCreateCompanionBuilder =
    PaymentOutboxTableCompanion Function({
      Value<int> id,
      required String idempotencyKey,
      required String stokvelId,
      required String cycleId,
      required String userId,
      required int amountCents,
      required DateTime createdAt,
      Value<int> attempts,
      Value<DateTime?> waitUntil,
    });
typedef $$PaymentOutboxTableTableUpdateCompanionBuilder =
    PaymentOutboxTableCompanion Function({
      Value<int> id,
      Value<String> idempotencyKey,
      Value<String> stokvelId,
      Value<String> cycleId,
      Value<String> userId,
      Value<int> amountCents,
      Value<DateTime> createdAt,
      Value<int> attempts,
      Value<DateTime?> waitUntil,
    });

class $$PaymentOutboxTableTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentOutboxTableTable> {
  $$PaymentOutboxTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stokvelId => $composableBuilder(
    column: $table.stokvelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cycleId => $composableBuilder(
    column: $table.cycleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get waitUntil => $composableBuilder(
    column: $table.waitUntil,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PaymentOutboxTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentOutboxTableTable> {
  $$PaymentOutboxTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stokvelId => $composableBuilder(
    column: $table.stokvelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cycleId => $composableBuilder(
    column: $table.cycleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get waitUntil => $composableBuilder(
    column: $table.waitUntil,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PaymentOutboxTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentOutboxTableTable> {
  $$PaymentOutboxTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get stokvelId =>
      $composableBuilder(column: $table.stokvelId, builder: (column) => column);

  GeneratedColumn<String> get cycleId =>
      $composableBuilder(column: $table.cycleId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<DateTime> get waitUntil =>
      $composableBuilder(column: $table.waitUntil, builder: (column) => column);
}

class $$PaymentOutboxTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentOutboxTableTable,
          OutboxRow,
          $$PaymentOutboxTableTableFilterComposer,
          $$PaymentOutboxTableTableOrderingComposer,
          $$PaymentOutboxTableTableAnnotationComposer,
          $$PaymentOutboxTableTableCreateCompanionBuilder,
          $$PaymentOutboxTableTableUpdateCompanionBuilder,
          (
            OutboxRow,
            BaseReferences<_$AppDatabase, $PaymentOutboxTableTable, OutboxRow>,
          ),
          OutboxRow,
          PrefetchHooks Function()
        > {
  $$PaymentOutboxTableTableTableManager(
    _$AppDatabase db,
    $PaymentOutboxTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentOutboxTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentOutboxTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentOutboxTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> idempotencyKey = const Value.absent(),
                Value<String> stokvelId = const Value.absent(),
                Value<String> cycleId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<DateTime?> waitUntil = const Value.absent(),
              }) => PaymentOutboxTableCompanion(
                id: id,
                idempotencyKey: idempotencyKey,
                stokvelId: stokvelId,
                cycleId: cycleId,
                userId: userId,
                amountCents: amountCents,
                createdAt: createdAt,
                attempts: attempts,
                waitUntil: waitUntil,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String idempotencyKey,
                required String stokvelId,
                required String cycleId,
                required String userId,
                required int amountCents,
                required DateTime createdAt,
                Value<int> attempts = const Value.absent(),
                Value<DateTime?> waitUntil = const Value.absent(),
              }) => PaymentOutboxTableCompanion.insert(
                id: id,
                idempotencyKey: idempotencyKey,
                stokvelId: stokvelId,
                cycleId: cycleId,
                userId: userId,
                amountCents: amountCents,
                createdAt: createdAt,
                attempts: attempts,
                waitUntil: waitUntil,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PaymentOutboxTableTable, OutboxRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $PaymentOutboxTableTable,
                    OutboxRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PaymentOutboxTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentOutboxTableTable,
      OutboxRow,
      $$PaymentOutboxTableTableFilterComposer,
      $$PaymentOutboxTableTableOrderingComposer,
      $$PaymentOutboxTableTableAnnotationComposer,
      $$PaymentOutboxTableTableCreateCompanionBuilder,
      $$PaymentOutboxTableTableUpdateCompanionBuilder,
      (
        OutboxRow,
        BaseReferences<_$AppDatabase, $PaymentOutboxTableTable, OutboxRow>,
      ),
      OutboxRow,
      PrefetchHooks Function()
    >;
typedef $$LastUserTableTableCreateCompanionBuilder =
    LastUserTableCompanion Function({
      Value<int> slot,
      required String userId,
      required String name,
      required String email,
    });
typedef $$LastUserTableTableUpdateCompanionBuilder =
    LastUserTableCompanion Function({
      Value<int> slot,
      Value<String> userId,
      Value<String> name,
      Value<String> email,
    });

class $$LastUserTableTableFilterComposer
    extends Composer<_$AppDatabase, $LastUserTableTable> {
  $$LastUserTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get slot => $composableBuilder(
    column: $table.slot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LastUserTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LastUserTableTable> {
  $$LastUserTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get slot => $composableBuilder(
    column: $table.slot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LastUserTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LastUserTableTable> {
  $$LastUserTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get slot =>
      $composableBuilder(column: $table.slot, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);
}

class $$LastUserTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LastUserTableTable,
          LastUserRow,
          $$LastUserTableTableFilterComposer,
          $$LastUserTableTableOrderingComposer,
          $$LastUserTableTableAnnotationComposer,
          $$LastUserTableTableCreateCompanionBuilder,
          $$LastUserTableTableUpdateCompanionBuilder,
          (
            LastUserRow,
            BaseReferences<_$AppDatabase, $LastUserTableTable, LastUserRow>,
          ),
          LastUserRow,
          PrefetchHooks Function()
        > {
  $$LastUserTableTableTableManager(_$AppDatabase db, $LastUserTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LastUserTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LastUserTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LastUserTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> slot = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> email = const Value.absent(),
              }) => LastUserTableCompanion(
                slot: slot,
                userId: userId,
                name: name,
                email: email,
              ),
          createCompanionCallback:
              ({
                Value<int> slot = const Value.absent(),
                required String userId,
                required String name,
                required String email,
              }) => LastUserTableCompanion.insert(
                slot: slot,
                userId: userId,
                name: name,
                email: email,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LastUserTableTable, LastUserRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LastUserTableTable,
                    LastUserRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LastUserTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LastUserTableTable,
      LastUserRow,
      $$LastUserTableTableFilterComposer,
      $$LastUserTableTableOrderingComposer,
      $$LastUserTableTableAnnotationComposer,
      $$LastUserTableTableCreateCompanionBuilder,
      $$LastUserTableTableUpdateCompanionBuilder,
      (
        LastUserRow,
        BaseReferences<_$AppDatabase, $LastUserTableTable, LastUserRow>,
      ),
      LastUserRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HomeCacheTableTableTableManager get homeCacheTable =>
      $$HomeCacheTableTableTableManager(_db, _db.homeCacheTable);
  $$StokvelCacheTableTableTableManager get stokvelCacheTable =>
      $$StokvelCacheTableTableTableManager(_db, _db.stokvelCacheTable);
  $$CycleCacheTableTableTableManager get cycleCacheTable =>
      $$CycleCacheTableTableTableManager(_db, _db.cycleCacheTable);
  $$PaymentOutboxTableTableTableManager get paymentOutboxTable =>
      $$PaymentOutboxTableTableTableManager(_db, _db.paymentOutboxTable);
  $$LastUserTableTableTableManager get lastUserTable =>
      $$LastUserTableTableTableManager(_db, _db.lastUserTable);
}
