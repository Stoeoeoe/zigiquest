// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DailyEntriesTable extends DailyEntries
    with TableInfo<$DailyEntriesTable, DailyEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateKeyMeta = const VerificationMeta(
    'dateKey',
  );
  @override
  late final GeneratedColumn<String> dateKey = GeneratedColumn<String>(
    'date_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
    'count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dateKey,
    count,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date_key')) {
      context.handle(
        _dateKeyMeta,
        dateKey.isAcceptableOrUnknown(data['date_key']!, _dateKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_dateKeyMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
        _countMeta,
        count.isAcceptableOrUnknown(data['count']!, _countMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      dateKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_key'],
      )!,
      count: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}count'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $DailyEntriesTable createAlias(String alias) {
    return $DailyEntriesTable(attachedDatabase, alias);
  }
}

class DailyEntry extends DataClass implements Insertable<DailyEntry> {
  final String id;
  final String dateKey;
  final int count;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const DailyEntry({
    required this.id,
    required this.dateKey,
    required this.count,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date_key'] = Variable<String>(dateKey);
    map['count'] = Variable<int>(count);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  DailyEntriesCompanion toCompanion(bool nullToAbsent) {
    return DailyEntriesCompanion(
      id: Value(id),
      dateKey: Value(dateKey),
      count: Value(count),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory DailyEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyEntry(
      id: serializer.fromJson<String>(json['id']),
      dateKey: serializer.fromJson<String>(json['dateKey']),
      count: serializer.fromJson<int>(json['count']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'dateKey': serializer.toJson<String>(dateKey),
      'count': serializer.toJson<int>(count),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  DailyEntry copyWith({
    String? id,
    String? dateKey,
    int? count,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => DailyEntry(
    id: id ?? this.id,
    dateKey: dateKey ?? this.dateKey,
    count: count ?? this.count,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  DailyEntry copyWithCompanion(DailyEntriesCompanion data) {
    return DailyEntry(
      id: data.id.present ? data.id.value : this.id,
      dateKey: data.dateKey.present ? data.dateKey.value : this.dateKey,
      count: data.count.present ? data.count.value : this.count,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyEntry(')
          ..write('id: $id, ')
          ..write('dateKey: $dateKey, ')
          ..write('count: $count, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, dateKey, count, createdAt, updatedAt, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyEntry &&
          other.id == this.id &&
          other.dateKey == this.dateKey &&
          other.count == this.count &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class DailyEntriesCompanion extends UpdateCompanion<DailyEntry> {
  final Value<String> id;
  final Value<String> dateKey;
  final Value<int> count;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const DailyEntriesCompanion({
    this.id = const Value.absent(),
    this.dateKey = const Value.absent(),
    this.count = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyEntriesCompanion.insert({
    required String id,
    required String dateKey,
    this.count = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       dateKey = Value(dateKey),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<DailyEntry> custom({
    Expression<String>? id,
    Expression<String>? dateKey,
    Expression<int>? count,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dateKey != null) 'date_key': dateKey,
      if (count != null) 'count': count,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? dateKey,
    Value<int>? count,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return DailyEntriesCompanion(
      id: id ?? this.id,
      dateKey: dateKey ?? this.dateKey,
      count: count ?? this.count,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (dateKey.present) {
      map['date_key'] = Variable<String>(dateKey.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyEntriesCompanion(')
          ..write('id: $id, ')
          ..write('dateKey: $dateKey, ')
          ..write('count: $count, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CleanupSessionsTable extends CleanupSessions
    with TableInfo<$CleanupSessionsTable, CleanupSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CleanupSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
    'count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _distanceMetersMeta = const VerificationMeta(
    'distanceMeters',
  );
  @override
  late final GeneratedColumn<double> distanceMeters = GeneratedColumn<double>(
    'distance_meters',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _locationModeMeta = const VerificationMeta(
    'locationMode',
  );
  @override
  late final GeneratedColumn<String> locationMode = GeneratedColumn<String>(
    'location_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  static const VerificationMeta _approximateLatitudeMeta =
      const VerificationMeta('approximateLatitude');
  @override
  late final GeneratedColumn<double> approximateLatitude =
      GeneratedColumn<double>(
        'approximate_latitude',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _approximateLongitudeMeta =
      const VerificationMeta('approximateLongitude');
  @override
  late final GeneratedColumn<double> approximateLongitude =
      GeneratedColumn<double>(
        'approximate_longitude',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _routeJsonMeta = const VerificationMeta(
    'routeJson',
  );
  @override
  late final GeneratedColumn<String> routeJson = GeneratedColumn<String>(
    'route_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startedAt,
    endedAt,
    count,
    durationSeconds,
    distanceMeters,
    locationMode,
    approximateLatitude,
    approximateLongitude,
    routeJson,
    notes,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cleanup_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<CleanupSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('count')) {
      context.handle(
        _countMeta,
        count.isAcceptableOrUnknown(data['count']!, _countMeta),
      );
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('distance_meters')) {
      context.handle(
        _distanceMetersMeta,
        distanceMeters.isAcceptableOrUnknown(
          data['distance_meters']!,
          _distanceMetersMeta,
        ),
      );
    }
    if (data.containsKey('location_mode')) {
      context.handle(
        _locationModeMeta,
        locationMode.isAcceptableOrUnknown(
          data['location_mode']!,
          _locationModeMeta,
        ),
      );
    }
    if (data.containsKey('approximate_latitude')) {
      context.handle(
        _approximateLatitudeMeta,
        approximateLatitude.isAcceptableOrUnknown(
          data['approximate_latitude']!,
          _approximateLatitudeMeta,
        ),
      );
    }
    if (data.containsKey('approximate_longitude')) {
      context.handle(
        _approximateLongitudeMeta,
        approximateLongitude.isAcceptableOrUnknown(
          data['approximate_longitude']!,
          _approximateLongitudeMeta,
        ),
      );
    }
    if (data.containsKey('route_json')) {
      context.handle(
        _routeJsonMeta,
        routeJson.isAcceptableOrUnknown(data['route_json']!, _routeJsonMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CleanupSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CleanupSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      count: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}count'],
      )!,
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      ),
      distanceMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distance_meters'],
      ),
      locationMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_mode'],
      )!,
      approximateLatitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}approximate_latitude'],
      ),
      approximateLongitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}approximate_longitude'],
      ),
      routeJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}route_json'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $CleanupSessionsTable createAlias(String alias) {
    return $CleanupSessionsTable(attachedDatabase, alias);
  }
}

class CleanupSession extends DataClass implements Insertable<CleanupSession> {
  final String id;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int count;
  final int? durationSeconds;
  final double? distanceMeters;
  final String locationMode;
  final double? approximateLatitude;
  final double? approximateLongitude;
  final String? routeJson;
  final String? notes;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const CleanupSession({
    required this.id,
    required this.startedAt,
    this.endedAt,
    required this.count,
    this.durationSeconds,
    this.distanceMeters,
    required this.locationMode,
    this.approximateLatitude,
    this.approximateLongitude,
    this.routeJson,
    this.notes,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    map['count'] = Variable<int>(count);
    if (!nullToAbsent || durationSeconds != null) {
      map['duration_seconds'] = Variable<int>(durationSeconds);
    }
    if (!nullToAbsent || distanceMeters != null) {
      map['distance_meters'] = Variable<double>(distanceMeters);
    }
    map['location_mode'] = Variable<String>(locationMode);
    if (!nullToAbsent || approximateLatitude != null) {
      map['approximate_latitude'] = Variable<double>(approximateLatitude);
    }
    if (!nullToAbsent || approximateLongitude != null) {
      map['approximate_longitude'] = Variable<double>(approximateLongitude);
    }
    if (!nullToAbsent || routeJson != null) {
      map['route_json'] = Variable<String>(routeJson);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  CleanupSessionsCompanion toCompanion(bool nullToAbsent) {
    return CleanupSessionsCompanion(
      id: Value(id),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      count: Value(count),
      durationSeconds: durationSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSeconds),
      distanceMeters: distanceMeters == null && nullToAbsent
          ? const Value.absent()
          : Value(distanceMeters),
      locationMode: Value(locationMode),
      approximateLatitude: approximateLatitude == null && nullToAbsent
          ? const Value.absent()
          : Value(approximateLatitude),
      approximateLongitude: approximateLongitude == null && nullToAbsent
          ? const Value.absent()
          : Value(approximateLongitude),
      routeJson: routeJson == null && nullToAbsent
          ? const Value.absent()
          : Value(routeJson),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory CleanupSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CleanupSession(
      id: serializer.fromJson<String>(json['id']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      count: serializer.fromJson<int>(json['count']),
      durationSeconds: serializer.fromJson<int?>(json['durationSeconds']),
      distanceMeters: serializer.fromJson<double?>(json['distanceMeters']),
      locationMode: serializer.fromJson<String>(json['locationMode']),
      approximateLatitude: serializer.fromJson<double?>(
        json['approximateLatitude'],
      ),
      approximateLongitude: serializer.fromJson<double?>(
        json['approximateLongitude'],
      ),
      routeJson: serializer.fromJson<String?>(json['routeJson']),
      notes: serializer.fromJson<String?>(json['notes']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'count': serializer.toJson<int>(count),
      'durationSeconds': serializer.toJson<int?>(durationSeconds),
      'distanceMeters': serializer.toJson<double?>(distanceMeters),
      'locationMode': serializer.toJson<String>(locationMode),
      'approximateLatitude': serializer.toJson<double?>(approximateLatitude),
      'approximateLongitude': serializer.toJson<double?>(approximateLongitude),
      'routeJson': serializer.toJson<String?>(routeJson),
      'notes': serializer.toJson<String?>(notes),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  CleanupSession copyWith({
    String? id,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    int? count,
    Value<int?> durationSeconds = const Value.absent(),
    Value<double?> distanceMeters = const Value.absent(),
    String? locationMode,
    Value<double?> approximateLatitude = const Value.absent(),
    Value<double?> approximateLongitude = const Value.absent(),
    Value<String?> routeJson = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => CleanupSession(
    id: id ?? this.id,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    count: count ?? this.count,
    durationSeconds: durationSeconds.present
        ? durationSeconds.value
        : this.durationSeconds,
    distanceMeters: distanceMeters.present
        ? distanceMeters.value
        : this.distanceMeters,
    locationMode: locationMode ?? this.locationMode,
    approximateLatitude: approximateLatitude.present
        ? approximateLatitude.value
        : this.approximateLatitude,
    approximateLongitude: approximateLongitude.present
        ? approximateLongitude.value
        : this.approximateLongitude,
    routeJson: routeJson.present ? routeJson.value : this.routeJson,
    notes: notes.present ? notes.value : this.notes,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  CleanupSession copyWithCompanion(CleanupSessionsCompanion data) {
    return CleanupSession(
      id: data.id.present ? data.id.value : this.id,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      count: data.count.present ? data.count.value : this.count,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      distanceMeters: data.distanceMeters.present
          ? data.distanceMeters.value
          : this.distanceMeters,
      locationMode: data.locationMode.present
          ? data.locationMode.value
          : this.locationMode,
      approximateLatitude: data.approximateLatitude.present
          ? data.approximateLatitude.value
          : this.approximateLatitude,
      approximateLongitude: data.approximateLongitude.present
          ? data.approximateLongitude.value
          : this.approximateLongitude,
      routeJson: data.routeJson.present ? data.routeJson.value : this.routeJson,
      notes: data.notes.present ? data.notes.value : this.notes,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CleanupSession(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('count: $count, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('distanceMeters: $distanceMeters, ')
          ..write('locationMode: $locationMode, ')
          ..write('approximateLatitude: $approximateLatitude, ')
          ..write('approximateLongitude: $approximateLongitude, ')
          ..write('routeJson: $routeJson, ')
          ..write('notes: $notes, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    startedAt,
    endedAt,
    count,
    durationSeconds,
    distanceMeters,
    locationMode,
    approximateLatitude,
    approximateLongitude,
    routeJson,
    notes,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CleanupSession &&
          other.id == this.id &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.count == this.count &&
          other.durationSeconds == this.durationSeconds &&
          other.distanceMeters == this.distanceMeters &&
          other.locationMode == this.locationMode &&
          other.approximateLatitude == this.approximateLatitude &&
          other.approximateLongitude == this.approximateLongitude &&
          other.routeJson == this.routeJson &&
          other.notes == this.notes &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class CleanupSessionsCompanion extends UpdateCompanion<CleanupSession> {
  final Value<String> id;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<int> count;
  final Value<int?> durationSeconds;
  final Value<double?> distanceMeters;
  final Value<String> locationMode;
  final Value<double?> approximateLatitude;
  final Value<double?> approximateLongitude;
  final Value<String?> routeJson;
  final Value<String?> notes;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const CleanupSessionsCompanion({
    this.id = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.count = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.distanceMeters = const Value.absent(),
    this.locationMode = const Value.absent(),
    this.approximateLatitude = const Value.absent(),
    this.approximateLongitude = const Value.absent(),
    this.routeJson = const Value.absent(),
    this.notes = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CleanupSessionsCompanion.insert({
    required String id,
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    this.count = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.distanceMeters = const Value.absent(),
    this.locationMode = const Value.absent(),
    this.approximateLatitude = const Value.absent(),
    this.approximateLongitude = const Value.absent(),
    this.routeJson = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       startedAt = Value(startedAt),
       updatedAt = Value(updatedAt);
  static Insertable<CleanupSession> custom({
    Expression<String>? id,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? count,
    Expression<int>? durationSeconds,
    Expression<double>? distanceMeters,
    Expression<String>? locationMode,
    Expression<double>? approximateLatitude,
    Expression<double>? approximateLongitude,
    Expression<String>? routeJson,
    Expression<String>? notes,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (count != null) 'count': count,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (distanceMeters != null) 'distance_meters': distanceMeters,
      if (locationMode != null) 'location_mode': locationMode,
      if (approximateLatitude != null)
        'approximate_latitude': approximateLatitude,
      if (approximateLongitude != null)
        'approximate_longitude': approximateLongitude,
      if (routeJson != null) 'route_json': routeJson,
      if (notes != null) 'notes': notes,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CleanupSessionsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<int>? count,
    Value<int?>? durationSeconds,
    Value<double?>? distanceMeters,
    Value<String>? locationMode,
    Value<double?>? approximateLatitude,
    Value<double?>? approximateLongitude,
    Value<String?>? routeJson,
    Value<String?>? notes,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return CleanupSessionsCompanion(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      count: count ?? this.count,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      locationMode: locationMode ?? this.locationMode,
      approximateLatitude: approximateLatitude ?? this.approximateLatitude,
      approximateLongitude: approximateLongitude ?? this.approximateLongitude,
      routeJson: routeJson ?? this.routeJson,
      notes: notes ?? this.notes,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (distanceMeters.present) {
      map['distance_meters'] = Variable<double>(distanceMeters.value);
    }
    if (locationMode.present) {
      map['location_mode'] = Variable<String>(locationMode.value);
    }
    if (approximateLatitude.present) {
      map['approximate_latitude'] = Variable<double>(approximateLatitude.value);
    }
    if (approximateLongitude.present) {
      map['approximate_longitude'] = Variable<double>(
        approximateLongitude.value,
      );
    }
    if (routeJson.present) {
      map['route_json'] = Variable<String>(routeJson.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CleanupSessionsCompanion(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('count: $count, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('distanceMeters: $distanceMeters, ')
          ..write('locationMode: $locationMode, ')
          ..write('approximateLatitude: $approximateLatitude, ')
          ..write('approximateLongitude: $approximateLongitude, ')
          ..write('routeJson: $routeJson, ')
          ..write('notes: $notes, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppPreferencesTable extends AppPreferences
    with TableInfo<$AppPreferencesTable, AppPreference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppPreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
    'theme_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('system'),
  );
  static const VerificationMeta _hapticsEnabledMeta = const VerificationMeta(
    'hapticsEnabled',
  );
  @override
  late final GeneratedColumn<bool> hapticsEnabled = GeneratedColumn<bool>(
    'haptics_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("haptics_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _soundEnabledMeta = const VerificationMeta(
    'soundEnabled',
  );
  @override
  late final GeneratedColumn<bool> soundEnabled = GeneratedColumn<bool>(
    'sound_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sound_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _reducedMotionMeta = const VerificationMeta(
    'reducedMotion',
  );
  @override
  late final GeneratedColumn<bool> reducedMotion = GeneratedColumn<bool>(
    'reduced_motion',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reduced_motion" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _containerStyleMeta = const VerificationMeta(
    'containerStyle',
  );
  @override
  late final GeneratedColumn<String> containerStyle = GeneratedColumn<String>(
    'container_style',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('glass_jar'),
  );
  static const VerificationMeta _cloudPhotoBackupMeta = const VerificationMeta(
    'cloudPhotoBackup',
  );
  @override
  late final GeneratedColumn<bool> cloudPhotoBackup = GeneratedColumn<bool>(
    'cloud_photo_backup',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("cloud_photo_backup" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _locationDefaultMeta = const VerificationMeta(
    'locationDefault',
  );
  @override
  late final GeneratedColumn<String> locationDefault = GeneratedColumn<String>(
    'location_default',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  static const VerificationMeta _userSeedMeta = const VerificationMeta(
    'userSeed',
  );
  @override
  late final GeneratedColumn<int> userSeed = GeneratedColumn<int>(
    'user_seed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(7319),
  );
  static const VerificationMeta _pileLimitMeta = const VerificationMeta(
    'pileLimit',
  );
  @override
  late final GeneratedColumn<int> pileLimit = GeneratedColumn<int>(
    'pile_limit',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(100),
  );
  static const VerificationMeta _environmentEffectsEnabledMeta =
      const VerificationMeta('environmentEffectsEnabled');
  @override
  late final GeneratedColumn<bool> environmentEffectsEnabled =
      GeneratedColumn<bool>(
        'environment_effects_enabled',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("environment_effects_enabled" IN (0, 1))',
        ),
        defaultValue: const Constant(true),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    themeMode,
    hapticsEnabled,
    soundEnabled,
    reducedMotion,
    containerStyle,
    cloudPhotoBackup,
    locationDefault,
    userSeed,
    pileLimit,
    environmentEffectsEnabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppPreference> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    }
    if (data.containsKey('haptics_enabled')) {
      context.handle(
        _hapticsEnabledMeta,
        hapticsEnabled.isAcceptableOrUnknown(
          data['haptics_enabled']!,
          _hapticsEnabledMeta,
        ),
      );
    }
    if (data.containsKey('sound_enabled')) {
      context.handle(
        _soundEnabledMeta,
        soundEnabled.isAcceptableOrUnknown(
          data['sound_enabled']!,
          _soundEnabledMeta,
        ),
      );
    }
    if (data.containsKey('reduced_motion')) {
      context.handle(
        _reducedMotionMeta,
        reducedMotion.isAcceptableOrUnknown(
          data['reduced_motion']!,
          _reducedMotionMeta,
        ),
      );
    }
    if (data.containsKey('container_style')) {
      context.handle(
        _containerStyleMeta,
        containerStyle.isAcceptableOrUnknown(
          data['container_style']!,
          _containerStyleMeta,
        ),
      );
    }
    if (data.containsKey('cloud_photo_backup')) {
      context.handle(
        _cloudPhotoBackupMeta,
        cloudPhotoBackup.isAcceptableOrUnknown(
          data['cloud_photo_backup']!,
          _cloudPhotoBackupMeta,
        ),
      );
    }
    if (data.containsKey('location_default')) {
      context.handle(
        _locationDefaultMeta,
        locationDefault.isAcceptableOrUnknown(
          data['location_default']!,
          _locationDefaultMeta,
        ),
      );
    }
    if (data.containsKey('user_seed')) {
      context.handle(
        _userSeedMeta,
        userSeed.isAcceptableOrUnknown(data['user_seed']!, _userSeedMeta),
      );
    }
    if (data.containsKey('pile_limit')) {
      context.handle(
        _pileLimitMeta,
        pileLimit.isAcceptableOrUnknown(data['pile_limit']!, _pileLimitMeta),
      );
    }
    if (data.containsKey('environment_effects_enabled')) {
      context.handle(
        _environmentEffectsEnabledMeta,
        environmentEffectsEnabled.isAcceptableOrUnknown(
          data['environment_effects_enabled']!,
          _environmentEffectsEnabledMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppPreference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppPreference(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      themeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_mode'],
      )!,
      hapticsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}haptics_enabled'],
      )!,
      soundEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sound_enabled'],
      )!,
      reducedMotion: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reduced_motion'],
      )!,
      containerStyle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}container_style'],
      )!,
      cloudPhotoBackup: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}cloud_photo_backup'],
      )!,
      locationDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_default'],
      )!,
      userSeed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_seed'],
      )!,
      pileLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pile_limit'],
      )!,
      environmentEffectsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}environment_effects_enabled'],
      )!,
    );
  }

  @override
  $AppPreferencesTable createAlias(String alias) {
    return $AppPreferencesTable(attachedDatabase, alias);
  }
}

class AppPreference extends DataClass implements Insertable<AppPreference> {
  final int id;
  final String themeMode;
  final bool hapticsEnabled;
  final bool soundEnabled;
  final bool reducedMotion;
  final String containerStyle;
  final bool cloudPhotoBackup;
  final String locationDefault;
  final int userSeed;
  final int pileLimit;
  final bool environmentEffectsEnabled;
  const AppPreference({
    required this.id,
    required this.themeMode,
    required this.hapticsEnabled,
    required this.soundEnabled,
    required this.reducedMotion,
    required this.containerStyle,
    required this.cloudPhotoBackup,
    required this.locationDefault,
    required this.userSeed,
    required this.pileLimit,
    required this.environmentEffectsEnabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['theme_mode'] = Variable<String>(themeMode);
    map['haptics_enabled'] = Variable<bool>(hapticsEnabled);
    map['sound_enabled'] = Variable<bool>(soundEnabled);
    map['reduced_motion'] = Variable<bool>(reducedMotion);
    map['container_style'] = Variable<String>(containerStyle);
    map['cloud_photo_backup'] = Variable<bool>(cloudPhotoBackup);
    map['location_default'] = Variable<String>(locationDefault);
    map['user_seed'] = Variable<int>(userSeed);
    map['pile_limit'] = Variable<int>(pileLimit);
    map['environment_effects_enabled'] = Variable<bool>(
      environmentEffectsEnabled,
    );
    return map;
  }

  AppPreferencesCompanion toCompanion(bool nullToAbsent) {
    return AppPreferencesCompanion(
      id: Value(id),
      themeMode: Value(themeMode),
      hapticsEnabled: Value(hapticsEnabled),
      soundEnabled: Value(soundEnabled),
      reducedMotion: Value(reducedMotion),
      containerStyle: Value(containerStyle),
      cloudPhotoBackup: Value(cloudPhotoBackup),
      locationDefault: Value(locationDefault),
      userSeed: Value(userSeed),
      pileLimit: Value(pileLimit),
      environmentEffectsEnabled: Value(environmentEffectsEnabled),
    );
  }

  factory AppPreference.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppPreference(
      id: serializer.fromJson<int>(json['id']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      hapticsEnabled: serializer.fromJson<bool>(json['hapticsEnabled']),
      soundEnabled: serializer.fromJson<bool>(json['soundEnabled']),
      reducedMotion: serializer.fromJson<bool>(json['reducedMotion']),
      containerStyle: serializer.fromJson<String>(json['containerStyle']),
      cloudPhotoBackup: serializer.fromJson<bool>(json['cloudPhotoBackup']),
      locationDefault: serializer.fromJson<String>(json['locationDefault']),
      userSeed: serializer.fromJson<int>(json['userSeed']),
      pileLimit: serializer.fromJson<int>(json['pileLimit']),
      environmentEffectsEnabled: serializer.fromJson<bool>(
        json['environmentEffectsEnabled'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'themeMode': serializer.toJson<String>(themeMode),
      'hapticsEnabled': serializer.toJson<bool>(hapticsEnabled),
      'soundEnabled': serializer.toJson<bool>(soundEnabled),
      'reducedMotion': serializer.toJson<bool>(reducedMotion),
      'containerStyle': serializer.toJson<String>(containerStyle),
      'cloudPhotoBackup': serializer.toJson<bool>(cloudPhotoBackup),
      'locationDefault': serializer.toJson<String>(locationDefault),
      'userSeed': serializer.toJson<int>(userSeed),
      'pileLimit': serializer.toJson<int>(pileLimit),
      'environmentEffectsEnabled': serializer.toJson<bool>(
        environmentEffectsEnabled,
      ),
    };
  }

  AppPreference copyWith({
    int? id,
    String? themeMode,
    bool? hapticsEnabled,
    bool? soundEnabled,
    bool? reducedMotion,
    String? containerStyle,
    bool? cloudPhotoBackup,
    String? locationDefault,
    int? userSeed,
    int? pileLimit,
    bool? environmentEffectsEnabled,
  }) => AppPreference(
    id: id ?? this.id,
    themeMode: themeMode ?? this.themeMode,
    hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
    soundEnabled: soundEnabled ?? this.soundEnabled,
    reducedMotion: reducedMotion ?? this.reducedMotion,
    containerStyle: containerStyle ?? this.containerStyle,
    cloudPhotoBackup: cloudPhotoBackup ?? this.cloudPhotoBackup,
    locationDefault: locationDefault ?? this.locationDefault,
    userSeed: userSeed ?? this.userSeed,
    pileLimit: pileLimit ?? this.pileLimit,
    environmentEffectsEnabled:
        environmentEffectsEnabled ?? this.environmentEffectsEnabled,
  );
  AppPreference copyWithCompanion(AppPreferencesCompanion data) {
    return AppPreference(
      id: data.id.present ? data.id.value : this.id,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      hapticsEnabled: data.hapticsEnabled.present
          ? data.hapticsEnabled.value
          : this.hapticsEnabled,
      soundEnabled: data.soundEnabled.present
          ? data.soundEnabled.value
          : this.soundEnabled,
      reducedMotion: data.reducedMotion.present
          ? data.reducedMotion.value
          : this.reducedMotion,
      containerStyle: data.containerStyle.present
          ? data.containerStyle.value
          : this.containerStyle,
      cloudPhotoBackup: data.cloudPhotoBackup.present
          ? data.cloudPhotoBackup.value
          : this.cloudPhotoBackup,
      locationDefault: data.locationDefault.present
          ? data.locationDefault.value
          : this.locationDefault,
      userSeed: data.userSeed.present ? data.userSeed.value : this.userSeed,
      pileLimit: data.pileLimit.present ? data.pileLimit.value : this.pileLimit,
      environmentEffectsEnabled: data.environmentEffectsEnabled.present
          ? data.environmentEffectsEnabled.value
          : this.environmentEffectsEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppPreference(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('hapticsEnabled: $hapticsEnabled, ')
          ..write('soundEnabled: $soundEnabled, ')
          ..write('reducedMotion: $reducedMotion, ')
          ..write('containerStyle: $containerStyle, ')
          ..write('cloudPhotoBackup: $cloudPhotoBackup, ')
          ..write('locationDefault: $locationDefault, ')
          ..write('userSeed: $userSeed, ')
          ..write('pileLimit: $pileLimit, ')
          ..write('environmentEffectsEnabled: $environmentEffectsEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    themeMode,
    hapticsEnabled,
    soundEnabled,
    reducedMotion,
    containerStyle,
    cloudPhotoBackup,
    locationDefault,
    userSeed,
    pileLimit,
    environmentEffectsEnabled,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppPreference &&
          other.id == this.id &&
          other.themeMode == this.themeMode &&
          other.hapticsEnabled == this.hapticsEnabled &&
          other.soundEnabled == this.soundEnabled &&
          other.reducedMotion == this.reducedMotion &&
          other.containerStyle == this.containerStyle &&
          other.cloudPhotoBackup == this.cloudPhotoBackup &&
          other.locationDefault == this.locationDefault &&
          other.userSeed == this.userSeed &&
          other.pileLimit == this.pileLimit &&
          other.environmentEffectsEnabled == this.environmentEffectsEnabled);
}

class AppPreferencesCompanion extends UpdateCompanion<AppPreference> {
  final Value<int> id;
  final Value<String> themeMode;
  final Value<bool> hapticsEnabled;
  final Value<bool> soundEnabled;
  final Value<bool> reducedMotion;
  final Value<String> containerStyle;
  final Value<bool> cloudPhotoBackup;
  final Value<String> locationDefault;
  final Value<int> userSeed;
  final Value<int> pileLimit;
  final Value<bool> environmentEffectsEnabled;
  const AppPreferencesCompanion({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.hapticsEnabled = const Value.absent(),
    this.soundEnabled = const Value.absent(),
    this.reducedMotion = const Value.absent(),
    this.containerStyle = const Value.absent(),
    this.cloudPhotoBackup = const Value.absent(),
    this.locationDefault = const Value.absent(),
    this.userSeed = const Value.absent(),
    this.pileLimit = const Value.absent(),
    this.environmentEffectsEnabled = const Value.absent(),
  });
  AppPreferencesCompanion.insert({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.hapticsEnabled = const Value.absent(),
    this.soundEnabled = const Value.absent(),
    this.reducedMotion = const Value.absent(),
    this.containerStyle = const Value.absent(),
    this.cloudPhotoBackup = const Value.absent(),
    this.locationDefault = const Value.absent(),
    this.userSeed = const Value.absent(),
    this.pileLimit = const Value.absent(),
    this.environmentEffectsEnabled = const Value.absent(),
  });
  static Insertable<AppPreference> custom({
    Expression<int>? id,
    Expression<String>? themeMode,
    Expression<bool>? hapticsEnabled,
    Expression<bool>? soundEnabled,
    Expression<bool>? reducedMotion,
    Expression<String>? containerStyle,
    Expression<bool>? cloudPhotoBackup,
    Expression<String>? locationDefault,
    Expression<int>? userSeed,
    Expression<int>? pileLimit,
    Expression<bool>? environmentEffectsEnabled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (themeMode != null) 'theme_mode': themeMode,
      if (hapticsEnabled != null) 'haptics_enabled': hapticsEnabled,
      if (soundEnabled != null) 'sound_enabled': soundEnabled,
      if (reducedMotion != null) 'reduced_motion': reducedMotion,
      if (containerStyle != null) 'container_style': containerStyle,
      if (cloudPhotoBackup != null) 'cloud_photo_backup': cloudPhotoBackup,
      if (locationDefault != null) 'location_default': locationDefault,
      if (userSeed != null) 'user_seed': userSeed,
      if (pileLimit != null) 'pile_limit': pileLimit,
      if (environmentEffectsEnabled != null)
        'environment_effects_enabled': environmentEffectsEnabled,
    });
  }

  AppPreferencesCompanion copyWith({
    Value<int>? id,
    Value<String>? themeMode,
    Value<bool>? hapticsEnabled,
    Value<bool>? soundEnabled,
    Value<bool>? reducedMotion,
    Value<String>? containerStyle,
    Value<bool>? cloudPhotoBackup,
    Value<String>? locationDefault,
    Value<int>? userSeed,
    Value<int>? pileLimit,
    Value<bool>? environmentEffectsEnabled,
  }) {
    return AppPreferencesCompanion(
      id: id ?? this.id,
      themeMode: themeMode ?? this.themeMode,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      reducedMotion: reducedMotion ?? this.reducedMotion,
      containerStyle: containerStyle ?? this.containerStyle,
      cloudPhotoBackup: cloudPhotoBackup ?? this.cloudPhotoBackup,
      locationDefault: locationDefault ?? this.locationDefault,
      userSeed: userSeed ?? this.userSeed,
      pileLimit: pileLimit ?? this.pileLimit,
      environmentEffectsEnabled:
          environmentEffectsEnabled ?? this.environmentEffectsEnabled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (hapticsEnabled.present) {
      map['haptics_enabled'] = Variable<bool>(hapticsEnabled.value);
    }
    if (soundEnabled.present) {
      map['sound_enabled'] = Variable<bool>(soundEnabled.value);
    }
    if (reducedMotion.present) {
      map['reduced_motion'] = Variable<bool>(reducedMotion.value);
    }
    if (containerStyle.present) {
      map['container_style'] = Variable<String>(containerStyle.value);
    }
    if (cloudPhotoBackup.present) {
      map['cloud_photo_backup'] = Variable<bool>(cloudPhotoBackup.value);
    }
    if (locationDefault.present) {
      map['location_default'] = Variable<String>(locationDefault.value);
    }
    if (userSeed.present) {
      map['user_seed'] = Variable<int>(userSeed.value);
    }
    if (pileLimit.present) {
      map['pile_limit'] = Variable<int>(pileLimit.value);
    }
    if (environmentEffectsEnabled.present) {
      map['environment_effects_enabled'] = Variable<bool>(
        environmentEffectsEnabled.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppPreferencesCompanion(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('hapticsEnabled: $hapticsEnabled, ')
          ..write('soundEnabled: $soundEnabled, ')
          ..write('reducedMotion: $reducedMotion, ')
          ..write('containerStyle: $containerStyle, ')
          ..write('cloudPhotoBackup: $cloudPhotoBackup, ')
          ..write('locationDefault: $locationDefault, ')
          ..write('userSeed: $userSeed, ')
          ..write('pileLimit: $pileLimit, ')
          ..write('environmentEffectsEnabled: $environmentEffectsEnabled')
          ..write(')'))
        .toString();
  }
}

class $SyncOutboxTable extends SyncOutbox
    with TableInfo<$SyncOutboxTable, SyncOutboxData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncOutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
  static const VerificationMeta _attemptCountMeta = const VerificationMeta(
    'attemptCount',
  );
  @override
  late final GeneratedColumn<int> attemptCount = GeneratedColumn<int>(
    'attempt_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nextRetryAtMeta = const VerificationMeta(
    'nextRetryAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextRetryAt = GeneratedColumn<DateTime>(
    'next_retry_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    entityId,
    operation,
    payload,
    createdAt,
    attemptCount,
    lastError,
    nextRetryAt,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_outbox';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncOutboxData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('attempt_count')) {
      context.handle(
        _attemptCountMeta,
        attemptCount.isAcceptableOrUnknown(
          data['attempt_count']!,
          _attemptCountMeta,
        ),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('next_retry_at')) {
      context.handle(
        _nextRetryAtMeta,
        nextRetryAt.isAcceptableOrUnknown(
          data['next_retry_at']!,
          _nextRetryAtMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncOutboxData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncOutboxData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      attemptCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_count'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      nextRetryAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_retry_at'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $SyncOutboxTable createAlias(String alias) {
    return $SyncOutboxTable(attachedDatabase, alias);
  }
}

class SyncOutboxData extends DataClass implements Insertable<SyncOutboxData> {
  final String id;
  final String entityType;
  final String entityId;
  final String operation;
  final String payload;
  final DateTime createdAt;
  final int attemptCount;
  final String? lastError;
  final DateTime? nextRetryAt;
  final String status;
  const SyncOutboxData({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.operation,
    required this.payload,
    required this.createdAt,
    required this.attemptCount,
    this.lastError,
    this.nextRetryAt,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['operation'] = Variable<String>(operation);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['attempt_count'] = Variable<int>(attemptCount);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    if (!nullToAbsent || nextRetryAt != null) {
      map['next_retry_at'] = Variable<DateTime>(nextRetryAt);
    }
    map['status'] = Variable<String>(status);
    return map;
  }

  SyncOutboxCompanion toCompanion(bool nullToAbsent) {
    return SyncOutboxCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      operation: Value(operation),
      payload: Value(payload),
      createdAt: Value(createdAt),
      attemptCount: Value(attemptCount),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      nextRetryAt: nextRetryAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextRetryAt),
      status: Value(status),
    );
  }

  factory SyncOutboxData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncOutboxData(
      id: serializer.fromJson<String>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      operation: serializer.fromJson<String>(json['operation']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      attemptCount: serializer.fromJson<int>(json['attemptCount']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      nextRetryAt: serializer.fromJson<DateTime?>(json['nextRetryAt']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'operation': serializer.toJson<String>(operation),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'attemptCount': serializer.toJson<int>(attemptCount),
      'lastError': serializer.toJson<String?>(lastError),
      'nextRetryAt': serializer.toJson<DateTime?>(nextRetryAt),
      'status': serializer.toJson<String>(status),
    };
  }

  SyncOutboxData copyWith({
    String? id,
    String? entityType,
    String? entityId,
    String? operation,
    String? payload,
    DateTime? createdAt,
    int? attemptCount,
    Value<String?> lastError = const Value.absent(),
    Value<DateTime?> nextRetryAt = const Value.absent(),
    String? status,
  }) => SyncOutboxData(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    operation: operation ?? this.operation,
    payload: payload ?? this.payload,
    createdAt: createdAt ?? this.createdAt,
    attemptCount: attemptCount ?? this.attemptCount,
    lastError: lastError.present ? lastError.value : this.lastError,
    nextRetryAt: nextRetryAt.present ? nextRetryAt.value : this.nextRetryAt,
    status: status ?? this.status,
  );
  SyncOutboxData copyWithCompanion(SyncOutboxCompanion data) {
    return SyncOutboxData(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operation: data.operation.present ? data.operation.value : this.operation,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      attemptCount: data.attemptCount.present
          ? data.attemptCount.value
          : this.attemptCount,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      nextRetryAt: data.nextRetryAt.present
          ? data.nextRetryAt.value
          : this.nextRetryAt,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxData(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('lastError: $lastError, ')
          ..write('nextRetryAt: $nextRetryAt, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entityType,
    entityId,
    operation,
    payload,
    createdAt,
    attemptCount,
    lastError,
    nextRetryAt,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncOutboxData &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.operation == this.operation &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt &&
          other.attemptCount == this.attemptCount &&
          other.lastError == this.lastError &&
          other.nextRetryAt == this.nextRetryAt &&
          other.status == this.status);
}

class SyncOutboxCompanion extends UpdateCompanion<SyncOutboxData> {
  final Value<String> id;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> operation;
  final Value<String> payload;
  final Value<DateTime> createdAt;
  final Value<int> attemptCount;
  final Value<String?> lastError;
  final Value<DateTime?> nextRetryAt;
  final Value<String> status;
  final Value<int> rowid;
  const SyncOutboxCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operation = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.nextRetryAt = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncOutboxCompanion.insert({
    required String id,
    required String entityType,
    required String entityId,
    required String operation,
    required String payload,
    required DateTime createdAt,
    this.attemptCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.nextRetryAt = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entityType = Value(entityType),
       entityId = Value(entityId),
       operation = Value(operation),
       payload = Value(payload),
       createdAt = Value(createdAt);
  static Insertable<SyncOutboxData> custom({
    Expression<String>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? operation,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<int>? attemptCount,
    Expression<String>? lastError,
    Expression<DateTime>? nextRetryAt,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (operation != null) 'operation': operation,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (attemptCount != null) 'attempt_count': attemptCount,
      if (lastError != null) 'last_error': lastError,
      if (nextRetryAt != null) 'next_retry_at': nextRetryAt,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncOutboxCompanion copyWith({
    Value<String>? id,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? operation,
    Value<String>? payload,
    Value<DateTime>? createdAt,
    Value<int>? attemptCount,
    Value<String?>? lastError,
    Value<DateTime?>? nextRetryAt,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return SyncOutboxCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      attemptCount: attemptCount ?? this.attemptCount,
      lastError: lastError ?? this.lastError,
      nextRetryAt: nextRetryAt ?? this.nextRetryAt,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (attemptCount.present) {
      map['attempt_count'] = Variable<int>(attemptCount.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (nextRetryAt.present) {
      map['next_retry_at'] = Variable<DateTime>(nextRetryAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('lastError: $lastError, ')
          ..write('nextRetryAt: $nextRetryAt, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SessionPhotosTable extends SessionPhotos
    with TableInfo<$SessionPhotosTable, SessionPhoto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionPhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<int> width = GeneratedColumn<int>(
    'width',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
    'height',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sizeBytesMeta = const VerificationMeta(
    'sizeBytes',
  );
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
    'size_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _uploadedMeta = const VerificationMeta(
    'uploaded',
  );
  @override
  late final GeneratedColumn<bool> uploaded = GeneratedColumn<bool>(
    'uploaded',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("uploaded" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    path,
    type,
    width,
    height,
    sizeBytes,
    uploaded,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionPhoto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('width')) {
      context.handle(
        _widthMeta,
        width.isAcceptableOrUnknown(data['width']!, _widthMeta),
      );
    } else if (isInserting) {
      context.missing(_widthMeta);
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    } else if (isInserting) {
      context.missing(_heightMeta);
    }
    if (data.containsKey('size_bytes')) {
      context.handle(
        _sizeBytesMeta,
        sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta),
      );
    } else if (isInserting) {
      context.missing(_sizeBytesMeta);
    }
    if (data.containsKey('uploaded')) {
      context.handle(
        _uploadedMeta,
        uploaded.isAcceptableOrUnknown(data['uploaded']!, _uploadedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionPhoto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionPhoto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      width: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}width'],
      )!,
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height'],
      )!,
      sizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size_bytes'],
      )!,
      uploaded: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}uploaded'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SessionPhotosTable createAlias(String alias) {
    return $SessionPhotosTable(attachedDatabase, alias);
  }
}

class SessionPhoto extends DataClass implements Insertable<SessionPhoto> {
  final String id;
  final String sessionId;
  final String path;
  final String type;
  final int width;
  final int height;
  final int sizeBytes;
  final bool uploaded;
  final DateTime createdAt;
  const SessionPhoto({
    required this.id,
    required this.sessionId,
    required this.path,
    required this.type,
    required this.width,
    required this.height,
    required this.sizeBytes,
    required this.uploaded,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['path'] = Variable<String>(path);
    map['type'] = Variable<String>(type);
    map['width'] = Variable<int>(width);
    map['height'] = Variable<int>(height);
    map['size_bytes'] = Variable<int>(sizeBytes);
    map['uploaded'] = Variable<bool>(uploaded);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SessionPhotosCompanion toCompanion(bool nullToAbsent) {
    return SessionPhotosCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      path: Value(path),
      type: Value(type),
      width: Value(width),
      height: Value(height),
      sizeBytes: Value(sizeBytes),
      uploaded: Value(uploaded),
      createdAt: Value(createdAt),
    );
  }

  factory SessionPhoto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionPhoto(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      path: serializer.fromJson<String>(json['path']),
      type: serializer.fromJson<String>(json['type']),
      width: serializer.fromJson<int>(json['width']),
      height: serializer.fromJson<int>(json['height']),
      sizeBytes: serializer.fromJson<int>(json['sizeBytes']),
      uploaded: serializer.fromJson<bool>(json['uploaded']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'path': serializer.toJson<String>(path),
      'type': serializer.toJson<String>(type),
      'width': serializer.toJson<int>(width),
      'height': serializer.toJson<int>(height),
      'sizeBytes': serializer.toJson<int>(sizeBytes),
      'uploaded': serializer.toJson<bool>(uploaded),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SessionPhoto copyWith({
    String? id,
    String? sessionId,
    String? path,
    String? type,
    int? width,
    int? height,
    int? sizeBytes,
    bool? uploaded,
    DateTime? createdAt,
  }) => SessionPhoto(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    path: path ?? this.path,
    type: type ?? this.type,
    width: width ?? this.width,
    height: height ?? this.height,
    sizeBytes: sizeBytes ?? this.sizeBytes,
    uploaded: uploaded ?? this.uploaded,
    createdAt: createdAt ?? this.createdAt,
  );
  SessionPhoto copyWithCompanion(SessionPhotosCompanion data) {
    return SessionPhoto(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      path: data.path.present ? data.path.value : this.path,
      type: data.type.present ? data.type.value : this.type,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
      uploaded: data.uploaded.present ? data.uploaded.value : this.uploaded,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionPhoto(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('path: $path, ')
          ..write('type: $type, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('uploaded: $uploaded, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    path,
    type,
    width,
    height,
    sizeBytes,
    uploaded,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionPhoto &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.path == this.path &&
          other.type == this.type &&
          other.width == this.width &&
          other.height == this.height &&
          other.sizeBytes == this.sizeBytes &&
          other.uploaded == this.uploaded &&
          other.createdAt == this.createdAt);
}

class SessionPhotosCompanion extends UpdateCompanion<SessionPhoto> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<String> path;
  final Value<String> type;
  final Value<int> width;
  final Value<int> height;
  final Value<int> sizeBytes;
  final Value<bool> uploaded;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SessionPhotosCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.path = const Value.absent(),
    this.type = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.uploaded = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionPhotosCompanion.insert({
    required String id,
    required String sessionId,
    required String path,
    required String type,
    required int width,
    required int height,
    required int sizeBytes,
    this.uploaded = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessionId = Value(sessionId),
       path = Value(path),
       type = Value(type),
       width = Value(width),
       height = Value(height),
       sizeBytes = Value(sizeBytes),
       createdAt = Value(createdAt);
  static Insertable<SessionPhoto> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<String>? path,
    Expression<String>? type,
    Expression<int>? width,
    Expression<int>? height,
    Expression<int>? sizeBytes,
    Expression<bool>? uploaded,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (path != null) 'path': path,
      if (type != null) 'type': type,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (uploaded != null) 'uploaded': uploaded,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionPhotosCompanion copyWith({
    Value<String>? id,
    Value<String>? sessionId,
    Value<String>? path,
    Value<String>? type,
    Value<int>? width,
    Value<int>? height,
    Value<int>? sizeBytes,
    Value<bool>? uploaded,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return SessionPhotosCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      path: path ?? this.path,
      type: type ?? this.type,
      width: width ?? this.width,
      height: height ?? this.height,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      uploaded: uploaded ?? this.uploaded,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (width.present) {
      map['width'] = Variable<int>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    if (uploaded.present) {
      map['uploaded'] = Variable<bool>(uploaded.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionPhotosCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('path: $path, ')
          ..write('type: $type, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('uploaded: $uploaded, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UnlockRecordsTable extends UnlockRecords
    with TableInfo<$UnlockRecordsTable, UnlockRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnlockRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unlockedAtMeta = const VerificationMeta(
    'unlockedAt',
  );
  @override
  late final GeneratedColumn<DateTime> unlockedAt = GeneratedColumn<DateTime>(
    'unlocked_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, unlockedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'unlock_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<UnlockRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('unlocked_at')) {
      context.handle(
        _unlockedAtMeta,
        unlockedAt.isAcceptableOrUnknown(data['unlocked_at']!, _unlockedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_unlockedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  UnlockRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UnlockRecord(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      unlockedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}unlocked_at'],
      )!,
    );
  }

  @override
  $UnlockRecordsTable createAlias(String alias) {
    return $UnlockRecordsTable(attachedDatabase, alias);
  }
}

class UnlockRecord extends DataClass implements Insertable<UnlockRecord> {
  final String key;
  final DateTime unlockedAt;
  const UnlockRecord({required this.key, required this.unlockedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['unlocked_at'] = Variable<DateTime>(unlockedAt);
    return map;
  }

  UnlockRecordsCompanion toCompanion(bool nullToAbsent) {
    return UnlockRecordsCompanion(
      key: Value(key),
      unlockedAt: Value(unlockedAt),
    );
  }

  factory UnlockRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UnlockRecord(
      key: serializer.fromJson<String>(json['key']),
      unlockedAt: serializer.fromJson<DateTime>(json['unlockedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'unlockedAt': serializer.toJson<DateTime>(unlockedAt),
    };
  }

  UnlockRecord copyWith({String? key, DateTime? unlockedAt}) => UnlockRecord(
    key: key ?? this.key,
    unlockedAt: unlockedAt ?? this.unlockedAt,
  );
  UnlockRecord copyWithCompanion(UnlockRecordsCompanion data) {
    return UnlockRecord(
      key: data.key.present ? data.key.value : this.key,
      unlockedAt: data.unlockedAt.present
          ? data.unlockedAt.value
          : this.unlockedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UnlockRecord(')
          ..write('key: $key, ')
          ..write('unlockedAt: $unlockedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, unlockedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UnlockRecord &&
          other.key == this.key &&
          other.unlockedAt == this.unlockedAt);
}

class UnlockRecordsCompanion extends UpdateCompanion<UnlockRecord> {
  final Value<String> key;
  final Value<DateTime> unlockedAt;
  final Value<int> rowid;
  const UnlockRecordsCompanion({
    this.key = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UnlockRecordsCompanion.insert({
    required String key,
    required DateTime unlockedAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       unlockedAt = Value(unlockedAt);
  static Insertable<UnlockRecord> custom({
    Expression<String>? key,
    Expression<DateTime>? unlockedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (unlockedAt != null) 'unlocked_at': unlockedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UnlockRecordsCompanion copyWith({
    Value<String>? key,
    Value<DateTime>? unlockedAt,
    Value<int>? rowid,
  }) {
    return UnlockRecordsCompanion(
      key: key ?? this.key,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (unlockedAt.present) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnlockRecordsCompanion(')
          ..write('key: $key, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MilestoneRecordsTable extends MilestoneRecords
    with TableInfo<$MilestoneRecordsTable, MilestoneRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MilestoneRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _achievedAtMeta = const VerificationMeta(
    'achievedAt',
  );
  @override
  late final GeneratedColumn<DateTime> achievedAt = GeneratedColumn<DateTime>(
    'achieved_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, achievedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'milestone_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<MilestoneRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('achieved_at')) {
      context.handle(
        _achievedAtMeta,
        achievedAt.isAcceptableOrUnknown(data['achieved_at']!, _achievedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_achievedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  MilestoneRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MilestoneRecord(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      achievedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}achieved_at'],
      )!,
    );
  }

  @override
  $MilestoneRecordsTable createAlias(String alias) {
    return $MilestoneRecordsTable(attachedDatabase, alias);
  }
}

class MilestoneRecord extends DataClass implements Insertable<MilestoneRecord> {
  final String key;
  final DateTime achievedAt;
  const MilestoneRecord({required this.key, required this.achievedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['achieved_at'] = Variable<DateTime>(achievedAt);
    return map;
  }

  MilestoneRecordsCompanion toCompanion(bool nullToAbsent) {
    return MilestoneRecordsCompanion(
      key: Value(key),
      achievedAt: Value(achievedAt),
    );
  }

  factory MilestoneRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MilestoneRecord(
      key: serializer.fromJson<String>(json['key']),
      achievedAt: serializer.fromJson<DateTime>(json['achievedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'achievedAt': serializer.toJson<DateTime>(achievedAt),
    };
  }

  MilestoneRecord copyWith({String? key, DateTime? achievedAt}) =>
      MilestoneRecord(
        key: key ?? this.key,
        achievedAt: achievedAt ?? this.achievedAt,
      );
  MilestoneRecord copyWithCompanion(MilestoneRecordsCompanion data) {
    return MilestoneRecord(
      key: data.key.present ? data.key.value : this.key,
      achievedAt: data.achievedAt.present
          ? data.achievedAt.value
          : this.achievedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MilestoneRecord(')
          ..write('key: $key, ')
          ..write('achievedAt: $achievedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, achievedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MilestoneRecord &&
          other.key == this.key &&
          other.achievedAt == this.achievedAt);
}

class MilestoneRecordsCompanion extends UpdateCompanion<MilestoneRecord> {
  final Value<String> key;
  final Value<DateTime> achievedAt;
  final Value<int> rowid;
  const MilestoneRecordsCompanion({
    this.key = const Value.absent(),
    this.achievedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MilestoneRecordsCompanion.insert({
    required String key,
    required DateTime achievedAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       achievedAt = Value(achievedAt);
  static Insertable<MilestoneRecord> custom({
    Expression<String>? key,
    Expression<DateTime>? achievedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (achievedAt != null) 'achieved_at': achievedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MilestoneRecordsCompanion copyWith({
    Value<String>? key,
    Value<DateTime>? achievedAt,
    Value<int>? rowid,
  }) {
    return MilestoneRecordsCompanion(
      key: key ?? this.key,
      achievedAt: achievedAt ?? this.achievedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (achievedAt.present) {
      map['achieved_at'] = Variable<DateTime>(achievedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MilestoneRecordsCompanion(')
          ..write('key: $key, ')
          ..write('achievedAt: $achievedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DailyEntriesTable dailyEntries = $DailyEntriesTable(this);
  late final $CleanupSessionsTable cleanupSessions = $CleanupSessionsTable(
    this,
  );
  late final $AppPreferencesTable appPreferences = $AppPreferencesTable(this);
  late final $SyncOutboxTable syncOutbox = $SyncOutboxTable(this);
  late final $SessionPhotosTable sessionPhotos = $SessionPhotosTable(this);
  late final $UnlockRecordsTable unlockRecords = $UnlockRecordsTable(this);
  late final $MilestoneRecordsTable milestoneRecords = $MilestoneRecordsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    dailyEntries,
    cleanupSessions,
    appPreferences,
    syncOutbox,
    sessionPhotos,
    unlockRecords,
    milestoneRecords,
  ];
}

typedef $$DailyEntriesTableCreateCompanionBuilder =
    DailyEntriesCompanion Function({
      required String id,
      required String dateKey,
      Value<int> count,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$DailyEntriesTableUpdateCompanionBuilder =
    DailyEntriesCompanion Function({
      Value<String> id,
      Value<String> dateKey,
      Value<int> count,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$DailyEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $DailyEntriesTable> {
  $$DailyEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateKey => $composableBuilder(
    column: $table.dateKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyEntriesTable> {
  $$DailyEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateKey => $composableBuilder(
    column: $table.dateKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyEntriesTable> {
  $$DailyEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dateKey =>
      $composableBuilder(column: $table.dateKey, builder: (column) => column);

  GeneratedColumn<int> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$DailyEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyEntriesTable,
          DailyEntry,
          $$DailyEntriesTableFilterComposer,
          $$DailyEntriesTableOrderingComposer,
          $$DailyEntriesTableAnnotationComposer,
          $$DailyEntriesTableCreateCompanionBuilder,
          $$DailyEntriesTableUpdateCompanionBuilder,
          (
            DailyEntry,
            BaseReferences<_$AppDatabase, $DailyEntriesTable, DailyEntry>,
          ),
          DailyEntry,
          PrefetchHooks Function()
        > {
  $$DailyEntriesTableTableManager(_$AppDatabase db, $DailyEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> dateKey = const Value.absent(),
                Value<int> count = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyEntriesCompanion(
                id: id,
                dateKey: dateKey,
                count: count,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String dateKey,
                Value<int> count = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyEntriesCompanion.insert(
                id: id,
                dateKey: dateKey,
                count: count,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyEntriesTable,
      DailyEntry,
      $$DailyEntriesTableFilterComposer,
      $$DailyEntriesTableOrderingComposer,
      $$DailyEntriesTableAnnotationComposer,
      $$DailyEntriesTableCreateCompanionBuilder,
      $$DailyEntriesTableUpdateCompanionBuilder,
      (
        DailyEntry,
        BaseReferences<_$AppDatabase, $DailyEntriesTable, DailyEntry>,
      ),
      DailyEntry,
      PrefetchHooks Function()
    >;
typedef $$CleanupSessionsTableCreateCompanionBuilder =
    CleanupSessionsCompanion Function({
      required String id,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
      Value<int> count,
      Value<int?> durationSeconds,
      Value<double?> distanceMeters,
      Value<String> locationMode,
      Value<double?> approximateLatitude,
      Value<double?> approximateLongitude,
      Value<String?> routeJson,
      Value<String?> notes,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$CleanupSessionsTableUpdateCompanionBuilder =
    CleanupSessionsCompanion Function({
      Value<String> id,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      Value<int> count,
      Value<int?> durationSeconds,
      Value<double?> distanceMeters,
      Value<String> locationMode,
      Value<double?> approximateLatitude,
      Value<double?> approximateLongitude,
      Value<String?> routeJson,
      Value<String?> notes,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$CleanupSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $CleanupSessionsTable> {
  $$CleanupSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locationMode => $composableBuilder(
    column: $table.locationMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get approximateLatitude => $composableBuilder(
    column: $table.approximateLatitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get approximateLongitude => $composableBuilder(
    column: $table.approximateLongitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get routeJson => $composableBuilder(
    column: $table.routeJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CleanupSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CleanupSessionsTable> {
  $$CleanupSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locationMode => $composableBuilder(
    column: $table.locationMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get approximateLatitude => $composableBuilder(
    column: $table.approximateLatitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get approximateLongitude => $composableBuilder(
    column: $table.approximateLongitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get routeJson => $composableBuilder(
    column: $table.routeJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CleanupSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CleanupSessionsTable> {
  $$CleanupSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => column,
  );

  GeneratedColumn<String> get locationMode => $composableBuilder(
    column: $table.locationMode,
    builder: (column) => column,
  );

  GeneratedColumn<double> get approximateLatitude => $composableBuilder(
    column: $table.approximateLatitude,
    builder: (column) => column,
  );

  GeneratedColumn<double> get approximateLongitude => $composableBuilder(
    column: $table.approximateLongitude,
    builder: (column) => column,
  );

  GeneratedColumn<String> get routeJson =>
      $composableBuilder(column: $table.routeJson, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$CleanupSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CleanupSessionsTable,
          CleanupSession,
          $$CleanupSessionsTableFilterComposer,
          $$CleanupSessionsTableOrderingComposer,
          $$CleanupSessionsTableAnnotationComposer,
          $$CleanupSessionsTableCreateCompanionBuilder,
          $$CleanupSessionsTableUpdateCompanionBuilder,
          (
            CleanupSession,
            BaseReferences<
              _$AppDatabase,
              $CleanupSessionsTable,
              CleanupSession
            >,
          ),
          CleanupSession,
          PrefetchHooks Function()
        > {
  $$CleanupSessionsTableTableManager(
    _$AppDatabase db,
    $CleanupSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CleanupSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CleanupSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CleanupSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> count = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<double?> distanceMeters = const Value.absent(),
                Value<String> locationMode = const Value.absent(),
                Value<double?> approximateLatitude = const Value.absent(),
                Value<double?> approximateLongitude = const Value.absent(),
                Value<String?> routeJson = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CleanupSessionsCompanion(
                id: id,
                startedAt: startedAt,
                endedAt: endedAt,
                count: count,
                durationSeconds: durationSeconds,
                distanceMeters: distanceMeters,
                locationMode: locationMode,
                approximateLatitude: approximateLatitude,
                approximateLongitude: approximateLongitude,
                routeJson: routeJson,
                notes: notes,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> count = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<double?> distanceMeters = const Value.absent(),
                Value<String> locationMode = const Value.absent(),
                Value<double?> approximateLatitude = const Value.absent(),
                Value<double?> approximateLongitude = const Value.absent(),
                Value<String?> routeJson = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CleanupSessionsCompanion.insert(
                id: id,
                startedAt: startedAt,
                endedAt: endedAt,
                count: count,
                durationSeconds: durationSeconds,
                distanceMeters: distanceMeters,
                locationMode: locationMode,
                approximateLatitude: approximateLatitude,
                approximateLongitude: approximateLongitude,
                routeJson: routeJson,
                notes: notes,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CleanupSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CleanupSessionsTable,
      CleanupSession,
      $$CleanupSessionsTableFilterComposer,
      $$CleanupSessionsTableOrderingComposer,
      $$CleanupSessionsTableAnnotationComposer,
      $$CleanupSessionsTableCreateCompanionBuilder,
      $$CleanupSessionsTableUpdateCompanionBuilder,
      (
        CleanupSession,
        BaseReferences<_$AppDatabase, $CleanupSessionsTable, CleanupSession>,
      ),
      CleanupSession,
      PrefetchHooks Function()
    >;
typedef $$AppPreferencesTableCreateCompanionBuilder =
    AppPreferencesCompanion Function({
      Value<int> id,
      Value<String> themeMode,
      Value<bool> hapticsEnabled,
      Value<bool> soundEnabled,
      Value<bool> reducedMotion,
      Value<String> containerStyle,
      Value<bool> cloudPhotoBackup,
      Value<String> locationDefault,
      Value<int> userSeed,
      Value<int> pileLimit,
      Value<bool> environmentEffectsEnabled,
    });
typedef $$AppPreferencesTableUpdateCompanionBuilder =
    AppPreferencesCompanion Function({
      Value<int> id,
      Value<String> themeMode,
      Value<bool> hapticsEnabled,
      Value<bool> soundEnabled,
      Value<bool> reducedMotion,
      Value<String> containerStyle,
      Value<bool> cloudPhotoBackup,
      Value<String> locationDefault,
      Value<int> userSeed,
      Value<int> pileLimit,
      Value<bool> environmentEffectsEnabled,
    });

class $$AppPreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $AppPreferencesTable> {
  $$AppPreferencesTableFilterComposer({
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

  ColumnFilters<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hapticsEnabled => $composableBuilder(
    column: $table.hapticsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get soundEnabled => $composableBuilder(
    column: $table.soundEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reducedMotion => $composableBuilder(
    column: $table.reducedMotion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get containerStyle => $composableBuilder(
    column: $table.containerStyle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get cloudPhotoBackup => $composableBuilder(
    column: $table.cloudPhotoBackup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locationDefault => $composableBuilder(
    column: $table.locationDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userSeed => $composableBuilder(
    column: $table.userSeed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pileLimit => $composableBuilder(
    column: $table.pileLimit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get environmentEffectsEnabled => $composableBuilder(
    column: $table.environmentEffectsEnabled,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppPreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $AppPreferencesTable> {
  $$AppPreferencesTableOrderingComposer({
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

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hapticsEnabled => $composableBuilder(
    column: $table.hapticsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get soundEnabled => $composableBuilder(
    column: $table.soundEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reducedMotion => $composableBuilder(
    column: $table.reducedMotion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get containerStyle => $composableBuilder(
    column: $table.containerStyle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get cloudPhotoBackup => $composableBuilder(
    column: $table.cloudPhotoBackup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locationDefault => $composableBuilder(
    column: $table.locationDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userSeed => $composableBuilder(
    column: $table.userSeed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pileLimit => $composableBuilder(
    column: $table.pileLimit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get environmentEffectsEnabled => $composableBuilder(
    column: $table.environmentEffectsEnabled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppPreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppPreferencesTable> {
  $$AppPreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<bool> get hapticsEnabled => $composableBuilder(
    column: $table.hapticsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get soundEnabled => $composableBuilder(
    column: $table.soundEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get reducedMotion => $composableBuilder(
    column: $table.reducedMotion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get containerStyle => $composableBuilder(
    column: $table.containerStyle,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get cloudPhotoBackup => $composableBuilder(
    column: $table.cloudPhotoBackup,
    builder: (column) => column,
  );

  GeneratedColumn<String> get locationDefault => $composableBuilder(
    column: $table.locationDefault,
    builder: (column) => column,
  );

  GeneratedColumn<int> get userSeed =>
      $composableBuilder(column: $table.userSeed, builder: (column) => column);

  GeneratedColumn<int> get pileLimit =>
      $composableBuilder(column: $table.pileLimit, builder: (column) => column);

  GeneratedColumn<bool> get environmentEffectsEnabled => $composableBuilder(
    column: $table.environmentEffectsEnabled,
    builder: (column) => column,
  );
}

class $$AppPreferencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppPreferencesTable,
          AppPreference,
          $$AppPreferencesTableFilterComposer,
          $$AppPreferencesTableOrderingComposer,
          $$AppPreferencesTableAnnotationComposer,
          $$AppPreferencesTableCreateCompanionBuilder,
          $$AppPreferencesTableUpdateCompanionBuilder,
          (
            AppPreference,
            BaseReferences<_$AppDatabase, $AppPreferencesTable, AppPreference>,
          ),
          AppPreference,
          PrefetchHooks Function()
        > {
  $$AppPreferencesTableTableManager(
    _$AppDatabase db,
    $AppPreferencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppPreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppPreferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppPreferencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<bool> hapticsEnabled = const Value.absent(),
                Value<bool> soundEnabled = const Value.absent(),
                Value<bool> reducedMotion = const Value.absent(),
                Value<String> containerStyle = const Value.absent(),
                Value<bool> cloudPhotoBackup = const Value.absent(),
                Value<String> locationDefault = const Value.absent(),
                Value<int> userSeed = const Value.absent(),
                Value<int> pileLimit = const Value.absent(),
                Value<bool> environmentEffectsEnabled = const Value.absent(),
              }) => AppPreferencesCompanion(
                id: id,
                themeMode: themeMode,
                hapticsEnabled: hapticsEnabled,
                soundEnabled: soundEnabled,
                reducedMotion: reducedMotion,
                containerStyle: containerStyle,
                cloudPhotoBackup: cloudPhotoBackup,
                locationDefault: locationDefault,
                userSeed: userSeed,
                pileLimit: pileLimit,
                environmentEffectsEnabled: environmentEffectsEnabled,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<bool> hapticsEnabled = const Value.absent(),
                Value<bool> soundEnabled = const Value.absent(),
                Value<bool> reducedMotion = const Value.absent(),
                Value<String> containerStyle = const Value.absent(),
                Value<bool> cloudPhotoBackup = const Value.absent(),
                Value<String> locationDefault = const Value.absent(),
                Value<int> userSeed = const Value.absent(),
                Value<int> pileLimit = const Value.absent(),
                Value<bool> environmentEffectsEnabled = const Value.absent(),
              }) => AppPreferencesCompanion.insert(
                id: id,
                themeMode: themeMode,
                hapticsEnabled: hapticsEnabled,
                soundEnabled: soundEnabled,
                reducedMotion: reducedMotion,
                containerStyle: containerStyle,
                cloudPhotoBackup: cloudPhotoBackup,
                locationDefault: locationDefault,
                userSeed: userSeed,
                pileLimit: pileLimit,
                environmentEffectsEnabled: environmentEffectsEnabled,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppPreferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppPreferencesTable,
      AppPreference,
      $$AppPreferencesTableFilterComposer,
      $$AppPreferencesTableOrderingComposer,
      $$AppPreferencesTableAnnotationComposer,
      $$AppPreferencesTableCreateCompanionBuilder,
      $$AppPreferencesTableUpdateCompanionBuilder,
      (
        AppPreference,
        BaseReferences<_$AppDatabase, $AppPreferencesTable, AppPreference>,
      ),
      AppPreference,
      PrefetchHooks Function()
    >;
typedef $$SyncOutboxTableCreateCompanionBuilder =
    SyncOutboxCompanion Function({
      required String id,
      required String entityType,
      required String entityId,
      required String operation,
      required String payload,
      required DateTime createdAt,
      Value<int> attemptCount,
      Value<String?> lastError,
      Value<DateTime?> nextRetryAt,
      Value<String> status,
      Value<int> rowid,
    });
typedef $$SyncOutboxTableUpdateCompanionBuilder =
    SyncOutboxCompanion Function({
      Value<String> id,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> operation,
      Value<String> payload,
      Value<DateTime> createdAt,
      Value<int> attemptCount,
      Value<String?> lastError,
      Value<DateTime?> nextRetryAt,
      Value<String> status,
      Value<int> rowid,
    });

class $$SyncOutboxTableFilterComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncOutboxTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncOutboxTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$SyncOutboxTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncOutboxTable,
          SyncOutboxData,
          $$SyncOutboxTableFilterComposer,
          $$SyncOutboxTableOrderingComposer,
          $$SyncOutboxTableAnnotationComposer,
          $$SyncOutboxTableCreateCompanionBuilder,
          $$SyncOutboxTableUpdateCompanionBuilder,
          (
            SyncOutboxData,
            BaseReferences<_$AppDatabase, $SyncOutboxTable, SyncOutboxData>,
          ),
          SyncOutboxData,
          PrefetchHooks Function()
        > {
  $$SyncOutboxTableTableManager(_$AppDatabase db, $SyncOutboxTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncOutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncOutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncOutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime?> nextRetryAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncOutboxCompanion(
                id: id,
                entityType: entityType,
                entityId: entityId,
                operation: operation,
                payload: payload,
                createdAt: createdAt,
                attemptCount: attemptCount,
                lastError: lastError,
                nextRetryAt: nextRetryAt,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String entityType,
                required String entityId,
                required String operation,
                required String payload,
                required DateTime createdAt,
                Value<int> attemptCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime?> nextRetryAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncOutboxCompanion.insert(
                id: id,
                entityType: entityType,
                entityId: entityId,
                operation: operation,
                payload: payload,
                createdAt: createdAt,
                attemptCount: attemptCount,
                lastError: lastError,
                nextRetryAt: nextRetryAt,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncOutboxTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncOutboxTable,
      SyncOutboxData,
      $$SyncOutboxTableFilterComposer,
      $$SyncOutboxTableOrderingComposer,
      $$SyncOutboxTableAnnotationComposer,
      $$SyncOutboxTableCreateCompanionBuilder,
      $$SyncOutboxTableUpdateCompanionBuilder,
      (
        SyncOutboxData,
        BaseReferences<_$AppDatabase, $SyncOutboxTable, SyncOutboxData>,
      ),
      SyncOutboxData,
      PrefetchHooks Function()
    >;
typedef $$SessionPhotosTableCreateCompanionBuilder =
    SessionPhotosCompanion Function({
      required String id,
      required String sessionId,
      required String path,
      required String type,
      required int width,
      required int height,
      required int sizeBytes,
      Value<bool> uploaded,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$SessionPhotosTableUpdateCompanionBuilder =
    SessionPhotosCompanion Function({
      Value<String> id,
      Value<String> sessionId,
      Value<String> path,
      Value<String> type,
      Value<int> width,
      Value<int> height,
      Value<int> sizeBytes,
      Value<bool> uploaded,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$SessionPhotosTableFilterComposer
    extends Composer<_$AppDatabase, $SessionPhotosTable> {
  $$SessionPhotosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get uploaded => $composableBuilder(
    column: $table.uploaded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SessionPhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionPhotosTable> {
  $$SessionPhotosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get uploaded => $composableBuilder(
    column: $table.uploaded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionPhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionPhotosTable> {
  $$SessionPhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);

  GeneratedColumn<bool> get uploaded =>
      $composableBuilder(column: $table.uploaded, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SessionPhotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionPhotosTable,
          SessionPhoto,
          $$SessionPhotosTableFilterComposer,
          $$SessionPhotosTableOrderingComposer,
          $$SessionPhotosTableAnnotationComposer,
          $$SessionPhotosTableCreateCompanionBuilder,
          $$SessionPhotosTableUpdateCompanionBuilder,
          (
            SessionPhoto,
            BaseReferences<_$AppDatabase, $SessionPhotosTable, SessionPhoto>,
          ),
          SessionPhoto,
          PrefetchHooks Function()
        > {
  $$SessionPhotosTableTableManager(_$AppDatabase db, $SessionPhotosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionPhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionPhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionPhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> width = const Value.absent(),
                Value<int> height = const Value.absent(),
                Value<int> sizeBytes = const Value.absent(),
                Value<bool> uploaded = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionPhotosCompanion(
                id: id,
                sessionId: sessionId,
                path: path,
                type: type,
                width: width,
                height: height,
                sizeBytes: sizeBytes,
                uploaded: uploaded,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sessionId,
                required String path,
                required String type,
                required int width,
                required int height,
                required int sizeBytes,
                Value<bool> uploaded = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => SessionPhotosCompanion.insert(
                id: id,
                sessionId: sessionId,
                path: path,
                type: type,
                width: width,
                height: height,
                sizeBytes: sizeBytes,
                uploaded: uploaded,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SessionPhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionPhotosTable,
      SessionPhoto,
      $$SessionPhotosTableFilterComposer,
      $$SessionPhotosTableOrderingComposer,
      $$SessionPhotosTableAnnotationComposer,
      $$SessionPhotosTableCreateCompanionBuilder,
      $$SessionPhotosTableUpdateCompanionBuilder,
      (
        SessionPhoto,
        BaseReferences<_$AppDatabase, $SessionPhotosTable, SessionPhoto>,
      ),
      SessionPhoto,
      PrefetchHooks Function()
    >;
typedef $$UnlockRecordsTableCreateCompanionBuilder =
    UnlockRecordsCompanion Function({
      required String key,
      required DateTime unlockedAt,
      Value<int> rowid,
    });
typedef $$UnlockRecordsTableUpdateCompanionBuilder =
    UnlockRecordsCompanion Function({
      Value<String> key,
      Value<DateTime> unlockedAt,
      Value<int> rowid,
    });

class $$UnlockRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $UnlockRecordsTable> {
  $$UnlockRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UnlockRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $UnlockRecordsTable> {
  $$UnlockRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UnlockRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnlockRecordsTable> {
  $$UnlockRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => column,
  );
}

class $$UnlockRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UnlockRecordsTable,
          UnlockRecord,
          $$UnlockRecordsTableFilterComposer,
          $$UnlockRecordsTableOrderingComposer,
          $$UnlockRecordsTableAnnotationComposer,
          $$UnlockRecordsTableCreateCompanionBuilder,
          $$UnlockRecordsTableUpdateCompanionBuilder,
          (
            UnlockRecord,
            BaseReferences<_$AppDatabase, $UnlockRecordsTable, UnlockRecord>,
          ),
          UnlockRecord,
          PrefetchHooks Function()
        > {
  $$UnlockRecordsTableTableManager(_$AppDatabase db, $UnlockRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnlockRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnlockRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnlockRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<DateTime> unlockedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UnlockRecordsCompanion(
                key: key,
                unlockedAt: unlockedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required DateTime unlockedAt,
                Value<int> rowid = const Value.absent(),
              }) => UnlockRecordsCompanion.insert(
                key: key,
                unlockedAt: unlockedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UnlockRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UnlockRecordsTable,
      UnlockRecord,
      $$UnlockRecordsTableFilterComposer,
      $$UnlockRecordsTableOrderingComposer,
      $$UnlockRecordsTableAnnotationComposer,
      $$UnlockRecordsTableCreateCompanionBuilder,
      $$UnlockRecordsTableUpdateCompanionBuilder,
      (
        UnlockRecord,
        BaseReferences<_$AppDatabase, $UnlockRecordsTable, UnlockRecord>,
      ),
      UnlockRecord,
      PrefetchHooks Function()
    >;
typedef $$MilestoneRecordsTableCreateCompanionBuilder =
    MilestoneRecordsCompanion Function({
      required String key,
      required DateTime achievedAt,
      Value<int> rowid,
    });
typedef $$MilestoneRecordsTableUpdateCompanionBuilder =
    MilestoneRecordsCompanion Function({
      Value<String> key,
      Value<DateTime> achievedAt,
      Value<int> rowid,
    });

class $$MilestoneRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $MilestoneRecordsTable> {
  $$MilestoneRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MilestoneRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $MilestoneRecordsTable> {
  $$MilestoneRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MilestoneRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MilestoneRecordsTable> {
  $$MilestoneRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<DateTime> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => column,
  );
}

class $$MilestoneRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MilestoneRecordsTable,
          MilestoneRecord,
          $$MilestoneRecordsTableFilterComposer,
          $$MilestoneRecordsTableOrderingComposer,
          $$MilestoneRecordsTableAnnotationComposer,
          $$MilestoneRecordsTableCreateCompanionBuilder,
          $$MilestoneRecordsTableUpdateCompanionBuilder,
          (
            MilestoneRecord,
            BaseReferences<
              _$AppDatabase,
              $MilestoneRecordsTable,
              MilestoneRecord
            >,
          ),
          MilestoneRecord,
          PrefetchHooks Function()
        > {
  $$MilestoneRecordsTableTableManager(
    _$AppDatabase db,
    $MilestoneRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MilestoneRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MilestoneRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MilestoneRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<DateTime> achievedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MilestoneRecordsCompanion(
                key: key,
                achievedAt: achievedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required DateTime achievedAt,
                Value<int> rowid = const Value.absent(),
              }) => MilestoneRecordsCompanion.insert(
                key: key,
                achievedAt: achievedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MilestoneRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MilestoneRecordsTable,
      MilestoneRecord,
      $$MilestoneRecordsTableFilterComposer,
      $$MilestoneRecordsTableOrderingComposer,
      $$MilestoneRecordsTableAnnotationComposer,
      $$MilestoneRecordsTableCreateCompanionBuilder,
      $$MilestoneRecordsTableUpdateCompanionBuilder,
      (
        MilestoneRecord,
        BaseReferences<_$AppDatabase, $MilestoneRecordsTable, MilestoneRecord>,
      ),
      MilestoneRecord,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DailyEntriesTableTableManager get dailyEntries =>
      $$DailyEntriesTableTableManager(_db, _db.dailyEntries);
  $$CleanupSessionsTableTableManager get cleanupSessions =>
      $$CleanupSessionsTableTableManager(_db, _db.cleanupSessions);
  $$AppPreferencesTableTableManager get appPreferences =>
      $$AppPreferencesTableTableManager(_db, _db.appPreferences);
  $$SyncOutboxTableTableManager get syncOutbox =>
      $$SyncOutboxTableTableManager(_db, _db.syncOutbox);
  $$SessionPhotosTableTableManager get sessionPhotos =>
      $$SessionPhotosTableTableManager(_db, _db.sessionPhotos);
  $$UnlockRecordsTableTableManager get unlockRecords =>
      $$UnlockRecordsTableTableManager(_db, _db.unlockRecords);
  $$MilestoneRecordsTableTableManager get milestoneRecords =>
      $$MilestoneRecordsTableTableManager(_db, _db.milestoneRecords);
}
