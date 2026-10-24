// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $OutboxSyncQueueTable extends OutboxSyncQueue
    with TableInfo<$OutboxSyncQueueTable, OutboxSyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxSyncQueueTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PENDING'),
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    entityType,
    action,
    payloadJson,
    status,
    retryCount,
    nextRetryAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox_sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxSyncQueueData> instance, {
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
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
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
  OutboxSyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxSyncQueueData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      nextRetryAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_retry_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $OutboxSyncQueueTable createAlias(String alias) {
    return $OutboxSyncQueueTable(attachedDatabase, alias);
  }
}

class OutboxSyncQueueData extends DataClass
    implements Insertable<OutboxSyncQueueData> {
  final String id;
  final String entityType;
  final String action;
  final String payloadJson;
  final String status;
  final int retryCount;
  final DateTime? nextRetryAt;
  final DateTime createdAt;
  const OutboxSyncQueueData({
    required this.id,
    required this.entityType,
    required this.action,
    required this.payloadJson,
    required this.status,
    required this.retryCount,
    this.nextRetryAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['action'] = Variable<String>(action);
    map['payload_json'] = Variable<String>(payloadJson);
    map['status'] = Variable<String>(status);
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || nextRetryAt != null) {
      map['next_retry_at'] = Variable<DateTime>(nextRetryAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  OutboxSyncQueueCompanion toCompanion(bool nullToAbsent) {
    return OutboxSyncQueueCompanion(
      id: Value(id),
      entityType: Value(entityType),
      action: Value(action),
      payloadJson: Value(payloadJson),
      status: Value(status),
      retryCount: Value(retryCount),
      nextRetryAt: nextRetryAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextRetryAt),
      createdAt: Value(createdAt),
    );
  }

  factory OutboxSyncQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxSyncQueueData(
      id: serializer.fromJson<String>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      action: serializer.fromJson<String>(json['action']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      status: serializer.fromJson<String>(json['status']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      nextRetryAt: serializer.fromJson<DateTime?>(json['nextRetryAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityType': serializer.toJson<String>(entityType),
      'action': serializer.toJson<String>(action),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'status': serializer.toJson<String>(status),
      'retryCount': serializer.toJson<int>(retryCount),
      'nextRetryAt': serializer.toJson<DateTime?>(nextRetryAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  OutboxSyncQueueData copyWith({
    String? id,
    String? entityType,
    String? action,
    String? payloadJson,
    String? status,
    int? retryCount,
    Value<DateTime?> nextRetryAt = const Value.absent(),
    DateTime? createdAt,
  }) => OutboxSyncQueueData(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    action: action ?? this.action,
    payloadJson: payloadJson ?? this.payloadJson,
    status: status ?? this.status,
    retryCount: retryCount ?? this.retryCount,
    nextRetryAt: nextRetryAt.present ? nextRetryAt.value : this.nextRetryAt,
    createdAt: createdAt ?? this.createdAt,
  );
  OutboxSyncQueueData copyWithCompanion(OutboxSyncQueueCompanion data) {
    return OutboxSyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      action: data.action.present ? data.action.value : this.action,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      status: data.status.present ? data.status.value : this.status,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      nextRetryAt: data.nextRetryAt.present
          ? data.nextRetryAt.value
          : this.nextRetryAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxSyncQueueData(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('action: $action, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('nextRetryAt: $nextRetryAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entityType,
    action,
    payloadJson,
    status,
    retryCount,
    nextRetryAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxSyncQueueData &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.action == this.action &&
          other.payloadJson == this.payloadJson &&
          other.status == this.status &&
          other.retryCount == this.retryCount &&
          other.nextRetryAt == this.nextRetryAt &&
          other.createdAt == this.createdAt);
}

class OutboxSyncQueueCompanion extends UpdateCompanion<OutboxSyncQueueData> {
  final Value<String> id;
  final Value<String> entityType;
  final Value<String> action;
  final Value<String> payloadJson;
  final Value<String> status;
  final Value<int> retryCount;
  final Value<DateTime?> nextRetryAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const OutboxSyncQueueCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.action = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.nextRetryAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OutboxSyncQueueCompanion.insert({
    required String id,
    required String entityType,
    required String action,
    required String payloadJson,
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.nextRetryAt = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entityType = Value(entityType),
       action = Value(action),
       payloadJson = Value(payloadJson),
       createdAt = Value(createdAt);
  static Insertable<OutboxSyncQueueData> custom({
    Expression<String>? id,
    Expression<String>? entityType,
    Expression<String>? action,
    Expression<String>? payloadJson,
    Expression<String>? status,
    Expression<int>? retryCount,
    Expression<DateTime>? nextRetryAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (action != null) 'action': action,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (status != null) 'status': status,
      if (retryCount != null) 'retry_count': retryCount,
      if (nextRetryAt != null) 'next_retry_at': nextRetryAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OutboxSyncQueueCompanion copyWith({
    Value<String>? id,
    Value<String>? entityType,
    Value<String>? action,
    Value<String>? payloadJson,
    Value<String>? status,
    Value<int>? retryCount,
    Value<DateTime?>? nextRetryAt,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return OutboxSyncQueueCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      action: action ?? this.action,
      payloadJson: payloadJson ?? this.payloadJson,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      nextRetryAt: nextRetryAt ?? this.nextRetryAt,
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
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (nextRetryAt.present) {
      map['next_retry_at'] = Variable<DateTime>(nextRetryAt.value);
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
    return (StringBuffer('OutboxSyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('action: $action, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('nextRetryAt: $nextRetryAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CoursesTableTable extends CoursesTable
    with TableInfo<$CoursesTableTable, CoursesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CoursesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
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
  static const VerificationMeta _creditsMeta = const VerificationMeta(
    'credits',
  );
  @override
  late final GeneratedColumn<int> credits = GeneratedColumn<int>(
    'credits',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _departmentMeta = const VerificationMeta(
    'department',
  );
  @override
  late final GeneratedColumn<String> department = GeneratedColumn<String>(
    'department',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _instructorMeta = const VerificationMeta(
    'instructor',
  );
  @override
  late final GeneratedColumn<String> instructor = GeneratedColumn<String>(
    'instructor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roomMeta = const VerificationMeta('room');
  @override
  late final GeneratedColumn<String> room = GeneratedColumn<String>(
    'room',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syllabusMeta = const VerificationMeta(
    'syllabus',
  );
  @override
  late final GeneratedColumn<String> syllabus = GeneratedColumn<String>(
    'syllabus',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _examDateMeta = const VerificationMeta(
    'examDate',
  );
  @override
  late final GeneratedColumn<DateTime> examDate = GeneratedColumn<DateTime>(
    'exam_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _attendanceGoalMeta = const VerificationMeta(
    'attendanceGoal',
  );
  @override
  late final GeneratedColumn<double> attendanceGoal = GeneratedColumn<double>(
    'attendance_goal',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(85.0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    name,
    credits,
    department,
    instructor,
    color,
    room,
    syllabus,
    examDate,
    attendanceGoal,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'courses_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CoursesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('credits')) {
      context.handle(
        _creditsMeta,
        credits.isAcceptableOrUnknown(data['credits']!, _creditsMeta),
      );
    } else if (isInserting) {
      context.missing(_creditsMeta);
    }
    if (data.containsKey('department')) {
      context.handle(
        _departmentMeta,
        department.isAcceptableOrUnknown(data['department']!, _departmentMeta),
      );
    } else if (isInserting) {
      context.missing(_departmentMeta);
    }
    if (data.containsKey('instructor')) {
      context.handle(
        _instructorMeta,
        instructor.isAcceptableOrUnknown(data['instructor']!, _instructorMeta),
      );
    } else if (isInserting) {
      context.missing(_instructorMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('room')) {
      context.handle(
        _roomMeta,
        room.isAcceptableOrUnknown(data['room']!, _roomMeta),
      );
    } else if (isInserting) {
      context.missing(_roomMeta);
    }
    if (data.containsKey('syllabus')) {
      context.handle(
        _syllabusMeta,
        syllabus.isAcceptableOrUnknown(data['syllabus']!, _syllabusMeta),
      );
    } else if (isInserting) {
      context.missing(_syllabusMeta);
    }
    if (data.containsKey('exam_date')) {
      context.handle(
        _examDateMeta,
        examDate.isAcceptableOrUnknown(data['exam_date']!, _examDateMeta),
      );
    }
    if (data.containsKey('attendance_goal')) {
      context.handle(
        _attendanceGoalMeta,
        attendanceGoal.isAcceptableOrUnknown(
          data['attendance_goal']!,
          _attendanceGoalMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CoursesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CoursesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      credits: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}credits'],
      )!,
      department: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}department'],
      )!,
      instructor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instructor'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      room: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}room'],
      )!,
      syllabus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}syllabus'],
      )!,
      examDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}exam_date'],
      ),
      attendanceGoal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}attendance_goal'],
      )!,
    );
  }

  @override
  $CoursesTableTable createAlias(String alias) {
    return $CoursesTableTable(attachedDatabase, alias);
  }
}

class CoursesTableData extends DataClass
    implements Insertable<CoursesTableData> {
  final String id;
  final String code;
  final String name;
  final int credits;
  final String department;
  final String instructor;
  final String color;
  final String room;
  final String syllabus;
  final DateTime? examDate;
  final double attendanceGoal;
  const CoursesTableData({
    required this.id,
    required this.code,
    required this.name,
    required this.credits,
    required this.department,
    required this.instructor,
    required this.color,
    required this.room,
    required this.syllabus,
    this.examDate,
    required this.attendanceGoal,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    map['credits'] = Variable<int>(credits);
    map['department'] = Variable<String>(department);
    map['instructor'] = Variable<String>(instructor);
    map['color'] = Variable<String>(color);
    map['room'] = Variable<String>(room);
    map['syllabus'] = Variable<String>(syllabus);
    if (!nullToAbsent || examDate != null) {
      map['exam_date'] = Variable<DateTime>(examDate);
    }
    map['attendance_goal'] = Variable<double>(attendanceGoal);
    return map;
  }

  CoursesTableCompanion toCompanion(bool nullToAbsent) {
    return CoursesTableCompanion(
      id: Value(id),
      code: Value(code),
      name: Value(name),
      credits: Value(credits),
      department: Value(department),
      instructor: Value(instructor),
      color: Value(color),
      room: Value(room),
      syllabus: Value(syllabus),
      examDate: examDate == null && nullToAbsent
          ? const Value.absent()
          : Value(examDate),
      attendanceGoal: Value(attendanceGoal),
    );
  }

  factory CoursesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CoursesTableData(
      id: serializer.fromJson<String>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      credits: serializer.fromJson<int>(json['credits']),
      department: serializer.fromJson<String>(json['department']),
      instructor: serializer.fromJson<String>(json['instructor']),
      color: serializer.fromJson<String>(json['color']),
      room: serializer.fromJson<String>(json['room']),
      syllabus: serializer.fromJson<String>(json['syllabus']),
      examDate: serializer.fromJson<DateTime?>(json['examDate']),
      attendanceGoal: serializer.fromJson<double>(json['attendanceGoal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'credits': serializer.toJson<int>(credits),
      'department': serializer.toJson<String>(department),
      'instructor': serializer.toJson<String>(instructor),
      'color': serializer.toJson<String>(color),
      'room': serializer.toJson<String>(room),
      'syllabus': serializer.toJson<String>(syllabus),
      'examDate': serializer.toJson<DateTime?>(examDate),
      'attendanceGoal': serializer.toJson<double>(attendanceGoal),
    };
  }

  CoursesTableData copyWith({
    String? id,
    String? code,
    String? name,
    int? credits,
    String? department,
    String? instructor,
    String? color,
    String? room,
    String? syllabus,
    Value<DateTime?> examDate = const Value.absent(),
    double? attendanceGoal,
  }) => CoursesTableData(
    id: id ?? this.id,
    code: code ?? this.code,
    name: name ?? this.name,
    credits: credits ?? this.credits,
    department: department ?? this.department,
    instructor: instructor ?? this.instructor,
    color: color ?? this.color,
    room: room ?? this.room,
    syllabus: syllabus ?? this.syllabus,
    examDate: examDate.present ? examDate.value : this.examDate,
    attendanceGoal: attendanceGoal ?? this.attendanceGoal,
  );
  CoursesTableData copyWithCompanion(CoursesTableCompanion data) {
    return CoursesTableData(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      credits: data.credits.present ? data.credits.value : this.credits,
      department: data.department.present
          ? data.department.value
          : this.department,
      instructor: data.instructor.present
          ? data.instructor.value
          : this.instructor,
      color: data.color.present ? data.color.value : this.color,
      room: data.room.present ? data.room.value : this.room,
      syllabus: data.syllabus.present ? data.syllabus.value : this.syllabus,
      examDate: data.examDate.present ? data.examDate.value : this.examDate,
      attendanceGoal: data.attendanceGoal.present
          ? data.attendanceGoal.value
          : this.attendanceGoal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CoursesTableData(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('credits: $credits, ')
          ..write('department: $department, ')
          ..write('instructor: $instructor, ')
          ..write('color: $color, ')
          ..write('room: $room, ')
          ..write('syllabus: $syllabus, ')
          ..write('examDate: $examDate, ')
          ..write('attendanceGoal: $attendanceGoal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    code,
    name,
    credits,
    department,
    instructor,
    color,
    room,
    syllabus,
    examDate,
    attendanceGoal,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CoursesTableData &&
          other.id == this.id &&
          other.code == this.code &&
          other.name == this.name &&
          other.credits == this.credits &&
          other.department == this.department &&
          other.instructor == this.instructor &&
          other.color == this.color &&
          other.room == this.room &&
          other.syllabus == this.syllabus &&
          other.examDate == this.examDate &&
          other.attendanceGoal == this.attendanceGoal);
}

class CoursesTableCompanion extends UpdateCompanion<CoursesTableData> {
  final Value<String> id;
  final Value<String> code;
  final Value<String> name;
  final Value<int> credits;
  final Value<String> department;
  final Value<String> instructor;
  final Value<String> color;
  final Value<String> room;
  final Value<String> syllabus;
  final Value<DateTime?> examDate;
  final Value<double> attendanceGoal;
  final Value<int> rowid;
  const CoursesTableCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.credits = const Value.absent(),
    this.department = const Value.absent(),
    this.instructor = const Value.absent(),
    this.color = const Value.absent(),
    this.room = const Value.absent(),
    this.syllabus = const Value.absent(),
    this.examDate = const Value.absent(),
    this.attendanceGoal = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CoursesTableCompanion.insert({
    required String id,
    required String code,
    required String name,
    required int credits,
    required String department,
    required String instructor,
    required String color,
    required String room,
    required String syllabus,
    this.examDate = const Value.absent(),
    this.attendanceGoal = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       code = Value(code),
       name = Value(name),
       credits = Value(credits),
       department = Value(department),
       instructor = Value(instructor),
       color = Value(color),
       room = Value(room),
       syllabus = Value(syllabus);
  static Insertable<CoursesTableData> custom({
    Expression<String>? id,
    Expression<String>? code,
    Expression<String>? name,
    Expression<int>? credits,
    Expression<String>? department,
    Expression<String>? instructor,
    Expression<String>? color,
    Expression<String>? room,
    Expression<String>? syllabus,
    Expression<DateTime>? examDate,
    Expression<double>? attendanceGoal,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (credits != null) 'credits': credits,
      if (department != null) 'department': department,
      if (instructor != null) 'instructor': instructor,
      if (color != null) 'color': color,
      if (room != null) 'room': room,
      if (syllabus != null) 'syllabus': syllabus,
      if (examDate != null) 'exam_date': examDate,
      if (attendanceGoal != null) 'attendance_goal': attendanceGoal,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CoursesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? code,
    Value<String>? name,
    Value<int>? credits,
    Value<String>? department,
    Value<String>? instructor,
    Value<String>? color,
    Value<String>? room,
    Value<String>? syllabus,
    Value<DateTime?>? examDate,
    Value<double>? attendanceGoal,
    Value<int>? rowid,
  }) {
    return CoursesTableCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      credits: credits ?? this.credits,
      department: department ?? this.department,
      instructor: instructor ?? this.instructor,
      color: color ?? this.color,
      room: room ?? this.room,
      syllabus: syllabus ?? this.syllabus,
      examDate: examDate ?? this.examDate,
      attendanceGoal: attendanceGoal ?? this.attendanceGoal,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (credits.present) {
      map['credits'] = Variable<int>(credits.value);
    }
    if (department.present) {
      map['department'] = Variable<String>(department.value);
    }
    if (instructor.present) {
      map['instructor'] = Variable<String>(instructor.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (room.present) {
      map['room'] = Variable<String>(room.value);
    }
    if (syllabus.present) {
      map['syllabus'] = Variable<String>(syllabus.value);
    }
    if (examDate.present) {
      map['exam_date'] = Variable<DateTime>(examDate.value);
    }
    if (attendanceGoal.present) {
      map['attendance_goal'] = Variable<double>(attendanceGoal.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CoursesTableCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('credits: $credits, ')
          ..write('department: $department, ')
          ..write('instructor: $instructor, ')
          ..write('color: $color, ')
          ..write('room: $room, ')
          ..write('syllabus: $syllabus, ')
          ..write('examDate: $examDate, ')
          ..write('attendanceGoal: $attendanceGoal, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TimetableTableTable extends TimetableTable
    with TableInfo<$TimetableTableTable, TimetableTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TimetableTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _courseIdMeta = const VerificationMeta(
    'courseId',
  );
  @override
  late final GeneratedColumn<String> courseId = GeneratedColumn<String>(
    'course_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _courseCodeMeta = const VerificationMeta(
    'courseCode',
  );
  @override
  late final GeneratedColumn<String> courseCode = GeneratedColumn<String>(
    'course_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayOfWeekMeta = const VerificationMeta(
    'dayOfWeek',
  );
  @override
  late final GeneratedColumn<int> dayOfWeek = GeneratedColumn<int>(
    'day_of_week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<String> startTime = GeneratedColumn<String>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<String> endTime = GeneratedColumn<String>(
    'end_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roomMeta = const VerificationMeta('room');
  @override
  late final GeneratedColumn<String> room = GeneratedColumn<String>(
    'room',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    courseId,
    courseCode,
    title,
    dayOfWeek,
    startTime,
    endTime,
    room,
    color,
    type,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'timetable_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TimetableTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('course_id')) {
      context.handle(
        _courseIdMeta,
        courseId.isAcceptableOrUnknown(data['course_id']!, _courseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_courseIdMeta);
    }
    if (data.containsKey('course_code')) {
      context.handle(
        _courseCodeMeta,
        courseCode.isAcceptableOrUnknown(data['course_code']!, _courseCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_courseCodeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('day_of_week')) {
      context.handle(
        _dayOfWeekMeta,
        dayOfWeek.isAcceptableOrUnknown(data['day_of_week']!, _dayOfWeekMeta),
      );
    } else if (isInserting) {
      context.missing(_dayOfWeekMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('room')) {
      context.handle(
        _roomMeta,
        room.isAcceptableOrUnknown(data['room']!, _roomMeta),
      );
    } else if (isInserting) {
      context.missing(_roomMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TimetableTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TimetableTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      courseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}course_id'],
      )!,
      courseCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}course_code'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      dayOfWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_of_week'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_time'],
      )!,
      room: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}room'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
    );
  }

  @override
  $TimetableTableTable createAlias(String alias) {
    return $TimetableTableTable(attachedDatabase, alias);
  }
}

class TimetableTableData extends DataClass
    implements Insertable<TimetableTableData> {
  final String id;
  final String courseId;
  final String courseCode;
  final String title;
  final int dayOfWeek;
  final String startTime;
  final String endTime;
  final String room;
  final String color;
  final String type;
  const TimetableTableData({
    required this.id,
    required this.courseId,
    required this.courseCode,
    required this.title,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.color,
    required this.type,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['course_id'] = Variable<String>(courseId);
    map['course_code'] = Variable<String>(courseCode);
    map['title'] = Variable<String>(title);
    map['day_of_week'] = Variable<int>(dayOfWeek);
    map['start_time'] = Variable<String>(startTime);
    map['end_time'] = Variable<String>(endTime);
    map['room'] = Variable<String>(room);
    map['color'] = Variable<String>(color);
    map['type'] = Variable<String>(type);
    return map;
  }

  TimetableTableCompanion toCompanion(bool nullToAbsent) {
    return TimetableTableCompanion(
      id: Value(id),
      courseId: Value(courseId),
      courseCode: Value(courseCode),
      title: Value(title),
      dayOfWeek: Value(dayOfWeek),
      startTime: Value(startTime),
      endTime: Value(endTime),
      room: Value(room),
      color: Value(color),
      type: Value(type),
    );
  }

  factory TimetableTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TimetableTableData(
      id: serializer.fromJson<String>(json['id']),
      courseId: serializer.fromJson<String>(json['courseId']),
      courseCode: serializer.fromJson<String>(json['courseCode']),
      title: serializer.fromJson<String>(json['title']),
      dayOfWeek: serializer.fromJson<int>(json['dayOfWeek']),
      startTime: serializer.fromJson<String>(json['startTime']),
      endTime: serializer.fromJson<String>(json['endTime']),
      room: serializer.fromJson<String>(json['room']),
      color: serializer.fromJson<String>(json['color']),
      type: serializer.fromJson<String>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'courseId': serializer.toJson<String>(courseId),
      'courseCode': serializer.toJson<String>(courseCode),
      'title': serializer.toJson<String>(title),
      'dayOfWeek': serializer.toJson<int>(dayOfWeek),
      'startTime': serializer.toJson<String>(startTime),
      'endTime': serializer.toJson<String>(endTime),
      'room': serializer.toJson<String>(room),
      'color': serializer.toJson<String>(color),
      'type': serializer.toJson<String>(type),
    };
  }

  TimetableTableData copyWith({
    String? id,
    String? courseId,
    String? courseCode,
    String? title,
    int? dayOfWeek,
    String? startTime,
    String? endTime,
    String? room,
    String? color,
    String? type,
  }) => TimetableTableData(
    id: id ?? this.id,
    courseId: courseId ?? this.courseId,
    courseCode: courseCode ?? this.courseCode,
    title: title ?? this.title,
    dayOfWeek: dayOfWeek ?? this.dayOfWeek,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    room: room ?? this.room,
    color: color ?? this.color,
    type: type ?? this.type,
  );
  TimetableTableData copyWithCompanion(TimetableTableCompanion data) {
    return TimetableTableData(
      id: data.id.present ? data.id.value : this.id,
      courseId: data.courseId.present ? data.courseId.value : this.courseId,
      courseCode: data.courseCode.present
          ? data.courseCode.value
          : this.courseCode,
      title: data.title.present ? data.title.value : this.title,
      dayOfWeek: data.dayOfWeek.present ? data.dayOfWeek.value : this.dayOfWeek,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      room: data.room.present ? data.room.value : this.room,
      color: data.color.present ? data.color.value : this.color,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TimetableTableData(')
          ..write('id: $id, ')
          ..write('courseId: $courseId, ')
          ..write('courseCode: $courseCode, ')
          ..write('title: $title, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('room: $room, ')
          ..write('color: $color, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    courseId,
    courseCode,
    title,
    dayOfWeek,
    startTime,
    endTime,
    room,
    color,
    type,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimetableTableData &&
          other.id == this.id &&
          other.courseId == this.courseId &&
          other.courseCode == this.courseCode &&
          other.title == this.title &&
          other.dayOfWeek == this.dayOfWeek &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.room == this.room &&
          other.color == this.color &&
          other.type == this.type);
}

class TimetableTableCompanion extends UpdateCompanion<TimetableTableData> {
  final Value<String> id;
  final Value<String> courseId;
  final Value<String> courseCode;
  final Value<String> title;
  final Value<int> dayOfWeek;
  final Value<String> startTime;
  final Value<String> endTime;
  final Value<String> room;
  final Value<String> color;
  final Value<String> type;
  final Value<int> rowid;
  const TimetableTableCompanion({
    this.id = const Value.absent(),
    this.courseId = const Value.absent(),
    this.courseCode = const Value.absent(),
    this.title = const Value.absent(),
    this.dayOfWeek = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.room = const Value.absent(),
    this.color = const Value.absent(),
    this.type = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TimetableTableCompanion.insert({
    required String id,
    required String courseId,
    required String courseCode,
    required String title,
    required int dayOfWeek,
    required String startTime,
    required String endTime,
    required String room,
    required String color,
    required String type,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       courseId = Value(courseId),
       courseCode = Value(courseCode),
       title = Value(title),
       dayOfWeek = Value(dayOfWeek),
       startTime = Value(startTime),
       endTime = Value(endTime),
       room = Value(room),
       color = Value(color),
       type = Value(type);
  static Insertable<TimetableTableData> custom({
    Expression<String>? id,
    Expression<String>? courseId,
    Expression<String>? courseCode,
    Expression<String>? title,
    Expression<int>? dayOfWeek,
    Expression<String>? startTime,
    Expression<String>? endTime,
    Expression<String>? room,
    Expression<String>? color,
    Expression<String>? type,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (courseId != null) 'course_id': courseId,
      if (courseCode != null) 'course_code': courseCode,
      if (title != null) 'title': title,
      if (dayOfWeek != null) 'day_of_week': dayOfWeek,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (room != null) 'room': room,
      if (color != null) 'color': color,
      if (type != null) 'type': type,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TimetableTableCompanion copyWith({
    Value<String>? id,
    Value<String>? courseId,
    Value<String>? courseCode,
    Value<String>? title,
    Value<int>? dayOfWeek,
    Value<String>? startTime,
    Value<String>? endTime,
    Value<String>? room,
    Value<String>? color,
    Value<String>? type,
    Value<int>? rowid,
  }) {
    return TimetableTableCompanion(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      courseCode: courseCode ?? this.courseCode,
      title: title ?? this.title,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      room: room ?? this.room,
      color: color ?? this.color,
      type: type ?? this.type,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (courseId.present) {
      map['course_id'] = Variable<String>(courseId.value);
    }
    if (courseCode.present) {
      map['course_code'] = Variable<String>(courseCode.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (dayOfWeek.present) {
      map['day_of_week'] = Variable<int>(dayOfWeek.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<String>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<String>(endTime.value);
    }
    if (room.present) {
      map['room'] = Variable<String>(room.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimetableTableCompanion(')
          ..write('id: $id, ')
          ..write('courseId: $courseId, ')
          ..write('courseCode: $courseCode, ')
          ..write('title: $title, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('room: $room, ')
          ..write('color: $color, ')
          ..write('type: $type, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksTableTable extends TasksTable
    with TableInfo<$TasksTableTable, TasksTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _courseIdMeta = const VerificationMeta(
    'courseId',
  );
  @override
  late final GeneratedColumn<String> courseId = GeneratedColumn<String>(
    'course_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('NORMAL'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('TODO'),
  );
  static const VerificationMeta _estimatedMinutesMeta = const VerificationMeta(
    'estimatedMinutes',
  );
  @override
  late final GeneratedColumn<int> estimatedMinutes = GeneratedColumn<int>(
    'estimated_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(60),
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    courseId,
    title,
    description,
    dueDate,
    priority,
    status,
    estimatedMinutes,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TasksTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('course_id')) {
      context.handle(
        _courseIdMeta,
        courseId.isAcceptableOrUnknown(data['course_id']!, _courseIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('estimated_minutes')) {
      context.handle(
        _estimatedMinutesMeta,
        estimatedMinutes.isAcceptableOrUnknown(
          data['estimated_minutes']!,
          _estimatedMinutesMeta,
        ),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TasksTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TasksTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      courseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}course_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priority'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      estimatedMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_minutes'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $TasksTableTable createAlias(String alias) {
    return $TasksTableTable(attachedDatabase, alias);
  }
}

class TasksTableData extends DataClass implements Insertable<TasksTableData> {
  final String id;
  final String? courseId;
  final String title;
  final String description;
  final DateTime dueDate;
  final String priority;
  final String status;
  final int estimatedMinutes;
  final bool isSynced;
  const TasksTableData({
    required this.id,
    this.courseId,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.status,
    required this.estimatedMinutes,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || courseId != null) {
      map['course_id'] = Variable<String>(courseId);
    }
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['due_date'] = Variable<DateTime>(dueDate);
    map['priority'] = Variable<String>(priority);
    map['status'] = Variable<String>(status);
    map['estimated_minutes'] = Variable<int>(estimatedMinutes);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  TasksTableCompanion toCompanion(bool nullToAbsent) {
    return TasksTableCompanion(
      id: Value(id),
      courseId: courseId == null && nullToAbsent
          ? const Value.absent()
          : Value(courseId),
      title: Value(title),
      description: Value(description),
      dueDate: Value(dueDate),
      priority: Value(priority),
      status: Value(status),
      estimatedMinutes: Value(estimatedMinutes),
      isSynced: Value(isSynced),
    );
  }

  factory TasksTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TasksTableData(
      id: serializer.fromJson<String>(json['id']),
      courseId: serializer.fromJson<String?>(json['courseId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      priority: serializer.fromJson<String>(json['priority']),
      status: serializer.fromJson<String>(json['status']),
      estimatedMinutes: serializer.fromJson<int>(json['estimatedMinutes']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'courseId': serializer.toJson<String?>(courseId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'priority': serializer.toJson<String>(priority),
      'status': serializer.toJson<String>(status),
      'estimatedMinutes': serializer.toJson<int>(estimatedMinutes),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  TasksTableData copyWith({
    String? id,
    Value<String?> courseId = const Value.absent(),
    String? title,
    String? description,
    DateTime? dueDate,
    String? priority,
    String? status,
    int? estimatedMinutes,
    bool? isSynced,
  }) => TasksTableData(
    id: id ?? this.id,
    courseId: courseId.present ? courseId.value : this.courseId,
    title: title ?? this.title,
    description: description ?? this.description,
    dueDate: dueDate ?? this.dueDate,
    priority: priority ?? this.priority,
    status: status ?? this.status,
    estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
    isSynced: isSynced ?? this.isSynced,
  );
  TasksTableData copyWithCompanion(TasksTableCompanion data) {
    return TasksTableData(
      id: data.id.present ? data.id.value : this.id,
      courseId: data.courseId.present ? data.courseId.value : this.courseId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      priority: data.priority.present ? data.priority.value : this.priority,
      status: data.status.present ? data.status.value : this.status,
      estimatedMinutes: data.estimatedMinutes.present
          ? data.estimatedMinutes.value
          : this.estimatedMinutes,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TasksTableData(')
          ..write('id: $id, ')
          ..write('courseId: $courseId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('dueDate: $dueDate, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('estimatedMinutes: $estimatedMinutes, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    courseId,
    title,
    description,
    dueDate,
    priority,
    status,
    estimatedMinutes,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TasksTableData &&
          other.id == this.id &&
          other.courseId == this.courseId &&
          other.title == this.title &&
          other.description == this.description &&
          other.dueDate == this.dueDate &&
          other.priority == this.priority &&
          other.status == this.status &&
          other.estimatedMinutes == this.estimatedMinutes &&
          other.isSynced == this.isSynced);
}

class TasksTableCompanion extends UpdateCompanion<TasksTableData> {
  final Value<String> id;
  final Value<String?> courseId;
  final Value<String> title;
  final Value<String> description;
  final Value<DateTime> dueDate;
  final Value<String> priority;
  final Value<String> status;
  final Value<int> estimatedMinutes;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const TasksTableCompanion({
    this.id = const Value.absent(),
    this.courseId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.priority = const Value.absent(),
    this.status = const Value.absent(),
    this.estimatedMinutes = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksTableCompanion.insert({
    required String id,
    this.courseId = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    required DateTime dueDate,
    this.priority = const Value.absent(),
    this.status = const Value.absent(),
    this.estimatedMinutes = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       dueDate = Value(dueDate);
  static Insertable<TasksTableData> custom({
    Expression<String>? id,
    Expression<String>? courseId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<DateTime>? dueDate,
    Expression<String>? priority,
    Expression<String>? status,
    Expression<int>? estimatedMinutes,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (courseId != null) 'course_id': courseId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (dueDate != null) 'due_date': dueDate,
      if (priority != null) 'priority': priority,
      if (status != null) 'status': status,
      if (estimatedMinutes != null) 'estimated_minutes': estimatedMinutes,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksTableCompanion copyWith({
    Value<String>? id,
    Value<String?>? courseId,
    Value<String>? title,
    Value<String>? description,
    Value<DateTime>? dueDate,
    Value<String>? priority,
    Value<String>? status,
    Value<int>? estimatedMinutes,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return TasksTableCompanion(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (courseId.present) {
      map['course_id'] = Variable<String>(courseId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (estimatedMinutes.present) {
      map['estimated_minutes'] = Variable<int>(estimatedMinutes.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksTableCompanion(')
          ..write('id: $id, ')
          ..write('courseId: $courseId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('dueDate: $dueDate, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('estimatedMinutes: $estimatedMinutes, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AttendanceTableTable extends AttendanceTable
    with TableInfo<$AttendanceTableTable, AttendanceTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttendanceTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _courseIdMeta = const VerificationMeta(
    'courseId',
  );
  @override
  late final GeneratedColumn<String> courseId = GeneratedColumn<String>(
    'course_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, courseId, date, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attendance_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<AttendanceTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('course_id')) {
      context.handle(
        _courseIdMeta,
        courseId.isAcceptableOrUnknown(data['course_id']!, _courseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_courseIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AttendanceTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttendanceTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      courseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}course_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $AttendanceTableTable createAlias(String alias) {
    return $AttendanceTableTable(attachedDatabase, alias);
  }
}

class AttendanceTableData extends DataClass
    implements Insertable<AttendanceTableData> {
  final String id;
  final String courseId;
  final DateTime date;
  final String status;
  const AttendanceTableData({
    required this.id,
    required this.courseId,
    required this.date,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['course_id'] = Variable<String>(courseId);
    map['date'] = Variable<DateTime>(date);
    map['status'] = Variable<String>(status);
    return map;
  }

  AttendanceTableCompanion toCompanion(bool nullToAbsent) {
    return AttendanceTableCompanion(
      id: Value(id),
      courseId: Value(courseId),
      date: Value(date),
      status: Value(status),
    );
  }

  factory AttendanceTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttendanceTableData(
      id: serializer.fromJson<String>(json['id']),
      courseId: serializer.fromJson<String>(json['courseId']),
      date: serializer.fromJson<DateTime>(json['date']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'courseId': serializer.toJson<String>(courseId),
      'date': serializer.toJson<DateTime>(date),
      'status': serializer.toJson<String>(status),
    };
  }

  AttendanceTableData copyWith({
    String? id,
    String? courseId,
    DateTime? date,
    String? status,
  }) => AttendanceTableData(
    id: id ?? this.id,
    courseId: courseId ?? this.courseId,
    date: date ?? this.date,
    status: status ?? this.status,
  );
  AttendanceTableData copyWithCompanion(AttendanceTableCompanion data) {
    return AttendanceTableData(
      id: data.id.present ? data.id.value : this.id,
      courseId: data.courseId.present ? data.courseId.value : this.courseId,
      date: data.date.present ? data.date.value : this.date,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceTableData(')
          ..write('id: $id, ')
          ..write('courseId: $courseId, ')
          ..write('date: $date, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, courseId, date, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttendanceTableData &&
          other.id == this.id &&
          other.courseId == this.courseId &&
          other.date == this.date &&
          other.status == this.status);
}

class AttendanceTableCompanion extends UpdateCompanion<AttendanceTableData> {
  final Value<String> id;
  final Value<String> courseId;
  final Value<DateTime> date;
  final Value<String> status;
  final Value<int> rowid;
  const AttendanceTableCompanion({
    this.id = const Value.absent(),
    this.courseId = const Value.absent(),
    this.date = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AttendanceTableCompanion.insert({
    required String id,
    required String courseId,
    required DateTime date,
    required String status,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       courseId = Value(courseId),
       date = Value(date),
       status = Value(status);
  static Insertable<AttendanceTableData> custom({
    Expression<String>? id,
    Expression<String>? courseId,
    Expression<DateTime>? date,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (courseId != null) 'course_id': courseId,
      if (date != null) 'date': date,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AttendanceTableCompanion copyWith({
    Value<String>? id,
    Value<String>? courseId,
    Value<DateTime>? date,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return AttendanceTableCompanion(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      date: date ?? this.date,
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
    if (courseId.present) {
      map['course_id'] = Variable<String>(courseId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
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
    return (StringBuffer('AttendanceTableCompanion(')
          ..write('id: $id, ')
          ..write('courseId: $courseId, ')
          ..write('date: $date, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GradesTableTable extends GradesTable
    with TableInfo<$GradesTableTable, GradesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GradesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _courseIdMeta = const VerificationMeta(
    'courseId',
  );
  @override
  late final GeneratedColumn<String> courseId = GeneratedColumn<String>(
    'course_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _courseCodeMeta = const VerificationMeta(
    'courseCode',
  );
  @override
  late final GeneratedColumn<String> courseCode = GeneratedColumn<String>(
    'course_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _semesterMeta = const VerificationMeta(
    'semester',
  );
  @override
  late final GeneratedColumn<int> semester = GeneratedColumn<int>(
    'semester',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _creditsMeta = const VerificationMeta(
    'credits',
  );
  @override
  late final GeneratedColumn<int> credits = GeneratedColumn<int>(
    'credits',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gradePointsMeta = const VerificationMeta(
    'gradePoints',
  );
  @override
  late final GeneratedColumn<double> gradePoints = GeneratedColumn<double>(
    'grade_points',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _letterGradeMeta = const VerificationMeta(
    'letterGrade',
  );
  @override
  late final GeneratedColumn<String> letterGrade = GeneratedColumn<String>(
    'letter_grade',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    courseId,
    courseCode,
    semester,
    credits,
    gradePoints,
    letterGrade,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grades_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<GradesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('course_id')) {
      context.handle(
        _courseIdMeta,
        courseId.isAcceptableOrUnknown(data['course_id']!, _courseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_courseIdMeta);
    }
    if (data.containsKey('course_code')) {
      context.handle(
        _courseCodeMeta,
        courseCode.isAcceptableOrUnknown(data['course_code']!, _courseCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_courseCodeMeta);
    }
    if (data.containsKey('semester')) {
      context.handle(
        _semesterMeta,
        semester.isAcceptableOrUnknown(data['semester']!, _semesterMeta),
      );
    }
    if (data.containsKey('credits')) {
      context.handle(
        _creditsMeta,
        credits.isAcceptableOrUnknown(data['credits']!, _creditsMeta),
      );
    } else if (isInserting) {
      context.missing(_creditsMeta);
    }
    if (data.containsKey('grade_points')) {
      context.handle(
        _gradePointsMeta,
        gradePoints.isAcceptableOrUnknown(
          data['grade_points']!,
          _gradePointsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_gradePointsMeta);
    }
    if (data.containsKey('letter_grade')) {
      context.handle(
        _letterGradeMeta,
        letterGrade.isAcceptableOrUnknown(
          data['letter_grade']!,
          _letterGradeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_letterGradeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GradesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GradesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      courseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}course_id'],
      )!,
      courseCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}course_code'],
      )!,
      semester: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}semester'],
      )!,
      credits: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}credits'],
      )!,
      gradePoints: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}grade_points'],
      )!,
      letterGrade: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}letter_grade'],
      )!,
    );
  }

  @override
  $GradesTableTable createAlias(String alias) {
    return $GradesTableTable(attachedDatabase, alias);
  }
}

class GradesTableData extends DataClass implements Insertable<GradesTableData> {
  final String id;
  final String courseId;
  final String courseCode;
  final int semester;
  final int credits;
  final double gradePoints;
  final String letterGrade;
  const GradesTableData({
    required this.id,
    required this.courseId,
    required this.courseCode,
    required this.semester,
    required this.credits,
    required this.gradePoints,
    required this.letterGrade,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['course_id'] = Variable<String>(courseId);
    map['course_code'] = Variable<String>(courseCode);
    map['semester'] = Variable<int>(semester);
    map['credits'] = Variable<int>(credits);
    map['grade_points'] = Variable<double>(gradePoints);
    map['letter_grade'] = Variable<String>(letterGrade);
    return map;
  }

  GradesTableCompanion toCompanion(bool nullToAbsent) {
    return GradesTableCompanion(
      id: Value(id),
      courseId: Value(courseId),
      courseCode: Value(courseCode),
      semester: Value(semester),
      credits: Value(credits),
      gradePoints: Value(gradePoints),
      letterGrade: Value(letterGrade),
    );
  }

  factory GradesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GradesTableData(
      id: serializer.fromJson<String>(json['id']),
      courseId: serializer.fromJson<String>(json['courseId']),
      courseCode: serializer.fromJson<String>(json['courseCode']),
      semester: serializer.fromJson<int>(json['semester']),
      credits: serializer.fromJson<int>(json['credits']),
      gradePoints: serializer.fromJson<double>(json['gradePoints']),
      letterGrade: serializer.fromJson<String>(json['letterGrade']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'courseId': serializer.toJson<String>(courseId),
      'courseCode': serializer.toJson<String>(courseCode),
      'semester': serializer.toJson<int>(semester),
      'credits': serializer.toJson<int>(credits),
      'gradePoints': serializer.toJson<double>(gradePoints),
      'letterGrade': serializer.toJson<String>(letterGrade),
    };
  }

  GradesTableData copyWith({
    String? id,
    String? courseId,
    String? courseCode,
    int? semester,
    int? credits,
    double? gradePoints,
    String? letterGrade,
  }) => GradesTableData(
    id: id ?? this.id,
    courseId: courseId ?? this.courseId,
    courseCode: courseCode ?? this.courseCode,
    semester: semester ?? this.semester,
    credits: credits ?? this.credits,
    gradePoints: gradePoints ?? this.gradePoints,
    letterGrade: letterGrade ?? this.letterGrade,
  );
  GradesTableData copyWithCompanion(GradesTableCompanion data) {
    return GradesTableData(
      id: data.id.present ? data.id.value : this.id,
      courseId: data.courseId.present ? data.courseId.value : this.courseId,
      courseCode: data.courseCode.present
          ? data.courseCode.value
          : this.courseCode,
      semester: data.semester.present ? data.semester.value : this.semester,
      credits: data.credits.present ? data.credits.value : this.credits,
      gradePoints: data.gradePoints.present
          ? data.gradePoints.value
          : this.gradePoints,
      letterGrade: data.letterGrade.present
          ? data.letterGrade.value
          : this.letterGrade,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GradesTableData(')
          ..write('id: $id, ')
          ..write('courseId: $courseId, ')
          ..write('courseCode: $courseCode, ')
          ..write('semester: $semester, ')
          ..write('credits: $credits, ')
          ..write('gradePoints: $gradePoints, ')
          ..write('letterGrade: $letterGrade')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    courseId,
    courseCode,
    semester,
    credits,
    gradePoints,
    letterGrade,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GradesTableData &&
          other.id == this.id &&
          other.courseId == this.courseId &&
          other.courseCode == this.courseCode &&
          other.semester == this.semester &&
          other.credits == this.credits &&
          other.gradePoints == this.gradePoints &&
          other.letterGrade == this.letterGrade);
}

class GradesTableCompanion extends UpdateCompanion<GradesTableData> {
  final Value<String> id;
  final Value<String> courseId;
  final Value<String> courseCode;
  final Value<int> semester;
  final Value<int> credits;
  final Value<double> gradePoints;
  final Value<String> letterGrade;
  final Value<int> rowid;
  const GradesTableCompanion({
    this.id = const Value.absent(),
    this.courseId = const Value.absent(),
    this.courseCode = const Value.absent(),
    this.semester = const Value.absent(),
    this.credits = const Value.absent(),
    this.gradePoints = const Value.absent(),
    this.letterGrade = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GradesTableCompanion.insert({
    required String id,
    required String courseId,
    required String courseCode,
    this.semester = const Value.absent(),
    required int credits,
    required double gradePoints,
    required String letterGrade,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       courseId = Value(courseId),
       courseCode = Value(courseCode),
       credits = Value(credits),
       gradePoints = Value(gradePoints),
       letterGrade = Value(letterGrade);
  static Insertable<GradesTableData> custom({
    Expression<String>? id,
    Expression<String>? courseId,
    Expression<String>? courseCode,
    Expression<int>? semester,
    Expression<int>? credits,
    Expression<double>? gradePoints,
    Expression<String>? letterGrade,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (courseId != null) 'course_id': courseId,
      if (courseCode != null) 'course_code': courseCode,
      if (semester != null) 'semester': semester,
      if (credits != null) 'credits': credits,
      if (gradePoints != null) 'grade_points': gradePoints,
      if (letterGrade != null) 'letter_grade': letterGrade,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GradesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? courseId,
    Value<String>? courseCode,
    Value<int>? semester,
    Value<int>? credits,
    Value<double>? gradePoints,
    Value<String>? letterGrade,
    Value<int>? rowid,
  }) {
    return GradesTableCompanion(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      courseCode: courseCode ?? this.courseCode,
      semester: semester ?? this.semester,
      credits: credits ?? this.credits,
      gradePoints: gradePoints ?? this.gradePoints,
      letterGrade: letterGrade ?? this.letterGrade,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (courseId.present) {
      map['course_id'] = Variable<String>(courseId.value);
    }
    if (courseCode.present) {
      map['course_code'] = Variable<String>(courseCode.value);
    }
    if (semester.present) {
      map['semester'] = Variable<int>(semester.value);
    }
    if (credits.present) {
      map['credits'] = Variable<int>(credits.value);
    }
    if (gradePoints.present) {
      map['grade_points'] = Variable<double>(gradePoints.value);
    }
    if (letterGrade.present) {
      map['letter_grade'] = Variable<String>(letterGrade.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GradesTableCompanion(')
          ..write('id: $id, ')
          ..write('courseId: $courseId, ')
          ..write('courseCode: $courseCode, ')
          ..write('semester: $semester, ')
          ..write('credits: $credits, ')
          ..write('gradePoints: $gradePoints, ')
          ..write('letterGrade: $letterGrade, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotesTableTable extends NotesTable
    with TableInfo<$NotesTableTable, NotesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _folderMeta = const VerificationMeta('folder');
  @override
  late final GeneratedColumn<String> folder = GeneratedColumn<String>(
    'folder',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('General'),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    folder,
    title,
    content,
    tags,
    updatedAt,
    isFavorite,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('folder')) {
      context.handle(
        _folderMeta,
        folder.isAcceptableOrUnknown(data['folder']!, _folderMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
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
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      folder: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}folder'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $NotesTableTable createAlias(String alias) {
    return $NotesTableTable(attachedDatabase, alias);
  }
}

class NotesTableData extends DataClass implements Insertable<NotesTableData> {
  final String id;
  final String folder;
  final String title;
  final String content;
  final String tags;
  final DateTime updatedAt;
  final bool isFavorite;
  final bool isSynced;
  const NotesTableData({
    required this.id,
    required this.folder,
    required this.title,
    required this.content,
    required this.tags,
    required this.updatedAt,
    required this.isFavorite,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['folder'] = Variable<String>(folder);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    map['tags'] = Variable<String>(tags);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  NotesTableCompanion toCompanion(bool nullToAbsent) {
    return NotesTableCompanion(
      id: Value(id),
      folder: Value(folder),
      title: Value(title),
      content: Value(content),
      tags: Value(tags),
      updatedAt: Value(updatedAt),
      isFavorite: Value(isFavorite),
      isSynced: Value(isSynced),
    );
  }

  factory NotesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotesTableData(
      id: serializer.fromJson<String>(json['id']),
      folder: serializer.fromJson<String>(json['folder']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      tags: serializer.fromJson<String>(json['tags']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'folder': serializer.toJson<String>(folder),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'tags': serializer.toJson<String>(tags),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  NotesTableData copyWith({
    String? id,
    String? folder,
    String? title,
    String? content,
    String? tags,
    DateTime? updatedAt,
    bool? isFavorite,
    bool? isSynced,
  }) => NotesTableData(
    id: id ?? this.id,
    folder: folder ?? this.folder,
    title: title ?? this.title,
    content: content ?? this.content,
    tags: tags ?? this.tags,
    updatedAt: updatedAt ?? this.updatedAt,
    isFavorite: isFavorite ?? this.isFavorite,
    isSynced: isSynced ?? this.isSynced,
  );
  NotesTableData copyWithCompanion(NotesTableCompanion data) {
    return NotesTableData(
      id: data.id.present ? data.id.value : this.id,
      folder: data.folder.present ? data.folder.value : this.folder,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      tags: data.tags.present ? data.tags.value : this.tags,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotesTableData(')
          ..write('id: $id, ')
          ..write('folder: $folder, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('tags: $tags, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    folder,
    title,
    content,
    tags,
    updatedAt,
    isFavorite,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotesTableData &&
          other.id == this.id &&
          other.folder == this.folder &&
          other.title == this.title &&
          other.content == this.content &&
          other.tags == this.tags &&
          other.updatedAt == this.updatedAt &&
          other.isFavorite == this.isFavorite &&
          other.isSynced == this.isSynced);
}

class NotesTableCompanion extends UpdateCompanion<NotesTableData> {
  final Value<String> id;
  final Value<String> folder;
  final Value<String> title;
  final Value<String> content;
  final Value<String> tags;
  final Value<DateTime> updatedAt;
  final Value<bool> isFavorite;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const NotesTableCompanion({
    this.id = const Value.absent(),
    this.folder = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.tags = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotesTableCompanion.insert({
    required String id,
    this.folder = const Value.absent(),
    required String title,
    required String content,
    this.tags = const Value.absent(),
    required DateTime updatedAt,
    this.isFavorite = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       content = Value(content),
       updatedAt = Value(updatedAt);
  static Insertable<NotesTableData> custom({
    Expression<String>? id,
    Expression<String>? folder,
    Expression<String>? title,
    Expression<String>? content,
    Expression<String>? tags,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isFavorite,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (folder != null) 'folder': folder,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (tags != null) 'tags': tags,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? folder,
    Value<String>? title,
    Value<String>? content,
    Value<String>? tags,
    Value<DateTime>? updatedAt,
    Value<bool>? isFavorite,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return NotesTableCompanion(
      id: id ?? this.id,
      folder: folder ?? this.folder,
      title: title ?? this.title,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (folder.present) {
      map['folder'] = Variable<String>(folder.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesTableCompanion(')
          ..write('id: $id, ')
          ..write('folder: $folder, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('tags: $tags, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FlashcardsTableTable extends FlashcardsTable
    with TableInfo<$FlashcardsTableTable, FlashcardsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FlashcardsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deckIdMeta = const VerificationMeta('deckId');
  @override
  late final GeneratedColumn<String> deckId = GeneratedColumn<String>(
    'deck_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionMeta = const VerificationMeta(
    'question',
  );
  @override
  late final GeneratedColumn<String> question = GeneratedColumn<String>(
    'question',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _answerMeta = const VerificationMeta('answer');
  @override
  late final GeneratedColumn<String> answer = GeneratedColumn<String>(
    'answer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _boxMeta = const VerificationMeta('box');
  @override
  late final GeneratedColumn<int> box = GeneratedColumn<int>(
    'box',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _easeFactorMeta = const VerificationMeta(
    'easeFactor',
  );
  @override
  late final GeneratedColumn<double> easeFactor = GeneratedColumn<double>(
    'ease_factor',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(2.5),
  );
  static const VerificationMeta _repetitionsMeta = const VerificationMeta(
    'repetitions',
  );
  @override
  late final GeneratedColumn<int> repetitions = GeneratedColumn<int>(
    'repetitions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nextReviewDateMeta = const VerificationMeta(
    'nextReviewDate',
  );
  @override
  late final GeneratedColumn<DateTime> nextReviewDate =
      GeneratedColumn<DateTime>(
        'next_review_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    deckId,
    question,
    answer,
    box,
    easeFactor,
    repetitions,
    nextReviewDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'flashcards_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<FlashcardsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('deck_id')) {
      context.handle(
        _deckIdMeta,
        deckId.isAcceptableOrUnknown(data['deck_id']!, _deckIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deckIdMeta);
    }
    if (data.containsKey('question')) {
      context.handle(
        _questionMeta,
        question.isAcceptableOrUnknown(data['question']!, _questionMeta),
      );
    } else if (isInserting) {
      context.missing(_questionMeta);
    }
    if (data.containsKey('answer')) {
      context.handle(
        _answerMeta,
        answer.isAcceptableOrUnknown(data['answer']!, _answerMeta),
      );
    } else if (isInserting) {
      context.missing(_answerMeta);
    }
    if (data.containsKey('box')) {
      context.handle(
        _boxMeta,
        box.isAcceptableOrUnknown(data['box']!, _boxMeta),
      );
    }
    if (data.containsKey('ease_factor')) {
      context.handle(
        _easeFactorMeta,
        easeFactor.isAcceptableOrUnknown(data['ease_factor']!, _easeFactorMeta),
      );
    }
    if (data.containsKey('repetitions')) {
      context.handle(
        _repetitionsMeta,
        repetitions.isAcceptableOrUnknown(
          data['repetitions']!,
          _repetitionsMeta,
        ),
      );
    }
    if (data.containsKey('next_review_date')) {
      context.handle(
        _nextReviewDateMeta,
        nextReviewDate.isAcceptableOrUnknown(
          data['next_review_date']!,
          _nextReviewDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextReviewDateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FlashcardsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FlashcardsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      deckId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deck_id'],
      )!,
      question: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question'],
      )!,
      answer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}answer'],
      )!,
      box: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}box'],
      )!,
      easeFactor: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ease_factor'],
      )!,
      repetitions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repetitions'],
      )!,
      nextReviewDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_review_date'],
      )!,
    );
  }

  @override
  $FlashcardsTableTable createAlias(String alias) {
    return $FlashcardsTableTable(attachedDatabase, alias);
  }
}

class FlashcardsTableData extends DataClass
    implements Insertable<FlashcardsTableData> {
  final String id;
  final String deckId;
  final String question;
  final String answer;
  final int box;
  final double easeFactor;
  final int repetitions;
  final DateTime nextReviewDate;
  const FlashcardsTableData({
    required this.id,
    required this.deckId,
    required this.question,
    required this.answer,
    required this.box,
    required this.easeFactor,
    required this.repetitions,
    required this.nextReviewDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['deck_id'] = Variable<String>(deckId);
    map['question'] = Variable<String>(question);
    map['answer'] = Variable<String>(answer);
    map['box'] = Variable<int>(box);
    map['ease_factor'] = Variable<double>(easeFactor);
    map['repetitions'] = Variable<int>(repetitions);
    map['next_review_date'] = Variable<DateTime>(nextReviewDate);
    return map;
  }

  FlashcardsTableCompanion toCompanion(bool nullToAbsent) {
    return FlashcardsTableCompanion(
      id: Value(id),
      deckId: Value(deckId),
      question: Value(question),
      answer: Value(answer),
      box: Value(box),
      easeFactor: Value(easeFactor),
      repetitions: Value(repetitions),
      nextReviewDate: Value(nextReviewDate),
    );
  }

  factory FlashcardsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FlashcardsTableData(
      id: serializer.fromJson<String>(json['id']),
      deckId: serializer.fromJson<String>(json['deckId']),
      question: serializer.fromJson<String>(json['question']),
      answer: serializer.fromJson<String>(json['answer']),
      box: serializer.fromJson<int>(json['box']),
      easeFactor: serializer.fromJson<double>(json['easeFactor']),
      repetitions: serializer.fromJson<int>(json['repetitions']),
      nextReviewDate: serializer.fromJson<DateTime>(json['nextReviewDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'deckId': serializer.toJson<String>(deckId),
      'question': serializer.toJson<String>(question),
      'answer': serializer.toJson<String>(answer),
      'box': serializer.toJson<int>(box),
      'easeFactor': serializer.toJson<double>(easeFactor),
      'repetitions': serializer.toJson<int>(repetitions),
      'nextReviewDate': serializer.toJson<DateTime>(nextReviewDate),
    };
  }

  FlashcardsTableData copyWith({
    String? id,
    String? deckId,
    String? question,
    String? answer,
    int? box,
    double? easeFactor,
    int? repetitions,
    DateTime? nextReviewDate,
  }) => FlashcardsTableData(
    id: id ?? this.id,
    deckId: deckId ?? this.deckId,
    question: question ?? this.question,
    answer: answer ?? this.answer,
    box: box ?? this.box,
    easeFactor: easeFactor ?? this.easeFactor,
    repetitions: repetitions ?? this.repetitions,
    nextReviewDate: nextReviewDate ?? this.nextReviewDate,
  );
  FlashcardsTableData copyWithCompanion(FlashcardsTableCompanion data) {
    return FlashcardsTableData(
      id: data.id.present ? data.id.value : this.id,
      deckId: data.deckId.present ? data.deckId.value : this.deckId,
      question: data.question.present ? data.question.value : this.question,
      answer: data.answer.present ? data.answer.value : this.answer,
      box: data.box.present ? data.box.value : this.box,
      easeFactor: data.easeFactor.present
          ? data.easeFactor.value
          : this.easeFactor,
      repetitions: data.repetitions.present
          ? data.repetitions.value
          : this.repetitions,
      nextReviewDate: data.nextReviewDate.present
          ? data.nextReviewDate.value
          : this.nextReviewDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FlashcardsTableData(')
          ..write('id: $id, ')
          ..write('deckId: $deckId, ')
          ..write('question: $question, ')
          ..write('answer: $answer, ')
          ..write('box: $box, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('repetitions: $repetitions, ')
          ..write('nextReviewDate: $nextReviewDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    deckId,
    question,
    answer,
    box,
    easeFactor,
    repetitions,
    nextReviewDate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FlashcardsTableData &&
          other.id == this.id &&
          other.deckId == this.deckId &&
          other.question == this.question &&
          other.answer == this.answer &&
          other.box == this.box &&
          other.easeFactor == this.easeFactor &&
          other.repetitions == this.repetitions &&
          other.nextReviewDate == this.nextReviewDate);
}

class FlashcardsTableCompanion extends UpdateCompanion<FlashcardsTableData> {
  final Value<String> id;
  final Value<String> deckId;
  final Value<String> question;
  final Value<String> answer;
  final Value<int> box;
  final Value<double> easeFactor;
  final Value<int> repetitions;
  final Value<DateTime> nextReviewDate;
  final Value<int> rowid;
  const FlashcardsTableCompanion({
    this.id = const Value.absent(),
    this.deckId = const Value.absent(),
    this.question = const Value.absent(),
    this.answer = const Value.absent(),
    this.box = const Value.absent(),
    this.easeFactor = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.nextReviewDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FlashcardsTableCompanion.insert({
    required String id,
    required String deckId,
    required String question,
    required String answer,
    this.box = const Value.absent(),
    this.easeFactor = const Value.absent(),
    this.repetitions = const Value.absent(),
    required DateTime nextReviewDate,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       deckId = Value(deckId),
       question = Value(question),
       answer = Value(answer),
       nextReviewDate = Value(nextReviewDate);
  static Insertable<FlashcardsTableData> custom({
    Expression<String>? id,
    Expression<String>? deckId,
    Expression<String>? question,
    Expression<String>? answer,
    Expression<int>? box,
    Expression<double>? easeFactor,
    Expression<int>? repetitions,
    Expression<DateTime>? nextReviewDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deckId != null) 'deck_id': deckId,
      if (question != null) 'question': question,
      if (answer != null) 'answer': answer,
      if (box != null) 'box': box,
      if (easeFactor != null) 'ease_factor': easeFactor,
      if (repetitions != null) 'repetitions': repetitions,
      if (nextReviewDate != null) 'next_review_date': nextReviewDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FlashcardsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? deckId,
    Value<String>? question,
    Value<String>? answer,
    Value<int>? box,
    Value<double>? easeFactor,
    Value<int>? repetitions,
    Value<DateTime>? nextReviewDate,
    Value<int>? rowid,
  }) {
    return FlashcardsTableCompanion(
      id: id ?? this.id,
      deckId: deckId ?? this.deckId,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      box: box ?? this.box,
      easeFactor: easeFactor ?? this.easeFactor,
      repetitions: repetitions ?? this.repetitions,
      nextReviewDate: nextReviewDate ?? this.nextReviewDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (deckId.present) {
      map['deck_id'] = Variable<String>(deckId.value);
    }
    if (question.present) {
      map['question'] = Variable<String>(question.value);
    }
    if (answer.present) {
      map['answer'] = Variable<String>(answer.value);
    }
    if (box.present) {
      map['box'] = Variable<int>(box.value);
    }
    if (easeFactor.present) {
      map['ease_factor'] = Variable<double>(easeFactor.value);
    }
    if (repetitions.present) {
      map['repetitions'] = Variable<int>(repetitions.value);
    }
    if (nextReviewDate.present) {
      map['next_review_date'] = Variable<DateTime>(nextReviewDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FlashcardsTableCompanion(')
          ..write('id: $id, ')
          ..write('deckId: $deckId, ')
          ..write('question: $question, ')
          ..write('answer: $answer, ')
          ..write('box: $box, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('repetitions: $repetitions, ')
          ..write('nextReviewDate: $nextReviewDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HabitsTableTable extends HabitsTable
    with TableInfo<$HabitsTableTable, HabitsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetDaysPerWeekMeta = const VerificationMeta(
    'targetDaysPerWeek',
  );
  @override
  late final GeneratedColumn<int> targetDaysPerWeek = GeneratedColumn<int>(
    'target_days_per_week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(7),
  );
  static const VerificationMeta _currentStreakMeta = const VerificationMeta(
    'currentStreak',
  );
  @override
  late final GeneratedColumn<int> currentStreak = GeneratedColumn<int>(
    'current_streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastCompletedDateMeta = const VerificationMeta(
    'lastCompletedDate',
  );
  @override
  late final GeneratedColumn<DateTime> lastCompletedDate =
      GeneratedColumn<DateTime>(
        'last_completed_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    icon,
    color,
    targetDaysPerWeek,
    currentStreak,
    lastCompletedDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habits_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<HabitsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('target_days_per_week')) {
      context.handle(
        _targetDaysPerWeekMeta,
        targetDaysPerWeek.isAcceptableOrUnknown(
          data['target_days_per_week']!,
          _targetDaysPerWeekMeta,
        ),
      );
    }
    if (data.containsKey('current_streak')) {
      context.handle(
        _currentStreakMeta,
        currentStreak.isAcceptableOrUnknown(
          data['current_streak']!,
          _currentStreakMeta,
        ),
      );
    }
    if (data.containsKey('last_completed_date')) {
      context.handle(
        _lastCompletedDateMeta,
        lastCompletedDate.isAcceptableOrUnknown(
          data['last_completed_date']!,
          _lastCompletedDateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HabitsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      targetDaysPerWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_days_per_week'],
      )!,
      currentStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_streak'],
      )!,
      lastCompletedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_completed_date'],
      ),
    );
  }

  @override
  $HabitsTableTable createAlias(String alias) {
    return $HabitsTableTable(attachedDatabase, alias);
  }
}

class HabitsTableData extends DataClass implements Insertable<HabitsTableData> {
  final String id;
  final String title;
  final String icon;
  final String color;
  final int targetDaysPerWeek;
  final int currentStreak;
  final DateTime? lastCompletedDate;
  const HabitsTableData({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    required this.targetDaysPerWeek,
    required this.currentStreak,
    this.lastCompletedDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['icon'] = Variable<String>(icon);
    map['color'] = Variable<String>(color);
    map['target_days_per_week'] = Variable<int>(targetDaysPerWeek);
    map['current_streak'] = Variable<int>(currentStreak);
    if (!nullToAbsent || lastCompletedDate != null) {
      map['last_completed_date'] = Variable<DateTime>(lastCompletedDate);
    }
    return map;
  }

  HabitsTableCompanion toCompanion(bool nullToAbsent) {
    return HabitsTableCompanion(
      id: Value(id),
      title: Value(title),
      icon: Value(icon),
      color: Value(color),
      targetDaysPerWeek: Value(targetDaysPerWeek),
      currentStreak: Value(currentStreak),
      lastCompletedDate: lastCompletedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCompletedDate),
    );
  }

  factory HabitsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitsTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      icon: serializer.fromJson<String>(json['icon']),
      color: serializer.fromJson<String>(json['color']),
      targetDaysPerWeek: serializer.fromJson<int>(json['targetDaysPerWeek']),
      currentStreak: serializer.fromJson<int>(json['currentStreak']),
      lastCompletedDate: serializer.fromJson<DateTime?>(
        json['lastCompletedDate'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'icon': serializer.toJson<String>(icon),
      'color': serializer.toJson<String>(color),
      'targetDaysPerWeek': serializer.toJson<int>(targetDaysPerWeek),
      'currentStreak': serializer.toJson<int>(currentStreak),
      'lastCompletedDate': serializer.toJson<DateTime?>(lastCompletedDate),
    };
  }

  HabitsTableData copyWith({
    String? id,
    String? title,
    String? icon,
    String? color,
    int? targetDaysPerWeek,
    int? currentStreak,
    Value<DateTime?> lastCompletedDate = const Value.absent(),
  }) => HabitsTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    icon: icon ?? this.icon,
    color: color ?? this.color,
    targetDaysPerWeek: targetDaysPerWeek ?? this.targetDaysPerWeek,
    currentStreak: currentStreak ?? this.currentStreak,
    lastCompletedDate: lastCompletedDate.present
        ? lastCompletedDate.value
        : this.lastCompletedDate,
  );
  HabitsTableData copyWithCompanion(HabitsTableCompanion data) {
    return HabitsTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      targetDaysPerWeek: data.targetDaysPerWeek.present
          ? data.targetDaysPerWeek.value
          : this.targetDaysPerWeek,
      currentStreak: data.currentStreak.present
          ? data.currentStreak.value
          : this.currentStreak,
      lastCompletedDate: data.lastCompletedDate.present
          ? data.lastCompletedDate.value
          : this.lastCompletedDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitsTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('targetDaysPerWeek: $targetDaysPerWeek, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('lastCompletedDate: $lastCompletedDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    icon,
    color,
    targetDaysPerWeek,
    currentStreak,
    lastCompletedDate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitsTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.targetDaysPerWeek == this.targetDaysPerWeek &&
          other.currentStreak == this.currentStreak &&
          other.lastCompletedDate == this.lastCompletedDate);
}

class HabitsTableCompanion extends UpdateCompanion<HabitsTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> icon;
  final Value<String> color;
  final Value<int> targetDaysPerWeek;
  final Value<int> currentStreak;
  final Value<DateTime?> lastCompletedDate;
  final Value<int> rowid;
  const HabitsTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.targetDaysPerWeek = const Value.absent(),
    this.currentStreak = const Value.absent(),
    this.lastCompletedDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitsTableCompanion.insert({
    required String id,
    required String title,
    required String icon,
    required String color,
    this.targetDaysPerWeek = const Value.absent(),
    this.currentStreak = const Value.absent(),
    this.lastCompletedDate = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       icon = Value(icon),
       color = Value(color);
  static Insertable<HabitsTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? icon,
    Expression<String>? color,
    Expression<int>? targetDaysPerWeek,
    Expression<int>? currentStreak,
    Expression<DateTime>? lastCompletedDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (targetDaysPerWeek != null) 'target_days_per_week': targetDaysPerWeek,
      if (currentStreak != null) 'current_streak': currentStreak,
      if (lastCompletedDate != null) 'last_completed_date': lastCompletedDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? icon,
    Value<String>? color,
    Value<int>? targetDaysPerWeek,
    Value<int>? currentStreak,
    Value<DateTime?>? lastCompletedDate,
    Value<int>? rowid,
  }) {
    return HabitsTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      targetDaysPerWeek: targetDaysPerWeek ?? this.targetDaysPerWeek,
      currentStreak: currentStreak ?? this.currentStreak,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (targetDaysPerWeek.present) {
      map['target_days_per_week'] = Variable<int>(targetDaysPerWeek.value);
    }
    if (currentStreak.present) {
      map['current_streak'] = Variable<int>(currentStreak.value);
    }
    if (lastCompletedDate.present) {
      map['last_completed_date'] = Variable<DateTime>(lastCompletedDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitsTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('targetDaysPerWeek: $targetDaysPerWeek, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('lastCompletedDate: $lastCompletedDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetTableTable extends BudgetTable
    with TableInfo<$BudgetTableTable, BudgetTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isMealPlanSwipeMeta = const VerificationMeta(
    'isMealPlanSwipe',
  );
  @override
  late final GeneratedColumn<bool> isMealPlanSwipe = GeneratedColumn<bool>(
    'is_meal_plan_swipe',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_meal_plan_swipe" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    amount,
    category,
    date,
    isMealPlanSwipe,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budget_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('is_meal_plan_swipe')) {
      context.handle(
        _isMealPlanSwipeMeta,
        isMealPlanSwipe.isAcceptableOrUnknown(
          data['is_meal_plan_swipe']!,
          _isMealPlanSwipeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      isMealPlanSwipe: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_meal_plan_swipe'],
      )!,
    );
  }

  @override
  $BudgetTableTable createAlias(String alias) {
    return $BudgetTableTable(attachedDatabase, alias);
  }
}

class BudgetTableData extends DataClass implements Insertable<BudgetTableData> {
  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final bool isMealPlanSwipe;
  const BudgetTableData({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.isMealPlanSwipe,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['amount'] = Variable<double>(amount);
    map['category'] = Variable<String>(category);
    map['date'] = Variable<DateTime>(date);
    map['is_meal_plan_swipe'] = Variable<bool>(isMealPlanSwipe);
    return map;
  }

  BudgetTableCompanion toCompanion(bool nullToAbsent) {
    return BudgetTableCompanion(
      id: Value(id),
      title: Value(title),
      amount: Value(amount),
      category: Value(category),
      date: Value(date),
      isMealPlanSwipe: Value(isMealPlanSwipe),
    );
  }

  factory BudgetTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      amount: serializer.fromJson<double>(json['amount']),
      category: serializer.fromJson<String>(json['category']),
      date: serializer.fromJson<DateTime>(json['date']),
      isMealPlanSwipe: serializer.fromJson<bool>(json['isMealPlanSwipe']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'amount': serializer.toJson<double>(amount),
      'category': serializer.toJson<String>(category),
      'date': serializer.toJson<DateTime>(date),
      'isMealPlanSwipe': serializer.toJson<bool>(isMealPlanSwipe),
    };
  }

  BudgetTableData copyWith({
    String? id,
    String? title,
    double? amount,
    String? category,
    DateTime? date,
    bool? isMealPlanSwipe,
  }) => BudgetTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    amount: amount ?? this.amount,
    category: category ?? this.category,
    date: date ?? this.date,
    isMealPlanSwipe: isMealPlanSwipe ?? this.isMealPlanSwipe,
  );
  BudgetTableData copyWithCompanion(BudgetTableCompanion data) {
    return BudgetTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      amount: data.amount.present ? data.amount.value : this.amount,
      category: data.category.present ? data.category.value : this.category,
      date: data.date.present ? data.date.value : this.date,
      isMealPlanSwipe: data.isMealPlanSwipe.present
          ? data.isMealPlanSwipe.value
          : this.isMealPlanSwipe,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('date: $date, ')
          ..write('isMealPlanSwipe: $isMealPlanSwipe')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, amount, category, date, isMealPlanSwipe);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.amount == this.amount &&
          other.category == this.category &&
          other.date == this.date &&
          other.isMealPlanSwipe == this.isMealPlanSwipe);
}

class BudgetTableCompanion extends UpdateCompanion<BudgetTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<double> amount;
  final Value<String> category;
  final Value<DateTime> date;
  final Value<bool> isMealPlanSwipe;
  final Value<int> rowid;
  const BudgetTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.amount = const Value.absent(),
    this.category = const Value.absent(),
    this.date = const Value.absent(),
    this.isMealPlanSwipe = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetTableCompanion.insert({
    required String id,
    required String title,
    required double amount,
    required String category,
    required DateTime date,
    this.isMealPlanSwipe = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       amount = Value(amount),
       category = Value(category),
       date = Value(date);
  static Insertable<BudgetTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<double>? amount,
    Expression<String>? category,
    Expression<DateTime>? date,
    Expression<bool>? isMealPlanSwipe,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (amount != null) 'amount': amount,
      if (category != null) 'category': category,
      if (date != null) 'date': date,
      if (isMealPlanSwipe != null) 'is_meal_plan_swipe': isMealPlanSwipe,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetTableCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<double>? amount,
    Value<String>? category,
    Value<DateTime>? date,
    Value<bool>? isMealPlanSwipe,
    Value<int>? rowid,
  }) {
    return BudgetTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      isMealPlanSwipe: isMealPlanSwipe ?? this.isMealPlanSwipe,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (isMealPlanSwipe.present) {
      map['is_meal_plan_swipe'] = Variable<bool>(isMealPlanSwipe.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('date: $date, ')
          ..write('isMealPlanSwipe: $isMealPlanSwipe, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MoodTableTable extends MoodTable
    with TableInfo<$MoodTableTable, MoodTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoodTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emotionMeta = const VerificationMeta(
    'emotion',
  );
  @override
  late final GeneratedColumn<String> emotion = GeneratedColumn<String>(
    'emotion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, score, emotion, notes, timestamp];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mood_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<MoodTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('emotion')) {
      context.handle(
        _emotionMeta,
        emotion.isAcceptableOrUnknown(data['emotion']!, _emotionMeta),
      );
    } else if (isInserting) {
      context.missing(_emotionMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MoodTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MoodTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      )!,
      emotion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emotion'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $MoodTableTable createAlias(String alias) {
    return $MoodTableTable(attachedDatabase, alias);
  }
}

class MoodTableData extends DataClass implements Insertable<MoodTableData> {
  final String id;
  final int score;
  final String emotion;
  final String notes;
  final DateTime timestamp;
  const MoodTableData({
    required this.id,
    required this.score,
    required this.emotion,
    required this.notes,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['score'] = Variable<int>(score);
    map['emotion'] = Variable<String>(emotion);
    map['notes'] = Variable<String>(notes);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  MoodTableCompanion toCompanion(bool nullToAbsent) {
    return MoodTableCompanion(
      id: Value(id),
      score: Value(score),
      emotion: Value(emotion),
      notes: Value(notes),
      timestamp: Value(timestamp),
    );
  }

  factory MoodTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MoodTableData(
      id: serializer.fromJson<String>(json['id']),
      score: serializer.fromJson<int>(json['score']),
      emotion: serializer.fromJson<String>(json['emotion']),
      notes: serializer.fromJson<String>(json['notes']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'score': serializer.toJson<int>(score),
      'emotion': serializer.toJson<String>(emotion),
      'notes': serializer.toJson<String>(notes),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  MoodTableData copyWith({
    String? id,
    int? score,
    String? emotion,
    String? notes,
    DateTime? timestamp,
  }) => MoodTableData(
    id: id ?? this.id,
    score: score ?? this.score,
    emotion: emotion ?? this.emotion,
    notes: notes ?? this.notes,
    timestamp: timestamp ?? this.timestamp,
  );
  MoodTableData copyWithCompanion(MoodTableCompanion data) {
    return MoodTableData(
      id: data.id.present ? data.id.value : this.id,
      score: data.score.present ? data.score.value : this.score,
      emotion: data.emotion.present ? data.emotion.value : this.emotion,
      notes: data.notes.present ? data.notes.value : this.notes,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MoodTableData(')
          ..write('id: $id, ')
          ..write('score: $score, ')
          ..write('emotion: $emotion, ')
          ..write('notes: $notes, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, score, emotion, notes, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MoodTableData &&
          other.id == this.id &&
          other.score == this.score &&
          other.emotion == this.emotion &&
          other.notes == this.notes &&
          other.timestamp == this.timestamp);
}

class MoodTableCompanion extends UpdateCompanion<MoodTableData> {
  final Value<String> id;
  final Value<int> score;
  final Value<String> emotion;
  final Value<String> notes;
  final Value<DateTime> timestamp;
  final Value<int> rowid;
  const MoodTableCompanion({
    this.id = const Value.absent(),
    this.score = const Value.absent(),
    this.emotion = const Value.absent(),
    this.notes = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MoodTableCompanion.insert({
    required String id,
    required int score,
    required String emotion,
    this.notes = const Value.absent(),
    required DateTime timestamp,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       score = Value(score),
       emotion = Value(emotion),
       timestamp = Value(timestamp);
  static Insertable<MoodTableData> custom({
    Expression<String>? id,
    Expression<int>? score,
    Expression<String>? emotion,
    Expression<String>? notes,
    Expression<DateTime>? timestamp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (score != null) 'score': score,
      if (emotion != null) 'emotion': emotion,
      if (notes != null) 'notes': notes,
      if (timestamp != null) 'timestamp': timestamp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MoodTableCompanion copyWith({
    Value<String>? id,
    Value<int>? score,
    Value<String>? emotion,
    Value<String>? notes,
    Value<DateTime>? timestamp,
    Value<int>? rowid,
  }) {
    return MoodTableCompanion(
      id: id ?? this.id,
      score: score ?? this.score,
      emotion: emotion ?? this.emotion,
      notes: notes ?? this.notes,
      timestamp: timestamp ?? this.timestamp,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (emotion.present) {
      map['emotion'] = Variable<String>(emotion.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoodTableCompanion(')
          ..write('id: $id, ')
          ..write('score: $score, ')
          ..write('emotion: $emotion, ')
          ..write('notes: $notes, ')
          ..write('timestamp: $timestamp, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EncryptedVaultTableTable extends EncryptedVaultTable
    with TableInfo<$EncryptedVaultTableTable, EncryptedVaultTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EncryptedVaultTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _encryptedPayloadMeta = const VerificationMeta(
    'encryptedPayload',
  );
  @override
  late final GeneratedColumn<String> encryptedPayload = GeneratedColumn<String>(
    'encrypted_payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ivMeta = const VerificationMeta('iv');
  @override
  late final GeneratedColumn<String> iv = GeneratedColumn<String>(
    'iv',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    category,
    encryptedPayload,
    iv,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'encrypted_vault_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<EncryptedVaultTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('encrypted_payload')) {
      context.handle(
        _encryptedPayloadMeta,
        encryptedPayload.isAcceptableOrUnknown(
          data['encrypted_payload']!,
          _encryptedPayloadMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_encryptedPayloadMeta);
    }
    if (data.containsKey('iv')) {
      context.handle(_ivMeta, iv.isAcceptableOrUnknown(data['iv']!, _ivMeta));
    } else if (isInserting) {
      context.missing(_ivMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EncryptedVaultTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EncryptedVaultTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      encryptedPayload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}encrypted_payload'],
      )!,
      iv: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}iv'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $EncryptedVaultTableTable createAlias(String alias) {
    return $EncryptedVaultTableTable(attachedDatabase, alias);
  }
}

class EncryptedVaultTableData extends DataClass
    implements Insertable<EncryptedVaultTableData> {
  final String id;
  final String category;
  final String encryptedPayload;
  final String iv;
  final DateTime updatedAt;
  const EncryptedVaultTableData({
    required this.id,
    required this.category,
    required this.encryptedPayload,
    required this.iv,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['category'] = Variable<String>(category);
    map['encrypted_payload'] = Variable<String>(encryptedPayload);
    map['iv'] = Variable<String>(iv);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  EncryptedVaultTableCompanion toCompanion(bool nullToAbsent) {
    return EncryptedVaultTableCompanion(
      id: Value(id),
      category: Value(category),
      encryptedPayload: Value(encryptedPayload),
      iv: Value(iv),
      updatedAt: Value(updatedAt),
    );
  }

  factory EncryptedVaultTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EncryptedVaultTableData(
      id: serializer.fromJson<String>(json['id']),
      category: serializer.fromJson<String>(json['category']),
      encryptedPayload: serializer.fromJson<String>(json['encryptedPayload']),
      iv: serializer.fromJson<String>(json['iv']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'category': serializer.toJson<String>(category),
      'encryptedPayload': serializer.toJson<String>(encryptedPayload),
      'iv': serializer.toJson<String>(iv),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  EncryptedVaultTableData copyWith({
    String? id,
    String? category,
    String? encryptedPayload,
    String? iv,
    DateTime? updatedAt,
  }) => EncryptedVaultTableData(
    id: id ?? this.id,
    category: category ?? this.category,
    encryptedPayload: encryptedPayload ?? this.encryptedPayload,
    iv: iv ?? this.iv,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  EncryptedVaultTableData copyWithCompanion(EncryptedVaultTableCompanion data) {
    return EncryptedVaultTableData(
      id: data.id.present ? data.id.value : this.id,
      category: data.category.present ? data.category.value : this.category,
      encryptedPayload: data.encryptedPayload.present
          ? data.encryptedPayload.value
          : this.encryptedPayload,
      iv: data.iv.present ? data.iv.value : this.iv,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EncryptedVaultTableData(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('encryptedPayload: $encryptedPayload, ')
          ..write('iv: $iv, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, category, encryptedPayload, iv, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EncryptedVaultTableData &&
          other.id == this.id &&
          other.category == this.category &&
          other.encryptedPayload == this.encryptedPayload &&
          other.iv == this.iv &&
          other.updatedAt == this.updatedAt);
}

class EncryptedVaultTableCompanion
    extends UpdateCompanion<EncryptedVaultTableData> {
  final Value<String> id;
  final Value<String> category;
  final Value<String> encryptedPayload;
  final Value<String> iv;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const EncryptedVaultTableCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.encryptedPayload = const Value.absent(),
    this.iv = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EncryptedVaultTableCompanion.insert({
    required String id,
    required String category,
    required String encryptedPayload,
    required String iv,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       category = Value(category),
       encryptedPayload = Value(encryptedPayload),
       iv = Value(iv),
       updatedAt = Value(updatedAt);
  static Insertable<EncryptedVaultTableData> custom({
    Expression<String>? id,
    Expression<String>? category,
    Expression<String>? encryptedPayload,
    Expression<String>? iv,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (encryptedPayload != null) 'encrypted_payload': encryptedPayload,
      if (iv != null) 'iv': iv,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EncryptedVaultTableCompanion copyWith({
    Value<String>? id,
    Value<String>? category,
    Value<String>? encryptedPayload,
    Value<String>? iv,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return EncryptedVaultTableCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      encryptedPayload: encryptedPayload ?? this.encryptedPayload,
      iv: iv ?? this.iv,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (encryptedPayload.present) {
      map['encrypted_payload'] = Variable<String>(encryptedPayload.value);
    }
    if (iv.present) {
      map['iv'] = Variable<String>(iv.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EncryptedVaultTableCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('encryptedPayload: $encryptedPayload, ')
          ..write('iv: $iv, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StudentProfileTableTable extends StudentProfileTable
    with TableInfo<$StudentProfileTableTable, StudentProfileTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudentProfileTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _degreeMeta = const VerificationMeta('degree');
  @override
  late final GeneratedColumn<String> degree = GeneratedColumn<String>(
    'degree',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('B.Tech'),
  );
  static const VerificationMeta _branchMeta = const VerificationMeta('branch');
  @override
  late final GeneratedColumn<String> branch = GeneratedColumn<String>(
    'branch',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Computer Science & Engineering'),
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _semesterMeta = const VerificationMeta(
    'semester',
  );
  @override
  late final GeneratedColumn<int> semester = GeneratedColumn<int>(
    'semester',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _collegeMeta = const VerificationMeta(
    'college',
  );
  @override
  late final GeneratedColumn<String> college = GeneratedColumn<String>(
    'college',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _enrollmentNumberMeta = const VerificationMeta(
    'enrollmentNumber',
  );
  @override
  late final GeneratedColumn<String> enrollmentNumber = GeneratedColumn<String>(
    'enrollment_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _apaarIdMeta = const VerificationMeta(
    'apaarId',
  );
  @override
  late final GeneratedColumn<String> apaarId = GeneratedColumn<String>(
    'apaar_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _semesterStartDateMeta = const VerificationMeta(
    'semesterStartDate',
  );
  @override
  late final GeneratedColumn<DateTime> semesterStartDate =
      GeneratedColumn<DateTime>(
        'semester_start_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _semesterEndDateMeta = const VerificationMeta(
    'semesterEndDate',
  );
  @override
  late final GeneratedColumn<DateTime> semesterEndDate =
      GeneratedColumn<DateTime>(
        'semester_end_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _gradingSchemeMeta = const VerificationMeta(
    'gradingScheme',
  );
  @override
  late final GeneratedColumn<String> gradingScheme = GeneratedColumn<String>(
    'grading_scheme',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('10_point_ugc'),
  );
  static const VerificationMeta _targetCgpaMeta = const VerificationMeta(
    'targetCgpa',
  );
  @override
  late final GeneratedColumn<double> targetCgpa = GeneratedColumn<double>(
    'target_cgpa',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(8.5),
  );
  static const VerificationMeta _attendanceRuleThresholdMeta =
      const VerificationMeta('attendanceRuleThreshold');
  @override
  late final GeneratedColumn<double> attendanceRuleThreshold =
      GeneratedColumn<double>(
        'attendance_rule_threshold',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(75.0),
      );
  static const VerificationMeta _emergencyContactNameMeta =
      const VerificationMeta('emergencyContactName');
  @override
  late final GeneratedColumn<String> emergencyContactName =
      GeneratedColumn<String>(
        'emergency_contact_name',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _emergencyContactPhoneMeta =
      const VerificationMeta('emergencyContactPhone');
  @override
  late final GeneratedColumn<String> emergencyContactPhone =
      GeneratedColumn<String>(
        'emergency_contact_phone',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _onboardingCompletedMeta =
      const VerificationMeta('onboardingCompleted');
  @override
  late final GeneratedColumn<bool> onboardingCompleted = GeneratedColumn<bool>(
    'onboarding_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _setupStepMeta = const VerificationMeta(
    'setupStep',
  );
  @override
  late final GeneratedColumn<int> setupStep = GeneratedColumn<int>(
    'setup_step',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isAppLockEnabledMeta = const VerificationMeta(
    'isAppLockEnabled',
  );
  @override
  late final GeneratedColumn<bool> isAppLockEnabled = GeneratedColumn<bool>(
    'is_app_lock_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_app_lock_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _pinCodeHashMeta = const VerificationMeta(
    'pinCodeHash',
  );
  @override
  late final GeneratedColumn<String> pinCodeHash = GeneratedColumn<String>(
    'pin_code_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _useBiometricsMeta = const VerificationMeta(
    'useBiometrics',
  );
  @override
  late final GeneratedColumn<bool> useBiometrics = GeneratedColumn<bool>(
    'use_biometrics',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("use_biometrics" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _upiIdMeta = const VerificationMeta('upiId');
  @override
  late final GeneratedColumn<String> upiId = GeneratedColumn<String>(
    'upi_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _selectedCampusIdMeta = const VerificationMeta(
    'selectedCampusId',
  );
  @override
  late final GeneratedColumn<String> selectedCampusId = GeneratedColumn<String>(
    'selected_campus_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _selectedCampusNameMeta =
      const VerificationMeta('selectedCampusName');
  @override
  late final GeneratedColumn<String> selectedCampusName =
      GeneratedColumn<String>(
        'selected_campus_name',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _preferredLanguageMeta = const VerificationMeta(
    'preferredLanguage',
  );
  @override
  late final GeneratedColumn<String> preferredLanguage =
      GeneratedColumn<String>(
        'preferred_language',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('en'),
      );
  static const VerificationMeta _notificationsEnabledMeta =
      const VerificationMeta('notificationsEnabled');
  @override
  late final GeneratedColumn<bool> notificationsEnabled = GeneratedColumn<bool>(
    'notifications_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notifications_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _tutorialCompletedMeta = const VerificationMeta(
    'tutorialCompleted',
  );
  @override
  late final GeneratedColumn<bool> tutorialCompleted = GeneratedColumn<bool>(
    'tutorial_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("tutorial_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _mapFilePathMeta = const VerificationMeta(
    'mapFilePath',
  );
  @override
  late final GeneratedColumn<String> mapFilePath = GeneratedColumn<String>(
    'map_file_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mapVersionMeta = const VerificationMeta(
    'mapVersion',
  );
  @override
  late final GeneratedColumn<String> mapVersion = GeneratedColumn<String>(
    'map_version',
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fullName,
    photoPath,
    degree,
    branch,
    year,
    semester,
    college,
    city,
    state,
    enrollmentNumber,
    apaarId,
    semesterStartDate,
    semesterEndDate,
    gradingScheme,
    targetCgpa,
    attendanceRuleThreshold,
    emergencyContactName,
    emergencyContactPhone,
    onboardingCompleted,
    setupStep,
    isAppLockEnabled,
    pinCodeHash,
    useBiometrics,
    upiId,
    selectedCampusId,
    selectedCampusName,
    preferredLanguage,
    notificationsEnabled,
    tutorialCompleted,
    mapFilePath,
    mapVersion,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'student_profile_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudentProfileTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('degree')) {
      context.handle(
        _degreeMeta,
        degree.isAcceptableOrUnknown(data['degree']!, _degreeMeta),
      );
    }
    if (data.containsKey('branch')) {
      context.handle(
        _branchMeta,
        branch.isAcceptableOrUnknown(data['branch']!, _branchMeta),
      );
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    if (data.containsKey('semester')) {
      context.handle(
        _semesterMeta,
        semester.isAcceptableOrUnknown(data['semester']!, _semesterMeta),
      );
    }
    if (data.containsKey('college')) {
      context.handle(
        _collegeMeta,
        college.isAcceptableOrUnknown(data['college']!, _collegeMeta),
      );
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('enrollment_number')) {
      context.handle(
        _enrollmentNumberMeta,
        enrollmentNumber.isAcceptableOrUnknown(
          data['enrollment_number']!,
          _enrollmentNumberMeta,
        ),
      );
    }
    if (data.containsKey('apaar_id')) {
      context.handle(
        _apaarIdMeta,
        apaarId.isAcceptableOrUnknown(data['apaar_id']!, _apaarIdMeta),
      );
    }
    if (data.containsKey('semester_start_date')) {
      context.handle(
        _semesterStartDateMeta,
        semesterStartDate.isAcceptableOrUnknown(
          data['semester_start_date']!,
          _semesterStartDateMeta,
        ),
      );
    }
    if (data.containsKey('semester_end_date')) {
      context.handle(
        _semesterEndDateMeta,
        semesterEndDate.isAcceptableOrUnknown(
          data['semester_end_date']!,
          _semesterEndDateMeta,
        ),
      );
    }
    if (data.containsKey('grading_scheme')) {
      context.handle(
        _gradingSchemeMeta,
        gradingScheme.isAcceptableOrUnknown(
          data['grading_scheme']!,
          _gradingSchemeMeta,
        ),
      );
    }
    if (data.containsKey('target_cgpa')) {
      context.handle(
        _targetCgpaMeta,
        targetCgpa.isAcceptableOrUnknown(data['target_cgpa']!, _targetCgpaMeta),
      );
    }
    if (data.containsKey('attendance_rule_threshold')) {
      context.handle(
        _attendanceRuleThresholdMeta,
        attendanceRuleThreshold.isAcceptableOrUnknown(
          data['attendance_rule_threshold']!,
          _attendanceRuleThresholdMeta,
        ),
      );
    }
    if (data.containsKey('emergency_contact_name')) {
      context.handle(
        _emergencyContactNameMeta,
        emergencyContactName.isAcceptableOrUnknown(
          data['emergency_contact_name']!,
          _emergencyContactNameMeta,
        ),
      );
    }
    if (data.containsKey('emergency_contact_phone')) {
      context.handle(
        _emergencyContactPhoneMeta,
        emergencyContactPhone.isAcceptableOrUnknown(
          data['emergency_contact_phone']!,
          _emergencyContactPhoneMeta,
        ),
      );
    }
    if (data.containsKey('onboarding_completed')) {
      context.handle(
        _onboardingCompletedMeta,
        onboardingCompleted.isAcceptableOrUnknown(
          data['onboarding_completed']!,
          _onboardingCompletedMeta,
        ),
      );
    }
    if (data.containsKey('setup_step')) {
      context.handle(
        _setupStepMeta,
        setupStep.isAcceptableOrUnknown(data['setup_step']!, _setupStepMeta),
      );
    }
    if (data.containsKey('is_app_lock_enabled')) {
      context.handle(
        _isAppLockEnabledMeta,
        isAppLockEnabled.isAcceptableOrUnknown(
          data['is_app_lock_enabled']!,
          _isAppLockEnabledMeta,
        ),
      );
    }
    if (data.containsKey('pin_code_hash')) {
      context.handle(
        _pinCodeHashMeta,
        pinCodeHash.isAcceptableOrUnknown(
          data['pin_code_hash']!,
          _pinCodeHashMeta,
        ),
      );
    }
    if (data.containsKey('use_biometrics')) {
      context.handle(
        _useBiometricsMeta,
        useBiometrics.isAcceptableOrUnknown(
          data['use_biometrics']!,
          _useBiometricsMeta,
        ),
      );
    }
    if (data.containsKey('upi_id')) {
      context.handle(
        _upiIdMeta,
        upiId.isAcceptableOrUnknown(data['upi_id']!, _upiIdMeta),
      );
    }
    if (data.containsKey('selected_campus_id')) {
      context.handle(
        _selectedCampusIdMeta,
        selectedCampusId.isAcceptableOrUnknown(
          data['selected_campus_id']!,
          _selectedCampusIdMeta,
        ),
      );
    }
    if (data.containsKey('selected_campus_name')) {
      context.handle(
        _selectedCampusNameMeta,
        selectedCampusName.isAcceptableOrUnknown(
          data['selected_campus_name']!,
          _selectedCampusNameMeta,
        ),
      );
    }
    if (data.containsKey('preferred_language')) {
      context.handle(
        _preferredLanguageMeta,
        preferredLanguage.isAcceptableOrUnknown(
          data['preferred_language']!,
          _preferredLanguageMeta,
        ),
      );
    }
    if (data.containsKey('notifications_enabled')) {
      context.handle(
        _notificationsEnabledMeta,
        notificationsEnabled.isAcceptableOrUnknown(
          data['notifications_enabled']!,
          _notificationsEnabledMeta,
        ),
      );
    }
    if (data.containsKey('tutorial_completed')) {
      context.handle(
        _tutorialCompletedMeta,
        tutorialCompleted.isAcceptableOrUnknown(
          data['tutorial_completed']!,
          _tutorialCompletedMeta,
        ),
      );
    }
    if (data.containsKey('map_file_path')) {
      context.handle(
        _mapFilePathMeta,
        mapFilePath.isAcceptableOrUnknown(
          data['map_file_path']!,
          _mapFilePathMeta,
        ),
      );
    }
    if (data.containsKey('map_version')) {
      context.handle(
        _mapVersionMeta,
        mapVersion.isAcceptableOrUnknown(data['map_version']!, _mapVersionMeta),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudentProfileTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudentProfileTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      degree: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}degree'],
      )!,
      branch: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}branch'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      semester: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}semester'],
      )!,
      college: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}college'],
      )!,
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      enrollmentNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}enrollment_number'],
      )!,
      apaarId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}apaar_id'],
      ),
      semesterStartDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}semester_start_date'],
      ),
      semesterEndDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}semester_end_date'],
      ),
      gradingScheme: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grading_scheme'],
      )!,
      targetCgpa: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_cgpa'],
      )!,
      attendanceRuleThreshold: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}attendance_rule_threshold'],
      )!,
      emergencyContactName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emergency_contact_name'],
      ),
      emergencyContactPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emergency_contact_phone'],
      ),
      onboardingCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_completed'],
      )!,
      setupStep: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}setup_step'],
      )!,
      isAppLockEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_app_lock_enabled'],
      )!,
      pinCodeHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pin_code_hash'],
      ),
      useBiometrics: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}use_biometrics'],
      )!,
      upiId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}upi_id'],
      )!,
      selectedCampusId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_campus_id'],
      )!,
      selectedCampusName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_campus_name'],
      )!,
      preferredLanguage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_language'],
      )!,
      notificationsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notifications_enabled'],
      )!,
      tutorialCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}tutorial_completed'],
      )!,
      mapFilePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}map_file_path'],
      ),
      mapVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}map_version'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $StudentProfileTableTable createAlias(String alias) {
    return $StudentProfileTableTable(attachedDatabase, alias);
  }
}

class StudentProfileTableData extends DataClass
    implements Insertable<StudentProfileTableData> {
  final String id;
  final String fullName;
  final String? photoPath;
  final String degree;
  final String branch;
  final int year;
  final int semester;
  final String college;
  final String city;
  final String state;
  final String enrollmentNumber;
  final String? apaarId;
  final DateTime? semesterStartDate;
  final DateTime? semesterEndDate;
  final String gradingScheme;
  final double targetCgpa;
  final double attendanceRuleThreshold;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final bool onboardingCompleted;
  final int setupStep;
  final bool isAppLockEnabled;
  final String? pinCodeHash;
  final bool useBiometrics;
  final String upiId;
  final String selectedCampusId;
  final String selectedCampusName;
  final String preferredLanguage;
  final bool notificationsEnabled;
  final bool tutorialCompleted;
  final String? mapFilePath;
  final String? mapVersion;
  final DateTime updatedAt;
  const StudentProfileTableData({
    required this.id,
    required this.fullName,
    this.photoPath,
    required this.degree,
    required this.branch,
    required this.year,
    required this.semester,
    required this.college,
    required this.city,
    required this.state,
    required this.enrollmentNumber,
    this.apaarId,
    this.semesterStartDate,
    this.semesterEndDate,
    required this.gradingScheme,
    required this.targetCgpa,
    required this.attendanceRuleThreshold,
    this.emergencyContactName,
    this.emergencyContactPhone,
    required this.onboardingCompleted,
    required this.setupStep,
    required this.isAppLockEnabled,
    this.pinCodeHash,
    required this.useBiometrics,
    required this.upiId,
    required this.selectedCampusId,
    required this.selectedCampusName,
    required this.preferredLanguage,
    required this.notificationsEnabled,
    required this.tutorialCompleted,
    this.mapFilePath,
    this.mapVersion,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['full_name'] = Variable<String>(fullName);
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    map['degree'] = Variable<String>(degree);
    map['branch'] = Variable<String>(branch);
    map['year'] = Variable<int>(year);
    map['semester'] = Variable<int>(semester);
    map['college'] = Variable<String>(college);
    map['city'] = Variable<String>(city);
    map['state'] = Variable<String>(state);
    map['enrollment_number'] = Variable<String>(enrollmentNumber);
    if (!nullToAbsent || apaarId != null) {
      map['apaar_id'] = Variable<String>(apaarId);
    }
    if (!nullToAbsent || semesterStartDate != null) {
      map['semester_start_date'] = Variable<DateTime>(semesterStartDate);
    }
    if (!nullToAbsent || semesterEndDate != null) {
      map['semester_end_date'] = Variable<DateTime>(semesterEndDate);
    }
    map['grading_scheme'] = Variable<String>(gradingScheme);
    map['target_cgpa'] = Variable<double>(targetCgpa);
    map['attendance_rule_threshold'] = Variable<double>(
      attendanceRuleThreshold,
    );
    if (!nullToAbsent || emergencyContactName != null) {
      map['emergency_contact_name'] = Variable<String>(emergencyContactName);
    }
    if (!nullToAbsent || emergencyContactPhone != null) {
      map['emergency_contact_phone'] = Variable<String>(emergencyContactPhone);
    }
    map['onboarding_completed'] = Variable<bool>(onboardingCompleted);
    map['setup_step'] = Variable<int>(setupStep);
    map['is_app_lock_enabled'] = Variable<bool>(isAppLockEnabled);
    if (!nullToAbsent || pinCodeHash != null) {
      map['pin_code_hash'] = Variable<String>(pinCodeHash);
    }
    map['use_biometrics'] = Variable<bool>(useBiometrics);
    map['upi_id'] = Variable<String>(upiId);
    map['selected_campus_id'] = Variable<String>(selectedCampusId);
    map['selected_campus_name'] = Variable<String>(selectedCampusName);
    map['preferred_language'] = Variable<String>(preferredLanguage);
    map['notifications_enabled'] = Variable<bool>(notificationsEnabled);
    map['tutorial_completed'] = Variable<bool>(tutorialCompleted);
    if (!nullToAbsent || mapFilePath != null) {
      map['map_file_path'] = Variable<String>(mapFilePath);
    }
    if (!nullToAbsent || mapVersion != null) {
      map['map_version'] = Variable<String>(mapVersion);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  StudentProfileTableCompanion toCompanion(bool nullToAbsent) {
    return StudentProfileTableCompanion(
      id: Value(id),
      fullName: Value(fullName),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      degree: Value(degree),
      branch: Value(branch),
      year: Value(year),
      semester: Value(semester),
      college: Value(college),
      city: Value(city),
      state: Value(state),
      enrollmentNumber: Value(enrollmentNumber),
      apaarId: apaarId == null && nullToAbsent
          ? const Value.absent()
          : Value(apaarId),
      semesterStartDate: semesterStartDate == null && nullToAbsent
          ? const Value.absent()
          : Value(semesterStartDate),
      semesterEndDate: semesterEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(semesterEndDate),
      gradingScheme: Value(gradingScheme),
      targetCgpa: Value(targetCgpa),
      attendanceRuleThreshold: Value(attendanceRuleThreshold),
      emergencyContactName: emergencyContactName == null && nullToAbsent
          ? const Value.absent()
          : Value(emergencyContactName),
      emergencyContactPhone: emergencyContactPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(emergencyContactPhone),
      onboardingCompleted: Value(onboardingCompleted),
      setupStep: Value(setupStep),
      isAppLockEnabled: Value(isAppLockEnabled),
      pinCodeHash: pinCodeHash == null && nullToAbsent
          ? const Value.absent()
          : Value(pinCodeHash),
      useBiometrics: Value(useBiometrics),
      upiId: Value(upiId),
      selectedCampusId: Value(selectedCampusId),
      selectedCampusName: Value(selectedCampusName),
      preferredLanguage: Value(preferredLanguage),
      notificationsEnabled: Value(notificationsEnabled),
      tutorialCompleted: Value(tutorialCompleted),
      mapFilePath: mapFilePath == null && nullToAbsent
          ? const Value.absent()
          : Value(mapFilePath),
      mapVersion: mapVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(mapVersion),
      updatedAt: Value(updatedAt),
    );
  }

  factory StudentProfileTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudentProfileTableData(
      id: serializer.fromJson<String>(json['id']),
      fullName: serializer.fromJson<String>(json['fullName']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      degree: serializer.fromJson<String>(json['degree']),
      branch: serializer.fromJson<String>(json['branch']),
      year: serializer.fromJson<int>(json['year']),
      semester: serializer.fromJson<int>(json['semester']),
      college: serializer.fromJson<String>(json['college']),
      city: serializer.fromJson<String>(json['city']),
      state: serializer.fromJson<String>(json['state']),
      enrollmentNumber: serializer.fromJson<String>(json['enrollmentNumber']),
      apaarId: serializer.fromJson<String?>(json['apaarId']),
      semesterStartDate: serializer.fromJson<DateTime?>(
        json['semesterStartDate'],
      ),
      semesterEndDate: serializer.fromJson<DateTime?>(json['semesterEndDate']),
      gradingScheme: serializer.fromJson<String>(json['gradingScheme']),
      targetCgpa: serializer.fromJson<double>(json['targetCgpa']),
      attendanceRuleThreshold: serializer.fromJson<double>(
        json['attendanceRuleThreshold'],
      ),
      emergencyContactName: serializer.fromJson<String?>(
        json['emergencyContactName'],
      ),
      emergencyContactPhone: serializer.fromJson<String?>(
        json['emergencyContactPhone'],
      ),
      onboardingCompleted: serializer.fromJson<bool>(
        json['onboardingCompleted'],
      ),
      setupStep: serializer.fromJson<int>(json['setupStep']),
      isAppLockEnabled: serializer.fromJson<bool>(json['isAppLockEnabled']),
      pinCodeHash: serializer.fromJson<String?>(json['pinCodeHash']),
      useBiometrics: serializer.fromJson<bool>(json['useBiometrics']),
      upiId: serializer.fromJson<String>(json['upiId']),
      selectedCampusId: serializer.fromJson<String>(json['selectedCampusId']),
      selectedCampusName: serializer.fromJson<String>(
        json['selectedCampusName'],
      ),
      preferredLanguage: serializer.fromJson<String>(json['preferredLanguage']),
      notificationsEnabled: serializer.fromJson<bool>(
        json['notificationsEnabled'],
      ),
      tutorialCompleted: serializer.fromJson<bool>(json['tutorialCompleted']),
      mapFilePath: serializer.fromJson<String?>(json['mapFilePath']),
      mapVersion: serializer.fromJson<String?>(json['mapVersion']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fullName': serializer.toJson<String>(fullName),
      'photoPath': serializer.toJson<String?>(photoPath),
      'degree': serializer.toJson<String>(degree),
      'branch': serializer.toJson<String>(branch),
      'year': serializer.toJson<int>(year),
      'semester': serializer.toJson<int>(semester),
      'college': serializer.toJson<String>(college),
      'city': serializer.toJson<String>(city),
      'state': serializer.toJson<String>(state),
      'enrollmentNumber': serializer.toJson<String>(enrollmentNumber),
      'apaarId': serializer.toJson<String?>(apaarId),
      'semesterStartDate': serializer.toJson<DateTime?>(semesterStartDate),
      'semesterEndDate': serializer.toJson<DateTime?>(semesterEndDate),
      'gradingScheme': serializer.toJson<String>(gradingScheme),
      'targetCgpa': serializer.toJson<double>(targetCgpa),
      'attendanceRuleThreshold': serializer.toJson<double>(
        attendanceRuleThreshold,
      ),
      'emergencyContactName': serializer.toJson<String?>(emergencyContactName),
      'emergencyContactPhone': serializer.toJson<String?>(
        emergencyContactPhone,
      ),
      'onboardingCompleted': serializer.toJson<bool>(onboardingCompleted),
      'setupStep': serializer.toJson<int>(setupStep),
      'isAppLockEnabled': serializer.toJson<bool>(isAppLockEnabled),
      'pinCodeHash': serializer.toJson<String?>(pinCodeHash),
      'useBiometrics': serializer.toJson<bool>(useBiometrics),
      'upiId': serializer.toJson<String>(upiId),
      'selectedCampusId': serializer.toJson<String>(selectedCampusId),
      'selectedCampusName': serializer.toJson<String>(selectedCampusName),
      'preferredLanguage': serializer.toJson<String>(preferredLanguage),
      'notificationsEnabled': serializer.toJson<bool>(notificationsEnabled),
      'tutorialCompleted': serializer.toJson<bool>(tutorialCompleted),
      'mapFilePath': serializer.toJson<String?>(mapFilePath),
      'mapVersion': serializer.toJson<String?>(mapVersion),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  StudentProfileTableData copyWith({
    String? id,
    String? fullName,
    Value<String?> photoPath = const Value.absent(),
    String? degree,
    String? branch,
    int? year,
    int? semester,
    String? college,
    String? city,
    String? state,
    String? enrollmentNumber,
    Value<String?> apaarId = const Value.absent(),
    Value<DateTime?> semesterStartDate = const Value.absent(),
    Value<DateTime?> semesterEndDate = const Value.absent(),
    String? gradingScheme,
    double? targetCgpa,
    double? attendanceRuleThreshold,
    Value<String?> emergencyContactName = const Value.absent(),
    Value<String?> emergencyContactPhone = const Value.absent(),
    bool? onboardingCompleted,
    int? setupStep,
    bool? isAppLockEnabled,
    Value<String?> pinCodeHash = const Value.absent(),
    bool? useBiometrics,
    String? upiId,
    String? selectedCampusId,
    String? selectedCampusName,
    String? preferredLanguage,
    bool? notificationsEnabled,
    bool? tutorialCompleted,
    Value<String?> mapFilePath = const Value.absent(),
    Value<String?> mapVersion = const Value.absent(),
    DateTime? updatedAt,
  }) => StudentProfileTableData(
    id: id ?? this.id,
    fullName: fullName ?? this.fullName,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    degree: degree ?? this.degree,
    branch: branch ?? this.branch,
    year: year ?? this.year,
    semester: semester ?? this.semester,
    college: college ?? this.college,
    city: city ?? this.city,
    state: state ?? this.state,
    enrollmentNumber: enrollmentNumber ?? this.enrollmentNumber,
    apaarId: apaarId.present ? apaarId.value : this.apaarId,
    semesterStartDate: semesterStartDate.present
        ? semesterStartDate.value
        : this.semesterStartDate,
    semesterEndDate: semesterEndDate.present
        ? semesterEndDate.value
        : this.semesterEndDate,
    gradingScheme: gradingScheme ?? this.gradingScheme,
    targetCgpa: targetCgpa ?? this.targetCgpa,
    attendanceRuleThreshold:
        attendanceRuleThreshold ?? this.attendanceRuleThreshold,
    emergencyContactName: emergencyContactName.present
        ? emergencyContactName.value
        : this.emergencyContactName,
    emergencyContactPhone: emergencyContactPhone.present
        ? emergencyContactPhone.value
        : this.emergencyContactPhone,
    onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    setupStep: setupStep ?? this.setupStep,
    isAppLockEnabled: isAppLockEnabled ?? this.isAppLockEnabled,
    pinCodeHash: pinCodeHash.present ? pinCodeHash.value : this.pinCodeHash,
    useBiometrics: useBiometrics ?? this.useBiometrics,
    upiId: upiId ?? this.upiId,
    selectedCampusId: selectedCampusId ?? this.selectedCampusId,
    selectedCampusName: selectedCampusName ?? this.selectedCampusName,
    preferredLanguage: preferredLanguage ?? this.preferredLanguage,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    tutorialCompleted: tutorialCompleted ?? this.tutorialCompleted,
    mapFilePath: mapFilePath.present ? mapFilePath.value : this.mapFilePath,
    mapVersion: mapVersion.present ? mapVersion.value : this.mapVersion,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  StudentProfileTableData copyWithCompanion(StudentProfileTableCompanion data) {
    return StudentProfileTableData(
      id: data.id.present ? data.id.value : this.id,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      degree: data.degree.present ? data.degree.value : this.degree,
      branch: data.branch.present ? data.branch.value : this.branch,
      year: data.year.present ? data.year.value : this.year,
      semester: data.semester.present ? data.semester.value : this.semester,
      college: data.college.present ? data.college.value : this.college,
      city: data.city.present ? data.city.value : this.city,
      state: data.state.present ? data.state.value : this.state,
      enrollmentNumber: data.enrollmentNumber.present
          ? data.enrollmentNumber.value
          : this.enrollmentNumber,
      apaarId: data.apaarId.present ? data.apaarId.value : this.apaarId,
      semesterStartDate: data.semesterStartDate.present
          ? data.semesterStartDate.value
          : this.semesterStartDate,
      semesterEndDate: data.semesterEndDate.present
          ? data.semesterEndDate.value
          : this.semesterEndDate,
      gradingScheme: data.gradingScheme.present
          ? data.gradingScheme.value
          : this.gradingScheme,
      targetCgpa: data.targetCgpa.present
          ? data.targetCgpa.value
          : this.targetCgpa,
      attendanceRuleThreshold: data.attendanceRuleThreshold.present
          ? data.attendanceRuleThreshold.value
          : this.attendanceRuleThreshold,
      emergencyContactName: data.emergencyContactName.present
          ? data.emergencyContactName.value
          : this.emergencyContactName,
      emergencyContactPhone: data.emergencyContactPhone.present
          ? data.emergencyContactPhone.value
          : this.emergencyContactPhone,
      onboardingCompleted: data.onboardingCompleted.present
          ? data.onboardingCompleted.value
          : this.onboardingCompleted,
      setupStep: data.setupStep.present ? data.setupStep.value : this.setupStep,
      isAppLockEnabled: data.isAppLockEnabled.present
          ? data.isAppLockEnabled.value
          : this.isAppLockEnabled,
      pinCodeHash: data.pinCodeHash.present
          ? data.pinCodeHash.value
          : this.pinCodeHash,
      useBiometrics: data.useBiometrics.present
          ? data.useBiometrics.value
          : this.useBiometrics,
      upiId: data.upiId.present ? data.upiId.value : this.upiId,
      selectedCampusId: data.selectedCampusId.present
          ? data.selectedCampusId.value
          : this.selectedCampusId,
      selectedCampusName: data.selectedCampusName.present
          ? data.selectedCampusName.value
          : this.selectedCampusName,
      preferredLanguage: data.preferredLanguage.present
          ? data.preferredLanguage.value
          : this.preferredLanguage,
      notificationsEnabled: data.notificationsEnabled.present
          ? data.notificationsEnabled.value
          : this.notificationsEnabled,
      tutorialCompleted: data.tutorialCompleted.present
          ? data.tutorialCompleted.value
          : this.tutorialCompleted,
      mapFilePath: data.mapFilePath.present
          ? data.mapFilePath.value
          : this.mapFilePath,
      mapVersion: data.mapVersion.present
          ? data.mapVersion.value
          : this.mapVersion,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudentProfileTableData(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('photoPath: $photoPath, ')
          ..write('degree: $degree, ')
          ..write('branch: $branch, ')
          ..write('year: $year, ')
          ..write('semester: $semester, ')
          ..write('college: $college, ')
          ..write('city: $city, ')
          ..write('state: $state, ')
          ..write('enrollmentNumber: $enrollmentNumber, ')
          ..write('apaarId: $apaarId, ')
          ..write('semesterStartDate: $semesterStartDate, ')
          ..write('semesterEndDate: $semesterEndDate, ')
          ..write('gradingScheme: $gradingScheme, ')
          ..write('targetCgpa: $targetCgpa, ')
          ..write('attendanceRuleThreshold: $attendanceRuleThreshold, ')
          ..write('emergencyContactName: $emergencyContactName, ')
          ..write('emergencyContactPhone: $emergencyContactPhone, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('setupStep: $setupStep, ')
          ..write('isAppLockEnabled: $isAppLockEnabled, ')
          ..write('pinCodeHash: $pinCodeHash, ')
          ..write('useBiometrics: $useBiometrics, ')
          ..write('upiId: $upiId, ')
          ..write('selectedCampusId: $selectedCampusId, ')
          ..write('selectedCampusName: $selectedCampusName, ')
          ..write('preferredLanguage: $preferredLanguage, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('tutorialCompleted: $tutorialCompleted, ')
          ..write('mapFilePath: $mapFilePath, ')
          ..write('mapVersion: $mapVersion, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    fullName,
    photoPath,
    degree,
    branch,
    year,
    semester,
    college,
    city,
    state,
    enrollmentNumber,
    apaarId,
    semesterStartDate,
    semesterEndDate,
    gradingScheme,
    targetCgpa,
    attendanceRuleThreshold,
    emergencyContactName,
    emergencyContactPhone,
    onboardingCompleted,
    setupStep,
    isAppLockEnabled,
    pinCodeHash,
    useBiometrics,
    upiId,
    selectedCampusId,
    selectedCampusName,
    preferredLanguage,
    notificationsEnabled,
    tutorialCompleted,
    mapFilePath,
    mapVersion,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudentProfileTableData &&
          other.id == this.id &&
          other.fullName == this.fullName &&
          other.photoPath == this.photoPath &&
          other.degree == this.degree &&
          other.branch == this.branch &&
          other.year == this.year &&
          other.semester == this.semester &&
          other.college == this.college &&
          other.city == this.city &&
          other.state == this.state &&
          other.enrollmentNumber == this.enrollmentNumber &&
          other.apaarId == this.apaarId &&
          other.semesterStartDate == this.semesterStartDate &&
          other.semesterEndDate == this.semesterEndDate &&
          other.gradingScheme == this.gradingScheme &&
          other.targetCgpa == this.targetCgpa &&
          other.attendanceRuleThreshold == this.attendanceRuleThreshold &&
          other.emergencyContactName == this.emergencyContactName &&
          other.emergencyContactPhone == this.emergencyContactPhone &&
          other.onboardingCompleted == this.onboardingCompleted &&
          other.setupStep == this.setupStep &&
          other.isAppLockEnabled == this.isAppLockEnabled &&
          other.pinCodeHash == this.pinCodeHash &&
          other.useBiometrics == this.useBiometrics &&
          other.upiId == this.upiId &&
          other.selectedCampusId == this.selectedCampusId &&
          other.selectedCampusName == this.selectedCampusName &&
          other.preferredLanguage == this.preferredLanguage &&
          other.notificationsEnabled == this.notificationsEnabled &&
          other.tutorialCompleted == this.tutorialCompleted &&
          other.mapFilePath == this.mapFilePath &&
          other.mapVersion == this.mapVersion &&
          other.updatedAt == this.updatedAt);
}

class StudentProfileTableCompanion
    extends UpdateCompanion<StudentProfileTableData> {
  final Value<String> id;
  final Value<String> fullName;
  final Value<String?> photoPath;
  final Value<String> degree;
  final Value<String> branch;
  final Value<int> year;
  final Value<int> semester;
  final Value<String> college;
  final Value<String> city;
  final Value<String> state;
  final Value<String> enrollmentNumber;
  final Value<String?> apaarId;
  final Value<DateTime?> semesterStartDate;
  final Value<DateTime?> semesterEndDate;
  final Value<String> gradingScheme;
  final Value<double> targetCgpa;
  final Value<double> attendanceRuleThreshold;
  final Value<String?> emergencyContactName;
  final Value<String?> emergencyContactPhone;
  final Value<bool> onboardingCompleted;
  final Value<int> setupStep;
  final Value<bool> isAppLockEnabled;
  final Value<String?> pinCodeHash;
  final Value<bool> useBiometrics;
  final Value<String> upiId;
  final Value<String> selectedCampusId;
  final Value<String> selectedCampusName;
  final Value<String> preferredLanguage;
  final Value<bool> notificationsEnabled;
  final Value<bool> tutorialCompleted;
  final Value<String?> mapFilePath;
  final Value<String?> mapVersion;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const StudentProfileTableCompanion({
    this.id = const Value.absent(),
    this.fullName = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.degree = const Value.absent(),
    this.branch = const Value.absent(),
    this.year = const Value.absent(),
    this.semester = const Value.absent(),
    this.college = const Value.absent(),
    this.city = const Value.absent(),
    this.state = const Value.absent(),
    this.enrollmentNumber = const Value.absent(),
    this.apaarId = const Value.absent(),
    this.semesterStartDate = const Value.absent(),
    this.semesterEndDate = const Value.absent(),
    this.gradingScheme = const Value.absent(),
    this.targetCgpa = const Value.absent(),
    this.attendanceRuleThreshold = const Value.absent(),
    this.emergencyContactName = const Value.absent(),
    this.emergencyContactPhone = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    this.setupStep = const Value.absent(),
    this.isAppLockEnabled = const Value.absent(),
    this.pinCodeHash = const Value.absent(),
    this.useBiometrics = const Value.absent(),
    this.upiId = const Value.absent(),
    this.selectedCampusId = const Value.absent(),
    this.selectedCampusName = const Value.absent(),
    this.preferredLanguage = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.tutorialCompleted = const Value.absent(),
    this.mapFilePath = const Value.absent(),
    this.mapVersion = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudentProfileTableCompanion.insert({
    required String id,
    this.fullName = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.degree = const Value.absent(),
    this.branch = const Value.absent(),
    this.year = const Value.absent(),
    this.semester = const Value.absent(),
    this.college = const Value.absent(),
    this.city = const Value.absent(),
    this.state = const Value.absent(),
    this.enrollmentNumber = const Value.absent(),
    this.apaarId = const Value.absent(),
    this.semesterStartDate = const Value.absent(),
    this.semesterEndDate = const Value.absent(),
    this.gradingScheme = const Value.absent(),
    this.targetCgpa = const Value.absent(),
    this.attendanceRuleThreshold = const Value.absent(),
    this.emergencyContactName = const Value.absent(),
    this.emergencyContactPhone = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    this.setupStep = const Value.absent(),
    this.isAppLockEnabled = const Value.absent(),
    this.pinCodeHash = const Value.absent(),
    this.useBiometrics = const Value.absent(),
    this.upiId = const Value.absent(),
    this.selectedCampusId = const Value.absent(),
    this.selectedCampusName = const Value.absent(),
    this.preferredLanguage = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.tutorialCompleted = const Value.absent(),
    this.mapFilePath = const Value.absent(),
    this.mapVersion = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       updatedAt = Value(updatedAt);
  static Insertable<StudentProfileTableData> custom({
    Expression<String>? id,
    Expression<String>? fullName,
    Expression<String>? photoPath,
    Expression<String>? degree,
    Expression<String>? branch,
    Expression<int>? year,
    Expression<int>? semester,
    Expression<String>? college,
    Expression<String>? city,
    Expression<String>? state,
    Expression<String>? enrollmentNumber,
    Expression<String>? apaarId,
    Expression<DateTime>? semesterStartDate,
    Expression<DateTime>? semesterEndDate,
    Expression<String>? gradingScheme,
    Expression<double>? targetCgpa,
    Expression<double>? attendanceRuleThreshold,
    Expression<String>? emergencyContactName,
    Expression<String>? emergencyContactPhone,
    Expression<bool>? onboardingCompleted,
    Expression<int>? setupStep,
    Expression<bool>? isAppLockEnabled,
    Expression<String>? pinCodeHash,
    Expression<bool>? useBiometrics,
    Expression<String>? upiId,
    Expression<String>? selectedCampusId,
    Expression<String>? selectedCampusName,
    Expression<String>? preferredLanguage,
    Expression<bool>? notificationsEnabled,
    Expression<bool>? tutorialCompleted,
    Expression<String>? mapFilePath,
    Expression<String>? mapVersion,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fullName != null) 'full_name': fullName,
      if (photoPath != null) 'photo_path': photoPath,
      if (degree != null) 'degree': degree,
      if (branch != null) 'branch': branch,
      if (year != null) 'year': year,
      if (semester != null) 'semester': semester,
      if (college != null) 'college': college,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (enrollmentNumber != null) 'enrollment_number': enrollmentNumber,
      if (apaarId != null) 'apaar_id': apaarId,
      if (semesterStartDate != null) 'semester_start_date': semesterStartDate,
      if (semesterEndDate != null) 'semester_end_date': semesterEndDate,
      if (gradingScheme != null) 'grading_scheme': gradingScheme,
      if (targetCgpa != null) 'target_cgpa': targetCgpa,
      if (attendanceRuleThreshold != null)
        'attendance_rule_threshold': attendanceRuleThreshold,
      if (emergencyContactName != null)
        'emergency_contact_name': emergencyContactName,
      if (emergencyContactPhone != null)
        'emergency_contact_phone': emergencyContactPhone,
      if (onboardingCompleted != null)
        'onboarding_completed': onboardingCompleted,
      if (setupStep != null) 'setup_step': setupStep,
      if (isAppLockEnabled != null) 'is_app_lock_enabled': isAppLockEnabled,
      if (pinCodeHash != null) 'pin_code_hash': pinCodeHash,
      if (useBiometrics != null) 'use_biometrics': useBiometrics,
      if (upiId != null) 'upi_id': upiId,
      if (selectedCampusId != null) 'selected_campus_id': selectedCampusId,
      if (selectedCampusName != null)
        'selected_campus_name': selectedCampusName,
      if (preferredLanguage != null) 'preferred_language': preferredLanguage,
      if (notificationsEnabled != null)
        'notifications_enabled': notificationsEnabled,
      if (tutorialCompleted != null) 'tutorial_completed': tutorialCompleted,
      if (mapFilePath != null) 'map_file_path': mapFilePath,
      if (mapVersion != null) 'map_version': mapVersion,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudentProfileTableCompanion copyWith({
    Value<String>? id,
    Value<String>? fullName,
    Value<String?>? photoPath,
    Value<String>? degree,
    Value<String>? branch,
    Value<int>? year,
    Value<int>? semester,
    Value<String>? college,
    Value<String>? city,
    Value<String>? state,
    Value<String>? enrollmentNumber,
    Value<String?>? apaarId,
    Value<DateTime?>? semesterStartDate,
    Value<DateTime?>? semesterEndDate,
    Value<String>? gradingScheme,
    Value<double>? targetCgpa,
    Value<double>? attendanceRuleThreshold,
    Value<String?>? emergencyContactName,
    Value<String?>? emergencyContactPhone,
    Value<bool>? onboardingCompleted,
    Value<int>? setupStep,
    Value<bool>? isAppLockEnabled,
    Value<String?>? pinCodeHash,
    Value<bool>? useBiometrics,
    Value<String>? upiId,
    Value<String>? selectedCampusId,
    Value<String>? selectedCampusName,
    Value<String>? preferredLanguage,
    Value<bool>? notificationsEnabled,
    Value<bool>? tutorialCompleted,
    Value<String?>? mapFilePath,
    Value<String?>? mapVersion,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return StudentProfileTableCompanion(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      photoPath: photoPath ?? this.photoPath,
      degree: degree ?? this.degree,
      branch: branch ?? this.branch,
      year: year ?? this.year,
      semester: semester ?? this.semester,
      college: college ?? this.college,
      city: city ?? this.city,
      state: state ?? this.state,
      enrollmentNumber: enrollmentNumber ?? this.enrollmentNumber,
      apaarId: apaarId ?? this.apaarId,
      semesterStartDate: semesterStartDate ?? this.semesterStartDate,
      semesterEndDate: semesterEndDate ?? this.semesterEndDate,
      gradingScheme: gradingScheme ?? this.gradingScheme,
      targetCgpa: targetCgpa ?? this.targetCgpa,
      attendanceRuleThreshold:
          attendanceRuleThreshold ?? this.attendanceRuleThreshold,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone:
          emergencyContactPhone ?? this.emergencyContactPhone,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      setupStep: setupStep ?? this.setupStep,
      isAppLockEnabled: isAppLockEnabled ?? this.isAppLockEnabled,
      pinCodeHash: pinCodeHash ?? this.pinCodeHash,
      useBiometrics: useBiometrics ?? this.useBiometrics,
      upiId: upiId ?? this.upiId,
      selectedCampusId: selectedCampusId ?? this.selectedCampusId,
      selectedCampusName: selectedCampusName ?? this.selectedCampusName,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      tutorialCompleted: tutorialCompleted ?? this.tutorialCompleted,
      mapFilePath: mapFilePath ?? this.mapFilePath,
      mapVersion: mapVersion ?? this.mapVersion,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (degree.present) {
      map['degree'] = Variable<String>(degree.value);
    }
    if (branch.present) {
      map['branch'] = Variable<String>(branch.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (semester.present) {
      map['semester'] = Variable<int>(semester.value);
    }
    if (college.present) {
      map['college'] = Variable<String>(college.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (enrollmentNumber.present) {
      map['enrollment_number'] = Variable<String>(enrollmentNumber.value);
    }
    if (apaarId.present) {
      map['apaar_id'] = Variable<String>(apaarId.value);
    }
    if (semesterStartDate.present) {
      map['semester_start_date'] = Variable<DateTime>(semesterStartDate.value);
    }
    if (semesterEndDate.present) {
      map['semester_end_date'] = Variable<DateTime>(semesterEndDate.value);
    }
    if (gradingScheme.present) {
      map['grading_scheme'] = Variable<String>(gradingScheme.value);
    }
    if (targetCgpa.present) {
      map['target_cgpa'] = Variable<double>(targetCgpa.value);
    }
    if (attendanceRuleThreshold.present) {
      map['attendance_rule_threshold'] = Variable<double>(
        attendanceRuleThreshold.value,
      );
    }
    if (emergencyContactName.present) {
      map['emergency_contact_name'] = Variable<String>(
        emergencyContactName.value,
      );
    }
    if (emergencyContactPhone.present) {
      map['emergency_contact_phone'] = Variable<String>(
        emergencyContactPhone.value,
      );
    }
    if (onboardingCompleted.present) {
      map['onboarding_completed'] = Variable<bool>(onboardingCompleted.value);
    }
    if (setupStep.present) {
      map['setup_step'] = Variable<int>(setupStep.value);
    }
    if (isAppLockEnabled.present) {
      map['is_app_lock_enabled'] = Variable<bool>(isAppLockEnabled.value);
    }
    if (pinCodeHash.present) {
      map['pin_code_hash'] = Variable<String>(pinCodeHash.value);
    }
    if (useBiometrics.present) {
      map['use_biometrics'] = Variable<bool>(useBiometrics.value);
    }
    if (upiId.present) {
      map['upi_id'] = Variable<String>(upiId.value);
    }
    if (selectedCampusId.present) {
      map['selected_campus_id'] = Variable<String>(selectedCampusId.value);
    }
    if (selectedCampusName.present) {
      map['selected_campus_name'] = Variable<String>(selectedCampusName.value);
    }
    if (preferredLanguage.present) {
      map['preferred_language'] = Variable<String>(preferredLanguage.value);
    }
    if (notificationsEnabled.present) {
      map['notifications_enabled'] = Variable<bool>(notificationsEnabled.value);
    }
    if (tutorialCompleted.present) {
      map['tutorial_completed'] = Variable<bool>(tutorialCompleted.value);
    }
    if (mapFilePath.present) {
      map['map_file_path'] = Variable<String>(mapFilePath.value);
    }
    if (mapVersion.present) {
      map['map_version'] = Variable<String>(mapVersion.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudentProfileTableCompanion(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('photoPath: $photoPath, ')
          ..write('degree: $degree, ')
          ..write('branch: $branch, ')
          ..write('year: $year, ')
          ..write('semester: $semester, ')
          ..write('college: $college, ')
          ..write('city: $city, ')
          ..write('state: $state, ')
          ..write('enrollmentNumber: $enrollmentNumber, ')
          ..write('apaarId: $apaarId, ')
          ..write('semesterStartDate: $semesterStartDate, ')
          ..write('semesterEndDate: $semesterEndDate, ')
          ..write('gradingScheme: $gradingScheme, ')
          ..write('targetCgpa: $targetCgpa, ')
          ..write('attendanceRuleThreshold: $attendanceRuleThreshold, ')
          ..write('emergencyContactName: $emergencyContactName, ')
          ..write('emergencyContactPhone: $emergencyContactPhone, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('setupStep: $setupStep, ')
          ..write('isAppLockEnabled: $isAppLockEnabled, ')
          ..write('pinCodeHash: $pinCodeHash, ')
          ..write('useBiometrics: $useBiometrics, ')
          ..write('upiId: $upiId, ')
          ..write('selectedCampusId: $selectedCampusId, ')
          ..write('selectedCampusName: $selectedCampusName, ')
          ..write('preferredLanguage: $preferredLanguage, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('tutorialCompleted: $tutorialCompleted, ')
          ..write('mapFilePath: $mapFilePath, ')
          ..write('mapVersion: $mapVersion, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PastPapersTableTable extends PastPapersTable
    with TableInfo<$PastPapersTableTable, PastPapersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PastPapersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _courseCodeMeta = const VerificationMeta(
    'courseCode',
  );
  @override
  late final GeneratedColumn<String> courseCode = GeneratedColumn<String>(
    'course_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _courseNameMeta = const VerificationMeta(
    'courseName',
  );
  @override
  late final GeneratedColumn<String> courseName = GeneratedColumn<String>(
    'course_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _examTypeMeta = const VerificationMeta(
    'examType',
  );
  @override
  late final GeneratedColumn<String> examType = GeneratedColumn<String>(
    'exam_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileUrlMeta = const VerificationMeta(
    'fileUrl',
  );
  @override
  late final GeneratedColumn<String> fileUrl = GeneratedColumn<String>(
    'file_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _semesterMeta = const VerificationMeta(
    'semester',
  );
  @override
  late final GeneratedColumn<int> semester = GeneratedColumn<int>(
    'semester',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    courseCode,
    courseName,
    year,
    examType,
    fileUrl,
    semester,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'past_papers_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PastPapersTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('course_code')) {
      context.handle(
        _courseCodeMeta,
        courseCode.isAcceptableOrUnknown(data['course_code']!, _courseCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_courseCodeMeta);
    }
    if (data.containsKey('course_name')) {
      context.handle(
        _courseNameMeta,
        courseName.isAcceptableOrUnknown(data['course_name']!, _courseNameMeta),
      );
    } else if (isInserting) {
      context.missing(_courseNameMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('exam_type')) {
      context.handle(
        _examTypeMeta,
        examType.isAcceptableOrUnknown(data['exam_type']!, _examTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_examTypeMeta);
    }
    if (data.containsKey('file_url')) {
      context.handle(
        _fileUrlMeta,
        fileUrl.isAcceptableOrUnknown(data['file_url']!, _fileUrlMeta),
      );
    }
    if (data.containsKey('semester')) {
      context.handle(
        _semesterMeta,
        semester.isAcceptableOrUnknown(data['semester']!, _semesterMeta),
      );
    } else if (isInserting) {
      context.missing(_semesterMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PastPapersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PastPapersTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      courseCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}course_code'],
      )!,
      courseName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}course_name'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      examType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exam_type'],
      )!,
      fileUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_url'],
      ),
      semester: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}semester'],
      )!,
    );
  }

  @override
  $PastPapersTableTable createAlias(String alias) {
    return $PastPapersTableTable(attachedDatabase, alias);
  }
}

class PastPapersTableData extends DataClass
    implements Insertable<PastPapersTableData> {
  final String id;
  final String courseCode;
  final String courseName;
  final int year;
  final String examType;
  final String? fileUrl;
  final int semester;
  const PastPapersTableData({
    required this.id,
    required this.courseCode,
    required this.courseName,
    required this.year,
    required this.examType,
    this.fileUrl,
    required this.semester,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['course_code'] = Variable<String>(courseCode);
    map['course_name'] = Variable<String>(courseName);
    map['year'] = Variable<int>(year);
    map['exam_type'] = Variable<String>(examType);
    if (!nullToAbsent || fileUrl != null) {
      map['file_url'] = Variable<String>(fileUrl);
    }
    map['semester'] = Variable<int>(semester);
    return map;
  }

  PastPapersTableCompanion toCompanion(bool nullToAbsent) {
    return PastPapersTableCompanion(
      id: Value(id),
      courseCode: Value(courseCode),
      courseName: Value(courseName),
      year: Value(year),
      examType: Value(examType),
      fileUrl: fileUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(fileUrl),
      semester: Value(semester),
    );
  }

  factory PastPapersTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PastPapersTableData(
      id: serializer.fromJson<String>(json['id']),
      courseCode: serializer.fromJson<String>(json['courseCode']),
      courseName: serializer.fromJson<String>(json['courseName']),
      year: serializer.fromJson<int>(json['year']),
      examType: serializer.fromJson<String>(json['examType']),
      fileUrl: serializer.fromJson<String?>(json['fileUrl']),
      semester: serializer.fromJson<int>(json['semester']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'courseCode': serializer.toJson<String>(courseCode),
      'courseName': serializer.toJson<String>(courseName),
      'year': serializer.toJson<int>(year),
      'examType': serializer.toJson<String>(examType),
      'fileUrl': serializer.toJson<String?>(fileUrl),
      'semester': serializer.toJson<int>(semester),
    };
  }

  PastPapersTableData copyWith({
    String? id,
    String? courseCode,
    String? courseName,
    int? year,
    String? examType,
    Value<String?> fileUrl = const Value.absent(),
    int? semester,
  }) => PastPapersTableData(
    id: id ?? this.id,
    courseCode: courseCode ?? this.courseCode,
    courseName: courseName ?? this.courseName,
    year: year ?? this.year,
    examType: examType ?? this.examType,
    fileUrl: fileUrl.present ? fileUrl.value : this.fileUrl,
    semester: semester ?? this.semester,
  );
  PastPapersTableData copyWithCompanion(PastPapersTableCompanion data) {
    return PastPapersTableData(
      id: data.id.present ? data.id.value : this.id,
      courseCode: data.courseCode.present
          ? data.courseCode.value
          : this.courseCode,
      courseName: data.courseName.present
          ? data.courseName.value
          : this.courseName,
      year: data.year.present ? data.year.value : this.year,
      examType: data.examType.present ? data.examType.value : this.examType,
      fileUrl: data.fileUrl.present ? data.fileUrl.value : this.fileUrl,
      semester: data.semester.present ? data.semester.value : this.semester,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PastPapersTableData(')
          ..write('id: $id, ')
          ..write('courseCode: $courseCode, ')
          ..write('courseName: $courseName, ')
          ..write('year: $year, ')
          ..write('examType: $examType, ')
          ..write('fileUrl: $fileUrl, ')
          ..write('semester: $semester')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    courseCode,
    courseName,
    year,
    examType,
    fileUrl,
    semester,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PastPapersTableData &&
          other.id == this.id &&
          other.courseCode == this.courseCode &&
          other.courseName == this.courseName &&
          other.year == this.year &&
          other.examType == this.examType &&
          other.fileUrl == this.fileUrl &&
          other.semester == this.semester);
}

class PastPapersTableCompanion extends UpdateCompanion<PastPapersTableData> {
  final Value<String> id;
  final Value<String> courseCode;
  final Value<String> courseName;
  final Value<int> year;
  final Value<String> examType;
  final Value<String?> fileUrl;
  final Value<int> semester;
  final Value<int> rowid;
  const PastPapersTableCompanion({
    this.id = const Value.absent(),
    this.courseCode = const Value.absent(),
    this.courseName = const Value.absent(),
    this.year = const Value.absent(),
    this.examType = const Value.absent(),
    this.fileUrl = const Value.absent(),
    this.semester = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PastPapersTableCompanion.insert({
    required String id,
    required String courseCode,
    required String courseName,
    required int year,
    required String examType,
    this.fileUrl = const Value.absent(),
    required int semester,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       courseCode = Value(courseCode),
       courseName = Value(courseName),
       year = Value(year),
       examType = Value(examType),
       semester = Value(semester);
  static Insertable<PastPapersTableData> custom({
    Expression<String>? id,
    Expression<String>? courseCode,
    Expression<String>? courseName,
    Expression<int>? year,
    Expression<String>? examType,
    Expression<String>? fileUrl,
    Expression<int>? semester,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (courseCode != null) 'course_code': courseCode,
      if (courseName != null) 'course_name': courseName,
      if (year != null) 'year': year,
      if (examType != null) 'exam_type': examType,
      if (fileUrl != null) 'file_url': fileUrl,
      if (semester != null) 'semester': semester,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PastPapersTableCompanion copyWith({
    Value<String>? id,
    Value<String>? courseCode,
    Value<String>? courseName,
    Value<int>? year,
    Value<String>? examType,
    Value<String?>? fileUrl,
    Value<int>? semester,
    Value<int>? rowid,
  }) {
    return PastPapersTableCompanion(
      id: id ?? this.id,
      courseCode: courseCode ?? this.courseCode,
      courseName: courseName ?? this.courseName,
      year: year ?? this.year,
      examType: examType ?? this.examType,
      fileUrl: fileUrl ?? this.fileUrl,
      semester: semester ?? this.semester,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (courseCode.present) {
      map['course_code'] = Variable<String>(courseCode.value);
    }
    if (courseName.present) {
      map['course_name'] = Variable<String>(courseName.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (examType.present) {
      map['exam_type'] = Variable<String>(examType.value);
    }
    if (fileUrl.present) {
      map['file_url'] = Variable<String>(fileUrl.value);
    }
    if (semester.present) {
      map['semester'] = Variable<int>(semester.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PastPapersTableCompanion(')
          ..write('id: $id, ')
          ..write('courseCode: $courseCode, ')
          ..write('courseName: $courseName, ')
          ..write('year: $year, ')
          ..write('examType: $examType, ')
          ..write('fileUrl: $fileUrl, ')
          ..write('semester: $semester, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StudyPlansTableTable extends StudyPlansTable
    with TableInfo<$StudyPlansTableTable, StudyPlansTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudyPlansTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _courseCodeMeta = const VerificationMeta(
    'courseCode',
  );
  @override
  late final GeneratedColumn<String> courseCode = GeneratedColumn<String>(
    'course_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetDateMeta = const VerificationMeta(
    'targetDate',
  );
  @override
  late final GeneratedColumn<DateTime> targetDate = GeneratedColumn<DateTime>(
    'target_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalHoursMeta = const VerificationMeta(
    'totalHours',
  );
  @override
  late final GeneratedColumn<double> totalHours = GeneratedColumn<double>(
    'total_hours',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedHoursMeta = const VerificationMeta(
    'completedHours',
  );
  @override
  late final GeneratedColumn<double> completedHours = GeneratedColumn<double>(
    'completed_hours',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ACTIVE'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    courseCode,
    targetDate,
    totalHours,
    completedHours,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_plans_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudyPlansTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('course_code')) {
      context.handle(
        _courseCodeMeta,
        courseCode.isAcceptableOrUnknown(data['course_code']!, _courseCodeMeta),
      );
    }
    if (data.containsKey('target_date')) {
      context.handle(
        _targetDateMeta,
        targetDate.isAcceptableOrUnknown(data['target_date']!, _targetDateMeta),
      );
    } else if (isInserting) {
      context.missing(_targetDateMeta);
    }
    if (data.containsKey('total_hours')) {
      context.handle(
        _totalHoursMeta,
        totalHours.isAcceptableOrUnknown(data['total_hours']!, _totalHoursMeta),
      );
    } else if (isInserting) {
      context.missing(_totalHoursMeta);
    }
    if (data.containsKey('completed_hours')) {
      context.handle(
        _completedHoursMeta,
        completedHours.isAcceptableOrUnknown(
          data['completed_hours']!,
          _completedHoursMeta,
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
  StudyPlansTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudyPlansTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      courseCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}course_code'],
      ),
      targetDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}target_date'],
      )!,
      totalHours: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_hours'],
      )!,
      completedHours: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}completed_hours'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $StudyPlansTableTable createAlias(String alias) {
    return $StudyPlansTableTable(attachedDatabase, alias);
  }
}

class StudyPlansTableData extends DataClass
    implements Insertable<StudyPlansTableData> {
  final String id;
  final String title;
  final String? courseCode;
  final DateTime targetDate;
  final double totalHours;
  final double completedHours;
  final String status;
  const StudyPlansTableData({
    required this.id,
    required this.title,
    this.courseCode,
    required this.targetDate,
    required this.totalHours,
    required this.completedHours,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || courseCode != null) {
      map['course_code'] = Variable<String>(courseCode);
    }
    map['target_date'] = Variable<DateTime>(targetDate);
    map['total_hours'] = Variable<double>(totalHours);
    map['completed_hours'] = Variable<double>(completedHours);
    map['status'] = Variable<String>(status);
    return map;
  }

  StudyPlansTableCompanion toCompanion(bool nullToAbsent) {
    return StudyPlansTableCompanion(
      id: Value(id),
      title: Value(title),
      courseCode: courseCode == null && nullToAbsent
          ? const Value.absent()
          : Value(courseCode),
      targetDate: Value(targetDate),
      totalHours: Value(totalHours),
      completedHours: Value(completedHours),
      status: Value(status),
    );
  }

  factory StudyPlansTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudyPlansTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      courseCode: serializer.fromJson<String?>(json['courseCode']),
      targetDate: serializer.fromJson<DateTime>(json['targetDate']),
      totalHours: serializer.fromJson<double>(json['totalHours']),
      completedHours: serializer.fromJson<double>(json['completedHours']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'courseCode': serializer.toJson<String?>(courseCode),
      'targetDate': serializer.toJson<DateTime>(targetDate),
      'totalHours': serializer.toJson<double>(totalHours),
      'completedHours': serializer.toJson<double>(completedHours),
      'status': serializer.toJson<String>(status),
    };
  }

  StudyPlansTableData copyWith({
    String? id,
    String? title,
    Value<String?> courseCode = const Value.absent(),
    DateTime? targetDate,
    double? totalHours,
    double? completedHours,
    String? status,
  }) => StudyPlansTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    courseCode: courseCode.present ? courseCode.value : this.courseCode,
    targetDate: targetDate ?? this.targetDate,
    totalHours: totalHours ?? this.totalHours,
    completedHours: completedHours ?? this.completedHours,
    status: status ?? this.status,
  );
  StudyPlansTableData copyWithCompanion(StudyPlansTableCompanion data) {
    return StudyPlansTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      courseCode: data.courseCode.present
          ? data.courseCode.value
          : this.courseCode,
      targetDate: data.targetDate.present
          ? data.targetDate.value
          : this.targetDate,
      totalHours: data.totalHours.present
          ? data.totalHours.value
          : this.totalHours,
      completedHours: data.completedHours.present
          ? data.completedHours.value
          : this.completedHours,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudyPlansTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('courseCode: $courseCode, ')
          ..write('targetDate: $targetDate, ')
          ..write('totalHours: $totalHours, ')
          ..write('completedHours: $completedHours, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    courseCode,
    targetDate,
    totalHours,
    completedHours,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudyPlansTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.courseCode == this.courseCode &&
          other.targetDate == this.targetDate &&
          other.totalHours == this.totalHours &&
          other.completedHours == this.completedHours &&
          other.status == this.status);
}

class StudyPlansTableCompanion extends UpdateCompanion<StudyPlansTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> courseCode;
  final Value<DateTime> targetDate;
  final Value<double> totalHours;
  final Value<double> completedHours;
  final Value<String> status;
  final Value<int> rowid;
  const StudyPlansTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.courseCode = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.totalHours = const Value.absent(),
    this.completedHours = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudyPlansTableCompanion.insert({
    required String id,
    required String title,
    this.courseCode = const Value.absent(),
    required DateTime targetDate,
    required double totalHours,
    this.completedHours = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       targetDate = Value(targetDate),
       totalHours = Value(totalHours);
  static Insertable<StudyPlansTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? courseCode,
    Expression<DateTime>? targetDate,
    Expression<double>? totalHours,
    Expression<double>? completedHours,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (courseCode != null) 'course_code': courseCode,
      if (targetDate != null) 'target_date': targetDate,
      if (totalHours != null) 'total_hours': totalHours,
      if (completedHours != null) 'completed_hours': completedHours,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudyPlansTableCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? courseCode,
    Value<DateTime>? targetDate,
    Value<double>? totalHours,
    Value<double>? completedHours,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return StudyPlansTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      courseCode: courseCode ?? this.courseCode,
      targetDate: targetDate ?? this.targetDate,
      totalHours: totalHours ?? this.totalHours,
      completedHours: completedHours ?? this.completedHours,
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
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (courseCode.present) {
      map['course_code'] = Variable<String>(courseCode.value);
    }
    if (targetDate.present) {
      map['target_date'] = Variable<DateTime>(targetDate.value);
    }
    if (totalHours.present) {
      map['total_hours'] = Variable<double>(totalHours.value);
    }
    if (completedHours.present) {
      map['completed_hours'] = Variable<double>(completedHours.value);
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
    return (StringBuffer('StudyPlansTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('courseCode: $courseCode, ')
          ..write('targetDate: $targetDate, ')
          ..write('totalHours: $totalHours, ')
          ..write('completedHours: $completedHours, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GroupProjectsTableTable extends GroupProjectsTable
    with TableInfo<$GroupProjectsTableTable, GroupProjectsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupProjectsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _courseCodeMeta = const VerificationMeta(
    'courseCode',
  );
  @override
  late final GeneratedColumn<String> courseCode = GeneratedColumn<String>(
    'course_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _teamMembersMeta = const VerificationMeta(
    'teamMembers',
  );
  @override
  late final GeneratedColumn<String> teamMembers = GeneratedColumn<String>(
    'team_members',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _progressMeta = const VerificationMeta(
    'progress',
  );
  @override
  late final GeneratedColumn<double> progress = GeneratedColumn<double>(
    'progress',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    courseCode,
    description,
    teamMembers,
    dueDate,
    progress,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'group_projects_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<GroupProjectsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('course_code')) {
      context.handle(
        _courseCodeMeta,
        courseCode.isAcceptableOrUnknown(data['course_code']!, _courseCodeMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('team_members')) {
      context.handle(
        _teamMembersMeta,
        teamMembers.isAcceptableOrUnknown(
          data['team_members']!,
          _teamMembersMeta,
        ),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('progress')) {
      context.handle(
        _progressMeta,
        progress.isAcceptableOrUnknown(data['progress']!, _progressMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GroupProjectsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupProjectsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      courseCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}course_code'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      teamMembers: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}team_members'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      )!,
      progress: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}progress'],
      )!,
    );
  }

  @override
  $GroupProjectsTableTable createAlias(String alias) {
    return $GroupProjectsTableTable(attachedDatabase, alias);
  }
}

class GroupProjectsTableData extends DataClass
    implements Insertable<GroupProjectsTableData> {
  final String id;
  final String title;
  final String? courseCode;
  final String description;
  final String teamMembers;
  final DateTime dueDate;
  final double progress;
  const GroupProjectsTableData({
    required this.id,
    required this.title,
    this.courseCode,
    required this.description,
    required this.teamMembers,
    required this.dueDate,
    required this.progress,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || courseCode != null) {
      map['course_code'] = Variable<String>(courseCode);
    }
    map['description'] = Variable<String>(description);
    map['team_members'] = Variable<String>(teamMembers);
    map['due_date'] = Variable<DateTime>(dueDate);
    map['progress'] = Variable<double>(progress);
    return map;
  }

  GroupProjectsTableCompanion toCompanion(bool nullToAbsent) {
    return GroupProjectsTableCompanion(
      id: Value(id),
      title: Value(title),
      courseCode: courseCode == null && nullToAbsent
          ? const Value.absent()
          : Value(courseCode),
      description: Value(description),
      teamMembers: Value(teamMembers),
      dueDate: Value(dueDate),
      progress: Value(progress),
    );
  }

  factory GroupProjectsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupProjectsTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      courseCode: serializer.fromJson<String?>(json['courseCode']),
      description: serializer.fromJson<String>(json['description']),
      teamMembers: serializer.fromJson<String>(json['teamMembers']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      progress: serializer.fromJson<double>(json['progress']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'courseCode': serializer.toJson<String?>(courseCode),
      'description': serializer.toJson<String>(description),
      'teamMembers': serializer.toJson<String>(teamMembers),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'progress': serializer.toJson<double>(progress),
    };
  }

  GroupProjectsTableData copyWith({
    String? id,
    String? title,
    Value<String?> courseCode = const Value.absent(),
    String? description,
    String? teamMembers,
    DateTime? dueDate,
    double? progress,
  }) => GroupProjectsTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    courseCode: courseCode.present ? courseCode.value : this.courseCode,
    description: description ?? this.description,
    teamMembers: teamMembers ?? this.teamMembers,
    dueDate: dueDate ?? this.dueDate,
    progress: progress ?? this.progress,
  );
  GroupProjectsTableData copyWithCompanion(GroupProjectsTableCompanion data) {
    return GroupProjectsTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      courseCode: data.courseCode.present
          ? data.courseCode.value
          : this.courseCode,
      description: data.description.present
          ? data.description.value
          : this.description,
      teamMembers: data.teamMembers.present
          ? data.teamMembers.value
          : this.teamMembers,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      progress: data.progress.present ? data.progress.value : this.progress,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupProjectsTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('courseCode: $courseCode, ')
          ..write('description: $description, ')
          ..write('teamMembers: $teamMembers, ')
          ..write('dueDate: $dueDate, ')
          ..write('progress: $progress')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    courseCode,
    description,
    teamMembers,
    dueDate,
    progress,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupProjectsTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.courseCode == this.courseCode &&
          other.description == this.description &&
          other.teamMembers == this.teamMembers &&
          other.dueDate == this.dueDate &&
          other.progress == this.progress);
}

class GroupProjectsTableCompanion
    extends UpdateCompanion<GroupProjectsTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> courseCode;
  final Value<String> description;
  final Value<String> teamMembers;
  final Value<DateTime> dueDate;
  final Value<double> progress;
  final Value<int> rowid;
  const GroupProjectsTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.courseCode = const Value.absent(),
    this.description = const Value.absent(),
    this.teamMembers = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.progress = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GroupProjectsTableCompanion.insert({
    required String id,
    required String title,
    this.courseCode = const Value.absent(),
    this.description = const Value.absent(),
    this.teamMembers = const Value.absent(),
    required DateTime dueDate,
    this.progress = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       dueDate = Value(dueDate);
  static Insertable<GroupProjectsTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? courseCode,
    Expression<String>? description,
    Expression<String>? teamMembers,
    Expression<DateTime>? dueDate,
    Expression<double>? progress,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (courseCode != null) 'course_code': courseCode,
      if (description != null) 'description': description,
      if (teamMembers != null) 'team_members': teamMembers,
      if (dueDate != null) 'due_date': dueDate,
      if (progress != null) 'progress': progress,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GroupProjectsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? courseCode,
    Value<String>? description,
    Value<String>? teamMembers,
    Value<DateTime>? dueDate,
    Value<double>? progress,
    Value<int>? rowid,
  }) {
    return GroupProjectsTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      courseCode: courseCode ?? this.courseCode,
      description: description ?? this.description,
      teamMembers: teamMembers ?? this.teamMembers,
      dueDate: dueDate ?? this.dueDate,
      progress: progress ?? this.progress,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (courseCode.present) {
      map['course_code'] = Variable<String>(courseCode.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (teamMembers.present) {
      map['team_members'] = Variable<String>(teamMembers.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (progress.present) {
      map['progress'] = Variable<double>(progress.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupProjectsTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('courseCode: $courseCode, ')
          ..write('description: $description, ')
          ..write('teamMembers: $teamMembers, ')
          ..write('dueDate: $dueDate, ')
          ..write('progress: $progress, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OfficeHoursTableTable extends OfficeHoursTable
    with TableInfo<$OfficeHoursTableTable, OfficeHoursTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OfficeHoursTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _facultyNameMeta = const VerificationMeta(
    'facultyName',
  );
  @override
  late final GeneratedColumn<String> facultyName = GeneratedColumn<String>(
    'faculty_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _departmentMeta = const VerificationMeta(
    'department',
  );
  @override
  late final GeneratedColumn<String> department = GeneratedColumn<String>(
    'department',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _courseCodeMeta = const VerificationMeta(
    'courseCode',
  );
  @override
  late final GeneratedColumn<String> courseCode = GeneratedColumn<String>(
    'course_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dayOfWeekMeta = const VerificationMeta(
    'dayOfWeek',
  );
  @override
  late final GeneratedColumn<int> dayOfWeek = GeneratedColumn<int>(
    'day_of_week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeSlotMeta = const VerificationMeta(
    'timeSlot',
  );
  @override
  late final GeneratedColumn<String> timeSlot = GeneratedColumn<String>(
    'time_slot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bookingStatusMeta = const VerificationMeta(
    'bookingStatus',
  );
  @override
  late final GeneratedColumn<String> bookingStatus = GeneratedColumn<String>(
    'booking_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('AVAILABLE'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    facultyName,
    department,
    courseCode,
    dayOfWeek,
    timeSlot,
    location,
    bookingStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'office_hours_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<OfficeHoursTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('faculty_name')) {
      context.handle(
        _facultyNameMeta,
        facultyName.isAcceptableOrUnknown(
          data['faculty_name']!,
          _facultyNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_facultyNameMeta);
    }
    if (data.containsKey('department')) {
      context.handle(
        _departmentMeta,
        department.isAcceptableOrUnknown(data['department']!, _departmentMeta),
      );
    } else if (isInserting) {
      context.missing(_departmentMeta);
    }
    if (data.containsKey('course_code')) {
      context.handle(
        _courseCodeMeta,
        courseCode.isAcceptableOrUnknown(data['course_code']!, _courseCodeMeta),
      );
    }
    if (data.containsKey('day_of_week')) {
      context.handle(
        _dayOfWeekMeta,
        dayOfWeek.isAcceptableOrUnknown(data['day_of_week']!, _dayOfWeekMeta),
      );
    } else if (isInserting) {
      context.missing(_dayOfWeekMeta);
    }
    if (data.containsKey('time_slot')) {
      context.handle(
        _timeSlotMeta,
        timeSlot.isAcceptableOrUnknown(data['time_slot']!, _timeSlotMeta),
      );
    } else if (isInserting) {
      context.missing(_timeSlotMeta);
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    } else if (isInserting) {
      context.missing(_locationMeta);
    }
    if (data.containsKey('booking_status')) {
      context.handle(
        _bookingStatusMeta,
        bookingStatus.isAcceptableOrUnknown(
          data['booking_status']!,
          _bookingStatusMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OfficeHoursTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OfficeHoursTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      facultyName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}faculty_name'],
      )!,
      department: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}department'],
      )!,
      courseCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}course_code'],
      ),
      dayOfWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_of_week'],
      )!,
      timeSlot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_slot'],
      )!,
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      )!,
      bookingStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}booking_status'],
      )!,
    );
  }

  @override
  $OfficeHoursTableTable createAlias(String alias) {
    return $OfficeHoursTableTable(attachedDatabase, alias);
  }
}

class OfficeHoursTableData extends DataClass
    implements Insertable<OfficeHoursTableData> {
  final String id;
  final String facultyName;
  final String department;
  final String? courseCode;
  final int dayOfWeek;
  final String timeSlot;
  final String location;
  final String bookingStatus;
  const OfficeHoursTableData({
    required this.id,
    required this.facultyName,
    required this.department,
    this.courseCode,
    required this.dayOfWeek,
    required this.timeSlot,
    required this.location,
    required this.bookingStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['faculty_name'] = Variable<String>(facultyName);
    map['department'] = Variable<String>(department);
    if (!nullToAbsent || courseCode != null) {
      map['course_code'] = Variable<String>(courseCode);
    }
    map['day_of_week'] = Variable<int>(dayOfWeek);
    map['time_slot'] = Variable<String>(timeSlot);
    map['location'] = Variable<String>(location);
    map['booking_status'] = Variable<String>(bookingStatus);
    return map;
  }

  OfficeHoursTableCompanion toCompanion(bool nullToAbsent) {
    return OfficeHoursTableCompanion(
      id: Value(id),
      facultyName: Value(facultyName),
      department: Value(department),
      courseCode: courseCode == null && nullToAbsent
          ? const Value.absent()
          : Value(courseCode),
      dayOfWeek: Value(dayOfWeek),
      timeSlot: Value(timeSlot),
      location: Value(location),
      bookingStatus: Value(bookingStatus),
    );
  }

  factory OfficeHoursTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OfficeHoursTableData(
      id: serializer.fromJson<String>(json['id']),
      facultyName: serializer.fromJson<String>(json['facultyName']),
      department: serializer.fromJson<String>(json['department']),
      courseCode: serializer.fromJson<String?>(json['courseCode']),
      dayOfWeek: serializer.fromJson<int>(json['dayOfWeek']),
      timeSlot: serializer.fromJson<String>(json['timeSlot']),
      location: serializer.fromJson<String>(json['location']),
      bookingStatus: serializer.fromJson<String>(json['bookingStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'facultyName': serializer.toJson<String>(facultyName),
      'department': serializer.toJson<String>(department),
      'courseCode': serializer.toJson<String?>(courseCode),
      'dayOfWeek': serializer.toJson<int>(dayOfWeek),
      'timeSlot': serializer.toJson<String>(timeSlot),
      'location': serializer.toJson<String>(location),
      'bookingStatus': serializer.toJson<String>(bookingStatus),
    };
  }

  OfficeHoursTableData copyWith({
    String? id,
    String? facultyName,
    String? department,
    Value<String?> courseCode = const Value.absent(),
    int? dayOfWeek,
    String? timeSlot,
    String? location,
    String? bookingStatus,
  }) => OfficeHoursTableData(
    id: id ?? this.id,
    facultyName: facultyName ?? this.facultyName,
    department: department ?? this.department,
    courseCode: courseCode.present ? courseCode.value : this.courseCode,
    dayOfWeek: dayOfWeek ?? this.dayOfWeek,
    timeSlot: timeSlot ?? this.timeSlot,
    location: location ?? this.location,
    bookingStatus: bookingStatus ?? this.bookingStatus,
  );
  OfficeHoursTableData copyWithCompanion(OfficeHoursTableCompanion data) {
    return OfficeHoursTableData(
      id: data.id.present ? data.id.value : this.id,
      facultyName: data.facultyName.present
          ? data.facultyName.value
          : this.facultyName,
      department: data.department.present
          ? data.department.value
          : this.department,
      courseCode: data.courseCode.present
          ? data.courseCode.value
          : this.courseCode,
      dayOfWeek: data.dayOfWeek.present ? data.dayOfWeek.value : this.dayOfWeek,
      timeSlot: data.timeSlot.present ? data.timeSlot.value : this.timeSlot,
      location: data.location.present ? data.location.value : this.location,
      bookingStatus: data.bookingStatus.present
          ? data.bookingStatus.value
          : this.bookingStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OfficeHoursTableData(')
          ..write('id: $id, ')
          ..write('facultyName: $facultyName, ')
          ..write('department: $department, ')
          ..write('courseCode: $courseCode, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('timeSlot: $timeSlot, ')
          ..write('location: $location, ')
          ..write('bookingStatus: $bookingStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    facultyName,
    department,
    courseCode,
    dayOfWeek,
    timeSlot,
    location,
    bookingStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OfficeHoursTableData &&
          other.id == this.id &&
          other.facultyName == this.facultyName &&
          other.department == this.department &&
          other.courseCode == this.courseCode &&
          other.dayOfWeek == this.dayOfWeek &&
          other.timeSlot == this.timeSlot &&
          other.location == this.location &&
          other.bookingStatus == this.bookingStatus);
}

class OfficeHoursTableCompanion extends UpdateCompanion<OfficeHoursTableData> {
  final Value<String> id;
  final Value<String> facultyName;
  final Value<String> department;
  final Value<String?> courseCode;
  final Value<int> dayOfWeek;
  final Value<String> timeSlot;
  final Value<String> location;
  final Value<String> bookingStatus;
  final Value<int> rowid;
  const OfficeHoursTableCompanion({
    this.id = const Value.absent(),
    this.facultyName = const Value.absent(),
    this.department = const Value.absent(),
    this.courseCode = const Value.absent(),
    this.dayOfWeek = const Value.absent(),
    this.timeSlot = const Value.absent(),
    this.location = const Value.absent(),
    this.bookingStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OfficeHoursTableCompanion.insert({
    required String id,
    required String facultyName,
    required String department,
    this.courseCode = const Value.absent(),
    required int dayOfWeek,
    required String timeSlot,
    required String location,
    this.bookingStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       facultyName = Value(facultyName),
       department = Value(department),
       dayOfWeek = Value(dayOfWeek),
       timeSlot = Value(timeSlot),
       location = Value(location);
  static Insertable<OfficeHoursTableData> custom({
    Expression<String>? id,
    Expression<String>? facultyName,
    Expression<String>? department,
    Expression<String>? courseCode,
    Expression<int>? dayOfWeek,
    Expression<String>? timeSlot,
    Expression<String>? location,
    Expression<String>? bookingStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (facultyName != null) 'faculty_name': facultyName,
      if (department != null) 'department': department,
      if (courseCode != null) 'course_code': courseCode,
      if (dayOfWeek != null) 'day_of_week': dayOfWeek,
      if (timeSlot != null) 'time_slot': timeSlot,
      if (location != null) 'location': location,
      if (bookingStatus != null) 'booking_status': bookingStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OfficeHoursTableCompanion copyWith({
    Value<String>? id,
    Value<String>? facultyName,
    Value<String>? department,
    Value<String?>? courseCode,
    Value<int>? dayOfWeek,
    Value<String>? timeSlot,
    Value<String>? location,
    Value<String>? bookingStatus,
    Value<int>? rowid,
  }) {
    return OfficeHoursTableCompanion(
      id: id ?? this.id,
      facultyName: facultyName ?? this.facultyName,
      department: department ?? this.department,
      courseCode: courseCode ?? this.courseCode,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      timeSlot: timeSlot ?? this.timeSlot,
      location: location ?? this.location,
      bookingStatus: bookingStatus ?? this.bookingStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (facultyName.present) {
      map['faculty_name'] = Variable<String>(facultyName.value);
    }
    if (department.present) {
      map['department'] = Variable<String>(department.value);
    }
    if (courseCode.present) {
      map['course_code'] = Variable<String>(courseCode.value);
    }
    if (dayOfWeek.present) {
      map['day_of_week'] = Variable<int>(dayOfWeek.value);
    }
    if (timeSlot.present) {
      map['time_slot'] = Variable<String>(timeSlot.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (bookingStatus.present) {
      map['booking_status'] = Variable<String>(bookingStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OfficeHoursTableCompanion(')
          ..write('id: $id, ')
          ..write('facultyName: $facultyName, ')
          ..write('department: $department, ')
          ..write('courseCode: $courseCode, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('timeSlot: $timeSlot, ')
          ..write('location: $location, ')
          ..write('bookingStatus: $bookingStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HealthRecordsTableTable extends HealthRecordsTable
    with TableInfo<$HealthRecordsTableTable, HealthRecordsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HealthRecordsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bloodGroupMeta = const VerificationMeta(
    'bloodGroup',
  );
  @override
  late final GeneratedColumn<String> bloodGroup = GeneratedColumn<String>(
    'blood_group',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _allergiesMeta = const VerificationMeta(
    'allergies',
  );
  @override
  late final GeneratedColumn<String> allergies = GeneratedColumn<String>(
    'allergies',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _medicationsMeta = const VerificationMeta(
    'medications',
  );
  @override
  late final GeneratedColumn<String> medications = GeneratedColumn<String>(
    'medications',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _emergencyInstructionsMeta =
      const VerificationMeta('emergencyInstructions');
  @override
  late final GeneratedColumn<String> emergencyInstructions =
      GeneratedColumn<String>(
        'emergency_instructions',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bloodGroup,
    allergies,
    medications,
    emergencyInstructions,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'health_records_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<HealthRecordsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('blood_group')) {
      context.handle(
        _bloodGroupMeta,
        bloodGroup.isAcceptableOrUnknown(data['blood_group']!, _bloodGroupMeta),
      );
    } else if (isInserting) {
      context.missing(_bloodGroupMeta);
    }
    if (data.containsKey('allergies')) {
      context.handle(
        _allergiesMeta,
        allergies.isAcceptableOrUnknown(data['allergies']!, _allergiesMeta),
      );
    }
    if (data.containsKey('medications')) {
      context.handle(
        _medicationsMeta,
        medications.isAcceptableOrUnknown(
          data['medications']!,
          _medicationsMeta,
        ),
      );
    }
    if (data.containsKey('emergency_instructions')) {
      context.handle(
        _emergencyInstructionsMeta,
        emergencyInstructions.isAcceptableOrUnknown(
          data['emergency_instructions']!,
          _emergencyInstructionsMeta,
        ),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HealthRecordsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HealthRecordsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bloodGroup: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}blood_group'],
      )!,
      allergies: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}allergies'],
      )!,
      medications: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medications'],
      )!,
      emergencyInstructions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emergency_instructions'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $HealthRecordsTableTable createAlias(String alias) {
    return $HealthRecordsTableTable(attachedDatabase, alias);
  }
}

class HealthRecordsTableData extends DataClass
    implements Insertable<HealthRecordsTableData> {
  final String id;
  final String bloodGroup;
  final String allergies;
  final String medications;
  final String emergencyInstructions;
  final DateTime updatedAt;
  const HealthRecordsTableData({
    required this.id,
    required this.bloodGroup,
    required this.allergies,
    required this.medications,
    required this.emergencyInstructions,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['blood_group'] = Variable<String>(bloodGroup);
    map['allergies'] = Variable<String>(allergies);
    map['medications'] = Variable<String>(medications);
    map['emergency_instructions'] = Variable<String>(emergencyInstructions);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  HealthRecordsTableCompanion toCompanion(bool nullToAbsent) {
    return HealthRecordsTableCompanion(
      id: Value(id),
      bloodGroup: Value(bloodGroup),
      allergies: Value(allergies),
      medications: Value(medications),
      emergencyInstructions: Value(emergencyInstructions),
      updatedAt: Value(updatedAt),
    );
  }

  factory HealthRecordsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HealthRecordsTableData(
      id: serializer.fromJson<String>(json['id']),
      bloodGroup: serializer.fromJson<String>(json['bloodGroup']),
      allergies: serializer.fromJson<String>(json['allergies']),
      medications: serializer.fromJson<String>(json['medications']),
      emergencyInstructions: serializer.fromJson<String>(
        json['emergencyInstructions'],
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'bloodGroup': serializer.toJson<String>(bloodGroup),
      'allergies': serializer.toJson<String>(allergies),
      'medications': serializer.toJson<String>(medications),
      'emergencyInstructions': serializer.toJson<String>(emergencyInstructions),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  HealthRecordsTableData copyWith({
    String? id,
    String? bloodGroup,
    String? allergies,
    String? medications,
    String? emergencyInstructions,
    DateTime? updatedAt,
  }) => HealthRecordsTableData(
    id: id ?? this.id,
    bloodGroup: bloodGroup ?? this.bloodGroup,
    allergies: allergies ?? this.allergies,
    medications: medications ?? this.medications,
    emergencyInstructions: emergencyInstructions ?? this.emergencyInstructions,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  HealthRecordsTableData copyWithCompanion(HealthRecordsTableCompanion data) {
    return HealthRecordsTableData(
      id: data.id.present ? data.id.value : this.id,
      bloodGroup: data.bloodGroup.present
          ? data.bloodGroup.value
          : this.bloodGroup,
      allergies: data.allergies.present ? data.allergies.value : this.allergies,
      medications: data.medications.present
          ? data.medications.value
          : this.medications,
      emergencyInstructions: data.emergencyInstructions.present
          ? data.emergencyInstructions.value
          : this.emergencyInstructions,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HealthRecordsTableData(')
          ..write('id: $id, ')
          ..write('bloodGroup: $bloodGroup, ')
          ..write('allergies: $allergies, ')
          ..write('medications: $medications, ')
          ..write('emergencyInstructions: $emergencyInstructions, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    bloodGroup,
    allergies,
    medications,
    emergencyInstructions,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HealthRecordsTableData &&
          other.id == this.id &&
          other.bloodGroup == this.bloodGroup &&
          other.allergies == this.allergies &&
          other.medications == this.medications &&
          other.emergencyInstructions == this.emergencyInstructions &&
          other.updatedAt == this.updatedAt);
}

class HealthRecordsTableCompanion
    extends UpdateCompanion<HealthRecordsTableData> {
  final Value<String> id;
  final Value<String> bloodGroup;
  final Value<String> allergies;
  final Value<String> medications;
  final Value<String> emergencyInstructions;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const HealthRecordsTableCompanion({
    this.id = const Value.absent(),
    this.bloodGroup = const Value.absent(),
    this.allergies = const Value.absent(),
    this.medications = const Value.absent(),
    this.emergencyInstructions = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HealthRecordsTableCompanion.insert({
    required String id,
    required String bloodGroup,
    this.allergies = const Value.absent(),
    this.medications = const Value.absent(),
    this.emergencyInstructions = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bloodGroup = Value(bloodGroup),
       updatedAt = Value(updatedAt);
  static Insertable<HealthRecordsTableData> custom({
    Expression<String>? id,
    Expression<String>? bloodGroup,
    Expression<String>? allergies,
    Expression<String>? medications,
    Expression<String>? emergencyInstructions,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bloodGroup != null) 'blood_group': bloodGroup,
      if (allergies != null) 'allergies': allergies,
      if (medications != null) 'medications': medications,
      if (emergencyInstructions != null)
        'emergency_instructions': emergencyInstructions,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HealthRecordsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? bloodGroup,
    Value<String>? allergies,
    Value<String>? medications,
    Value<String>? emergencyInstructions,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return HealthRecordsTableCompanion(
      id: id ?? this.id,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      allergies: allergies ?? this.allergies,
      medications: medications ?? this.medications,
      emergencyInstructions:
          emergencyInstructions ?? this.emergencyInstructions,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bloodGroup.present) {
      map['blood_group'] = Variable<String>(bloodGroup.value);
    }
    if (allergies.present) {
      map['allergies'] = Variable<String>(allergies.value);
    }
    if (medications.present) {
      map['medications'] = Variable<String>(medications.value);
    }
    if (emergencyInstructions.present) {
      map['emergency_instructions'] = Variable<String>(
        emergencyInstructions.value,
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HealthRecordsTableCompanion(')
          ..write('id: $id, ')
          ..write('bloodGroup: $bloodGroup, ')
          ..write('allergies: $allergies, ')
          ..write('medications: $medications, ')
          ..write('emergencyInstructions: $emergencyInstructions, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SleepLogsTableTable extends SleepLogsTable
    with TableInfo<$SleepLogsTableTable, SleepLogsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SleepLogsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bedTimeMeta = const VerificationMeta(
    'bedTime',
  );
  @override
  late final GeneratedColumn<String> bedTime = GeneratedColumn<String>(
    'bed_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wakeTimeMeta = const VerificationMeta(
    'wakeTime',
  );
  @override
  late final GeneratedColumn<String> wakeTime = GeneratedColumn<String>(
    'wake_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qualityRatingMeta = const VerificationMeta(
    'qualityRating',
  );
  @override
  late final GeneratedColumn<int> qualityRating = GeneratedColumn<int>(
    'quality_rating',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(4),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    bedTime,
    wakeTime,
    durationMinutes,
    qualityRating,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sleep_logs_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SleepLogsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('bed_time')) {
      context.handle(
        _bedTimeMeta,
        bedTime.isAcceptableOrUnknown(data['bed_time']!, _bedTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_bedTimeMeta);
    }
    if (data.containsKey('wake_time')) {
      context.handle(
        _wakeTimeMeta,
        wakeTime.isAcceptableOrUnknown(data['wake_time']!, _wakeTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_wakeTimeMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMinutesMeta);
    }
    if (data.containsKey('quality_rating')) {
      context.handle(
        _qualityRatingMeta,
        qualityRating.isAcceptableOrUnknown(
          data['quality_rating']!,
          _qualityRatingMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SleepLogsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SleepLogsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      bedTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bed_time'],
      )!,
      wakeTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wake_time'],
      )!,
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      )!,
      qualityRating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quality_rating'],
      )!,
    );
  }

  @override
  $SleepLogsTableTable createAlias(String alias) {
    return $SleepLogsTableTable(attachedDatabase, alias);
  }
}

class SleepLogsTableData extends DataClass
    implements Insertable<SleepLogsTableData> {
  final String id;
  final DateTime date;
  final String bedTime;
  final String wakeTime;
  final int durationMinutes;
  final int qualityRating;
  const SleepLogsTableData({
    required this.id,
    required this.date,
    required this.bedTime,
    required this.wakeTime,
    required this.durationMinutes,
    required this.qualityRating,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<DateTime>(date);
    map['bed_time'] = Variable<String>(bedTime);
    map['wake_time'] = Variable<String>(wakeTime);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    map['quality_rating'] = Variable<int>(qualityRating);
    return map;
  }

  SleepLogsTableCompanion toCompanion(bool nullToAbsent) {
    return SleepLogsTableCompanion(
      id: Value(id),
      date: Value(date),
      bedTime: Value(bedTime),
      wakeTime: Value(wakeTime),
      durationMinutes: Value(durationMinutes),
      qualityRating: Value(qualityRating),
    );
  }

  factory SleepLogsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SleepLogsTableData(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      bedTime: serializer.fromJson<String>(json['bedTime']),
      wakeTime: serializer.fromJson<String>(json['wakeTime']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      qualityRating: serializer.fromJson<int>(json['qualityRating']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<DateTime>(date),
      'bedTime': serializer.toJson<String>(bedTime),
      'wakeTime': serializer.toJson<String>(wakeTime),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'qualityRating': serializer.toJson<int>(qualityRating),
    };
  }

  SleepLogsTableData copyWith({
    String? id,
    DateTime? date,
    String? bedTime,
    String? wakeTime,
    int? durationMinutes,
    int? qualityRating,
  }) => SleepLogsTableData(
    id: id ?? this.id,
    date: date ?? this.date,
    bedTime: bedTime ?? this.bedTime,
    wakeTime: wakeTime ?? this.wakeTime,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    qualityRating: qualityRating ?? this.qualityRating,
  );
  SleepLogsTableData copyWithCompanion(SleepLogsTableCompanion data) {
    return SleepLogsTableData(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      bedTime: data.bedTime.present ? data.bedTime.value : this.bedTime,
      wakeTime: data.wakeTime.present ? data.wakeTime.value : this.wakeTime,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      qualityRating: data.qualityRating.present
          ? data.qualityRating.value
          : this.qualityRating,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SleepLogsTableData(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('bedTime: $bedTime, ')
          ..write('wakeTime: $wakeTime, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('qualityRating: $qualityRating')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, date, bedTime, wakeTime, durationMinutes, qualityRating);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SleepLogsTableData &&
          other.id == this.id &&
          other.date == this.date &&
          other.bedTime == this.bedTime &&
          other.wakeTime == this.wakeTime &&
          other.durationMinutes == this.durationMinutes &&
          other.qualityRating == this.qualityRating);
}

class SleepLogsTableCompanion extends UpdateCompanion<SleepLogsTableData> {
  final Value<String> id;
  final Value<DateTime> date;
  final Value<String> bedTime;
  final Value<String> wakeTime;
  final Value<int> durationMinutes;
  final Value<int> qualityRating;
  final Value<int> rowid;
  const SleepLogsTableCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.bedTime = const Value.absent(),
    this.wakeTime = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.qualityRating = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SleepLogsTableCompanion.insert({
    required String id,
    required DateTime date,
    required String bedTime,
    required String wakeTime,
    required int durationMinutes,
    this.qualityRating = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       bedTime = Value(bedTime),
       wakeTime = Value(wakeTime),
       durationMinutes = Value(durationMinutes);
  static Insertable<SleepLogsTableData> custom({
    Expression<String>? id,
    Expression<DateTime>? date,
    Expression<String>? bedTime,
    Expression<String>? wakeTime,
    Expression<int>? durationMinutes,
    Expression<int>? qualityRating,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (bedTime != null) 'bed_time': bedTime,
      if (wakeTime != null) 'wake_time': wakeTime,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (qualityRating != null) 'quality_rating': qualityRating,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SleepLogsTableCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? date,
    Value<String>? bedTime,
    Value<String>? wakeTime,
    Value<int>? durationMinutes,
    Value<int>? qualityRating,
    Value<int>? rowid,
  }) {
    return SleepLogsTableCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      bedTime: bedTime ?? this.bedTime,
      wakeTime: wakeTime ?? this.wakeTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      qualityRating: qualityRating ?? this.qualityRating,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (bedTime.present) {
      map['bed_time'] = Variable<String>(bedTime.value);
    }
    if (wakeTime.present) {
      map['wake_time'] = Variable<String>(wakeTime.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (qualityRating.present) {
      map['quality_rating'] = Variable<int>(qualityRating.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SleepLogsTableCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('bedTime: $bedTime, ')
          ..write('wakeTime: $wakeTime, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('qualityRating: $qualityRating, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NutritionLogsTableTable extends NutritionLogsTable
    with TableInfo<$NutritionLogsTableTable, NutritionLogsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NutritionLogsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mealTypeMeta = const VerificationMeta(
    'mealType',
  );
  @override
  late final GeneratedColumn<String> mealType = GeneratedColumn<String>(
    'meal_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _foodItemsMeta = const VerificationMeta(
    'foodItems',
  );
  @override
  late final GeneratedColumn<String> foodItems = GeneratedColumn<String>(
    'food_items',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<int> calories = GeneratedColumn<int>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isVegMeta = const VerificationMeta('isVeg');
  @override
  late final GeneratedColumn<bool> isVeg = GeneratedColumn<bool>(
    'is_veg',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_veg" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    mealType,
    foodItems,
    calories,
    isVeg,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'nutrition_logs_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<NutritionLogsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('meal_type')) {
      context.handle(
        _mealTypeMeta,
        mealType.isAcceptableOrUnknown(data['meal_type']!, _mealTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mealTypeMeta);
    }
    if (data.containsKey('food_items')) {
      context.handle(
        _foodItemsMeta,
        foodItems.isAcceptableOrUnknown(data['food_items']!, _foodItemsMeta),
      );
    } else if (isInserting) {
      context.missing(_foodItemsMeta);
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    }
    if (data.containsKey('is_veg')) {
      context.handle(
        _isVegMeta,
        isVeg.isAcceptableOrUnknown(data['is_veg']!, _isVegMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NutritionLogsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NutritionLogsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      mealType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_type'],
      )!,
      foodItems: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_items'],
      )!,
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calories'],
      )!,
      isVeg: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_veg'],
      )!,
    );
  }

  @override
  $NutritionLogsTableTable createAlias(String alias) {
    return $NutritionLogsTableTable(attachedDatabase, alias);
  }
}

class NutritionLogsTableData extends DataClass
    implements Insertable<NutritionLogsTableData> {
  final String id;
  final DateTime date;
  final String mealType;
  final String foodItems;
  final int calories;
  final bool isVeg;
  const NutritionLogsTableData({
    required this.id,
    required this.date,
    required this.mealType,
    required this.foodItems,
    required this.calories,
    required this.isVeg,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<DateTime>(date);
    map['meal_type'] = Variable<String>(mealType);
    map['food_items'] = Variable<String>(foodItems);
    map['calories'] = Variable<int>(calories);
    map['is_veg'] = Variable<bool>(isVeg);
    return map;
  }

  NutritionLogsTableCompanion toCompanion(bool nullToAbsent) {
    return NutritionLogsTableCompanion(
      id: Value(id),
      date: Value(date),
      mealType: Value(mealType),
      foodItems: Value(foodItems),
      calories: Value(calories),
      isVeg: Value(isVeg),
    );
  }

  factory NutritionLogsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NutritionLogsTableData(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      mealType: serializer.fromJson<String>(json['mealType']),
      foodItems: serializer.fromJson<String>(json['foodItems']),
      calories: serializer.fromJson<int>(json['calories']),
      isVeg: serializer.fromJson<bool>(json['isVeg']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<DateTime>(date),
      'mealType': serializer.toJson<String>(mealType),
      'foodItems': serializer.toJson<String>(foodItems),
      'calories': serializer.toJson<int>(calories),
      'isVeg': serializer.toJson<bool>(isVeg),
    };
  }

  NutritionLogsTableData copyWith({
    String? id,
    DateTime? date,
    String? mealType,
    String? foodItems,
    int? calories,
    bool? isVeg,
  }) => NutritionLogsTableData(
    id: id ?? this.id,
    date: date ?? this.date,
    mealType: mealType ?? this.mealType,
    foodItems: foodItems ?? this.foodItems,
    calories: calories ?? this.calories,
    isVeg: isVeg ?? this.isVeg,
  );
  NutritionLogsTableData copyWithCompanion(NutritionLogsTableCompanion data) {
    return NutritionLogsTableData(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
      foodItems: data.foodItems.present ? data.foodItems.value : this.foodItems,
      calories: data.calories.present ? data.calories.value : this.calories,
      isVeg: data.isVeg.present ? data.isVeg.value : this.isVeg,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NutritionLogsTableData(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('mealType: $mealType, ')
          ..write('foodItems: $foodItems, ')
          ..write('calories: $calories, ')
          ..write('isVeg: $isVeg')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, date, mealType, foodItems, calories, isVeg);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NutritionLogsTableData &&
          other.id == this.id &&
          other.date == this.date &&
          other.mealType == this.mealType &&
          other.foodItems == this.foodItems &&
          other.calories == this.calories &&
          other.isVeg == this.isVeg);
}

class NutritionLogsTableCompanion
    extends UpdateCompanion<NutritionLogsTableData> {
  final Value<String> id;
  final Value<DateTime> date;
  final Value<String> mealType;
  final Value<String> foodItems;
  final Value<int> calories;
  final Value<bool> isVeg;
  final Value<int> rowid;
  const NutritionLogsTableCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.mealType = const Value.absent(),
    this.foodItems = const Value.absent(),
    this.calories = const Value.absent(),
    this.isVeg = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NutritionLogsTableCompanion.insert({
    required String id,
    required DateTime date,
    required String mealType,
    required String foodItems,
    this.calories = const Value.absent(),
    this.isVeg = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       mealType = Value(mealType),
       foodItems = Value(foodItems);
  static Insertable<NutritionLogsTableData> custom({
    Expression<String>? id,
    Expression<DateTime>? date,
    Expression<String>? mealType,
    Expression<String>? foodItems,
    Expression<int>? calories,
    Expression<bool>? isVeg,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (mealType != null) 'meal_type': mealType,
      if (foodItems != null) 'food_items': foodItems,
      if (calories != null) 'calories': calories,
      if (isVeg != null) 'is_veg': isVeg,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NutritionLogsTableCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? date,
    Value<String>? mealType,
    Value<String>? foodItems,
    Value<int>? calories,
    Value<bool>? isVeg,
    Value<int>? rowid,
  }) {
    return NutritionLogsTableCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      mealType: mealType ?? this.mealType,
      foodItems: foodItems ?? this.foodItems,
      calories: calories ?? this.calories,
      isVeg: isVeg ?? this.isVeg,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (mealType.present) {
      map['meal_type'] = Variable<String>(mealType.value);
    }
    if (foodItems.present) {
      map['food_items'] = Variable<String>(foodItems.value);
    }
    if (calories.present) {
      map['calories'] = Variable<int>(calories.value);
    }
    if (isVeg.present) {
      map['is_veg'] = Variable<bool>(isVeg.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NutritionLogsTableCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('mealType: $mealType, ')
          ..write('foodItems: $foodItems, ')
          ..write('calories: $calories, ')
          ..write('isVeg: $isVeg, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShareHistoryTableTable extends ShareHistoryTable
    with TableInfo<$ShareHistoryTableTable, ShareHistoryTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShareHistoryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileSizeMeta = const VerificationMeta(
    'fileSize',
  );
  @override
  late final GeneratedColumn<int> fileSize = GeneratedColumn<int>(
    'file_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _directionMeta = const VerificationMeta(
    'direction',
  );
  @override
  late final GeneratedColumn<String> direction = GeneratedColumn<String>(
    'direction',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _peerNameMeta = const VerificationMeta(
    'peerName',
  );
  @override
  late final GeneratedColumn<String> peerName = GeneratedColumn<String>(
    'peer_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transferDateMeta = const VerificationMeta(
    'transferDate',
  );
  @override
  late final GeneratedColumn<DateTime> transferDate = GeneratedColumn<DateTime>(
    'transfer_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sha256HashMeta = const VerificationMeta(
    'sha256Hash',
  );
  @override
  late final GeneratedColumn<String> sha256Hash = GeneratedColumn<String>(
    'sha256_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fileName,
    fileSize,
    direction,
    peerName,
    transferDate,
    sha256Hash,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'share_history_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShareHistoryTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('file_size')) {
      context.handle(
        _fileSizeMeta,
        fileSize.isAcceptableOrUnknown(data['file_size']!, _fileSizeMeta),
      );
    } else if (isInserting) {
      context.missing(_fileSizeMeta);
    }
    if (data.containsKey('direction')) {
      context.handle(
        _directionMeta,
        direction.isAcceptableOrUnknown(data['direction']!, _directionMeta),
      );
    } else if (isInserting) {
      context.missing(_directionMeta);
    }
    if (data.containsKey('peer_name')) {
      context.handle(
        _peerNameMeta,
        peerName.isAcceptableOrUnknown(data['peer_name']!, _peerNameMeta),
      );
    } else if (isInserting) {
      context.missing(_peerNameMeta);
    }
    if (data.containsKey('transfer_date')) {
      context.handle(
        _transferDateMeta,
        transferDate.isAcceptableOrUnknown(
          data['transfer_date']!,
          _transferDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transferDateMeta);
    }
    if (data.containsKey('sha256_hash')) {
      context.handle(
        _sha256HashMeta,
        sha256Hash.isAcceptableOrUnknown(data['sha256_hash']!, _sha256HashMeta),
      );
    } else if (isInserting) {
      context.missing(_sha256HashMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShareHistoryTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShareHistoryTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      fileSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size'],
      )!,
      direction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direction'],
      )!,
      peerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}peer_name'],
      )!,
      transferDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}transfer_date'],
      )!,
      sha256Hash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sha256_hash'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $ShareHistoryTableTable createAlias(String alias) {
    return $ShareHistoryTableTable(attachedDatabase, alias);
  }
}

class ShareHistoryTableData extends DataClass
    implements Insertable<ShareHistoryTableData> {
  final String id;
  final String fileName;
  final int fileSize;
  final String direction;
  final String peerName;
  final DateTime transferDate;
  final String sha256Hash;
  final String status;
  const ShareHistoryTableData({
    required this.id,
    required this.fileName,
    required this.fileSize,
    required this.direction,
    required this.peerName,
    required this.transferDate,
    required this.sha256Hash,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['file_name'] = Variable<String>(fileName);
    map['file_size'] = Variable<int>(fileSize);
    map['direction'] = Variable<String>(direction);
    map['peer_name'] = Variable<String>(peerName);
    map['transfer_date'] = Variable<DateTime>(transferDate);
    map['sha256_hash'] = Variable<String>(sha256Hash);
    map['status'] = Variable<String>(status);
    return map;
  }

  ShareHistoryTableCompanion toCompanion(bool nullToAbsent) {
    return ShareHistoryTableCompanion(
      id: Value(id),
      fileName: Value(fileName),
      fileSize: Value(fileSize),
      direction: Value(direction),
      peerName: Value(peerName),
      transferDate: Value(transferDate),
      sha256Hash: Value(sha256Hash),
      status: Value(status),
    );
  }

  factory ShareHistoryTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShareHistoryTableData(
      id: serializer.fromJson<String>(json['id']),
      fileName: serializer.fromJson<String>(json['fileName']),
      fileSize: serializer.fromJson<int>(json['fileSize']),
      direction: serializer.fromJson<String>(json['direction']),
      peerName: serializer.fromJson<String>(json['peerName']),
      transferDate: serializer.fromJson<DateTime>(json['transferDate']),
      sha256Hash: serializer.fromJson<String>(json['sha256Hash']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fileName': serializer.toJson<String>(fileName),
      'fileSize': serializer.toJson<int>(fileSize),
      'direction': serializer.toJson<String>(direction),
      'peerName': serializer.toJson<String>(peerName),
      'transferDate': serializer.toJson<DateTime>(transferDate),
      'sha256Hash': serializer.toJson<String>(sha256Hash),
      'status': serializer.toJson<String>(status),
    };
  }

  ShareHistoryTableData copyWith({
    String? id,
    String? fileName,
    int? fileSize,
    String? direction,
    String? peerName,
    DateTime? transferDate,
    String? sha256Hash,
    String? status,
  }) => ShareHistoryTableData(
    id: id ?? this.id,
    fileName: fileName ?? this.fileName,
    fileSize: fileSize ?? this.fileSize,
    direction: direction ?? this.direction,
    peerName: peerName ?? this.peerName,
    transferDate: transferDate ?? this.transferDate,
    sha256Hash: sha256Hash ?? this.sha256Hash,
    status: status ?? this.status,
  );
  ShareHistoryTableData copyWithCompanion(ShareHistoryTableCompanion data) {
    return ShareHistoryTableData(
      id: data.id.present ? data.id.value : this.id,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      fileSize: data.fileSize.present ? data.fileSize.value : this.fileSize,
      direction: data.direction.present ? data.direction.value : this.direction,
      peerName: data.peerName.present ? data.peerName.value : this.peerName,
      transferDate: data.transferDate.present
          ? data.transferDate.value
          : this.transferDate,
      sha256Hash: data.sha256Hash.present
          ? data.sha256Hash.value
          : this.sha256Hash,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShareHistoryTableData(')
          ..write('id: $id, ')
          ..write('fileName: $fileName, ')
          ..write('fileSize: $fileSize, ')
          ..write('direction: $direction, ')
          ..write('peerName: $peerName, ')
          ..write('transferDate: $transferDate, ')
          ..write('sha256Hash: $sha256Hash, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fileName,
    fileSize,
    direction,
    peerName,
    transferDate,
    sha256Hash,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShareHistoryTableData &&
          other.id == this.id &&
          other.fileName == this.fileName &&
          other.fileSize == this.fileSize &&
          other.direction == this.direction &&
          other.peerName == this.peerName &&
          other.transferDate == this.transferDate &&
          other.sha256Hash == this.sha256Hash &&
          other.status == this.status);
}

class ShareHistoryTableCompanion
    extends UpdateCompanion<ShareHistoryTableData> {
  final Value<String> id;
  final Value<String> fileName;
  final Value<int> fileSize;
  final Value<String> direction;
  final Value<String> peerName;
  final Value<DateTime> transferDate;
  final Value<String> sha256Hash;
  final Value<String> status;
  final Value<int> rowid;
  const ShareHistoryTableCompanion({
    this.id = const Value.absent(),
    this.fileName = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.direction = const Value.absent(),
    this.peerName = const Value.absent(),
    this.transferDate = const Value.absent(),
    this.sha256Hash = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShareHistoryTableCompanion.insert({
    required String id,
    required String fileName,
    required int fileSize,
    required String direction,
    required String peerName,
    required DateTime transferDate,
    required String sha256Hash,
    required String status,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       fileName = Value(fileName),
       fileSize = Value(fileSize),
       direction = Value(direction),
       peerName = Value(peerName),
       transferDate = Value(transferDate),
       sha256Hash = Value(sha256Hash),
       status = Value(status);
  static Insertable<ShareHistoryTableData> custom({
    Expression<String>? id,
    Expression<String>? fileName,
    Expression<int>? fileSize,
    Expression<String>? direction,
    Expression<String>? peerName,
    Expression<DateTime>? transferDate,
    Expression<String>? sha256Hash,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fileName != null) 'file_name': fileName,
      if (fileSize != null) 'file_size': fileSize,
      if (direction != null) 'direction': direction,
      if (peerName != null) 'peer_name': peerName,
      if (transferDate != null) 'transfer_date': transferDate,
      if (sha256Hash != null) 'sha256_hash': sha256Hash,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShareHistoryTableCompanion copyWith({
    Value<String>? id,
    Value<String>? fileName,
    Value<int>? fileSize,
    Value<String>? direction,
    Value<String>? peerName,
    Value<DateTime>? transferDate,
    Value<String>? sha256Hash,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return ShareHistoryTableCompanion(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      direction: direction ?? this.direction,
      peerName: peerName ?? this.peerName,
      transferDate: transferDate ?? this.transferDate,
      sha256Hash: sha256Hash ?? this.sha256Hash,
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
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (fileSize.present) {
      map['file_size'] = Variable<int>(fileSize.value);
    }
    if (direction.present) {
      map['direction'] = Variable<String>(direction.value);
    }
    if (peerName.present) {
      map['peer_name'] = Variable<String>(peerName.value);
    }
    if (transferDate.present) {
      map['transfer_date'] = Variable<DateTime>(transferDate.value);
    }
    if (sha256Hash.present) {
      map['sha256_hash'] = Variable<String>(sha256Hash.value);
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
    return (StringBuffer('ShareHistoryTableCompanion(')
          ..write('id: $id, ')
          ..write('fileName: $fileName, ')
          ..write('fileSize: $fileSize, ')
          ..write('direction: $direction, ')
          ..write('peerName: $peerName, ')
          ..write('transferDate: $transferDate, ')
          ..write('sha256Hash: $sha256Hash, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $OutboxSyncQueueTable outboxSyncQueue = $OutboxSyncQueueTable(
    this,
  );
  late final $CoursesTableTable coursesTable = $CoursesTableTable(this);
  late final $TimetableTableTable timetableTable = $TimetableTableTable(this);
  late final $TasksTableTable tasksTable = $TasksTableTable(this);
  late final $AttendanceTableTable attendanceTable = $AttendanceTableTable(
    this,
  );
  late final $GradesTableTable gradesTable = $GradesTableTable(this);
  late final $NotesTableTable notesTable = $NotesTableTable(this);
  late final $FlashcardsTableTable flashcardsTable = $FlashcardsTableTable(
    this,
  );
  late final $HabitsTableTable habitsTable = $HabitsTableTable(this);
  late final $BudgetTableTable budgetTable = $BudgetTableTable(this);
  late final $MoodTableTable moodTable = $MoodTableTable(this);
  late final $EncryptedVaultTableTable encryptedVaultTable =
      $EncryptedVaultTableTable(this);
  late final $StudentProfileTableTable studentProfileTable =
      $StudentProfileTableTable(this);
  late final $PastPapersTableTable pastPapersTable = $PastPapersTableTable(
    this,
  );
  late final $StudyPlansTableTable studyPlansTable = $StudyPlansTableTable(
    this,
  );
  late final $GroupProjectsTableTable groupProjectsTable =
      $GroupProjectsTableTable(this);
  late final $OfficeHoursTableTable officeHoursTable = $OfficeHoursTableTable(
    this,
  );
  late final $HealthRecordsTableTable healthRecordsTable =
      $HealthRecordsTableTable(this);
  late final $SleepLogsTableTable sleepLogsTable = $SleepLogsTableTable(this);
  late final $NutritionLogsTableTable nutritionLogsTable =
      $NutritionLogsTableTable(this);
  late final $ShareHistoryTableTable shareHistoryTable =
      $ShareHistoryTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    outboxSyncQueue,
    coursesTable,
    timetableTable,
    tasksTable,
    attendanceTable,
    gradesTable,
    notesTable,
    flashcardsTable,
    habitsTable,
    budgetTable,
    moodTable,
    encryptedVaultTable,
    studentProfileTable,
    pastPapersTable,
    studyPlansTable,
    groupProjectsTable,
    officeHoursTable,
    healthRecordsTable,
    sleepLogsTable,
    nutritionLogsTable,
    shareHistoryTable,
  ];
}

typedef $$OutboxSyncQueueTableCreateCompanionBuilder =
    OutboxSyncQueueCompanion Function({
      required String id,
      required String entityType,
      required String action,
      required String payloadJson,
      Value<String> status,
      Value<int> retryCount,
      Value<DateTime?> nextRetryAt,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$OutboxSyncQueueTableUpdateCompanionBuilder =
    OutboxSyncQueueCompanion Function({
      Value<String> id,
      Value<String> entityType,
      Value<String> action,
      Value<String> payloadJson,
      Value<String> status,
      Value<int> retryCount,
      Value<DateTime?> nextRetryAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$OutboxSyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $OutboxSyncQueueTable> {
  $$OutboxSyncQueueTableFilterComposer({
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

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OutboxSyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $OutboxSyncQueueTable> {
  $$OutboxSyncQueueTableOrderingComposer({
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

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutboxSyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutboxSyncQueueTable> {
  $$OutboxSyncQueueTableAnnotationComposer({
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

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$OutboxSyncQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutboxSyncQueueTable,
          OutboxSyncQueueData,
          $$OutboxSyncQueueTableFilterComposer,
          $$OutboxSyncQueueTableOrderingComposer,
          $$OutboxSyncQueueTableAnnotationComposer,
          $$OutboxSyncQueueTableCreateCompanionBuilder,
          $$OutboxSyncQueueTableUpdateCompanionBuilder,
          (
            OutboxSyncQueueData,
            BaseReferences<
              _$AppDatabase,
              $OutboxSyncQueueTable,
              OutboxSyncQueueData
            >,
          ),
          OutboxSyncQueueData,
          PrefetchHooks Function()
        > {
  $$OutboxSyncQueueTableTableManager(
    _$AppDatabase db,
    $OutboxSyncQueueTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboxSyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboxSyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboxSyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<DateTime?> nextRetryAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OutboxSyncQueueCompanion(
                id: id,
                entityType: entityType,
                action: action,
                payloadJson: payloadJson,
                status: status,
                retryCount: retryCount,
                nextRetryAt: nextRetryAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String entityType,
                required String action,
                required String payloadJson,
                Value<String> status = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<DateTime?> nextRetryAt = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => OutboxSyncQueueCompanion.insert(
                id: id,
                entityType: entityType,
                action: action,
                payloadJson: payloadJson,
                status: status,
                retryCount: retryCount,
                nextRetryAt: nextRetryAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OutboxSyncQueueTable, OutboxSyncQueueData>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $OutboxSyncQueueTable,
                    OutboxSyncQueueData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OutboxSyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutboxSyncQueueTable,
      OutboxSyncQueueData,
      $$OutboxSyncQueueTableFilterComposer,
      $$OutboxSyncQueueTableOrderingComposer,
      $$OutboxSyncQueueTableAnnotationComposer,
      $$OutboxSyncQueueTableCreateCompanionBuilder,
      $$OutboxSyncQueueTableUpdateCompanionBuilder,
      (
        OutboxSyncQueueData,
        BaseReferences<
          _$AppDatabase,
          $OutboxSyncQueueTable,
          OutboxSyncQueueData
        >,
      ),
      OutboxSyncQueueData,
      PrefetchHooks Function()
    >;
typedef $$CoursesTableTableCreateCompanionBuilder =
    CoursesTableCompanion Function({
      required String id,
      required String code,
      required String name,
      required int credits,
      required String department,
      required String instructor,
      required String color,
      required String room,
      required String syllabus,
      Value<DateTime?> examDate,
      Value<double> attendanceGoal,
      Value<int> rowid,
    });
typedef $$CoursesTableTableUpdateCompanionBuilder =
    CoursesTableCompanion Function({
      Value<String> id,
      Value<String> code,
      Value<String> name,
      Value<int> credits,
      Value<String> department,
      Value<String> instructor,
      Value<String> color,
      Value<String> room,
      Value<String> syllabus,
      Value<DateTime?> examDate,
      Value<double> attendanceGoal,
      Value<int> rowid,
    });

class $$CoursesTableTableFilterComposer
    extends Composer<_$AppDatabase, $CoursesTableTable> {
  $$CoursesTableTableFilterComposer({
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

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get credits => $composableBuilder(
    column: $table.credits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instructor => $composableBuilder(
    column: $table.instructor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get room => $composableBuilder(
    column: $table.room,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syllabus => $composableBuilder(
    column: $table.syllabus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get examDate => $composableBuilder(
    column: $table.examDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get attendanceGoal => $composableBuilder(
    column: $table.attendanceGoal,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CoursesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CoursesTableTable> {
  $$CoursesTableTableOrderingComposer({
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

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get credits => $composableBuilder(
    column: $table.credits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instructor => $composableBuilder(
    column: $table.instructor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get room => $composableBuilder(
    column: $table.room,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syllabus => $composableBuilder(
    column: $table.syllabus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get examDate => $composableBuilder(
    column: $table.examDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get attendanceGoal => $composableBuilder(
    column: $table.attendanceGoal,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CoursesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CoursesTableTable> {
  $$CoursesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get credits =>
      $composableBuilder(column: $table.credits, builder: (column) => column);

  GeneratedColumn<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => column,
  );

  GeneratedColumn<String> get instructor => $composableBuilder(
    column: $table.instructor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get room =>
      $composableBuilder(column: $table.room, builder: (column) => column);

  GeneratedColumn<String> get syllabus =>
      $composableBuilder(column: $table.syllabus, builder: (column) => column);

  GeneratedColumn<DateTime> get examDate =>
      $composableBuilder(column: $table.examDate, builder: (column) => column);

  GeneratedColumn<double> get attendanceGoal => $composableBuilder(
    column: $table.attendanceGoal,
    builder: (column) => column,
  );
}

class $$CoursesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CoursesTableTable,
          CoursesTableData,
          $$CoursesTableTableFilterComposer,
          $$CoursesTableTableOrderingComposer,
          $$CoursesTableTableAnnotationComposer,
          $$CoursesTableTableCreateCompanionBuilder,
          $$CoursesTableTableUpdateCompanionBuilder,
          (
            CoursesTableData,
            BaseReferences<_$AppDatabase, $CoursesTableTable, CoursesTableData>,
          ),
          CoursesTableData,
          PrefetchHooks Function()
        > {
  $$CoursesTableTableTableManager(_$AppDatabase db, $CoursesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CoursesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CoursesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CoursesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> credits = const Value.absent(),
                Value<String> department = const Value.absent(),
                Value<String> instructor = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<String> room = const Value.absent(),
                Value<String> syllabus = const Value.absent(),
                Value<DateTime?> examDate = const Value.absent(),
                Value<double> attendanceGoal = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CoursesTableCompanion(
                id: id,
                code: code,
                name: name,
                credits: credits,
                department: department,
                instructor: instructor,
                color: color,
                room: room,
                syllabus: syllabus,
                examDate: examDate,
                attendanceGoal: attendanceGoal,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String code,
                required String name,
                required int credits,
                required String department,
                required String instructor,
                required String color,
                required String room,
                required String syllabus,
                Value<DateTime?> examDate = const Value.absent(),
                Value<double> attendanceGoal = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CoursesTableCompanion.insert(
                id: id,
                code: code,
                name: name,
                credits: credits,
                department: department,
                instructor: instructor,
                color: color,
                room: room,
                syllabus: syllabus,
                examDate: examDate,
                attendanceGoal: attendanceGoal,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CoursesTableTable, CoursesTableData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CoursesTableTable,
                    CoursesTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CoursesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CoursesTableTable,
      CoursesTableData,
      $$CoursesTableTableFilterComposer,
      $$CoursesTableTableOrderingComposer,
      $$CoursesTableTableAnnotationComposer,
      $$CoursesTableTableCreateCompanionBuilder,
      $$CoursesTableTableUpdateCompanionBuilder,
      (
        CoursesTableData,
        BaseReferences<_$AppDatabase, $CoursesTableTable, CoursesTableData>,
      ),
      CoursesTableData,
      PrefetchHooks Function()
    >;
typedef $$TimetableTableTableCreateCompanionBuilder =
    TimetableTableCompanion Function({
      required String id,
      required String courseId,
      required String courseCode,
      required String title,
      required int dayOfWeek,
      required String startTime,
      required String endTime,
      required String room,
      required String color,
      required String type,
      Value<int> rowid,
    });
typedef $$TimetableTableTableUpdateCompanionBuilder =
    TimetableTableCompanion Function({
      Value<String> id,
      Value<String> courseId,
      Value<String> courseCode,
      Value<String> title,
      Value<int> dayOfWeek,
      Value<String> startTime,
      Value<String> endTime,
      Value<String> room,
      Value<String> color,
      Value<String> type,
      Value<int> rowid,
    });

class $$TimetableTableTableFilterComposer
    extends Composer<_$AppDatabase, $TimetableTableTable> {
  $$TimetableTableTableFilterComposer({
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

  ColumnFilters<String> get courseId => $composableBuilder(
    column: $table.courseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get courseCode => $composableBuilder(
    column: $table.courseCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get room => $composableBuilder(
    column: $table.room,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TimetableTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TimetableTableTable> {
  $$TimetableTableTableOrderingComposer({
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

  ColumnOrderings<String> get courseId => $composableBuilder(
    column: $table.courseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get courseCode => $composableBuilder(
    column: $table.courseCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get room => $composableBuilder(
    column: $table.room,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TimetableTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TimetableTableTable> {
  $$TimetableTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get courseId =>
      $composableBuilder(column: $table.courseId, builder: (column) => column);

  GeneratedColumn<String> get courseCode => $composableBuilder(
    column: $table.courseCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get dayOfWeek =>
      $composableBuilder(column: $table.dayOfWeek, builder: (column) => column);

  GeneratedColumn<String> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<String> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<String> get room =>
      $composableBuilder(column: $table.room, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);
}

class $$TimetableTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TimetableTableTable,
          TimetableTableData,
          $$TimetableTableTableFilterComposer,
          $$TimetableTableTableOrderingComposer,
          $$TimetableTableTableAnnotationComposer,
          $$TimetableTableTableCreateCompanionBuilder,
          $$TimetableTableTableUpdateCompanionBuilder,
          (
            TimetableTableData,
            BaseReferences<
              _$AppDatabase,
              $TimetableTableTable,
              TimetableTableData
            >,
          ),
          TimetableTableData,
          PrefetchHooks Function()
        > {
  $$TimetableTableTableTableManager(
    _$AppDatabase db,
    $TimetableTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TimetableTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TimetableTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TimetableTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> courseId = const Value.absent(),
                Value<String> courseCode = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> dayOfWeek = const Value.absent(),
                Value<String> startTime = const Value.absent(),
                Value<String> endTime = const Value.absent(),
                Value<String> room = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TimetableTableCompanion(
                id: id,
                courseId: courseId,
                courseCode: courseCode,
                title: title,
                dayOfWeek: dayOfWeek,
                startTime: startTime,
                endTime: endTime,
                room: room,
                color: color,
                type: type,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String courseId,
                required String courseCode,
                required String title,
                required int dayOfWeek,
                required String startTime,
                required String endTime,
                required String room,
                required String color,
                required String type,
                Value<int> rowid = const Value.absent(),
              }) => TimetableTableCompanion.insert(
                id: id,
                courseId: courseId,
                courseCode: courseCode,
                title: title,
                dayOfWeek: dayOfWeek,
                startTime: startTime,
                endTime: endTime,
                room: room,
                color: color,
                type: type,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TimetableTableTable, TimetableTableData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $TimetableTableTable,
                    TimetableTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TimetableTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TimetableTableTable,
      TimetableTableData,
      $$TimetableTableTableFilterComposer,
      $$TimetableTableTableOrderingComposer,
      $$TimetableTableTableAnnotationComposer,
      $$TimetableTableTableCreateCompanionBuilder,
      $$TimetableTableTableUpdateCompanionBuilder,
      (
        TimetableTableData,
        BaseReferences<_$AppDatabase, $TimetableTableTable, TimetableTableData>,
      ),
      TimetableTableData,
      PrefetchHooks Function()
    >;
typedef $$TasksTableTableCreateCompanionBuilder = TasksTableCompanion Function({
  required String id,
  Value<String?> courseId,
  required String title,
  Value<String> description,
  required DateTime dueDate,
  Value<String> priority,
  Value<String> status,
  Value<int> estimatedMinutes,
  Value<bool> isSynced,
  Value<int> rowid,
});
typedef $$TasksTableTableUpdateCompanionBuilder = TasksTableCompanion Function({
  Value<String> id,
  Value<String?> courseId,
  Value<String> title,
  Value<String> description,
  Value<DateTime> dueDate,
  Value<String> priority,
  Value<String> status,
  Value<int> estimatedMinutes,
  Value<bool> isSynced,
  Value<int> rowid,
});

class $$TasksTableTableFilterComposer
    extends Composer<_$AppDatabase, $TasksTableTable> {
  $$TasksTableTableFilterComposer({
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

  ColumnFilters<String> get courseId => $composableBuilder(
    column: $table.courseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TasksTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTableTable> {
  $$TasksTableTableOrderingComposer({
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

  ColumnOrderings<String> get courseId => $composableBuilder(
    column: $table.courseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TasksTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTableTable> {
  $$TasksTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get courseId =>
      $composableBuilder(column: $table.courseId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
}

class $$TasksTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTableTable,
          TasksTableData,
          $$TasksTableTableFilterComposer,
          $$TasksTableTableOrderingComposer,
          $$TasksTableTableAnnotationComposer,
          $$TasksTableTableCreateCompanionBuilder,
          $$TasksTableTableUpdateCompanionBuilder,
          (
            TasksTableData,
            BaseReferences<_$AppDatabase, $TasksTableTable, TasksTableData>,
          ),
          TasksTableData,
          PrefetchHooks Function()
        > {
  $$TasksTableTableTableManager(_$AppDatabase db, $TasksTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> courseId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<DateTime> dueDate = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> estimatedMinutes = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksTableCompanion(
                id: id,
                courseId: courseId,
                title: title,
                description: description,
                dueDate: dueDate,
                priority: priority,
                status: status,
                estimatedMinutes: estimatedMinutes,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> courseId = const Value.absent(),
                required String title,
                Value<String> description = const Value.absent(),
                required DateTime dueDate,
                Value<String> priority = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> estimatedMinutes = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksTableCompanion.insert(
                id: id,
                courseId: courseId,
                title: title,
                description: description,
                dueDate: dueDate,
                priority: priority,
                status: status,
                estimatedMinutes: estimatedMinutes,
                isSynced: isSynced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TasksTableTable, TasksTableData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $TasksTableTable,
                    TasksTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TasksTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTableTable,
      TasksTableData,
      $$TasksTableTableFilterComposer,
      $$TasksTableTableOrderingComposer,
      $$TasksTableTableAnnotationComposer,
      $$TasksTableTableCreateCompanionBuilder,
      $$TasksTableTableUpdateCompanionBuilder,
      (
        TasksTableData,
        BaseReferences<_$AppDatabase, $TasksTableTable, TasksTableData>,
      ),
      TasksTableData,
      PrefetchHooks Function()
    >;
typedef $$AttendanceTableTableCreateCompanionBuilder =
    AttendanceTableCompanion Function({
      required String id,
      required String courseId,
      required DateTime date,
      required String status,
      Value<int> rowid,
    });
typedef $$AttendanceTableTableUpdateCompanionBuilder =
    AttendanceTableCompanion Function({
      Value<String> id,
      Value<String> courseId,
      Value<DateTime> date,
      Value<String> status,
      Value<int> rowid,
    });

class $$AttendanceTableTableFilterComposer
    extends Composer<_$AppDatabase, $AttendanceTableTable> {
  $$AttendanceTableTableFilterComposer({
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

  ColumnFilters<String> get courseId => $composableBuilder(
    column: $table.courseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AttendanceTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AttendanceTableTable> {
  $$AttendanceTableTableOrderingComposer({
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

  ColumnOrderings<String> get courseId => $composableBuilder(
    column: $table.courseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AttendanceTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttendanceTableTable> {
  $$AttendanceTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get courseId =>
      $composableBuilder(column: $table.courseId, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$AttendanceTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AttendanceTableTable,
          AttendanceTableData,
          $$AttendanceTableTableFilterComposer,
          $$AttendanceTableTableOrderingComposer,
          $$AttendanceTableTableAnnotationComposer,
          $$AttendanceTableTableCreateCompanionBuilder,
          $$AttendanceTableTableUpdateCompanionBuilder,
          (
            AttendanceTableData,
            BaseReferences<
              _$AppDatabase,
              $AttendanceTableTable,
              AttendanceTableData
            >,
          ),
          AttendanceTableData,
          PrefetchHooks Function()
        > {
  $$AttendanceTableTableTableManager(
    _$AppDatabase db,
    $AttendanceTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttendanceTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttendanceTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttendanceTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> courseId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttendanceTableCompanion(
                id: id,
                courseId: courseId,
                date: date,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String courseId,
                required DateTime date,
                required String status,
                Value<int> rowid = const Value.absent(),
              }) => AttendanceTableCompanion.insert(
                id: id,
                courseId: courseId,
                date: date,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AttendanceTableTable, AttendanceTableData>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $AttendanceTableTable,
                    AttendanceTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AttendanceTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AttendanceTableTable,
      AttendanceTableData,
      $$AttendanceTableTableFilterComposer,
      $$AttendanceTableTableOrderingComposer,
      $$AttendanceTableTableAnnotationComposer,
      $$AttendanceTableTableCreateCompanionBuilder,
      $$AttendanceTableTableUpdateCompanionBuilder,
      (
        AttendanceTableData,
        BaseReferences<
          _$AppDatabase,
          $AttendanceTableTable,
          AttendanceTableData
        >,
      ),
      AttendanceTableData,
      PrefetchHooks Function()
    >;
typedef $$GradesTableTableCreateCompanionBuilder =
    GradesTableCompanion Function({
      required String id,
      required String courseId,
      required String courseCode,
      Value<int> semester,
      required int credits,
      required double gradePoints,
      required String letterGrade,
      Value<int> rowid,
    });
typedef $$GradesTableTableUpdateCompanionBuilder =
    GradesTableCompanion Function({
      Value<String> id,
      Value<String> courseId,
      Value<String> courseCode,
      Value<int> semester,
      Value<int> credits,
      Value<double> gradePoints,
      Value<String> letterGrade,
      Value<int> rowid,
    });

class $$GradesTableTableFilterComposer
    extends Composer<_$AppDatabase, $GradesTableTable> {
  $$GradesTableTableFilterComposer({
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

  ColumnFilters<String> get courseId => $composableBuilder(
    column: $table.courseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get courseCode => $composableBuilder(
    column: $table.courseCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get semester => $composableBuilder(
    column: $table.semester,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get credits => $composableBuilder(
    column: $table.credits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get gradePoints => $composableBuilder(
    column: $table.gradePoints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get letterGrade => $composableBuilder(
    column: $table.letterGrade,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GradesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $GradesTableTable> {
  $$GradesTableTableOrderingComposer({
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

  ColumnOrderings<String> get courseId => $composableBuilder(
    column: $table.courseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get courseCode => $composableBuilder(
    column: $table.courseCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get semester => $composableBuilder(
    column: $table.semester,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get credits => $composableBuilder(
    column: $table.credits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get gradePoints => $composableBuilder(
    column: $table.gradePoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get letterGrade => $composableBuilder(
    column: $table.letterGrade,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GradesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $GradesTableTable> {
  $$GradesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get courseId =>
      $composableBuilder(column: $table.courseId, builder: (column) => column);

  GeneratedColumn<String> get courseCode => $composableBuilder(
    column: $table.courseCode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get semester =>
      $composableBuilder(column: $table.semester, builder: (column) => column);

  GeneratedColumn<int> get credits =>
      $composableBuilder(column: $table.credits, builder: (column) => column);

  GeneratedColumn<double> get gradePoints => $composableBuilder(
    column: $table.gradePoints,
    builder: (column) => column,
  );

  GeneratedColumn<String> get letterGrade => $composableBuilder(
    column: $table.letterGrade,
    builder: (column) => column,
  );
}

class $$GradesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GradesTableTable,
          GradesTableData,
          $$GradesTableTableFilterComposer,
          $$GradesTableTableOrderingComposer,
          $$GradesTableTableAnnotationComposer,
          $$GradesTableTableCreateCompanionBuilder,
          $$GradesTableTableUpdateCompanionBuilder,
          (
            GradesTableData,
            BaseReferences<_$AppDatabase, $GradesTableTable, GradesTableData>,
          ),
          GradesTableData,
          PrefetchHooks Function()
        > {
  $$GradesTableTableTableManager(_$AppDatabase db, $GradesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GradesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GradesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GradesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> courseId = const Value.absent(),
                Value<String> courseCode = const Value.absent(),
                Value<int> semester = const Value.absent(),
                Value<int> credits = const Value.absent(),
                Value<double> gradePoints = const Value.absent(),
                Value<String> letterGrade = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GradesTableCompanion(
                id: id,
                courseId: courseId,
                courseCode: courseCode,
                semester: semester,
                credits: credits,
                gradePoints: gradePoints,
                letterGrade: letterGrade,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String courseId,
                required String courseCode,
                Value<int> semester = const Value.absent(),
                required int credits,
                required double gradePoints,
                required String letterGrade,
                Value<int> rowid = const Value.absent(),
              }) => GradesTableCompanion.insert(
                id: id,
                courseId: courseId,
                courseCode: courseCode,
                semester: semester,
                credits: credits,
                gradePoints: gradePoints,
                letterGrade: letterGrade,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GradesTableTable, GradesTableData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $GradesTableTable,
                    GradesTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GradesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GradesTableTable,
      GradesTableData,
      $$GradesTableTableFilterComposer,
      $$GradesTableTableOrderingComposer,
      $$GradesTableTableAnnotationComposer,
      $$GradesTableTableCreateCompanionBuilder,
      $$GradesTableTableUpdateCompanionBuilder,
      (
        GradesTableData,
        BaseReferences<_$AppDatabase, $GradesTableTable, GradesTableData>,
      ),
      GradesTableData,
      PrefetchHooks Function()
    >;
typedef $$NotesTableTableCreateCompanionBuilder = NotesTableCompanion Function({
  required String id,
  Value<String> folder,
  required String title,
  required String content,
  Value<String> tags,
  required DateTime updatedAt,
  Value<bool> isFavorite,
  Value<bool> isSynced,
  Value<int> rowid,
});
typedef $$NotesTableTableUpdateCompanionBuilder = NotesTableCompanion Function({
  Value<String> id,
  Value<String> folder,
  Value<String> title,
  Value<String> content,
  Value<String> tags,
  Value<DateTime> updatedAt,
  Value<bool> isFavorite,
  Value<bool> isSynced,
  Value<int> rowid,
});

class $$NotesTableTableFilterComposer
    extends Composer<_$AppDatabase, $NotesTableTable> {
  $$NotesTableTableFilterComposer({
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

  ColumnFilters<String> get folder => $composableBuilder(
    column: $table.folder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $NotesTableTable> {
  $$NotesTableTableOrderingComposer({
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

  ColumnOrderings<String> get folder => $composableBuilder(
    column: $table.folder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotesTableTable> {
  $$NotesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get folder =>
      $composableBuilder(column: $table.folder, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
}

class $$NotesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotesTableTable,
          NotesTableData,
          $$NotesTableTableFilterComposer,
          $$NotesTableTableOrderingComposer,
          $$NotesTableTableAnnotationComposer,
          $$NotesTableTableCreateCompanionBuilder,
          $$NotesTableTableUpdateCompanionBuilder,
          (
            NotesTableData,
            BaseReferences<_$AppDatabase, $NotesTableTable, NotesTableData>,
          ),
          NotesTableData,
          PrefetchHooks Function()
        > {
  $$NotesTableTableTableManager(_$AppDatabase db, $NotesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> folder = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotesTableCompanion(
                id: id,
                folder: folder,
                title: title,
                content: content,
                tags: tags,
                updatedAt: updatedAt,
                isFavorite: isFavorite,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> folder = const Value.absent(),
                required String title,
                required String content,
                Value<String> tags = const Value.absent(),
                required DateTime updatedAt,
                Value<bool> isFavorite = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotesTableCompanion.insert(
                id: id,
                folder: folder,
                title: title,
                content: content,
                tags: tags,
                updatedAt: updatedAt,
                isFavorite: isFavorite,
                isSynced: isSynced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$NotesTableTable, NotesTableData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $NotesTableTable,
                    NotesTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotesTableTable,
      NotesTableData,
      $$NotesTableTableFilterComposer,
      $$NotesTableTableOrderingComposer,
      $$NotesTableTableAnnotationComposer,
      $$NotesTableTableCreateCompanionBuilder,
      $$NotesTableTableUpdateCompanionBuilder,
      (
        NotesTableData,
        BaseReferences<_$AppDatabase, $NotesTableTable, NotesTableData>,
      ),
      NotesTableData,
      PrefetchHooks Function()
    >;
typedef $$FlashcardsTableTableCreateCompanionBuilder =
    FlashcardsTableCompanion Function({
      required String id,
      required String deckId,
      required String question,
      required String answer,
      Value<int> box,
      Value<double> easeFactor,
      Value<int> repetitions,
      required DateTime nextReviewDate,
      Value<int> rowid,
    });
typedef $$FlashcardsTableTableUpdateCompanionBuilder =
    FlashcardsTableCompanion Function({
      Value<String> id,
      Value<String> deckId,
      Value<String> question,
      Value<String> answer,
      Value<int> box,
      Value<double> easeFactor,
      Value<int> repetitions,
      Value<DateTime> nextReviewDate,
      Value<int> rowid,
    });

class $$FlashcardsTableTableFilterComposer
    extends Composer<_$AppDatabase, $FlashcardsTableTable> {
  $$FlashcardsTableTableFilterComposer({
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

  ColumnFilters<String> get deckId => $composableBuilder(
    column: $table.deckId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get question => $composableBuilder(
    column: $table.question,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get answer => $composableBuilder(
    column: $table.answer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get box => $composableBuilder(
    column: $table.box,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get easeFactor => $composableBuilder(
    column: $table.easeFactor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextReviewDate => $composableBuilder(
    column: $table.nextReviewDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FlashcardsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $FlashcardsTableTable> {
  $$FlashcardsTableTableOrderingComposer({
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

  ColumnOrderings<String> get deckId => $composableBuilder(
    column: $table.deckId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get question => $composableBuilder(
    column: $table.question,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answer => $composableBuilder(
    column: $table.answer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get box => $composableBuilder(
    column: $table.box,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get easeFactor => $composableBuilder(
    column: $table.easeFactor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextReviewDate => $composableBuilder(
    column: $table.nextReviewDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FlashcardsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $FlashcardsTableTable> {
  $$FlashcardsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get deckId =>
      $composableBuilder(column: $table.deckId, builder: (column) => column);

  GeneratedColumn<String> get question =>
      $composableBuilder(column: $table.question, builder: (column) => column);

  GeneratedColumn<String> get answer =>
      $composableBuilder(column: $table.answer, builder: (column) => column);

  GeneratedColumn<int> get box =>
      $composableBuilder(column: $table.box, builder: (column) => column);

  GeneratedColumn<double> get easeFactor => $composableBuilder(
    column: $table.easeFactor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextReviewDate => $composableBuilder(
    column: $table.nextReviewDate,
    builder: (column) => column,
  );
}

class $$FlashcardsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FlashcardsTableTable,
          FlashcardsTableData,
          $$FlashcardsTableTableFilterComposer,
          $$FlashcardsTableTableOrderingComposer,
          $$FlashcardsTableTableAnnotationComposer,
          $$FlashcardsTableTableCreateCompanionBuilder,
          $$FlashcardsTableTableUpdateCompanionBuilder,
          (
            FlashcardsTableData,
            BaseReferences<
              _$AppDatabase,
              $FlashcardsTableTable,
              FlashcardsTableData
            >,
          ),
          FlashcardsTableData,
          PrefetchHooks Function()
        > {
  $$FlashcardsTableTableTableManager(
    _$AppDatabase db,
    $FlashcardsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FlashcardsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FlashcardsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FlashcardsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> deckId = const Value.absent(),
                Value<String> question = const Value.absent(),
                Value<String> answer = const Value.absent(),
                Value<int> box = const Value.absent(),
                Value<double> easeFactor = const Value.absent(),
                Value<int> repetitions = const Value.absent(),
                Value<DateTime> nextReviewDate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FlashcardsTableCompanion(
                id: id,
                deckId: deckId,
                question: question,
                answer: answer,
                box: box,
                easeFactor: easeFactor,
                repetitions: repetitions,
                nextReviewDate: nextReviewDate,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String deckId,
                required String question,
                required String answer,
                Value<int> box = const Value.absent(),
                Value<double> easeFactor = const Value.absent(),
                Value<int> repetitions = const Value.absent(),
                required DateTime nextReviewDate,
                Value<int> rowid = const Value.absent(),
              }) => FlashcardsTableCompanion.insert(
                id: id,
                deckId: deckId,
                question: question,
                answer: answer,
                box: box,
                easeFactor: easeFactor,
                repetitions: repetitions,
                nextReviewDate: nextReviewDate,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FlashcardsTableTable, FlashcardsTableData>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $FlashcardsTableTable,
                    FlashcardsTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FlashcardsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FlashcardsTableTable,
      FlashcardsTableData,
      $$FlashcardsTableTableFilterComposer,
      $$FlashcardsTableTableOrderingComposer,
      $$FlashcardsTableTableAnnotationComposer,
      $$FlashcardsTableTableCreateCompanionBuilder,
      $$FlashcardsTableTableUpdateCompanionBuilder,
      (
        FlashcardsTableData,
        BaseReferences<
          _$AppDatabase,
          $FlashcardsTableTable,
          FlashcardsTableData
        >,
      ),
      FlashcardsTableData,
      PrefetchHooks Function()
    >;
typedef $$HabitsTableTableCreateCompanionBuilder =
    HabitsTableCompanion Function({
      required String id,
      required String title,
      required String icon,
      required String color,
      Value<int> targetDaysPerWeek,
      Value<int> currentStreak,
      Value<DateTime?> lastCompletedDate,
      Value<int> rowid,
    });
typedef $$HabitsTableTableUpdateCompanionBuilder =
    HabitsTableCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> icon,
      Value<String> color,
      Value<int> targetDaysPerWeek,
      Value<int> currentStreak,
      Value<DateTime?> lastCompletedDate,
      Value<int> rowid,
    });

class $$HabitsTableTableFilterComposer
    extends Composer<_$AppDatabase, $HabitsTableTable> {
  $$HabitsTableTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetDaysPerWeek => $composableBuilder(
    column: $table.targetDaysPerWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastCompletedDate => $composableBuilder(
    column: $table.lastCompletedDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HabitsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitsTableTable> {
  $$HabitsTableTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetDaysPerWeek => $composableBuilder(
    column: $table.targetDaysPerWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastCompletedDate => $composableBuilder(
    column: $table.lastCompletedDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HabitsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitsTableTable> {
  $$HabitsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<int> get targetDaysPerWeek => $composableBuilder(
    column: $table.targetDaysPerWeek,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastCompletedDate => $composableBuilder(
    column: $table.lastCompletedDate,
    builder: (column) => column,
  );
}

class $$HabitsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitsTableTable,
          HabitsTableData,
          $$HabitsTableTableFilterComposer,
          $$HabitsTableTableOrderingComposer,
          $$HabitsTableTableAnnotationComposer,
          $$HabitsTableTableCreateCompanionBuilder,
          $$HabitsTableTableUpdateCompanionBuilder,
          (
            HabitsTableData,
            BaseReferences<_$AppDatabase, $HabitsTableTable, HabitsTableData>,
          ),
          HabitsTableData,
          PrefetchHooks Function()
        > {
  $$HabitsTableTableTableManager(_$AppDatabase db, $HabitsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<int> targetDaysPerWeek = const Value.absent(),
                Value<int> currentStreak = const Value.absent(),
                Value<DateTime?> lastCompletedDate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitsTableCompanion(
                id: id,
                title: title,
                icon: icon,
                color: color,
                targetDaysPerWeek: targetDaysPerWeek,
                currentStreak: currentStreak,
                lastCompletedDate: lastCompletedDate,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String icon,
                required String color,
                Value<int> targetDaysPerWeek = const Value.absent(),
                Value<int> currentStreak = const Value.absent(),
                Value<DateTime?> lastCompletedDate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitsTableCompanion.insert(
                id: id,
                title: title,
                icon: icon,
                color: color,
                targetDaysPerWeek: targetDaysPerWeek,
                currentStreak: currentStreak,
                lastCompletedDate: lastCompletedDate,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HabitsTableTable, HabitsTableData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $HabitsTableTable,
                    HabitsTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HabitsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitsTableTable,
      HabitsTableData,
      $$HabitsTableTableFilterComposer,
      $$HabitsTableTableOrderingComposer,
      $$HabitsTableTableAnnotationComposer,
      $$HabitsTableTableCreateCompanionBuilder,
      $$HabitsTableTableUpdateCompanionBuilder,
      (
        HabitsTableData,
        BaseReferences<_$AppDatabase, $HabitsTableTable, HabitsTableData>,
      ),
      HabitsTableData,
      PrefetchHooks Function()
    >;
typedef $$BudgetTableTableCreateCompanionBuilder =
    BudgetTableCompanion Function({
      required String id,
      required String title,
      required double amount,
      required String category,
      required DateTime date,
      Value<bool> isMealPlanSwipe,
      Value<int> rowid,
    });
typedef $$BudgetTableTableUpdateCompanionBuilder =
    BudgetTableCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<double> amount,
      Value<String> category,
      Value<DateTime> date,
      Value<bool> isMealPlanSwipe,
      Value<int> rowid,
    });

class $$BudgetTableTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetTableTable> {
  $$BudgetTableTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isMealPlanSwipe => $composableBuilder(
    column: $table.isMealPlanSwipe,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BudgetTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetTableTable> {
  $$BudgetTableTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isMealPlanSwipe => $composableBuilder(
    column: $table.isMealPlanSwipe,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BudgetTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetTableTable> {
  $$BudgetTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<bool> get isMealPlanSwipe => $composableBuilder(
    column: $table.isMealPlanSwipe,
    builder: (column) => column,
  );
}

class $$BudgetTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetTableTable,
          BudgetTableData,
          $$BudgetTableTableFilterComposer,
          $$BudgetTableTableOrderingComposer,
          $$BudgetTableTableAnnotationComposer,
          $$BudgetTableTableCreateCompanionBuilder,
          $$BudgetTableTableUpdateCompanionBuilder,
          (
            BudgetTableData,
            BaseReferences<_$AppDatabase, $BudgetTableTable, BudgetTableData>,
          ),
          BudgetTableData,
          PrefetchHooks Function()
        > {
  $$BudgetTableTableTableManager(_$AppDatabase db, $BudgetTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<bool> isMealPlanSwipe = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BudgetTableCompanion(
                id: id,
                title: title,
                amount: amount,
                category: category,
                date: date,
                isMealPlanSwipe: isMealPlanSwipe,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required double amount,
                required String category,
                required DateTime date,
                Value<bool> isMealPlanSwipe = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BudgetTableCompanion.insert(
                id: id,
                title: title,
                amount: amount,
                category: category,
                date: date,
                isMealPlanSwipe: isMealPlanSwipe,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BudgetTableTable, BudgetTableData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $BudgetTableTable,
                    BudgetTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BudgetTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetTableTable,
      BudgetTableData,
      $$BudgetTableTableFilterComposer,
      $$BudgetTableTableOrderingComposer,
      $$BudgetTableTableAnnotationComposer,
      $$BudgetTableTableCreateCompanionBuilder,
      $$BudgetTableTableUpdateCompanionBuilder,
      (
        BudgetTableData,
        BaseReferences<_$AppDatabase, $BudgetTableTable, BudgetTableData>,
      ),
      BudgetTableData,
      PrefetchHooks Function()
    >;
typedef $$MoodTableTableCreateCompanionBuilder = MoodTableCompanion Function({
  required String id,
  required int score,
  required String emotion,
  Value<String> notes,
  required DateTime timestamp,
  Value<int> rowid,
});
typedef $$MoodTableTableUpdateCompanionBuilder = MoodTableCompanion Function({
  Value<String> id,
  Value<int> score,
  Value<String> emotion,
  Value<String> notes,
  Value<DateTime> timestamp,
  Value<int> rowid,
});

class $$MoodTableTableFilterComposer
    extends Composer<_$AppDatabase, $MoodTableTable> {
  $$MoodTableTableFilterComposer({
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

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emotion => $composableBuilder(
    column: $table.emotion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MoodTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MoodTableTable> {
  $$MoodTableTableOrderingComposer({
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

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emotion => $composableBuilder(
    column: $table.emotion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MoodTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MoodTableTable> {
  $$MoodTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<String> get emotion =>
      $composableBuilder(column: $table.emotion, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$MoodTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MoodTableTable,
          MoodTableData,
          $$MoodTableTableFilterComposer,
          $$MoodTableTableOrderingComposer,
          $$MoodTableTableAnnotationComposer,
          $$MoodTableTableCreateCompanionBuilder,
          $$MoodTableTableUpdateCompanionBuilder,
          (
            MoodTableData,
            BaseReferences<_$AppDatabase, $MoodTableTable, MoodTableData>,
          ),
          MoodTableData,
          PrefetchHooks Function()
        > {
  $$MoodTableTableTableManager(_$AppDatabase db, $MoodTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MoodTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MoodTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MoodTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> score = const Value.absent(),
                Value<String> emotion = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MoodTableCompanion(
                id: id,
                score: score,
                emotion: emotion,
                notes: notes,
                timestamp: timestamp,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int score,
                required String emotion,
                Value<String> notes = const Value.absent(),
                required DateTime timestamp,
                Value<int> rowid = const Value.absent(),
              }) => MoodTableCompanion.insert(
                id: id,
                score: score,
                emotion: emotion,
                notes: notes,
                timestamp: timestamp,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MoodTableTable, MoodTableData>(table),
                  BaseReferences<_$AppDatabase, $MoodTableTable, MoodTableData>(
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

typedef $$MoodTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MoodTableTable,
      MoodTableData,
      $$MoodTableTableFilterComposer,
      $$MoodTableTableOrderingComposer,
      $$MoodTableTableAnnotationComposer,
      $$MoodTableTableCreateCompanionBuilder,
      $$MoodTableTableUpdateCompanionBuilder,
      (
        MoodTableData,
        BaseReferences<_$AppDatabase, $MoodTableTable, MoodTableData>,
      ),
      MoodTableData,
      PrefetchHooks Function()
    >;
typedef $$EncryptedVaultTableTableCreateCompanionBuilder =
    EncryptedVaultTableCompanion Function({
      required String id,
      required String category,
      required String encryptedPayload,
      required String iv,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$EncryptedVaultTableTableUpdateCompanionBuilder =
    EncryptedVaultTableCompanion Function({
      Value<String> id,
      Value<String> category,
      Value<String> encryptedPayload,
      Value<String> iv,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$EncryptedVaultTableTableFilterComposer
    extends Composer<_$AppDatabase, $EncryptedVaultTableTable> {
  $$EncryptedVaultTableTableFilterComposer({
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

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get encryptedPayload => $composableBuilder(
    column: $table.encryptedPayload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iv => $composableBuilder(
    column: $table.iv,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EncryptedVaultTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EncryptedVaultTableTable> {
  $$EncryptedVaultTableTableOrderingComposer({
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

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get encryptedPayload => $composableBuilder(
    column: $table.encryptedPayload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iv => $composableBuilder(
    column: $table.iv,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EncryptedVaultTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EncryptedVaultTableTable> {
  $$EncryptedVaultTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get encryptedPayload => $composableBuilder(
    column: $table.encryptedPayload,
    builder: (column) => column,
  );

  GeneratedColumn<String> get iv =>
      $composableBuilder(column: $table.iv, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$EncryptedVaultTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EncryptedVaultTableTable,
          EncryptedVaultTableData,
          $$EncryptedVaultTableTableFilterComposer,
          $$EncryptedVaultTableTableOrderingComposer,
          $$EncryptedVaultTableTableAnnotationComposer,
          $$EncryptedVaultTableTableCreateCompanionBuilder,
          $$EncryptedVaultTableTableUpdateCompanionBuilder,
          (
            EncryptedVaultTableData,
            BaseReferences<
              _$AppDatabase,
              $EncryptedVaultTableTable,
              EncryptedVaultTableData
            >,
          ),
          EncryptedVaultTableData,
          PrefetchHooks Function()
        > {
  $$EncryptedVaultTableTableTableManager(
    _$AppDatabase db,
    $EncryptedVaultTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EncryptedVaultTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EncryptedVaultTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$EncryptedVaultTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> encryptedPayload = const Value.absent(),
                Value<String> iv = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EncryptedVaultTableCompanion(
                id: id,
                category: category,
                encryptedPayload: encryptedPayload,
                iv: iv,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String category,
                required String encryptedPayload,
                required String iv,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => EncryptedVaultTableCompanion.insert(
                id: id,
                category: category,
                encryptedPayload: encryptedPayload,
                iv: iv,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $EncryptedVaultTableTable,
                    EncryptedVaultTableData
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $EncryptedVaultTableTable,
                    EncryptedVaultTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EncryptedVaultTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EncryptedVaultTableTable,
      EncryptedVaultTableData,
      $$EncryptedVaultTableTableFilterComposer,
      $$EncryptedVaultTableTableOrderingComposer,
      $$EncryptedVaultTableTableAnnotationComposer,
      $$EncryptedVaultTableTableCreateCompanionBuilder,
      $$EncryptedVaultTableTableUpdateCompanionBuilder,
      (
        EncryptedVaultTableData,
        BaseReferences<
          _$AppDatabase,
          $EncryptedVaultTableTable,
          EncryptedVaultTableData
        >,
      ),
      EncryptedVaultTableData,
      PrefetchHooks Function()
    >;
typedef $$StudentProfileTableTableCreateCompanionBuilder =
    StudentProfileTableCompanion Function({
      required String id,
      Value<String> fullName,
      Value<String?> photoPath,
      Value<String> degree,
      Value<String> branch,
      Value<int> year,
      Value<int> semester,
      Value<String> college,
      Value<String> city,
      Value<String> state,
      Value<String> enrollmentNumber,
      Value<String?> apaarId,
      Value<DateTime?> semesterStartDate,
      Value<DateTime?> semesterEndDate,
      Value<String> gradingScheme,
      Value<double> targetCgpa,
      Value<double> attendanceRuleThreshold,
      Value<String?> emergencyContactName,
      Value<String?> emergencyContactPhone,
      Value<bool> onboardingCompleted,
      Value<int> setupStep,
      Value<bool> isAppLockEnabled,
      Value<String?> pinCodeHash,
      Value<bool> useBiometrics,
      Value<String> upiId,
      Value<String> selectedCampusId,
      Value<String> selectedCampusName,
      Value<String> preferredLanguage,
      Value<bool> notificationsEnabled,
      Value<bool> tutorialCompleted,
      Value<String?> mapFilePath,
      Value<String?> mapVersion,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$StudentProfileTableTableUpdateCompanionBuilder =
    StudentProfileTableCompanion Function({
      Value<String> id,
      Value<String> fullName,
      Value<String?> photoPath,
      Value<String> degree,
      Value<String> branch,
      Value<int> year,
      Value<int> semester,
      Value<String> college,
      Value<String> city,
      Value<String> state,
      Value<String> enrollmentNumber,
      Value<String?> apaarId,
      Value<DateTime?> semesterStartDate,
      Value<DateTime?> semesterEndDate,
      Value<String> gradingScheme,
      Value<double> targetCgpa,
      Value<double> attendanceRuleThreshold,
      Value<String?> emergencyContactName,
      Value<String?> emergencyContactPhone,
      Value<bool> onboardingCompleted,
      Value<int> setupStep,
      Value<bool> isAppLockEnabled,
      Value<String?> pinCodeHash,
      Value<bool> useBiometrics,
      Value<String> upiId,
      Value<String> selectedCampusId,
      Value<String> selectedCampusName,
      Value<String> preferredLanguage,
      Value<bool> notificationsEnabled,
      Value<bool> tutorialCompleted,
      Value<String?> mapFilePath,
      Value<String?> mapVersion,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$StudentProfileTableTableFilterComposer
    extends Composer<_$AppDatabase, $StudentProfileTableTable> {
  $$StudentProfileTableTableFilterComposer({
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

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get degree => $composableBuilder(
    column: $table.degree,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get branch => $composableBuilder(
    column: $table.branch,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get semester => $composableBuilder(
    column: $table.semester,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get college => $composableBuilder(
    column: $table.college,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get enrollmentNumber => $composableBuilder(
    column: $table.enrollmentNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get apaarId => $composableBuilder(
    column: $table.apaarId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get semesterStartDate => $composableBuilder(
    column: $table.semesterStartDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get semesterEndDate => $composableBuilder(
    column: $table.semesterEndDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gradingScheme => $composableBuilder(
    column: $table.gradingScheme,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetCgpa => $composableBuilder(
    column: $table.targetCgpa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get attendanceRuleThreshold => $composableBuilder(
    column: $table.attendanceRuleThreshold,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emergencyContactName => $composableBuilder(
    column: $table.emergencyContactName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emergencyContactPhone => $composableBuilder(
    column: $table.emergencyContactPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get setupStep => $composableBuilder(
    column: $table.setupStep,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAppLockEnabled => $composableBuilder(
    column: $table.isAppLockEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinCodeHash => $composableBuilder(
    column: $table.pinCodeHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get useBiometrics => $composableBuilder(
    column: $table.useBiometrics,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get upiId => $composableBuilder(
    column: $table.upiId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selectedCampusId => $composableBuilder(
    column: $table.selectedCampusId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selectedCampusName => $composableBuilder(
    column: $table.selectedCampusName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferredLanguage => $composableBuilder(
    column: $table.preferredLanguage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get tutorialCompleted => $composableBuilder(
    column: $table.tutorialCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mapFilePath => $composableBuilder(
    column: $table.mapFilePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mapVersion => $composableBuilder(
    column: $table.mapVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StudentProfileTableTableOrderingComposer
    extends Composer<_$AppDatabase, $StudentProfileTableTable> {
  $$StudentProfileTableTableOrderingComposer({
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

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get degree => $composableBuilder(
    column: $table.degree,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get branch => $composableBuilder(
    column: $table.branch,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get semester => $composableBuilder(
    column: $table.semester,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get college => $composableBuilder(
    column: $table.college,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get enrollmentNumber => $composableBuilder(
    column: $table.enrollmentNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get apaarId => $composableBuilder(
    column: $table.apaarId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get semesterStartDate => $composableBuilder(
    column: $table.semesterStartDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get semesterEndDate => $composableBuilder(
    column: $table.semesterEndDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gradingScheme => $composableBuilder(
    column: $table.gradingScheme,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetCgpa => $composableBuilder(
    column: $table.targetCgpa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get attendanceRuleThreshold => $composableBuilder(
    column: $table.attendanceRuleThreshold,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emergencyContactName => $composableBuilder(
    column: $table.emergencyContactName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emergencyContactPhone => $composableBuilder(
    column: $table.emergencyContactPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get setupStep => $composableBuilder(
    column: $table.setupStep,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAppLockEnabled => $composableBuilder(
    column: $table.isAppLockEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinCodeHash => $composableBuilder(
    column: $table.pinCodeHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get useBiometrics => $composableBuilder(
    column: $table.useBiometrics,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get upiId => $composableBuilder(
    column: $table.upiId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedCampusId => $composableBuilder(
    column: $table.selectedCampusId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedCampusName => $composableBuilder(
    column: $table.selectedCampusName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredLanguage => $composableBuilder(
    column: $table.preferredLanguage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get tutorialCompleted => $composableBuilder(
    column: $table.tutorialCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mapFilePath => $composableBuilder(
    column: $table.mapFilePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mapVersion => $composableBuilder(
    column: $table.mapVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StudentProfileTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudentProfileTableTable> {
  $$StudentProfileTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get degree =>
      $composableBuilder(column: $table.degree, builder: (column) => column);

  GeneratedColumn<String> get branch =>
      $composableBuilder(column: $table.branch, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get semester =>
      $composableBuilder(column: $table.semester, builder: (column) => column);

  GeneratedColumn<String> get college =>
      $composableBuilder(column: $table.college, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get enrollmentNumber => $composableBuilder(
    column: $table.enrollmentNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get apaarId =>
      $composableBuilder(column: $table.apaarId, builder: (column) => column);

  GeneratedColumn<DateTime> get semesterStartDate => $composableBuilder(
    column: $table.semesterStartDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get semesterEndDate => $composableBuilder(
    column: $table.semesterEndDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get gradingScheme => $composableBuilder(
    column: $table.gradingScheme,
    builder: (column) => column,
  );

  GeneratedColumn<double> get targetCgpa => $composableBuilder(
    column: $table.targetCgpa,
    builder: (column) => column,
  );

  GeneratedColumn<double> get attendanceRuleThreshold => $composableBuilder(
    column: $table.attendanceRuleThreshold,
    builder: (column) => column,
  );

  GeneratedColumn<String> get emergencyContactName => $composableBuilder(
    column: $table.emergencyContactName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get emergencyContactPhone => $composableBuilder(
    column: $table.emergencyContactPhone,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get setupStep =>
      $composableBuilder(column: $table.setupStep, builder: (column) => column);

  GeneratedColumn<bool> get isAppLockEnabled => $composableBuilder(
    column: $table.isAppLockEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pinCodeHash => $composableBuilder(
    column: $table.pinCodeHash,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get useBiometrics => $composableBuilder(
    column: $table.useBiometrics,
    builder: (column) => column,
  );

  GeneratedColumn<String> get upiId =>
      $composableBuilder(column: $table.upiId, builder: (column) => column);

  GeneratedColumn<String> get selectedCampusId => $composableBuilder(
    column: $table.selectedCampusId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get selectedCampusName => $composableBuilder(
    column: $table.selectedCampusName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get preferredLanguage => $composableBuilder(
    column: $table.preferredLanguage,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get tutorialCompleted => $composableBuilder(
    column: $table.tutorialCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mapFilePath => $composableBuilder(
    column: $table.mapFilePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mapVersion => $composableBuilder(
    column: $table.mapVersion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$StudentProfileTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudentProfileTableTable,
          StudentProfileTableData,
          $$StudentProfileTableTableFilterComposer,
          $$StudentProfileTableTableOrderingComposer,
          $$StudentProfileTableTableAnnotationComposer,
          $$StudentProfileTableTableCreateCompanionBuilder,
          $$StudentProfileTableTableUpdateCompanionBuilder,
          (
            StudentProfileTableData,
            BaseReferences<
              _$AppDatabase,
              $StudentProfileTableTable,
              StudentProfileTableData
            >,
          ),
          StudentProfileTableData,
          PrefetchHooks Function()
        > {
  $$StudentProfileTableTableTableManager(
    _$AppDatabase db,
    $StudentProfileTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudentProfileTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudentProfileTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$StudentProfileTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String> degree = const Value.absent(),
                Value<String> branch = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<int> semester = const Value.absent(),
                Value<String> college = const Value.absent(),
                Value<String> city = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<String> enrollmentNumber = const Value.absent(),
                Value<String?> apaarId = const Value.absent(),
                Value<DateTime?> semesterStartDate = const Value.absent(),
                Value<DateTime?> semesterEndDate = const Value.absent(),
                Value<String> gradingScheme = const Value.absent(),
                Value<double> targetCgpa = const Value.absent(),
                Value<double> attendanceRuleThreshold = const Value.absent(),
                Value<String?> emergencyContactName = const Value.absent(),
                Value<String?> emergencyContactPhone = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
                Value<int> setupStep = const Value.absent(),
                Value<bool> isAppLockEnabled = const Value.absent(),
                Value<String?> pinCodeHash = const Value.absent(),
                Value<bool> useBiometrics = const Value.absent(),
                Value<String> upiId = const Value.absent(),
                Value<String> selectedCampusId = const Value.absent(),
                Value<String> selectedCampusName = const Value.absent(),
                Value<String> preferredLanguage = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
                Value<bool> tutorialCompleted = const Value.absent(),
                Value<String?> mapFilePath = const Value.absent(),
                Value<String?> mapVersion = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudentProfileTableCompanion(
                id: id,
                fullName: fullName,
                photoPath: photoPath,
                degree: degree,
                branch: branch,
                year: year,
                semester: semester,
                college: college,
                city: city,
                state: state,
                enrollmentNumber: enrollmentNumber,
                apaarId: apaarId,
                semesterStartDate: semesterStartDate,
                semesterEndDate: semesterEndDate,
                gradingScheme: gradingScheme,
                targetCgpa: targetCgpa,
                attendanceRuleThreshold: attendanceRuleThreshold,
                emergencyContactName: emergencyContactName,
                emergencyContactPhone: emergencyContactPhone,
                onboardingCompleted: onboardingCompleted,
                setupStep: setupStep,
                isAppLockEnabled: isAppLockEnabled,
                pinCodeHash: pinCodeHash,
                useBiometrics: useBiometrics,
                upiId: upiId,
                selectedCampusId: selectedCampusId,
                selectedCampusName: selectedCampusName,
                preferredLanguage: preferredLanguage,
                notificationsEnabled: notificationsEnabled,
                tutorialCompleted: tutorialCompleted,
                mapFilePath: mapFilePath,
                mapVersion: mapVersion,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> fullName = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String> degree = const Value.absent(),
                Value<String> branch = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<int> semester = const Value.absent(),
                Value<String> college = const Value.absent(),
                Value<String> city = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<String> enrollmentNumber = const Value.absent(),
                Value<String?> apaarId = const Value.absent(),
                Value<DateTime?> semesterStartDate = const Value.absent(),
                Value<DateTime?> semesterEndDate = const Value.absent(),
                Value<String> gradingScheme = const Value.absent(),
                Value<double> targetCgpa = const Value.absent(),
                Value<double> attendanceRuleThreshold = const Value.absent(),
                Value<String?> emergencyContactName = const Value.absent(),
                Value<String?> emergencyContactPhone = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
                Value<int> setupStep = const Value.absent(),
                Value<bool> isAppLockEnabled = const Value.absent(),
                Value<String?> pinCodeHash = const Value.absent(),
                Value<bool> useBiometrics = const Value.absent(),
                Value<String> upiId = const Value.absent(),
                Value<String> selectedCampusId = const Value.absent(),
                Value<String> selectedCampusName = const Value.absent(),
                Value<String> preferredLanguage = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
                Value<bool> tutorialCompleted = const Value.absent(),
                Value<String?> mapFilePath = const Value.absent(),
                Value<String?> mapVersion = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => StudentProfileTableCompanion.insert(
                id: id,
                fullName: fullName,
                photoPath: photoPath,
                degree: degree,
                branch: branch,
                year: year,
                semester: semester,
                college: college,
                city: city,
                state: state,
                enrollmentNumber: enrollmentNumber,
                apaarId: apaarId,
                semesterStartDate: semesterStartDate,
                semesterEndDate: semesterEndDate,
                gradingScheme: gradingScheme,
                targetCgpa: targetCgpa,
                attendanceRuleThreshold: attendanceRuleThreshold,
                emergencyContactName: emergencyContactName,
                emergencyContactPhone: emergencyContactPhone,
                onboardingCompleted: onboardingCompleted,
                setupStep: setupStep,
                isAppLockEnabled: isAppLockEnabled,
                pinCodeHash: pinCodeHash,
                useBiometrics: useBiometrics,
                upiId: upiId,
                selectedCampusId: selectedCampusId,
                selectedCampusName: selectedCampusName,
                preferredLanguage: preferredLanguage,
                notificationsEnabled: notificationsEnabled,
                tutorialCompleted: tutorialCompleted,
                mapFilePath: mapFilePath,
                mapVersion: mapVersion,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $StudentProfileTableTable,
                    StudentProfileTableData
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $StudentProfileTableTable,
                    StudentProfileTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StudentProfileTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudentProfileTableTable,
      StudentProfileTableData,
      $$StudentProfileTableTableFilterComposer,
      $$StudentProfileTableTableOrderingComposer,
      $$StudentProfileTableTableAnnotationComposer,
      $$StudentProfileTableTableCreateCompanionBuilder,
      $$StudentProfileTableTableUpdateCompanionBuilder,
      (
        StudentProfileTableData,
        BaseReferences<
          _$AppDatabase,
          $StudentProfileTableTable,
          StudentProfileTableData
        >,
      ),
      StudentProfileTableData,
      PrefetchHooks Function()
    >;
typedef $$PastPapersTableTableCreateCompanionBuilder =
    PastPapersTableCompanion Function({
      required String id,
      required String courseCode,
      required String courseName,
      required int year,
      required String examType,
      Value<String?> fileUrl,
      required int semester,
      Value<int> rowid,
    });
typedef $$PastPapersTableTableUpdateCompanionBuilder =
    PastPapersTableCompanion Function({
      Value<String> id,
      Value<String> courseCode,
      Value<String> courseName,
      Value<int> year,
      Value<String> examType,
      Value<String?> fileUrl,
      Value<int> semester,
      Value<int> rowid,
    });

class $$PastPapersTableTableFilterComposer
    extends Composer<_$AppDatabase, $PastPapersTableTable> {
  $$PastPapersTableTableFilterComposer({
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

  ColumnFilters<String> get courseCode => $composableBuilder(
    column: $table.courseCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get courseName => $composableBuilder(
    column: $table.courseName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get examType => $composableBuilder(
    column: $table.examType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileUrl => $composableBuilder(
    column: $table.fileUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get semester => $composableBuilder(
    column: $table.semester,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PastPapersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PastPapersTableTable> {
  $$PastPapersTableTableOrderingComposer({
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

  ColumnOrderings<String> get courseCode => $composableBuilder(
    column: $table.courseCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get courseName => $composableBuilder(
    column: $table.courseName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get examType => $composableBuilder(
    column: $table.examType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileUrl => $composableBuilder(
    column: $table.fileUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get semester => $composableBuilder(
    column: $table.semester,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PastPapersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PastPapersTableTable> {
  $$PastPapersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get courseCode => $composableBuilder(
    column: $table.courseCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get courseName => $composableBuilder(
    column: $table.courseName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get examType =>
      $composableBuilder(column: $table.examType, builder: (column) => column);

  GeneratedColumn<String> get fileUrl =>
      $composableBuilder(column: $table.fileUrl, builder: (column) => column);

  GeneratedColumn<int> get semester =>
      $composableBuilder(column: $table.semester, builder: (column) => column);
}

class $$PastPapersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PastPapersTableTable,
          PastPapersTableData,
          $$PastPapersTableTableFilterComposer,
          $$PastPapersTableTableOrderingComposer,
          $$PastPapersTableTableAnnotationComposer,
          $$PastPapersTableTableCreateCompanionBuilder,
          $$PastPapersTableTableUpdateCompanionBuilder,
          (
            PastPapersTableData,
            BaseReferences<
              _$AppDatabase,
              $PastPapersTableTable,
              PastPapersTableData
            >,
          ),
          PastPapersTableData,
          PrefetchHooks Function()
        > {
  $$PastPapersTableTableTableManager(
    _$AppDatabase db,
    $PastPapersTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PastPapersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PastPapersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PastPapersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> courseCode = const Value.absent(),
                Value<String> courseName = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<String> examType = const Value.absent(),
                Value<String?> fileUrl = const Value.absent(),
                Value<int> semester = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PastPapersTableCompanion(
                id: id,
                courseCode: courseCode,
                courseName: courseName,
                year: year,
                examType: examType,
                fileUrl: fileUrl,
                semester: semester,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String courseCode,
                required String courseName,
                required int year,
                required String examType,
                Value<String?> fileUrl = const Value.absent(),
                required int semester,
                Value<int> rowid = const Value.absent(),
              }) => PastPapersTableCompanion.insert(
                id: id,
                courseCode: courseCode,
                courseName: courseName,
                year: year,
                examType: examType,
                fileUrl: fileUrl,
                semester: semester,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PastPapersTableTable, PastPapersTableData>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $PastPapersTableTable,
                    PastPapersTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PastPapersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PastPapersTableTable,
      PastPapersTableData,
      $$PastPapersTableTableFilterComposer,
      $$PastPapersTableTableOrderingComposer,
      $$PastPapersTableTableAnnotationComposer,
      $$PastPapersTableTableCreateCompanionBuilder,
      $$PastPapersTableTableUpdateCompanionBuilder,
      (
        PastPapersTableData,
        BaseReferences<
          _$AppDatabase,
          $PastPapersTableTable,
          PastPapersTableData
        >,
      ),
      PastPapersTableData,
      PrefetchHooks Function()
    >;
typedef $$StudyPlansTableTableCreateCompanionBuilder =
    StudyPlansTableCompanion Function({
      required String id,
      required String title,
      Value<String?> courseCode,
      required DateTime targetDate,
      required double totalHours,
      Value<double> completedHours,
      Value<String> status,
      Value<int> rowid,
    });
typedef $$StudyPlansTableTableUpdateCompanionBuilder =
    StudyPlansTableCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> courseCode,
      Value<DateTime> targetDate,
      Value<double> totalHours,
      Value<double> completedHours,
      Value<String> status,
      Value<int> rowid,
    });

class $$StudyPlansTableTableFilterComposer
    extends Composer<_$AppDatabase, $StudyPlansTableTable> {
  $$StudyPlansTableTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get courseCode => $composableBuilder(
    column: $table.courseCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalHours => $composableBuilder(
    column: $table.totalHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get completedHours => $composableBuilder(
    column: $table.completedHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StudyPlansTableTableOrderingComposer
    extends Composer<_$AppDatabase, $StudyPlansTableTable> {
  $$StudyPlansTableTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get courseCode => $composableBuilder(
    column: $table.courseCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalHours => $composableBuilder(
    column: $table.totalHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get completedHours => $composableBuilder(
    column: $table.completedHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StudyPlansTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudyPlansTableTable> {
  $$StudyPlansTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get courseCode => $composableBuilder(
    column: $table.courseCode,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalHours => $composableBuilder(
    column: $table.totalHours,
    builder: (column) => column,
  );

  GeneratedColumn<double> get completedHours => $composableBuilder(
    column: $table.completedHours,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$StudyPlansTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudyPlansTableTable,
          StudyPlansTableData,
          $$StudyPlansTableTableFilterComposer,
          $$StudyPlansTableTableOrderingComposer,
          $$StudyPlansTableTableAnnotationComposer,
          $$StudyPlansTableTableCreateCompanionBuilder,
          $$StudyPlansTableTableUpdateCompanionBuilder,
          (
            StudyPlansTableData,
            BaseReferences<
              _$AppDatabase,
              $StudyPlansTableTable,
              StudyPlansTableData
            >,
          ),
          StudyPlansTableData,
          PrefetchHooks Function()
        > {
  $$StudyPlansTableTableTableManager(
    _$AppDatabase db,
    $StudyPlansTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudyPlansTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudyPlansTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudyPlansTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> courseCode = const Value.absent(),
                Value<DateTime> targetDate = const Value.absent(),
                Value<double> totalHours = const Value.absent(),
                Value<double> completedHours = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudyPlansTableCompanion(
                id: id,
                title: title,
                courseCode: courseCode,
                targetDate: targetDate,
                totalHours: totalHours,
                completedHours: completedHours,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> courseCode = const Value.absent(),
                required DateTime targetDate,
                required double totalHours,
                Value<double> completedHours = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudyPlansTableCompanion.insert(
                id: id,
                title: title,
                courseCode: courseCode,
                targetDate: targetDate,
                totalHours: totalHours,
                completedHours: completedHours,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StudyPlansTableTable, StudyPlansTableData>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $StudyPlansTableTable,
                    StudyPlansTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StudyPlansTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudyPlansTableTable,
      StudyPlansTableData,
      $$StudyPlansTableTableFilterComposer,
      $$StudyPlansTableTableOrderingComposer,
      $$StudyPlansTableTableAnnotationComposer,
      $$StudyPlansTableTableCreateCompanionBuilder,
      $$StudyPlansTableTableUpdateCompanionBuilder,
      (
        StudyPlansTableData,
        BaseReferences<
          _$AppDatabase,
          $StudyPlansTableTable,
          StudyPlansTableData
        >,
      ),
      StudyPlansTableData,
      PrefetchHooks Function()
    >;
typedef $$GroupProjectsTableTableCreateCompanionBuilder =
    GroupProjectsTableCompanion Function({
      required String id,
      required String title,
      Value<String?> courseCode,
      Value<String> description,
      Value<String> teamMembers,
      required DateTime dueDate,
      Value<double> progress,
      Value<int> rowid,
    });
typedef $$GroupProjectsTableTableUpdateCompanionBuilder =
    GroupProjectsTableCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> courseCode,
      Value<String> description,
      Value<String> teamMembers,
      Value<DateTime> dueDate,
      Value<double> progress,
      Value<int> rowid,
    });

class $$GroupProjectsTableTableFilterComposer
    extends Composer<_$AppDatabase, $GroupProjectsTableTable> {
  $$GroupProjectsTableTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get courseCode => $composableBuilder(
    column: $table.courseCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get teamMembers => $composableBuilder(
    column: $table.teamMembers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GroupProjectsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupProjectsTableTable> {
  $$GroupProjectsTableTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get courseCode => $composableBuilder(
    column: $table.courseCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get teamMembers => $composableBuilder(
    column: $table.teamMembers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GroupProjectsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupProjectsTableTable> {
  $$GroupProjectsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get courseCode => $composableBuilder(
    column: $table.courseCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get teamMembers => $composableBuilder(
    column: $table.teamMembers,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<double> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);
}

class $$GroupProjectsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GroupProjectsTableTable,
          GroupProjectsTableData,
          $$GroupProjectsTableTableFilterComposer,
          $$GroupProjectsTableTableOrderingComposer,
          $$GroupProjectsTableTableAnnotationComposer,
          $$GroupProjectsTableTableCreateCompanionBuilder,
          $$GroupProjectsTableTableUpdateCompanionBuilder,
          (
            GroupProjectsTableData,
            BaseReferences<
              _$AppDatabase,
              $GroupProjectsTableTable,
              GroupProjectsTableData
            >,
          ),
          GroupProjectsTableData,
          PrefetchHooks Function()
        > {
  $$GroupProjectsTableTableTableManager(
    _$AppDatabase db,
    $GroupProjectsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupProjectsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupProjectsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupProjectsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> courseCode = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> teamMembers = const Value.absent(),
                Value<DateTime> dueDate = const Value.absent(),
                Value<double> progress = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroupProjectsTableCompanion(
                id: id,
                title: title,
                courseCode: courseCode,
                description: description,
                teamMembers: teamMembers,
                dueDate: dueDate,
                progress: progress,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> courseCode = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> teamMembers = const Value.absent(),
                required DateTime dueDate,
                Value<double> progress = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroupProjectsTableCompanion.insert(
                id: id,
                title: title,
                courseCode: courseCode,
                description: description,
                teamMembers: teamMembers,
                dueDate: dueDate,
                progress: progress,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GroupProjectsTableTable, GroupProjectsTableData>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $GroupProjectsTableTable,
                    GroupProjectsTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GroupProjectsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GroupProjectsTableTable,
      GroupProjectsTableData,
      $$GroupProjectsTableTableFilterComposer,
      $$GroupProjectsTableTableOrderingComposer,
      $$GroupProjectsTableTableAnnotationComposer,
      $$GroupProjectsTableTableCreateCompanionBuilder,
      $$GroupProjectsTableTableUpdateCompanionBuilder,
      (
        GroupProjectsTableData,
        BaseReferences<
          _$AppDatabase,
          $GroupProjectsTableTable,
          GroupProjectsTableData
        >,
      ),
      GroupProjectsTableData,
      PrefetchHooks Function()
    >;
typedef $$OfficeHoursTableTableCreateCompanionBuilder =
    OfficeHoursTableCompanion Function({
      required String id,
      required String facultyName,
      required String department,
      Value<String?> courseCode,
      required int dayOfWeek,
      required String timeSlot,
      required String location,
      Value<String> bookingStatus,
      Value<int> rowid,
    });
typedef $$OfficeHoursTableTableUpdateCompanionBuilder =
    OfficeHoursTableCompanion Function({
      Value<String> id,
      Value<String> facultyName,
      Value<String> department,
      Value<String?> courseCode,
      Value<int> dayOfWeek,
      Value<String> timeSlot,
      Value<String> location,
      Value<String> bookingStatus,
      Value<int> rowid,
    });

class $$OfficeHoursTableTableFilterComposer
    extends Composer<_$AppDatabase, $OfficeHoursTableTable> {
  $$OfficeHoursTableTableFilterComposer({
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

  ColumnFilters<String> get facultyName => $composableBuilder(
    column: $table.facultyName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get courseCode => $composableBuilder(
    column: $table.courseCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timeSlot => $composableBuilder(
    column: $table.timeSlot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bookingStatus => $composableBuilder(
    column: $table.bookingStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OfficeHoursTableTableOrderingComposer
    extends Composer<_$AppDatabase, $OfficeHoursTableTable> {
  $$OfficeHoursTableTableOrderingComposer({
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

  ColumnOrderings<String> get facultyName => $composableBuilder(
    column: $table.facultyName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get courseCode => $composableBuilder(
    column: $table.courseCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeSlot => $composableBuilder(
    column: $table.timeSlot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bookingStatus => $composableBuilder(
    column: $table.bookingStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OfficeHoursTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $OfficeHoursTableTable> {
  $$OfficeHoursTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get facultyName => $composableBuilder(
    column: $table.facultyName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => column,
  );

  GeneratedColumn<String> get courseCode => $composableBuilder(
    column: $table.courseCode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dayOfWeek =>
      $composableBuilder(column: $table.dayOfWeek, builder: (column) => column);

  GeneratedColumn<String> get timeSlot =>
      $composableBuilder(column: $table.timeSlot, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get bookingStatus => $composableBuilder(
    column: $table.bookingStatus,
    builder: (column) => column,
  );
}

class $$OfficeHoursTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OfficeHoursTableTable,
          OfficeHoursTableData,
          $$OfficeHoursTableTableFilterComposer,
          $$OfficeHoursTableTableOrderingComposer,
          $$OfficeHoursTableTableAnnotationComposer,
          $$OfficeHoursTableTableCreateCompanionBuilder,
          $$OfficeHoursTableTableUpdateCompanionBuilder,
          (
            OfficeHoursTableData,
            BaseReferences<
              _$AppDatabase,
              $OfficeHoursTableTable,
              OfficeHoursTableData
            >,
          ),
          OfficeHoursTableData,
          PrefetchHooks Function()
        > {
  $$OfficeHoursTableTableTableManager(
    _$AppDatabase db,
    $OfficeHoursTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OfficeHoursTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OfficeHoursTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OfficeHoursTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> facultyName = const Value.absent(),
                Value<String> department = const Value.absent(),
                Value<String?> courseCode = const Value.absent(),
                Value<int> dayOfWeek = const Value.absent(),
                Value<String> timeSlot = const Value.absent(),
                Value<String> location = const Value.absent(),
                Value<String> bookingStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OfficeHoursTableCompanion(
                id: id,
                facultyName: facultyName,
                department: department,
                courseCode: courseCode,
                dayOfWeek: dayOfWeek,
                timeSlot: timeSlot,
                location: location,
                bookingStatus: bookingStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String facultyName,
                required String department,
                Value<String?> courseCode = const Value.absent(),
                required int dayOfWeek,
                required String timeSlot,
                required String location,
                Value<String> bookingStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OfficeHoursTableCompanion.insert(
                id: id,
                facultyName: facultyName,
                department: department,
                courseCode: courseCode,
                dayOfWeek: dayOfWeek,
                timeSlot: timeSlot,
                location: location,
                bookingStatus: bookingStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OfficeHoursTableTable, OfficeHoursTableData>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $OfficeHoursTableTable,
                    OfficeHoursTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OfficeHoursTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OfficeHoursTableTable,
      OfficeHoursTableData,
      $$OfficeHoursTableTableFilterComposer,
      $$OfficeHoursTableTableOrderingComposer,
      $$OfficeHoursTableTableAnnotationComposer,
      $$OfficeHoursTableTableCreateCompanionBuilder,
      $$OfficeHoursTableTableUpdateCompanionBuilder,
      (
        OfficeHoursTableData,
        BaseReferences<
          _$AppDatabase,
          $OfficeHoursTableTable,
          OfficeHoursTableData
        >,
      ),
      OfficeHoursTableData,
      PrefetchHooks Function()
    >;
typedef $$HealthRecordsTableTableCreateCompanionBuilder =
    HealthRecordsTableCompanion Function({
      required String id,
      required String bloodGroup,
      Value<String> allergies,
      Value<String> medications,
      Value<String> emergencyInstructions,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$HealthRecordsTableTableUpdateCompanionBuilder =
    HealthRecordsTableCompanion Function({
      Value<String> id,
      Value<String> bloodGroup,
      Value<String> allergies,
      Value<String> medications,
      Value<String> emergencyInstructions,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$HealthRecordsTableTableFilterComposer
    extends Composer<_$AppDatabase, $HealthRecordsTableTable> {
  $$HealthRecordsTableTableFilterComposer({
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

  ColumnFilters<String> get bloodGroup => $composableBuilder(
    column: $table.bloodGroup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get allergies => $composableBuilder(
    column: $table.allergies,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get medications => $composableBuilder(
    column: $table.medications,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emergencyInstructions => $composableBuilder(
    column: $table.emergencyInstructions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HealthRecordsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $HealthRecordsTableTable> {
  $$HealthRecordsTableTableOrderingComposer({
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

  ColumnOrderings<String> get bloodGroup => $composableBuilder(
    column: $table.bloodGroup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get allergies => $composableBuilder(
    column: $table.allergies,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get medications => $composableBuilder(
    column: $table.medications,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emergencyInstructions => $composableBuilder(
    column: $table.emergencyInstructions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HealthRecordsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $HealthRecordsTableTable> {
  $$HealthRecordsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get bloodGroup => $composableBuilder(
    column: $table.bloodGroup,
    builder: (column) => column,
  );

  GeneratedColumn<String> get allergies =>
      $composableBuilder(column: $table.allergies, builder: (column) => column);

  GeneratedColumn<String> get medications => $composableBuilder(
    column: $table.medications,
    builder: (column) => column,
  );

  GeneratedColumn<String> get emergencyInstructions => $composableBuilder(
    column: $table.emergencyInstructions,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$HealthRecordsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HealthRecordsTableTable,
          HealthRecordsTableData,
          $$HealthRecordsTableTableFilterComposer,
          $$HealthRecordsTableTableOrderingComposer,
          $$HealthRecordsTableTableAnnotationComposer,
          $$HealthRecordsTableTableCreateCompanionBuilder,
          $$HealthRecordsTableTableUpdateCompanionBuilder,
          (
            HealthRecordsTableData,
            BaseReferences<
              _$AppDatabase,
              $HealthRecordsTableTable,
              HealthRecordsTableData
            >,
          ),
          HealthRecordsTableData,
          PrefetchHooks Function()
        > {
  $$HealthRecordsTableTableTableManager(
    _$AppDatabase db,
    $HealthRecordsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HealthRecordsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HealthRecordsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HealthRecordsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> bloodGroup = const Value.absent(),
                Value<String> allergies = const Value.absent(),
                Value<String> medications = const Value.absent(),
                Value<String> emergencyInstructions = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HealthRecordsTableCompanion(
                id: id,
                bloodGroup: bloodGroup,
                allergies: allergies,
                medications: medications,
                emergencyInstructions: emergencyInstructions,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String bloodGroup,
                Value<String> allergies = const Value.absent(),
                Value<String> medications = const Value.absent(),
                Value<String> emergencyInstructions = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => HealthRecordsTableCompanion.insert(
                id: id,
                bloodGroup: bloodGroup,
                allergies: allergies,
                medications: medications,
                emergencyInstructions: emergencyInstructions,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HealthRecordsTableTable, HealthRecordsTableData>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $HealthRecordsTableTable,
                    HealthRecordsTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HealthRecordsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HealthRecordsTableTable,
      HealthRecordsTableData,
      $$HealthRecordsTableTableFilterComposer,
      $$HealthRecordsTableTableOrderingComposer,
      $$HealthRecordsTableTableAnnotationComposer,
      $$HealthRecordsTableTableCreateCompanionBuilder,
      $$HealthRecordsTableTableUpdateCompanionBuilder,
      (
        HealthRecordsTableData,
        BaseReferences<
          _$AppDatabase,
          $HealthRecordsTableTable,
          HealthRecordsTableData
        >,
      ),
      HealthRecordsTableData,
      PrefetchHooks Function()
    >;
typedef $$SleepLogsTableTableCreateCompanionBuilder =
    SleepLogsTableCompanion Function({
      required String id,
      required DateTime date,
      required String bedTime,
      required String wakeTime,
      required int durationMinutes,
      Value<int> qualityRating,
      Value<int> rowid,
    });
typedef $$SleepLogsTableTableUpdateCompanionBuilder =
    SleepLogsTableCompanion Function({
      Value<String> id,
      Value<DateTime> date,
      Value<String> bedTime,
      Value<String> wakeTime,
      Value<int> durationMinutes,
      Value<int> qualityRating,
      Value<int> rowid,
    });

class $$SleepLogsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SleepLogsTableTable> {
  $$SleepLogsTableTableFilterComposer({
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

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bedTime => $composableBuilder(
    column: $table.bedTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wakeTime => $composableBuilder(
    column: $table.wakeTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qualityRating => $composableBuilder(
    column: $table.qualityRating,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SleepLogsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SleepLogsTableTable> {
  $$SleepLogsTableTableOrderingComposer({
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

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bedTime => $composableBuilder(
    column: $table.bedTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wakeTime => $composableBuilder(
    column: $table.wakeTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qualityRating => $composableBuilder(
    column: $table.qualityRating,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SleepLogsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SleepLogsTableTable> {
  $$SleepLogsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get bedTime =>
      $composableBuilder(column: $table.bedTime, builder: (column) => column);

  GeneratedColumn<String> get wakeTime =>
      $composableBuilder(column: $table.wakeTime, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get qualityRating => $composableBuilder(
    column: $table.qualityRating,
    builder: (column) => column,
  );
}

class $$SleepLogsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SleepLogsTableTable,
          SleepLogsTableData,
          $$SleepLogsTableTableFilterComposer,
          $$SleepLogsTableTableOrderingComposer,
          $$SleepLogsTableTableAnnotationComposer,
          $$SleepLogsTableTableCreateCompanionBuilder,
          $$SleepLogsTableTableUpdateCompanionBuilder,
          (
            SleepLogsTableData,
            BaseReferences<
              _$AppDatabase,
              $SleepLogsTableTable,
              SleepLogsTableData
            >,
          ),
          SleepLogsTableData,
          PrefetchHooks Function()
        > {
  $$SleepLogsTableTableTableManager(
    _$AppDatabase db,
    $SleepLogsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SleepLogsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SleepLogsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SleepLogsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> bedTime = const Value.absent(),
                Value<String> wakeTime = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<int> qualityRating = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SleepLogsTableCompanion(
                id: id,
                date: date,
                bedTime: bedTime,
                wakeTime: wakeTime,
                durationMinutes: durationMinutes,
                qualityRating: qualityRating,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime date,
                required String bedTime,
                required String wakeTime,
                required int durationMinutes,
                Value<int> qualityRating = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SleepLogsTableCompanion.insert(
                id: id,
                date: date,
                bedTime: bedTime,
                wakeTime: wakeTime,
                durationMinutes: durationMinutes,
                qualityRating: qualityRating,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SleepLogsTableTable, SleepLogsTableData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SleepLogsTableTable,
                    SleepLogsTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SleepLogsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SleepLogsTableTable,
      SleepLogsTableData,
      $$SleepLogsTableTableFilterComposer,
      $$SleepLogsTableTableOrderingComposer,
      $$SleepLogsTableTableAnnotationComposer,
      $$SleepLogsTableTableCreateCompanionBuilder,
      $$SleepLogsTableTableUpdateCompanionBuilder,
      (
        SleepLogsTableData,
        BaseReferences<_$AppDatabase, $SleepLogsTableTable, SleepLogsTableData>,
      ),
      SleepLogsTableData,
      PrefetchHooks Function()
    >;
typedef $$NutritionLogsTableTableCreateCompanionBuilder =
    NutritionLogsTableCompanion Function({
      required String id,
      required DateTime date,
      required String mealType,
      required String foodItems,
      Value<int> calories,
      Value<bool> isVeg,
      Value<int> rowid,
    });
typedef $$NutritionLogsTableTableUpdateCompanionBuilder =
    NutritionLogsTableCompanion Function({
      Value<String> id,
      Value<DateTime> date,
      Value<String> mealType,
      Value<String> foodItems,
      Value<int> calories,
      Value<bool> isVeg,
      Value<int> rowid,
    });

class $$NutritionLogsTableTableFilterComposer
    extends Composer<_$AppDatabase, $NutritionLogsTableTable> {
  $$NutritionLogsTableTableFilterComposer({
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

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foodItems => $composableBuilder(
    column: $table.foodItems,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isVeg => $composableBuilder(
    column: $table.isVeg,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NutritionLogsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $NutritionLogsTableTable> {
  $$NutritionLogsTableTableOrderingComposer({
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

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foodItems => $composableBuilder(
    column: $table.foodItems,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isVeg => $composableBuilder(
    column: $table.isVeg,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NutritionLogsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $NutritionLogsTableTable> {
  $$NutritionLogsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  GeneratedColumn<String> get foodItems =>
      $composableBuilder(column: $table.foodItems, builder: (column) => column);

  GeneratedColumn<int> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<bool> get isVeg =>
      $composableBuilder(column: $table.isVeg, builder: (column) => column);
}

class $$NutritionLogsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NutritionLogsTableTable,
          NutritionLogsTableData,
          $$NutritionLogsTableTableFilterComposer,
          $$NutritionLogsTableTableOrderingComposer,
          $$NutritionLogsTableTableAnnotationComposer,
          $$NutritionLogsTableTableCreateCompanionBuilder,
          $$NutritionLogsTableTableUpdateCompanionBuilder,
          (
            NutritionLogsTableData,
            BaseReferences<
              _$AppDatabase,
              $NutritionLogsTableTable,
              NutritionLogsTableData
            >,
          ),
          NutritionLogsTableData,
          PrefetchHooks Function()
        > {
  $$NutritionLogsTableTableTableManager(
    _$AppDatabase db,
    $NutritionLogsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NutritionLogsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NutritionLogsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NutritionLogsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> mealType = const Value.absent(),
                Value<String> foodItems = const Value.absent(),
                Value<int> calories = const Value.absent(),
                Value<bool> isVeg = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NutritionLogsTableCompanion(
                id: id,
                date: date,
                mealType: mealType,
                foodItems: foodItems,
                calories: calories,
                isVeg: isVeg,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime date,
                required String mealType,
                required String foodItems,
                Value<int> calories = const Value.absent(),
                Value<bool> isVeg = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NutritionLogsTableCompanion.insert(
                id: id,
                date: date,
                mealType: mealType,
                foodItems: foodItems,
                calories: calories,
                isVeg: isVeg,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$NutritionLogsTableTable, NutritionLogsTableData>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $NutritionLogsTableTable,
                    NutritionLogsTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NutritionLogsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NutritionLogsTableTable,
      NutritionLogsTableData,
      $$NutritionLogsTableTableFilterComposer,
      $$NutritionLogsTableTableOrderingComposer,
      $$NutritionLogsTableTableAnnotationComposer,
      $$NutritionLogsTableTableCreateCompanionBuilder,
      $$NutritionLogsTableTableUpdateCompanionBuilder,
      (
        NutritionLogsTableData,
        BaseReferences<
          _$AppDatabase,
          $NutritionLogsTableTable,
          NutritionLogsTableData
        >,
      ),
      NutritionLogsTableData,
      PrefetchHooks Function()
    >;
typedef $$ShareHistoryTableTableCreateCompanionBuilder =
    ShareHistoryTableCompanion Function({
      required String id,
      required String fileName,
      required int fileSize,
      required String direction,
      required String peerName,
      required DateTime transferDate,
      required String sha256Hash,
      required String status,
      Value<int> rowid,
    });
typedef $$ShareHistoryTableTableUpdateCompanionBuilder =
    ShareHistoryTableCompanion Function({
      Value<String> id,
      Value<String> fileName,
      Value<int> fileSize,
      Value<String> direction,
      Value<String> peerName,
      Value<DateTime> transferDate,
      Value<String> sha256Hash,
      Value<String> status,
      Value<int> rowid,
    });

class $$ShareHistoryTableTableFilterComposer
    extends Composer<_$AppDatabase, $ShareHistoryTableTable> {
  $$ShareHistoryTableTableFilterComposer({
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

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get peerName => $composableBuilder(
    column: $table.peerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get transferDate => $composableBuilder(
    column: $table.transferDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sha256Hash => $composableBuilder(
    column: $table.sha256Hash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ShareHistoryTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ShareHistoryTableTable> {
  $$ShareHistoryTableTableOrderingComposer({
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

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get peerName => $composableBuilder(
    column: $table.peerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get transferDate => $composableBuilder(
    column: $table.transferDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sha256Hash => $composableBuilder(
    column: $table.sha256Hash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShareHistoryTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShareHistoryTableTable> {
  $$ShareHistoryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<int> get fileSize =>
      $composableBuilder(column: $table.fileSize, builder: (column) => column);

  GeneratedColumn<String> get direction =>
      $composableBuilder(column: $table.direction, builder: (column) => column);

  GeneratedColumn<String> get peerName =>
      $composableBuilder(column: $table.peerName, builder: (column) => column);

  GeneratedColumn<DateTime> get transferDate => $composableBuilder(
    column: $table.transferDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sha256Hash => $composableBuilder(
    column: $table.sha256Hash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$ShareHistoryTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShareHistoryTableTable,
          ShareHistoryTableData,
          $$ShareHistoryTableTableFilterComposer,
          $$ShareHistoryTableTableOrderingComposer,
          $$ShareHistoryTableTableAnnotationComposer,
          $$ShareHistoryTableTableCreateCompanionBuilder,
          $$ShareHistoryTableTableUpdateCompanionBuilder,
          (
            ShareHistoryTableData,
            BaseReferences<
              _$AppDatabase,
              $ShareHistoryTableTable,
              ShareHistoryTableData
            >,
          ),
          ShareHistoryTableData,
          PrefetchHooks Function()
        > {
  $$ShareHistoryTableTableTableManager(
    _$AppDatabase db,
    $ShareHistoryTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShareHistoryTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShareHistoryTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShareHistoryTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<int> fileSize = const Value.absent(),
                Value<String> direction = const Value.absent(),
                Value<String> peerName = const Value.absent(),
                Value<DateTime> transferDate = const Value.absent(),
                Value<String> sha256Hash = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShareHistoryTableCompanion(
                id: id,
                fileName: fileName,
                fileSize: fileSize,
                direction: direction,
                peerName: peerName,
                transferDate: transferDate,
                sha256Hash: sha256Hash,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String fileName,
                required int fileSize,
                required String direction,
                required String peerName,
                required DateTime transferDate,
                required String sha256Hash,
                required String status,
                Value<int> rowid = const Value.absent(),
              }) => ShareHistoryTableCompanion.insert(
                id: id,
                fileName: fileName,
                fileSize: fileSize,
                direction: direction,
                peerName: peerName,
                transferDate: transferDate,
                sha256Hash: sha256Hash,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ShareHistoryTableTable, ShareHistoryTableData>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $ShareHistoryTableTable,
                    ShareHistoryTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ShareHistoryTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShareHistoryTableTable,
      ShareHistoryTableData,
      $$ShareHistoryTableTableFilterComposer,
      $$ShareHistoryTableTableOrderingComposer,
      $$ShareHistoryTableTableAnnotationComposer,
      $$ShareHistoryTableTableCreateCompanionBuilder,
      $$ShareHistoryTableTableUpdateCompanionBuilder,
      (
        ShareHistoryTableData,
        BaseReferences<
          _$AppDatabase,
          $ShareHistoryTableTable,
          ShareHistoryTableData
        >,
      ),
      ShareHistoryTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$OutboxSyncQueueTableTableManager get outboxSyncQueue =>
      $$OutboxSyncQueueTableTableManager(_db, _db.outboxSyncQueue);
  $$CoursesTableTableTableManager get coursesTable =>
      $$CoursesTableTableTableManager(_db, _db.coursesTable);
  $$TimetableTableTableTableManager get timetableTable =>
      $$TimetableTableTableTableManager(_db, _db.timetableTable);
  $$TasksTableTableTableManager get tasksTable =>
      $$TasksTableTableTableManager(_db, _db.tasksTable);
  $$AttendanceTableTableTableManager get attendanceTable =>
      $$AttendanceTableTableTableManager(_db, _db.attendanceTable);
  $$GradesTableTableTableManager get gradesTable =>
      $$GradesTableTableTableManager(_db, _db.gradesTable);
  $$NotesTableTableTableManager get notesTable =>
      $$NotesTableTableTableManager(_db, _db.notesTable);
  $$FlashcardsTableTableTableManager get flashcardsTable =>
      $$FlashcardsTableTableTableManager(_db, _db.flashcardsTable);
  $$HabitsTableTableTableManager get habitsTable =>
      $$HabitsTableTableTableManager(_db, _db.habitsTable);
  $$BudgetTableTableTableManager get budgetTable =>
      $$BudgetTableTableTableManager(_db, _db.budgetTable);
  $$MoodTableTableTableManager get moodTable =>
      $$MoodTableTableTableManager(_db, _db.moodTable);
  $$EncryptedVaultTableTableTableManager get encryptedVaultTable =>
      $$EncryptedVaultTableTableTableManager(_db, _db.encryptedVaultTable);
  $$StudentProfileTableTableTableManager get studentProfileTable =>
      $$StudentProfileTableTableTableManager(_db, _db.studentProfileTable);
  $$PastPapersTableTableTableManager get pastPapersTable =>
      $$PastPapersTableTableTableManager(_db, _db.pastPapersTable);
  $$StudyPlansTableTableTableManager get studyPlansTable =>
      $$StudyPlansTableTableTableManager(_db, _db.studyPlansTable);
  $$GroupProjectsTableTableTableManager get groupProjectsTable =>
      $$GroupProjectsTableTableTableManager(_db, _db.groupProjectsTable);
  $$OfficeHoursTableTableTableManager get officeHoursTable =>
      $$OfficeHoursTableTableTableManager(_db, _db.officeHoursTable);
  $$HealthRecordsTableTableTableManager get healthRecordsTable =>
      $$HealthRecordsTableTableTableManager(_db, _db.healthRecordsTable);
  $$SleepLogsTableTableTableManager get sleepLogsTable =>
      $$SleepLogsTableTableTableManager(_db, _db.sleepLogsTable);
  $$NutritionLogsTableTableTableManager get nutritionLogsTable =>
      $$NutritionLogsTableTableTableManager(_db, _db.nutritionLogsTable);
  $$ShareHistoryTableTableTableManager get shareHistoryTable =>
      $$ShareHistoryTableTableTableManager(_db, _db.shareHistoryTable);
}
