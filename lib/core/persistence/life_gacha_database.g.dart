// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'life_gacha_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, UserRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
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
  List<GeneratedColumn> get $columns => [id, displayName, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
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
  UserRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class UserRecord extends DataClass implements Insertable<UserRecord> {
  final String id;
  final String? displayName;
  final DateTime createdAt;
  final DateTime updatedAt;
  const UserRecord({
    required this.id,
    this.displayName,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserRecord(
      id: serializer.fromJson<String>(json['id']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'displayName': serializer.toJson<String?>(displayName),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserRecord copyWith({
    String? id,
    Value<String?> displayName = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UserRecord(
    id: id ?? this.id,
    displayName: displayName.present ? displayName.value : this.displayName,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserRecord copyWithCompanion(UsersCompanion data) {
    return UserRecord(
      id: data.id.present ? data.id.value : this.id,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserRecord(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, displayName, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserRecord &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UsersCompanion extends UpdateCompanion<UserRecord> {
  final Value<String> id;
  final Value<String?> displayName;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    this.displayName = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<UserRecord> custom({
    Expression<String>? id,
    Expression<String>? displayName,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<String?>? displayName,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
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
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
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
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, TaskRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
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
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    category,
    status,
    createdAt,
    updatedAt,
    archivedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskRecord> instance, {
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
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
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
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class TaskRecord extends DataClass implements Insertable<TaskRecord> {
  final String id;
  final String title;
  final String category;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;
  const TaskRecord({
    required this.id,
    required this.title,
    required this.category,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.archivedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['category'] = Variable<String>(category);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      title: Value(title),
      category: Value(category),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
    );
  }

  factory TaskRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskRecord(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      category: serializer.fromJson<String>(json['category']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'category': serializer.toJson<String>(category),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
    };
  }

  TaskRecord copyWith({
    String? id,
    String? title,
    String? category,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> archivedAt = const Value.absent(),
  }) => TaskRecord(
    id: id ?? this.id,
    title: title ?? this.title,
    category: category ?? this.category,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
  );
  TaskRecord copyWithCompanion(TasksCompanion data) {
    return TaskRecord(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      category: data.category.present ? data.category.value : this.category,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskRecord(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    category,
    status,
    createdAt,
    updatedAt,
    archivedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskRecord &&
          other.id == this.id &&
          other.title == this.title &&
          other.category == this.category &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.archivedAt == this.archivedAt);
}

class TasksCompanion extends UpdateCompanion<TaskRecord> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> category;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> archivedAt;
  final Value<int> rowid;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.category = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksCompanion.insert({
    required String id,
    required String title,
    required String category,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       category = Value(category),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TaskRecord> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? category,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? archivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (category != null) 'category': category,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? category,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? archivedAt,
    Value<int>? rowid,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      archivedAt: archivedAt ?? this.archivedAt,
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
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FocusSessionsTable extends FocusSessions
    with TableInfo<$FocusSessionsTable, FocusSessionRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FocusSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _plannedMinutesMeta = const VerificationMeta(
    'plannedMinutes',
  );
  @override
  late final GeneratedColumn<int> plannedMinutes = GeneratedColumn<int>(
    'planned_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pauseCountMeta = const VerificationMeta(
    'pauseCount',
  );
  @override
  late final GeneratedColumn<int> pauseCount = GeneratedColumn<int>(
    'pause_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _appBackgroundViolationMeta =
      const VerificationMeta('appBackgroundViolation');
  @override
  late final GeneratedColumn<bool> appBackgroundViolation =
      GeneratedColumn<bool>(
        'app_background_violation',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("app_background_violation" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _actualElapsedSecondsMeta =
      const VerificationMeta('actualElapsedSeconds');
  @override
  late final GeneratedColumn<int> actualElapsedSeconds = GeneratedColumn<int>(
    'actual_elapsed_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _pointsAwardedMeta = const VerificationMeta(
    'pointsAwarded',
  );
  @override
  late final GeneratedColumn<int> pointsAwarded = GeneratedColumn<int>(
    'points_awarded',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastStateChangedAtMeta =
      const VerificationMeta('lastStateChangedAt');
  @override
  late final GeneratedColumn<DateTime> lastStateChangedAt =
      GeneratedColumn<DateTime>(
        'last_state_changed_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskId,
    plannedMinutes,
    startedAt,
    endedAt,
    status,
    pauseCount,
    appBackgroundViolation,
    actualElapsedSeconds,
    pointsAwarded,
    lastStateChangedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'focus_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<FocusSessionRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    }
    if (data.containsKey('planned_minutes')) {
      context.handle(
        _plannedMinutesMeta,
        plannedMinutes.isAcceptableOrUnknown(
          data['planned_minutes']!,
          _plannedMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plannedMinutesMeta);
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
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('pause_count')) {
      context.handle(
        _pauseCountMeta,
        pauseCount.isAcceptableOrUnknown(data['pause_count']!, _pauseCountMeta),
      );
    }
    if (data.containsKey('app_background_violation')) {
      context.handle(
        _appBackgroundViolationMeta,
        appBackgroundViolation.isAcceptableOrUnknown(
          data['app_background_violation']!,
          _appBackgroundViolationMeta,
        ),
      );
    }
    if (data.containsKey('actual_elapsed_seconds')) {
      context.handle(
        _actualElapsedSecondsMeta,
        actualElapsedSeconds.isAcceptableOrUnknown(
          data['actual_elapsed_seconds']!,
          _actualElapsedSecondsMeta,
        ),
      );
    }
    if (data.containsKey('points_awarded')) {
      context.handle(
        _pointsAwardedMeta,
        pointsAwarded.isAcceptableOrUnknown(
          data['points_awarded']!,
          _pointsAwardedMeta,
        ),
      );
    }
    if (data.containsKey('last_state_changed_at')) {
      context.handle(
        _lastStateChangedAtMeta,
        lastStateChangedAt.isAcceptableOrUnknown(
          data['last_state_changed_at']!,
          _lastStateChangedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastStateChangedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FocusSessionRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FocusSessionRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      ),
      plannedMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_minutes'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      pauseCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pause_count'],
      )!,
      appBackgroundViolation: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}app_background_violation'],
      )!,
      actualElapsedSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}actual_elapsed_seconds'],
      )!,
      pointsAwarded: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}points_awarded'],
      )!,
      lastStateChangedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_state_changed_at'],
      )!,
    );
  }

  @override
  $FocusSessionsTable createAlias(String alias) {
    return $FocusSessionsTable(attachedDatabase, alias);
  }
}

class FocusSessionRecord extends DataClass
    implements Insertable<FocusSessionRecord> {
  final String id;
  final String? taskId;
  final int plannedMinutes;
  final DateTime startedAt;
  final DateTime? endedAt;
  final String status;
  final int pauseCount;
  final bool appBackgroundViolation;
  final int actualElapsedSeconds;
  final int pointsAwarded;
  final DateTime lastStateChangedAt;
  const FocusSessionRecord({
    required this.id,
    this.taskId,
    required this.plannedMinutes,
    required this.startedAt,
    this.endedAt,
    required this.status,
    required this.pauseCount,
    required this.appBackgroundViolation,
    required this.actualElapsedSeconds,
    required this.pointsAwarded,
    required this.lastStateChangedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<String>(taskId);
    }
    map['planned_minutes'] = Variable<int>(plannedMinutes);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    map['status'] = Variable<String>(status);
    map['pause_count'] = Variable<int>(pauseCount);
    map['app_background_violation'] = Variable<bool>(appBackgroundViolation);
    map['actual_elapsed_seconds'] = Variable<int>(actualElapsedSeconds);
    map['points_awarded'] = Variable<int>(pointsAwarded);
    map['last_state_changed_at'] = Variable<DateTime>(lastStateChangedAt);
    return map;
  }

  FocusSessionsCompanion toCompanion(bool nullToAbsent) {
    return FocusSessionsCompanion(
      id: Value(id),
      taskId: taskId == null && nullToAbsent
          ? const Value.absent()
          : Value(taskId),
      plannedMinutes: Value(plannedMinutes),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      status: Value(status),
      pauseCount: Value(pauseCount),
      appBackgroundViolation: Value(appBackgroundViolation),
      actualElapsedSeconds: Value(actualElapsedSeconds),
      pointsAwarded: Value(pointsAwarded),
      lastStateChangedAt: Value(lastStateChangedAt),
    );
  }

  factory FocusSessionRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FocusSessionRecord(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String?>(json['taskId']),
      plannedMinutes: serializer.fromJson<int>(json['plannedMinutes']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      status: serializer.fromJson<String>(json['status']),
      pauseCount: serializer.fromJson<int>(json['pauseCount']),
      appBackgroundViolation: serializer.fromJson<bool>(
        json['appBackgroundViolation'],
      ),
      actualElapsedSeconds: serializer.fromJson<int>(
        json['actualElapsedSeconds'],
      ),
      pointsAwarded: serializer.fromJson<int>(json['pointsAwarded']),
      lastStateChangedAt: serializer.fromJson<DateTime>(
        json['lastStateChangedAt'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String?>(taskId),
      'plannedMinutes': serializer.toJson<int>(plannedMinutes),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'status': serializer.toJson<String>(status),
      'pauseCount': serializer.toJson<int>(pauseCount),
      'appBackgroundViolation': serializer.toJson<bool>(appBackgroundViolation),
      'actualElapsedSeconds': serializer.toJson<int>(actualElapsedSeconds),
      'pointsAwarded': serializer.toJson<int>(pointsAwarded),
      'lastStateChangedAt': serializer.toJson<DateTime>(lastStateChangedAt),
    };
  }

  FocusSessionRecord copyWith({
    String? id,
    Value<String?> taskId = const Value.absent(),
    int? plannedMinutes,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    String? status,
    int? pauseCount,
    bool? appBackgroundViolation,
    int? actualElapsedSeconds,
    int? pointsAwarded,
    DateTime? lastStateChangedAt,
  }) => FocusSessionRecord(
    id: id ?? this.id,
    taskId: taskId.present ? taskId.value : this.taskId,
    plannedMinutes: plannedMinutes ?? this.plannedMinutes,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    status: status ?? this.status,
    pauseCount: pauseCount ?? this.pauseCount,
    appBackgroundViolation:
        appBackgroundViolation ?? this.appBackgroundViolation,
    actualElapsedSeconds: actualElapsedSeconds ?? this.actualElapsedSeconds,
    pointsAwarded: pointsAwarded ?? this.pointsAwarded,
    lastStateChangedAt: lastStateChangedAt ?? this.lastStateChangedAt,
  );
  FocusSessionRecord copyWithCompanion(FocusSessionsCompanion data) {
    return FocusSessionRecord(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      plannedMinutes: data.plannedMinutes.present
          ? data.plannedMinutes.value
          : this.plannedMinutes,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      status: data.status.present ? data.status.value : this.status,
      pauseCount: data.pauseCount.present
          ? data.pauseCount.value
          : this.pauseCount,
      appBackgroundViolation: data.appBackgroundViolation.present
          ? data.appBackgroundViolation.value
          : this.appBackgroundViolation,
      actualElapsedSeconds: data.actualElapsedSeconds.present
          ? data.actualElapsedSeconds.value
          : this.actualElapsedSeconds,
      pointsAwarded: data.pointsAwarded.present
          ? data.pointsAwarded.value
          : this.pointsAwarded,
      lastStateChangedAt: data.lastStateChangedAt.present
          ? data.lastStateChangedAt.value
          : this.lastStateChangedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FocusSessionRecord(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('plannedMinutes: $plannedMinutes, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('status: $status, ')
          ..write('pauseCount: $pauseCount, ')
          ..write('appBackgroundViolation: $appBackgroundViolation, ')
          ..write('actualElapsedSeconds: $actualElapsedSeconds, ')
          ..write('pointsAwarded: $pointsAwarded, ')
          ..write('lastStateChangedAt: $lastStateChangedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    taskId,
    plannedMinutes,
    startedAt,
    endedAt,
    status,
    pauseCount,
    appBackgroundViolation,
    actualElapsedSeconds,
    pointsAwarded,
    lastStateChangedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FocusSessionRecord &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.plannedMinutes == this.plannedMinutes &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.status == this.status &&
          other.pauseCount == this.pauseCount &&
          other.appBackgroundViolation == this.appBackgroundViolation &&
          other.actualElapsedSeconds == this.actualElapsedSeconds &&
          other.pointsAwarded == this.pointsAwarded &&
          other.lastStateChangedAt == this.lastStateChangedAt);
}

class FocusSessionsCompanion extends UpdateCompanion<FocusSessionRecord> {
  final Value<String> id;
  final Value<String?> taskId;
  final Value<int> plannedMinutes;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<String> status;
  final Value<int> pauseCount;
  final Value<bool> appBackgroundViolation;
  final Value<int> actualElapsedSeconds;
  final Value<int> pointsAwarded;
  final Value<DateTime> lastStateChangedAt;
  final Value<int> rowid;
  const FocusSessionsCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.plannedMinutes = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.pauseCount = const Value.absent(),
    this.appBackgroundViolation = const Value.absent(),
    this.actualElapsedSeconds = const Value.absent(),
    this.pointsAwarded = const Value.absent(),
    this.lastStateChangedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FocusSessionsCompanion.insert({
    required String id,
    this.taskId = const Value.absent(),
    required int plannedMinutes,
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    required String status,
    this.pauseCount = const Value.absent(),
    this.appBackgroundViolation = const Value.absent(),
    this.actualElapsedSeconds = const Value.absent(),
    this.pointsAwarded = const Value.absent(),
    required DateTime lastStateChangedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       plannedMinutes = Value(plannedMinutes),
       startedAt = Value(startedAt),
       status = Value(status),
       lastStateChangedAt = Value(lastStateChangedAt);
  static Insertable<FocusSessionRecord> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<int>? plannedMinutes,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<String>? status,
    Expression<int>? pauseCount,
    Expression<bool>? appBackgroundViolation,
    Expression<int>? actualElapsedSeconds,
    Expression<int>? pointsAwarded,
    Expression<DateTime>? lastStateChangedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (plannedMinutes != null) 'planned_minutes': plannedMinutes,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (status != null) 'status': status,
      if (pauseCount != null) 'pause_count': pauseCount,
      if (appBackgroundViolation != null)
        'app_background_violation': appBackgroundViolation,
      if (actualElapsedSeconds != null)
        'actual_elapsed_seconds': actualElapsedSeconds,
      if (pointsAwarded != null) 'points_awarded': pointsAwarded,
      if (lastStateChangedAt != null)
        'last_state_changed_at': lastStateChangedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FocusSessionsCompanion copyWith({
    Value<String>? id,
    Value<String?>? taskId,
    Value<int>? plannedMinutes,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<String>? status,
    Value<int>? pauseCount,
    Value<bool>? appBackgroundViolation,
    Value<int>? actualElapsedSeconds,
    Value<int>? pointsAwarded,
    Value<DateTime>? lastStateChangedAt,
    Value<int>? rowid,
  }) {
    return FocusSessionsCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      plannedMinutes: plannedMinutes ?? this.plannedMinutes,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      status: status ?? this.status,
      pauseCount: pauseCount ?? this.pauseCount,
      appBackgroundViolation:
          appBackgroundViolation ?? this.appBackgroundViolation,
      actualElapsedSeconds: actualElapsedSeconds ?? this.actualElapsedSeconds,
      pointsAwarded: pointsAwarded ?? this.pointsAwarded,
      lastStateChangedAt: lastStateChangedAt ?? this.lastStateChangedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (plannedMinutes.present) {
      map['planned_minutes'] = Variable<int>(plannedMinutes.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (pauseCount.present) {
      map['pause_count'] = Variable<int>(pauseCount.value);
    }
    if (appBackgroundViolation.present) {
      map['app_background_violation'] = Variable<bool>(
        appBackgroundViolation.value,
      );
    }
    if (actualElapsedSeconds.present) {
      map['actual_elapsed_seconds'] = Variable<int>(actualElapsedSeconds.value);
    }
    if (pointsAwarded.present) {
      map['points_awarded'] = Variable<int>(pointsAwarded.value);
    }
    if (lastStateChangedAt.present) {
      map['last_state_changed_at'] = Variable<DateTime>(
        lastStateChangedAt.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FocusSessionsCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('plannedMinutes: $plannedMinutes, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('status: $status, ')
          ..write('pauseCount: $pauseCount, ')
          ..write('appBackgroundViolation: $appBackgroundViolation, ')
          ..write('actualElapsedSeconds: $actualElapsedSeconds, ')
          ..write('pointsAwarded: $pointsAwarded, ')
          ..write('lastStateChangedAt: $lastStateChangedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WalletLedgerTable extends WalletLedger
    with TableInfo<$WalletLedgerTable, WalletLedgerRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletLedgerTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventTypeMeta = const VerificationMeta(
    'eventType',
  );
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
    'event_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deltaPointsMeta = const VerificationMeta(
    'deltaPoints',
  );
  @override
  late final GeneratedColumn<int> deltaPoints = GeneratedColumn<int>(
    'delta_points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referenceIdMeta = const VerificationMeta(
    'referenceId',
  );
  @override
  late final GeneratedColumn<String> referenceId = GeneratedColumn<String>(
    'reference_id',
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    eventType,
    deltaPoints,
    referenceId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallet_ledger';
  @override
  VerificationContext validateIntegrity(
    Insertable<WalletLedgerRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('event_type')) {
      context.handle(
        _eventTypeMeta,
        eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('delta_points')) {
      context.handle(
        _deltaPointsMeta,
        deltaPoints.isAcceptableOrUnknown(
          data['delta_points']!,
          _deltaPointsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_deltaPointsMeta);
    }
    if (data.containsKey('reference_id')) {
      context.handle(
        _referenceIdMeta,
        referenceId.isAcceptableOrUnknown(
          data['reference_id']!,
          _referenceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_referenceIdMeta);
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
  WalletLedgerRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WalletLedgerRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      eventType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_type'],
      )!,
      deltaPoints: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}delta_points'],
      )!,
      referenceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WalletLedgerTable createAlias(String alias) {
    return $WalletLedgerTable(attachedDatabase, alias);
  }
}

class WalletLedgerRecord extends DataClass
    implements Insertable<WalletLedgerRecord> {
  final String id;
  final String eventType;
  final int deltaPoints;
  final String referenceId;
  final DateTime createdAt;
  const WalletLedgerRecord({
    required this.id,
    required this.eventType,
    required this.deltaPoints,
    required this.referenceId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['event_type'] = Variable<String>(eventType);
    map['delta_points'] = Variable<int>(deltaPoints);
    map['reference_id'] = Variable<String>(referenceId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WalletLedgerCompanion toCompanion(bool nullToAbsent) {
    return WalletLedgerCompanion(
      id: Value(id),
      eventType: Value(eventType),
      deltaPoints: Value(deltaPoints),
      referenceId: Value(referenceId),
      createdAt: Value(createdAt),
    );
  }

  factory WalletLedgerRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WalletLedgerRecord(
      id: serializer.fromJson<String>(json['id']),
      eventType: serializer.fromJson<String>(json['eventType']),
      deltaPoints: serializer.fromJson<int>(json['deltaPoints']),
      referenceId: serializer.fromJson<String>(json['referenceId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'eventType': serializer.toJson<String>(eventType),
      'deltaPoints': serializer.toJson<int>(deltaPoints),
      'referenceId': serializer.toJson<String>(referenceId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  WalletLedgerRecord copyWith({
    String? id,
    String? eventType,
    int? deltaPoints,
    String? referenceId,
    DateTime? createdAt,
  }) => WalletLedgerRecord(
    id: id ?? this.id,
    eventType: eventType ?? this.eventType,
    deltaPoints: deltaPoints ?? this.deltaPoints,
    referenceId: referenceId ?? this.referenceId,
    createdAt: createdAt ?? this.createdAt,
  );
  WalletLedgerRecord copyWithCompanion(WalletLedgerCompanion data) {
    return WalletLedgerRecord(
      id: data.id.present ? data.id.value : this.id,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      deltaPoints: data.deltaPoints.present
          ? data.deltaPoints.value
          : this.deltaPoints,
      referenceId: data.referenceId.present
          ? data.referenceId.value
          : this.referenceId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WalletLedgerRecord(')
          ..write('id: $id, ')
          ..write('eventType: $eventType, ')
          ..write('deltaPoints: $deltaPoints, ')
          ..write('referenceId: $referenceId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, eventType, deltaPoints, referenceId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalletLedgerRecord &&
          other.id == this.id &&
          other.eventType == this.eventType &&
          other.deltaPoints == this.deltaPoints &&
          other.referenceId == this.referenceId &&
          other.createdAt == this.createdAt);
}

class WalletLedgerCompanion extends UpdateCompanion<WalletLedgerRecord> {
  final Value<String> id;
  final Value<String> eventType;
  final Value<int> deltaPoints;
  final Value<String> referenceId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const WalletLedgerCompanion({
    this.id = const Value.absent(),
    this.eventType = const Value.absent(),
    this.deltaPoints = const Value.absent(),
    this.referenceId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WalletLedgerCompanion.insert({
    required String id,
    required String eventType,
    required int deltaPoints,
    required String referenceId,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       eventType = Value(eventType),
       deltaPoints = Value(deltaPoints),
       referenceId = Value(referenceId),
       createdAt = Value(createdAt);
  static Insertable<WalletLedgerRecord> custom({
    Expression<String>? id,
    Expression<String>? eventType,
    Expression<int>? deltaPoints,
    Expression<String>? referenceId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventType != null) 'event_type': eventType,
      if (deltaPoints != null) 'delta_points': deltaPoints,
      if (referenceId != null) 'reference_id': referenceId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WalletLedgerCompanion copyWith({
    Value<String>? id,
    Value<String>? eventType,
    Value<int>? deltaPoints,
    Value<String>? referenceId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return WalletLedgerCompanion(
      id: id ?? this.id,
      eventType: eventType ?? this.eventType,
      deltaPoints: deltaPoints ?? this.deltaPoints,
      referenceId: referenceId ?? this.referenceId,
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
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (deltaPoints.present) {
      map['delta_points'] = Variable<int>(deltaPoints.value);
    }
    if (referenceId.present) {
      map['reference_id'] = Variable<String>(referenceId.value);
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
    return (StringBuffer('WalletLedgerCompanion(')
          ..write('id: $id, ')
          ..write('eventType: $eventType, ')
          ..write('deltaPoints: $deltaPoints, ')
          ..write('referenceId: $referenceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RewardCardsTable extends RewardCards
    with TableInfo<$RewardCardsTable, RewardCardRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RewardCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _rarityMeta = const VerificationMeta('rarity');
  @override
  late final GeneratedColumn<String> rarity = GeneratedColumn<String>(
    'rarity',
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
  static const VerificationMeta _drawnAtMeta = const VerificationMeta(
    'drawnAt',
  );
  @override
  late final GeneratedColumn<DateTime> drawnAt = GeneratedColumn<DateTime>(
    'drawn_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    content,
    rarity,
    status,
    createdAt,
    updatedAt,
    drawnAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reward_cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<RewardCardRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('rarity')) {
      context.handle(
        _rarityMeta,
        rarity.isAcceptableOrUnknown(data['rarity']!, _rarityMeta),
      );
    } else if (isInserting) {
      context.missing(_rarityMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
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
    if (data.containsKey('drawn_at')) {
      context.handle(
        _drawnAtMeta,
        drawnAt.isAcceptableOrUnknown(data['drawn_at']!, _drawnAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RewardCardRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RewardCardRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      rarity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rarity'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      drawnAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}drawn_at'],
      ),
    );
  }

  @override
  $RewardCardsTable createAlias(String alias) {
    return $RewardCardsTable(attachedDatabase, alias);
  }
}

class RewardCardRecord extends DataClass
    implements Insertable<RewardCardRecord> {
  final String id;
  final String content;
  final String rarity;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? drawnAt;
  const RewardCardRecord({
    required this.id,
    required this.content,
    required this.rarity,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.drawnAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['content'] = Variable<String>(content);
    map['rarity'] = Variable<String>(rarity);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || drawnAt != null) {
      map['drawn_at'] = Variable<DateTime>(drawnAt);
    }
    return map;
  }

  RewardCardsCompanion toCompanion(bool nullToAbsent) {
    return RewardCardsCompanion(
      id: Value(id),
      content: Value(content),
      rarity: Value(rarity),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      drawnAt: drawnAt == null && nullToAbsent
          ? const Value.absent()
          : Value(drawnAt),
    );
  }

  factory RewardCardRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RewardCardRecord(
      id: serializer.fromJson<String>(json['id']),
      content: serializer.fromJson<String>(json['content']),
      rarity: serializer.fromJson<String>(json['rarity']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      drawnAt: serializer.fromJson<DateTime?>(json['drawnAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'content': serializer.toJson<String>(content),
      'rarity': serializer.toJson<String>(rarity),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'drawnAt': serializer.toJson<DateTime?>(drawnAt),
    };
  }

  RewardCardRecord copyWith({
    String? id,
    String? content,
    String? rarity,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> drawnAt = const Value.absent(),
  }) => RewardCardRecord(
    id: id ?? this.id,
    content: content ?? this.content,
    rarity: rarity ?? this.rarity,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    drawnAt: drawnAt.present ? drawnAt.value : this.drawnAt,
  );
  RewardCardRecord copyWithCompanion(RewardCardsCompanion data) {
    return RewardCardRecord(
      id: data.id.present ? data.id.value : this.id,
      content: data.content.present ? data.content.value : this.content,
      rarity: data.rarity.present ? data.rarity.value : this.rarity,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      drawnAt: data.drawnAt.present ? data.drawnAt.value : this.drawnAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RewardCardRecord(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('rarity: $rarity, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('drawnAt: $drawnAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, content, rarity, status, createdAt, updatedAt, drawnAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RewardCardRecord &&
          other.id == this.id &&
          other.content == this.content &&
          other.rarity == this.rarity &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.drawnAt == this.drawnAt);
}

class RewardCardsCompanion extends UpdateCompanion<RewardCardRecord> {
  final Value<String> id;
  final Value<String> content;
  final Value<String> rarity;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> drawnAt;
  final Value<int> rowid;
  const RewardCardsCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.rarity = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.drawnAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RewardCardsCompanion.insert({
    required String id,
    required String content,
    required String rarity,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.drawnAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       content = Value(content),
       rarity = Value(rarity),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<RewardCardRecord> custom({
    Expression<String>? id,
    Expression<String>? content,
    Expression<String>? rarity,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? drawnAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
      if (rarity != null) 'rarity': rarity,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (drawnAt != null) 'drawn_at': drawnAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RewardCardsCompanion copyWith({
    Value<String>? id,
    Value<String>? content,
    Value<String>? rarity,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? drawnAt,
    Value<int>? rowid,
  }) {
    return RewardCardsCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
      rarity: rarity ?? this.rarity,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      drawnAt: drawnAt ?? this.drawnAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (rarity.present) {
      map['rarity'] = Variable<String>(rarity.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (drawnAt.present) {
      map['drawn_at'] = Variable<DateTime>(drawnAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RewardCardsCompanion(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('rarity: $rarity, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('drawnAt: $drawnAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GachaDrawsTable extends GachaDraws
    with TableInfo<$GachaDrawsTable, GachaDrawRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GachaDrawsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _drawTypeMeta = const VerificationMeta(
    'drawType',
  );
  @override
  late final GeneratedColumn<String> drawType = GeneratedColumn<String>(
    'draw_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costPointsMeta = const VerificationMeta(
    'costPoints',
  );
  @override
  late final GeneratedColumn<int> costPoints = GeneratedColumn<int>(
    'cost_points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rolledRarityMeta = const VerificationMeta(
    'rolledRarity',
  );
  @override
  late final GeneratedColumn<String> rolledRarity = GeneratedColumn<String>(
    'rolled_rarity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rewardCardIdMeta = const VerificationMeta(
    'rewardCardId',
  );
  @override
  late final GeneratedColumn<String> rewardCardId = GeneratedColumn<String>(
    'reward_card_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES reward_cards (id)',
    ),
  );
  static const VerificationMeta _rngAuditHashMeta = const VerificationMeta(
    'rngAuditHash',
  );
  @override
  late final GeneratedColumn<String> rngAuditHash = GeneratedColumn<String>(
    'rng_audit_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
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
    drawType,
    costPoints,
    rolledRarity,
    rewardCardId,
    rngAuditHash,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gacha_draws';
  @override
  VerificationContext validateIntegrity(
    Insertable<GachaDrawRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('draw_type')) {
      context.handle(
        _drawTypeMeta,
        drawType.isAcceptableOrUnknown(data['draw_type']!, _drawTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_drawTypeMeta);
    }
    if (data.containsKey('cost_points')) {
      context.handle(
        _costPointsMeta,
        costPoints.isAcceptableOrUnknown(data['cost_points']!, _costPointsMeta),
      );
    } else if (isInserting) {
      context.missing(_costPointsMeta);
    }
    if (data.containsKey('rolled_rarity')) {
      context.handle(
        _rolledRarityMeta,
        rolledRarity.isAcceptableOrUnknown(
          data['rolled_rarity']!,
          _rolledRarityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rolledRarityMeta);
    }
    if (data.containsKey('reward_card_id')) {
      context.handle(
        _rewardCardIdMeta,
        rewardCardId.isAcceptableOrUnknown(
          data['reward_card_id']!,
          _rewardCardIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rewardCardIdMeta);
    }
    if (data.containsKey('rng_audit_hash')) {
      context.handle(
        _rngAuditHashMeta,
        rngAuditHash.isAcceptableOrUnknown(
          data['rng_audit_hash']!,
          _rngAuditHashMeta,
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
  GachaDrawRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GachaDrawRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      drawType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}draw_type'],
      )!,
      costPoints: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cost_points'],
      )!,
      rolledRarity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rolled_rarity'],
      )!,
      rewardCardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reward_card_id'],
      )!,
      rngAuditHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rng_audit_hash'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $GachaDrawsTable createAlias(String alias) {
    return $GachaDrawsTable(attachedDatabase, alias);
  }
}

class GachaDrawRecord extends DataClass implements Insertable<GachaDrawRecord> {
  final String id;
  final String drawType;
  final int costPoints;
  final String rolledRarity;
  final String rewardCardId;
  final String? rngAuditHash;
  final DateTime createdAt;
  const GachaDrawRecord({
    required this.id,
    required this.drawType,
    required this.costPoints,
    required this.rolledRarity,
    required this.rewardCardId,
    this.rngAuditHash,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['draw_type'] = Variable<String>(drawType);
    map['cost_points'] = Variable<int>(costPoints);
    map['rolled_rarity'] = Variable<String>(rolledRarity);
    map['reward_card_id'] = Variable<String>(rewardCardId);
    if (!nullToAbsent || rngAuditHash != null) {
      map['rng_audit_hash'] = Variable<String>(rngAuditHash);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  GachaDrawsCompanion toCompanion(bool nullToAbsent) {
    return GachaDrawsCompanion(
      id: Value(id),
      drawType: Value(drawType),
      costPoints: Value(costPoints),
      rolledRarity: Value(rolledRarity),
      rewardCardId: Value(rewardCardId),
      rngAuditHash: rngAuditHash == null && nullToAbsent
          ? const Value.absent()
          : Value(rngAuditHash),
      createdAt: Value(createdAt),
    );
  }

  factory GachaDrawRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GachaDrawRecord(
      id: serializer.fromJson<String>(json['id']),
      drawType: serializer.fromJson<String>(json['drawType']),
      costPoints: serializer.fromJson<int>(json['costPoints']),
      rolledRarity: serializer.fromJson<String>(json['rolledRarity']),
      rewardCardId: serializer.fromJson<String>(json['rewardCardId']),
      rngAuditHash: serializer.fromJson<String?>(json['rngAuditHash']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'drawType': serializer.toJson<String>(drawType),
      'costPoints': serializer.toJson<int>(costPoints),
      'rolledRarity': serializer.toJson<String>(rolledRarity),
      'rewardCardId': serializer.toJson<String>(rewardCardId),
      'rngAuditHash': serializer.toJson<String?>(rngAuditHash),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  GachaDrawRecord copyWith({
    String? id,
    String? drawType,
    int? costPoints,
    String? rolledRarity,
    String? rewardCardId,
    Value<String?> rngAuditHash = const Value.absent(),
    DateTime? createdAt,
  }) => GachaDrawRecord(
    id: id ?? this.id,
    drawType: drawType ?? this.drawType,
    costPoints: costPoints ?? this.costPoints,
    rolledRarity: rolledRarity ?? this.rolledRarity,
    rewardCardId: rewardCardId ?? this.rewardCardId,
    rngAuditHash: rngAuditHash.present ? rngAuditHash.value : this.rngAuditHash,
    createdAt: createdAt ?? this.createdAt,
  );
  GachaDrawRecord copyWithCompanion(GachaDrawsCompanion data) {
    return GachaDrawRecord(
      id: data.id.present ? data.id.value : this.id,
      drawType: data.drawType.present ? data.drawType.value : this.drawType,
      costPoints: data.costPoints.present
          ? data.costPoints.value
          : this.costPoints,
      rolledRarity: data.rolledRarity.present
          ? data.rolledRarity.value
          : this.rolledRarity,
      rewardCardId: data.rewardCardId.present
          ? data.rewardCardId.value
          : this.rewardCardId,
      rngAuditHash: data.rngAuditHash.present
          ? data.rngAuditHash.value
          : this.rngAuditHash,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GachaDrawRecord(')
          ..write('id: $id, ')
          ..write('drawType: $drawType, ')
          ..write('costPoints: $costPoints, ')
          ..write('rolledRarity: $rolledRarity, ')
          ..write('rewardCardId: $rewardCardId, ')
          ..write('rngAuditHash: $rngAuditHash, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    drawType,
    costPoints,
    rolledRarity,
    rewardCardId,
    rngAuditHash,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GachaDrawRecord &&
          other.id == this.id &&
          other.drawType == this.drawType &&
          other.costPoints == this.costPoints &&
          other.rolledRarity == this.rolledRarity &&
          other.rewardCardId == this.rewardCardId &&
          other.rngAuditHash == this.rngAuditHash &&
          other.createdAt == this.createdAt);
}

class GachaDrawsCompanion extends UpdateCompanion<GachaDrawRecord> {
  final Value<String> id;
  final Value<String> drawType;
  final Value<int> costPoints;
  final Value<String> rolledRarity;
  final Value<String> rewardCardId;
  final Value<String?> rngAuditHash;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const GachaDrawsCompanion({
    this.id = const Value.absent(),
    this.drawType = const Value.absent(),
    this.costPoints = const Value.absent(),
    this.rolledRarity = const Value.absent(),
    this.rewardCardId = const Value.absent(),
    this.rngAuditHash = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GachaDrawsCompanion.insert({
    required String id,
    required String drawType,
    required int costPoints,
    required String rolledRarity,
    required String rewardCardId,
    this.rngAuditHash = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       drawType = Value(drawType),
       costPoints = Value(costPoints),
       rolledRarity = Value(rolledRarity),
       rewardCardId = Value(rewardCardId),
       createdAt = Value(createdAt);
  static Insertable<GachaDrawRecord> custom({
    Expression<String>? id,
    Expression<String>? drawType,
    Expression<int>? costPoints,
    Expression<String>? rolledRarity,
    Expression<String>? rewardCardId,
    Expression<String>? rngAuditHash,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (drawType != null) 'draw_type': drawType,
      if (costPoints != null) 'cost_points': costPoints,
      if (rolledRarity != null) 'rolled_rarity': rolledRarity,
      if (rewardCardId != null) 'reward_card_id': rewardCardId,
      if (rngAuditHash != null) 'rng_audit_hash': rngAuditHash,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GachaDrawsCompanion copyWith({
    Value<String>? id,
    Value<String>? drawType,
    Value<int>? costPoints,
    Value<String>? rolledRarity,
    Value<String>? rewardCardId,
    Value<String?>? rngAuditHash,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return GachaDrawsCompanion(
      id: id ?? this.id,
      drawType: drawType ?? this.drawType,
      costPoints: costPoints ?? this.costPoints,
      rolledRarity: rolledRarity ?? this.rolledRarity,
      rewardCardId: rewardCardId ?? this.rewardCardId,
      rngAuditHash: rngAuditHash ?? this.rngAuditHash,
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
    if (drawType.present) {
      map['draw_type'] = Variable<String>(drawType.value);
    }
    if (costPoints.present) {
      map['cost_points'] = Variable<int>(costPoints.value);
    }
    if (rolledRarity.present) {
      map['rolled_rarity'] = Variable<String>(rolledRarity.value);
    }
    if (rewardCardId.present) {
      map['reward_card_id'] = Variable<String>(rewardCardId.value);
    }
    if (rngAuditHash.present) {
      map['rng_audit_hash'] = Variable<String>(rngAuditHash.value);
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
    return (StringBuffer('GachaDrawsCompanion(')
          ..write('id: $id, ')
          ..write('drawType: $drawType, ')
          ..write('costPoints: $costPoints, ')
          ..write('rolledRarity: $rolledRarity, ')
          ..write('rewardCardId: $rewardCardId, ')
          ..write('rngAuditHash: $rngAuditHash, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CharacterProfilesTable extends CharacterProfiles
    with TableInfo<$CharacterProfilesTable, CharacterProfileRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CharacterProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _xpMeta = const VerificationMeta('xp');
  @override
  late final GeneratedColumn<int> xp = GeneratedColumn<int>(
    'xp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _staminaMeta = const VerificationMeta(
    'stamina',
  );
  @override
  late final GeneratedColumn<int> stamina = GeneratedColumn<int>(
    'stamina',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intelligenceMeta = const VerificationMeta(
    'intelligence',
  );
  @override
  late final GeneratedColumn<int> intelligence = GeneratedColumn<int>(
    'intelligence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _disciplineMeta = const VerificationMeta(
    'discipline',
  );
  @override
  late final GeneratedColumn<int> discipline = GeneratedColumn<int>(
    'discipline',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creativityMeta = const VerificationMeta(
    'creativity',
  );
  @override
  late final GeneratedColumn<int> creativity = GeneratedColumn<int>(
    'creativity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _skinStateMeta = const VerificationMeta(
    'skinState',
  );
  @override
  late final GeneratedColumn<String> skinState = GeneratedColumn<String>(
    'skin_state',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bodyTypeMeta = const VerificationMeta(
    'bodyType',
  );
  @override
  late final GeneratedColumn<String> bodyType = GeneratedColumn<String>(
    'body_type',
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
    name,
    level,
    xp,
    stamina,
    intelligence,
    discipline,
    creativity,
    skinState,
    bodyType,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'character_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<CharacterProfileRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('xp')) {
      context.handle(_xpMeta, xp.isAcceptableOrUnknown(data['xp']!, _xpMeta));
    } else if (isInserting) {
      context.missing(_xpMeta);
    }
    if (data.containsKey('stamina')) {
      context.handle(
        _staminaMeta,
        stamina.isAcceptableOrUnknown(data['stamina']!, _staminaMeta),
      );
    } else if (isInserting) {
      context.missing(_staminaMeta);
    }
    if (data.containsKey('intelligence')) {
      context.handle(
        _intelligenceMeta,
        intelligence.isAcceptableOrUnknown(
          data['intelligence']!,
          _intelligenceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_intelligenceMeta);
    }
    if (data.containsKey('discipline')) {
      context.handle(
        _disciplineMeta,
        discipline.isAcceptableOrUnknown(data['discipline']!, _disciplineMeta),
      );
    } else if (isInserting) {
      context.missing(_disciplineMeta);
    }
    if (data.containsKey('creativity')) {
      context.handle(
        _creativityMeta,
        creativity.isAcceptableOrUnknown(data['creativity']!, _creativityMeta),
      );
    } else if (isInserting) {
      context.missing(_creativityMeta);
    }
    if (data.containsKey('skin_state')) {
      context.handle(
        _skinStateMeta,
        skinState.isAcceptableOrUnknown(data['skin_state']!, _skinStateMeta),
      );
    }
    if (data.containsKey('body_type')) {
      context.handle(
        _bodyTypeMeta,
        bodyType.isAcceptableOrUnknown(data['body_type']!, _bodyTypeMeta),
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
  CharacterProfileRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CharacterProfileRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      )!,
      xp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}xp'],
      )!,
      stamina: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stamina'],
      )!,
      intelligence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intelligence'],
      )!,
      discipline: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discipline'],
      )!,
      creativity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}creativity'],
      )!,
      skinState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}skin_state'],
      ),
      bodyType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body_type'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CharacterProfilesTable createAlias(String alias) {
    return $CharacterProfilesTable(attachedDatabase, alias);
  }
}

class CharacterProfileRecord extends DataClass
    implements Insertable<CharacterProfileRecord> {
  final String id;
  final String? name;
  final int level;
  final int xp;
  final int stamina;
  final int intelligence;
  final int discipline;
  final int creativity;
  final String? skinState;
  final String? bodyType;
  final DateTime updatedAt;
  const CharacterProfileRecord({
    required this.id,
    this.name,
    required this.level,
    required this.xp,
    required this.stamina,
    required this.intelligence,
    required this.discipline,
    required this.creativity,
    this.skinState,
    this.bodyType,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['level'] = Variable<int>(level);
    map['xp'] = Variable<int>(xp);
    map['stamina'] = Variable<int>(stamina);
    map['intelligence'] = Variable<int>(intelligence);
    map['discipline'] = Variable<int>(discipline);
    map['creativity'] = Variable<int>(creativity);
    if (!nullToAbsent || skinState != null) {
      map['skin_state'] = Variable<String>(skinState);
    }
    if (!nullToAbsent || bodyType != null) {
      map['body_type'] = Variable<String>(bodyType);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CharacterProfilesCompanion toCompanion(bool nullToAbsent) {
    return CharacterProfilesCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      level: Value(level),
      xp: Value(xp),
      stamina: Value(stamina),
      intelligence: Value(intelligence),
      discipline: Value(discipline),
      creativity: Value(creativity),
      skinState: skinState == null && nullToAbsent
          ? const Value.absent()
          : Value(skinState),
      bodyType: bodyType == null && nullToAbsent
          ? const Value.absent()
          : Value(bodyType),
      updatedAt: Value(updatedAt),
    );
  }

  factory CharacterProfileRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CharacterProfileRecord(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      level: serializer.fromJson<int>(json['level']),
      xp: serializer.fromJson<int>(json['xp']),
      stamina: serializer.fromJson<int>(json['stamina']),
      intelligence: serializer.fromJson<int>(json['intelligence']),
      discipline: serializer.fromJson<int>(json['discipline']),
      creativity: serializer.fromJson<int>(json['creativity']),
      skinState: serializer.fromJson<String?>(json['skinState']),
      bodyType: serializer.fromJson<String?>(json['bodyType']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String?>(name),
      'level': serializer.toJson<int>(level),
      'xp': serializer.toJson<int>(xp),
      'stamina': serializer.toJson<int>(stamina),
      'intelligence': serializer.toJson<int>(intelligence),
      'discipline': serializer.toJson<int>(discipline),
      'creativity': serializer.toJson<int>(creativity),
      'skinState': serializer.toJson<String?>(skinState),
      'bodyType': serializer.toJson<String?>(bodyType),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CharacterProfileRecord copyWith({
    String? id,
    Value<String?> name = const Value.absent(),
    int? level,
    int? xp,
    int? stamina,
    int? intelligence,
    int? discipline,
    int? creativity,
    Value<String?> skinState = const Value.absent(),
    Value<String?> bodyType = const Value.absent(),
    DateTime? updatedAt,
  }) => CharacterProfileRecord(
    id: id ?? this.id,
    name: name.present ? name.value : this.name,
    level: level ?? this.level,
    xp: xp ?? this.xp,
    stamina: stamina ?? this.stamina,
    intelligence: intelligence ?? this.intelligence,
    discipline: discipline ?? this.discipline,
    creativity: creativity ?? this.creativity,
    skinState: skinState.present ? skinState.value : this.skinState,
    bodyType: bodyType.present ? bodyType.value : this.bodyType,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CharacterProfileRecord copyWithCompanion(CharacterProfilesCompanion data) {
    return CharacterProfileRecord(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      level: data.level.present ? data.level.value : this.level,
      xp: data.xp.present ? data.xp.value : this.xp,
      stamina: data.stamina.present ? data.stamina.value : this.stamina,
      intelligence: data.intelligence.present
          ? data.intelligence.value
          : this.intelligence,
      discipline: data.discipline.present
          ? data.discipline.value
          : this.discipline,
      creativity: data.creativity.present
          ? data.creativity.value
          : this.creativity,
      skinState: data.skinState.present ? data.skinState.value : this.skinState,
      bodyType: data.bodyType.present ? data.bodyType.value : this.bodyType,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CharacterProfileRecord(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('level: $level, ')
          ..write('xp: $xp, ')
          ..write('stamina: $stamina, ')
          ..write('intelligence: $intelligence, ')
          ..write('discipline: $discipline, ')
          ..write('creativity: $creativity, ')
          ..write('skinState: $skinState, ')
          ..write('bodyType: $bodyType, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    level,
    xp,
    stamina,
    intelligence,
    discipline,
    creativity,
    skinState,
    bodyType,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CharacterProfileRecord &&
          other.id == this.id &&
          other.name == this.name &&
          other.level == this.level &&
          other.xp == this.xp &&
          other.stamina == this.stamina &&
          other.intelligence == this.intelligence &&
          other.discipline == this.discipline &&
          other.creativity == this.creativity &&
          other.skinState == this.skinState &&
          other.bodyType == this.bodyType &&
          other.updatedAt == this.updatedAt);
}

class CharacterProfilesCompanion
    extends UpdateCompanion<CharacterProfileRecord> {
  final Value<String> id;
  final Value<String?> name;
  final Value<int> level;
  final Value<int> xp;
  final Value<int> stamina;
  final Value<int> intelligence;
  final Value<int> discipline;
  final Value<int> creativity;
  final Value<String?> skinState;
  final Value<String?> bodyType;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CharacterProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.level = const Value.absent(),
    this.xp = const Value.absent(),
    this.stamina = const Value.absent(),
    this.intelligence = const Value.absent(),
    this.discipline = const Value.absent(),
    this.creativity = const Value.absent(),
    this.skinState = const Value.absent(),
    this.bodyType = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CharacterProfilesCompanion.insert({
    required String id,
    this.name = const Value.absent(),
    required int level,
    required int xp,
    required int stamina,
    required int intelligence,
    required int discipline,
    required int creativity,
    this.skinState = const Value.absent(),
    this.bodyType = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       level = Value(level),
       xp = Value(xp),
       stamina = Value(stamina),
       intelligence = Value(intelligence),
       discipline = Value(discipline),
       creativity = Value(creativity),
       updatedAt = Value(updatedAt);
  static Insertable<CharacterProfileRecord> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? level,
    Expression<int>? xp,
    Expression<int>? stamina,
    Expression<int>? intelligence,
    Expression<int>? discipline,
    Expression<int>? creativity,
    Expression<String>? skinState,
    Expression<String>? bodyType,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (level != null) 'level': level,
      if (xp != null) 'xp': xp,
      if (stamina != null) 'stamina': stamina,
      if (intelligence != null) 'intelligence': intelligence,
      if (discipline != null) 'discipline': discipline,
      if (creativity != null) 'creativity': creativity,
      if (skinState != null) 'skin_state': skinState,
      if (bodyType != null) 'body_type': bodyType,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CharacterProfilesCompanion copyWith({
    Value<String>? id,
    Value<String?>? name,
    Value<int>? level,
    Value<int>? xp,
    Value<int>? stamina,
    Value<int>? intelligence,
    Value<int>? discipline,
    Value<int>? creativity,
    Value<String?>? skinState,
    Value<String?>? bodyType,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CharacterProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      stamina: stamina ?? this.stamina,
      intelligence: intelligence ?? this.intelligence,
      discipline: discipline ?? this.discipline,
      creativity: creativity ?? this.creativity,
      skinState: skinState ?? this.skinState,
      bodyType: bodyType ?? this.bodyType,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (xp.present) {
      map['xp'] = Variable<int>(xp.value);
    }
    if (stamina.present) {
      map['stamina'] = Variable<int>(stamina.value);
    }
    if (intelligence.present) {
      map['intelligence'] = Variable<int>(intelligence.value);
    }
    if (discipline.present) {
      map['discipline'] = Variable<int>(discipline.value);
    }
    if (creativity.present) {
      map['creativity'] = Variable<int>(creativity.value);
    }
    if (skinState.present) {
      map['skin_state'] = Variable<String>(skinState.value);
    }
    if (bodyType.present) {
      map['body_type'] = Variable<String>(bodyType.value);
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
    return (StringBuffer('CharacterProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('level: $level, ')
          ..write('xp: $xp, ')
          ..write('stamina: $stamina, ')
          ..write('intelligence: $intelligence, ')
          ..write('discipline: $discipline, ')
          ..write('creativity: $creativity, ')
          ..write('skinState: $skinState, ')
          ..write('bodyType: $bodyType, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AchievementsTable extends Achievements
    with TableInfo<$AchievementsTable, AchievementRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AchievementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _achievementTypeMeta = const VerificationMeta(
    'achievementType',
  );
  @override
  late final GeneratedColumn<String> achievementType = GeneratedColumn<String>(
    'achievement_type',
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
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _progressCounterMeta = const VerificationMeta(
    'progressCounter',
  );
  @override
  late final GeneratedColumn<int> progressCounter = GeneratedColumn<int>(
    'progress_counter',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    achievementType,
    unlockedAt,
    progressCounter,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'achievements';
  @override
  VerificationContext validateIntegrity(
    Insertable<AchievementRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('achievement_type')) {
      context.handle(
        _achievementTypeMeta,
        achievementType.isAcceptableOrUnknown(
          data['achievement_type']!,
          _achievementTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_achievementTypeMeta);
    }
    if (data.containsKey('unlocked_at')) {
      context.handle(
        _unlockedAtMeta,
        unlockedAt.isAcceptableOrUnknown(data['unlocked_at']!, _unlockedAtMeta),
      );
    }
    if (data.containsKey('progress_counter')) {
      context.handle(
        _progressCounterMeta,
        progressCounter.isAcceptableOrUnknown(
          data['progress_counter']!,
          _progressCounterMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AchievementRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AchievementRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      achievementType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}achievement_type'],
      )!,
      unlockedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}unlocked_at'],
      ),
      progressCounter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}progress_counter'],
      )!,
    );
  }

  @override
  $AchievementsTable createAlias(String alias) {
    return $AchievementsTable(attachedDatabase, alias);
  }
}

class AchievementRecord extends DataClass
    implements Insertable<AchievementRecord> {
  final String id;
  final String achievementType;
  final DateTime? unlockedAt;
  final int progressCounter;
  const AchievementRecord({
    required this.id,
    required this.achievementType,
    this.unlockedAt,
    required this.progressCounter,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['achievement_type'] = Variable<String>(achievementType);
    if (!nullToAbsent || unlockedAt != null) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt);
    }
    map['progress_counter'] = Variable<int>(progressCounter);
    return map;
  }

  AchievementsCompanion toCompanion(bool nullToAbsent) {
    return AchievementsCompanion(
      id: Value(id),
      achievementType: Value(achievementType),
      unlockedAt: unlockedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(unlockedAt),
      progressCounter: Value(progressCounter),
    );
  }

  factory AchievementRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AchievementRecord(
      id: serializer.fromJson<String>(json['id']),
      achievementType: serializer.fromJson<String>(json['achievementType']),
      unlockedAt: serializer.fromJson<DateTime?>(json['unlockedAt']),
      progressCounter: serializer.fromJson<int>(json['progressCounter']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'achievementType': serializer.toJson<String>(achievementType),
      'unlockedAt': serializer.toJson<DateTime?>(unlockedAt),
      'progressCounter': serializer.toJson<int>(progressCounter),
    };
  }

  AchievementRecord copyWith({
    String? id,
    String? achievementType,
    Value<DateTime?> unlockedAt = const Value.absent(),
    int? progressCounter,
  }) => AchievementRecord(
    id: id ?? this.id,
    achievementType: achievementType ?? this.achievementType,
    unlockedAt: unlockedAt.present ? unlockedAt.value : this.unlockedAt,
    progressCounter: progressCounter ?? this.progressCounter,
  );
  AchievementRecord copyWithCompanion(AchievementsCompanion data) {
    return AchievementRecord(
      id: data.id.present ? data.id.value : this.id,
      achievementType: data.achievementType.present
          ? data.achievementType.value
          : this.achievementType,
      unlockedAt: data.unlockedAt.present
          ? data.unlockedAt.value
          : this.unlockedAt,
      progressCounter: data.progressCounter.present
          ? data.progressCounter.value
          : this.progressCounter,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AchievementRecord(')
          ..write('id: $id, ')
          ..write('achievementType: $achievementType, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('progressCounter: $progressCounter')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, achievementType, unlockedAt, progressCounter);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AchievementRecord &&
          other.id == this.id &&
          other.achievementType == this.achievementType &&
          other.unlockedAt == this.unlockedAt &&
          other.progressCounter == this.progressCounter);
}

class AchievementsCompanion extends UpdateCompanion<AchievementRecord> {
  final Value<String> id;
  final Value<String> achievementType;
  final Value<DateTime?> unlockedAt;
  final Value<int> progressCounter;
  final Value<int> rowid;
  const AchievementsCompanion({
    this.id = const Value.absent(),
    this.achievementType = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.progressCounter = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AchievementsCompanion.insert({
    required String id,
    required String achievementType,
    this.unlockedAt = const Value.absent(),
    this.progressCounter = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       achievementType = Value(achievementType);
  static Insertable<AchievementRecord> custom({
    Expression<String>? id,
    Expression<String>? achievementType,
    Expression<DateTime>? unlockedAt,
    Expression<int>? progressCounter,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (achievementType != null) 'achievement_type': achievementType,
      if (unlockedAt != null) 'unlocked_at': unlockedAt,
      if (progressCounter != null) 'progress_counter': progressCounter,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AchievementsCompanion copyWith({
    Value<String>? id,
    Value<String>? achievementType,
    Value<DateTime?>? unlockedAt,
    Value<int>? progressCounter,
    Value<int>? rowid,
  }) {
    return AchievementsCompanion(
      id: id ?? this.id,
      achievementType: achievementType ?? this.achievementType,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      progressCounter: progressCounter ?? this.progressCounter,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (achievementType.present) {
      map['achievement_type'] = Variable<String>(achievementType.value);
    }
    if (unlockedAt.present) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt.value);
    }
    if (progressCounter.present) {
      map['progress_counter'] = Variable<int>(progressCounter.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AchievementsCompanion(')
          ..write('id: $id, ')
          ..write('achievementType: $achievementType, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('progressCounter: $progressCounter, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyStreaksTable extends DailyStreaks
    with TableInfo<$DailyStreaksTable, DailyStreakRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyStreaksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _bestStreakMeta = const VerificationMeta(
    'bestStreak',
  );
  @override
  late final GeneratedColumn<int> bestStreak = GeneratedColumn<int>(
    'best_streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastQualifiedDateMeta = const VerificationMeta(
    'lastQualifiedDate',
  );
  @override
  late final GeneratedColumn<DateTime> lastQualifiedDate =
      GeneratedColumn<DateTime>(
        'last_qualified_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
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
    currentStreak,
    bestStreak,
    lastQualifiedDate,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_streaks';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyStreakRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
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
    if (data.containsKey('best_streak')) {
      context.handle(
        _bestStreakMeta,
        bestStreak.isAcceptableOrUnknown(data['best_streak']!, _bestStreakMeta),
      );
    }
    if (data.containsKey('last_qualified_date')) {
      context.handle(
        _lastQualifiedDateMeta,
        lastQualifiedDate.isAcceptableOrUnknown(
          data['last_qualified_date']!,
          _lastQualifiedDateMeta,
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
  DailyStreakRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyStreakRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      currentStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_streak'],
      )!,
      bestStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}best_streak'],
      )!,
      lastQualifiedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_qualified_date'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DailyStreaksTable createAlias(String alias) {
    return $DailyStreaksTable(attachedDatabase, alias);
  }
}

class DailyStreakRecord extends DataClass
    implements Insertable<DailyStreakRecord> {
  final String id;
  final int currentStreak;
  final int bestStreak;
  final DateTime? lastQualifiedDate;
  final DateTime updatedAt;
  const DailyStreakRecord({
    required this.id,
    required this.currentStreak,
    required this.bestStreak,
    this.lastQualifiedDate,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['current_streak'] = Variable<int>(currentStreak);
    map['best_streak'] = Variable<int>(bestStreak);
    if (!nullToAbsent || lastQualifiedDate != null) {
      map['last_qualified_date'] = Variable<DateTime>(lastQualifiedDate);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DailyStreaksCompanion toCompanion(bool nullToAbsent) {
    return DailyStreaksCompanion(
      id: Value(id),
      currentStreak: Value(currentStreak),
      bestStreak: Value(bestStreak),
      lastQualifiedDate: lastQualifiedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastQualifiedDate),
      updatedAt: Value(updatedAt),
    );
  }

  factory DailyStreakRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyStreakRecord(
      id: serializer.fromJson<String>(json['id']),
      currentStreak: serializer.fromJson<int>(json['currentStreak']),
      bestStreak: serializer.fromJson<int>(json['bestStreak']),
      lastQualifiedDate: serializer.fromJson<DateTime?>(
        json['lastQualifiedDate'],
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'currentStreak': serializer.toJson<int>(currentStreak),
      'bestStreak': serializer.toJson<int>(bestStreak),
      'lastQualifiedDate': serializer.toJson<DateTime?>(lastQualifiedDate),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DailyStreakRecord copyWith({
    String? id,
    int? currentStreak,
    int? bestStreak,
    Value<DateTime?> lastQualifiedDate = const Value.absent(),
    DateTime? updatedAt,
  }) => DailyStreakRecord(
    id: id ?? this.id,
    currentStreak: currentStreak ?? this.currentStreak,
    bestStreak: bestStreak ?? this.bestStreak,
    lastQualifiedDate: lastQualifiedDate.present
        ? lastQualifiedDate.value
        : this.lastQualifiedDate,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DailyStreakRecord copyWithCompanion(DailyStreaksCompanion data) {
    return DailyStreakRecord(
      id: data.id.present ? data.id.value : this.id,
      currentStreak: data.currentStreak.present
          ? data.currentStreak.value
          : this.currentStreak,
      bestStreak: data.bestStreak.present
          ? data.bestStreak.value
          : this.bestStreak,
      lastQualifiedDate: data.lastQualifiedDate.present
          ? data.lastQualifiedDate.value
          : this.lastQualifiedDate,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyStreakRecord(')
          ..write('id: $id, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('bestStreak: $bestStreak, ')
          ..write('lastQualifiedDate: $lastQualifiedDate, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, currentStreak, bestStreak, lastQualifiedDate, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyStreakRecord &&
          other.id == this.id &&
          other.currentStreak == this.currentStreak &&
          other.bestStreak == this.bestStreak &&
          other.lastQualifiedDate == this.lastQualifiedDate &&
          other.updatedAt == this.updatedAt);
}

class DailyStreaksCompanion extends UpdateCompanion<DailyStreakRecord> {
  final Value<String> id;
  final Value<int> currentStreak;
  final Value<int> bestStreak;
  final Value<DateTime?> lastQualifiedDate;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DailyStreaksCompanion({
    this.id = const Value.absent(),
    this.currentStreak = const Value.absent(),
    this.bestStreak = const Value.absent(),
    this.lastQualifiedDate = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyStreaksCompanion.insert({
    required String id,
    this.currentStreak = const Value.absent(),
    this.bestStreak = const Value.absent(),
    this.lastQualifiedDate = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       updatedAt = Value(updatedAt);
  static Insertable<DailyStreakRecord> custom({
    Expression<String>? id,
    Expression<int>? currentStreak,
    Expression<int>? bestStreak,
    Expression<DateTime>? lastQualifiedDate,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (currentStreak != null) 'current_streak': currentStreak,
      if (bestStreak != null) 'best_streak': bestStreak,
      if (lastQualifiedDate != null) 'last_qualified_date': lastQualifiedDate,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyStreaksCompanion copyWith({
    Value<String>? id,
    Value<int>? currentStreak,
    Value<int>? bestStreak,
    Value<DateTime?>? lastQualifiedDate,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return DailyStreaksCompanion(
      id: id ?? this.id,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      lastQualifiedDate: lastQualifiedDate ?? this.lastQualifiedDate,
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
    if (currentStreak.present) {
      map['current_streak'] = Variable<int>(currentStreak.value);
    }
    if (bestStreak.present) {
      map['best_streak'] = Variable<int>(bestStreak.value);
    }
    if (lastQualifiedDate.present) {
      map['last_qualified_date'] = Variable<DateTime>(lastQualifiedDate.value);
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
    return (StringBuffer('DailyStreaksCompanion(')
          ..write('id: $id, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('bestStreak: $bestStreak, ')
          ..write('lastQualifiedDate: $lastQualifiedDate, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSettingRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
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
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSettingRecord> instance, {
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
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
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
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSettingRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingRecord(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSettingRecord extends DataClass
    implements Insertable<AppSettingRecord> {
  final String key;
  final String value;
  final DateTime updatedAt;
  const AppSettingRecord({
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSettingRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingRecord(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppSettingRecord copyWith({
    String? key,
    String? value,
    DateTime? updatedAt,
  }) => AppSettingRecord(
    key: key ?? this.key,
    value: value ?? this.value,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AppSettingRecord copyWithCompanion(AppSettingsCompanion data) {
    return AppSettingRecord(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingRecord(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingRecord &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsCompanion extends UpdateCompanion<AppSettingRecord> {
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value),
       updatedAt = Value(updatedAt);
  static Insertable<AppSettingRecord> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
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
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LifeGachaDatabase extends GeneratedDatabase {
  _$LifeGachaDatabase(QueryExecutor e) : super(e);
  $LifeGachaDatabaseManager get managers => $LifeGachaDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $FocusSessionsTable focusSessions = $FocusSessionsTable(this);
  late final $WalletLedgerTable walletLedger = $WalletLedgerTable(this);
  late final $RewardCardsTable rewardCards = $RewardCardsTable(this);
  late final $GachaDrawsTable gachaDraws = $GachaDrawsTable(this);
  late final $CharacterProfilesTable characterProfiles =
      $CharacterProfilesTable(this);
  late final $AchievementsTable achievements = $AchievementsTable(this);
  late final $DailyStreaksTable dailyStreaks = $DailyStreaksTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    tasks,
    focusSessions,
    walletLedger,
    rewardCards,
    gachaDraws,
    characterProfiles,
    achievements,
    dailyStreaks,
    appSettings,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tasks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('focus_sessions', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      required String id,
      Value<String?> displayName,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<String> id,
      Value<String?> displayName,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$UsersTableFilterComposer
    extends Composer<_$LifeGachaDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
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

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
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
}

class $$UsersTableOrderingComposer
    extends Composer<_$LifeGachaDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
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

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
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
}

class $$UsersTableAnnotationComposer
    extends Composer<_$LifeGachaDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$LifeGachaDatabase,
          $UsersTable,
          UserRecord,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (
            UserRecord,
            BaseReferences<_$LifeGachaDatabase, $UsersTable, UserRecord>,
          ),
          UserRecord,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$LifeGachaDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                displayName: displayName,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> displayName = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                displayName: displayName,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$LifeGachaDatabase,
      $UsersTable,
      UserRecord,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (
        UserRecord,
        BaseReferences<_$LifeGachaDatabase, $UsersTable, UserRecord>,
      ),
      UserRecord,
      PrefetchHooks Function()
    >;
typedef $$TasksTableCreateCompanionBuilder =
    TasksCompanion Function({
      required String id,
      required String title,
      required String category,
      required String status,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });
typedef $$TasksTableUpdateCompanionBuilder =
    TasksCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> category,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });

final class $$TasksTableReferences
    extends BaseReferences<_$LifeGachaDatabase, $TasksTable, TaskRecord> {
  $$TasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FocusSessionsTable, List<FocusSessionRecord>>
  _focusSessionsRefsTable(_$LifeGachaDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.focusSessions,
        aliasName: $_aliasNameGenerator(db.tasks.id, db.focusSessions.taskId),
      );

  $$FocusSessionsTableProcessedTableManager get focusSessionsRefs {
    final manager = $$FocusSessionsTableTableManager(
      $_db,
      $_db.focusSessions,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_focusSessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TasksTableFilterComposer
    extends Composer<_$LifeGachaDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
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

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
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

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> focusSessionsRefs(
    Expression<bool> Function($$FocusSessionsTableFilterComposer f) f,
  ) {
    final $$FocusSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.focusSessions,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableFilterComposer(
            $db: $db,
            $table: $db.focusSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TasksTableOrderingComposer
    extends Composer<_$LifeGachaDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
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

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
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

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TasksTableAnnotationComposer
    extends Composer<_$LifeGachaDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
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

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  Expression<T> focusSessionsRefs<T extends Object>(
    Expression<T> Function($$FocusSessionsTableAnnotationComposer a) f,
  ) {
    final $$FocusSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.focusSessions,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.focusSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$LifeGachaDatabase,
          $TasksTable,
          TaskRecord,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (TaskRecord, $$TasksTableReferences),
          TaskRecord,
          PrefetchHooks Function({bool focusSessionsRefs})
        > {
  $$TasksTableTableManager(_$LifeGachaDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                title: title,
                category: category,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String category,
                required String status,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                title: title,
                category: category,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TasksTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({focusSessionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (focusSessionsRefs) db.focusSessions,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (focusSessionsRefs)
                    await $_getPrefetchedData<
                      TaskRecord,
                      $TasksTable,
                      FocusSessionRecord
                    >(
                      currentTable: table,
                      referencedTable: $$TasksTableReferences
                          ._focusSessionsRefsTable(db),
                      managerFromTypedResult: (p0) => $$TasksTableReferences(
                        db,
                        table,
                        p0,
                      ).focusSessionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.taskId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$LifeGachaDatabase,
      $TasksTable,
      TaskRecord,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (TaskRecord, $$TasksTableReferences),
      TaskRecord,
      PrefetchHooks Function({bool focusSessionsRefs})
    >;
typedef $$FocusSessionsTableCreateCompanionBuilder =
    FocusSessionsCompanion Function({
      required String id,
      Value<String?> taskId,
      required int plannedMinutes,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
      required String status,
      Value<int> pauseCount,
      Value<bool> appBackgroundViolation,
      Value<int> actualElapsedSeconds,
      Value<int> pointsAwarded,
      required DateTime lastStateChangedAt,
      Value<int> rowid,
    });
typedef $$FocusSessionsTableUpdateCompanionBuilder =
    FocusSessionsCompanion Function({
      Value<String> id,
      Value<String?> taskId,
      Value<int> plannedMinutes,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      Value<String> status,
      Value<int> pauseCount,
      Value<bool> appBackgroundViolation,
      Value<int> actualElapsedSeconds,
      Value<int> pointsAwarded,
      Value<DateTime> lastStateChangedAt,
      Value<int> rowid,
    });

final class $$FocusSessionsTableReferences
    extends
        BaseReferences<
          _$LifeGachaDatabase,
          $FocusSessionsTable,
          FocusSessionRecord
        > {
  $$FocusSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TasksTable _taskIdTable(_$LifeGachaDatabase db) => db.tasks
      .createAlias($_aliasNameGenerator(db.focusSessions.taskId, db.tasks.id));

  $$TasksTableProcessedTableManager? get taskId {
    final $_column = $_itemColumn<String>('task_id');
    if ($_column == null) return null;
    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FocusSessionsTableFilterComposer
    extends Composer<_$LifeGachaDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableFilterComposer({
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

  ColumnFilters<int> get plannedMinutes => $composableBuilder(
    column: $table.plannedMinutes,
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

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pauseCount => $composableBuilder(
    column: $table.pauseCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get appBackgroundViolation => $composableBuilder(
    column: $table.appBackgroundViolation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get actualElapsedSeconds => $composableBuilder(
    column: $table.actualElapsedSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pointsAwarded => $composableBuilder(
    column: $table.pointsAwarded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastStateChangedAt => $composableBuilder(
    column: $table.lastStateChangedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TasksTableFilterComposer get taskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FocusSessionsTableOrderingComposer
    extends Composer<_$LifeGachaDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableOrderingComposer({
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

  ColumnOrderings<int> get plannedMinutes => $composableBuilder(
    column: $table.plannedMinutes,
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

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pauseCount => $composableBuilder(
    column: $table.pauseCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get appBackgroundViolation => $composableBuilder(
    column: $table.appBackgroundViolation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get actualElapsedSeconds => $composableBuilder(
    column: $table.actualElapsedSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pointsAwarded => $composableBuilder(
    column: $table.pointsAwarded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastStateChangedAt => $composableBuilder(
    column: $table.lastStateChangedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TasksTableOrderingComposer get taskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableOrderingComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FocusSessionsTableAnnotationComposer
    extends Composer<_$LifeGachaDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get plannedMinutes => $composableBuilder(
    column: $table.plannedMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get pauseCount => $composableBuilder(
    column: $table.pauseCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get appBackgroundViolation => $composableBuilder(
    column: $table.appBackgroundViolation,
    builder: (column) => column,
  );

  GeneratedColumn<int> get actualElapsedSeconds => $composableBuilder(
    column: $table.actualElapsedSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pointsAwarded => $composableBuilder(
    column: $table.pointsAwarded,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastStateChangedAt => $composableBuilder(
    column: $table.lastStateChangedAt,
    builder: (column) => column,
  );

  $$TasksTableAnnotationComposer get taskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FocusSessionsTableTableManager
    extends
        RootTableManager<
          _$LifeGachaDatabase,
          $FocusSessionsTable,
          FocusSessionRecord,
          $$FocusSessionsTableFilterComposer,
          $$FocusSessionsTableOrderingComposer,
          $$FocusSessionsTableAnnotationComposer,
          $$FocusSessionsTableCreateCompanionBuilder,
          $$FocusSessionsTableUpdateCompanionBuilder,
          (FocusSessionRecord, $$FocusSessionsTableReferences),
          FocusSessionRecord,
          PrefetchHooks Function({bool taskId})
        > {
  $$FocusSessionsTableTableManager(
    _$LifeGachaDatabase db,
    $FocusSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FocusSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FocusSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FocusSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> taskId = const Value.absent(),
                Value<int> plannedMinutes = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> pauseCount = const Value.absent(),
                Value<bool> appBackgroundViolation = const Value.absent(),
                Value<int> actualElapsedSeconds = const Value.absent(),
                Value<int> pointsAwarded = const Value.absent(),
                Value<DateTime> lastStateChangedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FocusSessionsCompanion(
                id: id,
                taskId: taskId,
                plannedMinutes: plannedMinutes,
                startedAt: startedAt,
                endedAt: endedAt,
                status: status,
                pauseCount: pauseCount,
                appBackgroundViolation: appBackgroundViolation,
                actualElapsedSeconds: actualElapsedSeconds,
                pointsAwarded: pointsAwarded,
                lastStateChangedAt: lastStateChangedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> taskId = const Value.absent(),
                required int plannedMinutes,
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                required String status,
                Value<int> pauseCount = const Value.absent(),
                Value<bool> appBackgroundViolation = const Value.absent(),
                Value<int> actualElapsedSeconds = const Value.absent(),
                Value<int> pointsAwarded = const Value.absent(),
                required DateTime lastStateChangedAt,
                Value<int> rowid = const Value.absent(),
              }) => FocusSessionsCompanion.insert(
                id: id,
                taskId: taskId,
                plannedMinutes: plannedMinutes,
                startedAt: startedAt,
                endedAt: endedAt,
                status: status,
                pauseCount: pauseCount,
                appBackgroundViolation: appBackgroundViolation,
                actualElapsedSeconds: actualElapsedSeconds,
                pointsAwarded: pointsAwarded,
                lastStateChangedAt: lastStateChangedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FocusSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (taskId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.taskId,
                                referencedTable: $$FocusSessionsTableReferences
                                    ._taskIdTable(db),
                                referencedColumn: $$FocusSessionsTableReferences
                                    ._taskIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FocusSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$LifeGachaDatabase,
      $FocusSessionsTable,
      FocusSessionRecord,
      $$FocusSessionsTableFilterComposer,
      $$FocusSessionsTableOrderingComposer,
      $$FocusSessionsTableAnnotationComposer,
      $$FocusSessionsTableCreateCompanionBuilder,
      $$FocusSessionsTableUpdateCompanionBuilder,
      (FocusSessionRecord, $$FocusSessionsTableReferences),
      FocusSessionRecord,
      PrefetchHooks Function({bool taskId})
    >;
typedef $$WalletLedgerTableCreateCompanionBuilder =
    WalletLedgerCompanion Function({
      required String id,
      required String eventType,
      required int deltaPoints,
      required String referenceId,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$WalletLedgerTableUpdateCompanionBuilder =
    WalletLedgerCompanion Function({
      Value<String> id,
      Value<String> eventType,
      Value<int> deltaPoints,
      Value<String> referenceId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$WalletLedgerTableFilterComposer
    extends Composer<_$LifeGachaDatabase, $WalletLedgerTable> {
  $$WalletLedgerTableFilterComposer({
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

  ColumnFilters<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deltaPoints => $composableBuilder(
    column: $table.deltaPoints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WalletLedgerTableOrderingComposer
    extends Composer<_$LifeGachaDatabase, $WalletLedgerTable> {
  $$WalletLedgerTableOrderingComposer({
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

  ColumnOrderings<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deltaPoints => $composableBuilder(
    column: $table.deltaPoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WalletLedgerTableAnnotationComposer
    extends Composer<_$LifeGachaDatabase, $WalletLedgerTable> {
  $$WalletLedgerTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<int> get deltaPoints => $composableBuilder(
    column: $table.deltaPoints,
    builder: (column) => column,
  );

  GeneratedColumn<String> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$WalletLedgerTableTableManager
    extends
        RootTableManager<
          _$LifeGachaDatabase,
          $WalletLedgerTable,
          WalletLedgerRecord,
          $$WalletLedgerTableFilterComposer,
          $$WalletLedgerTableOrderingComposer,
          $$WalletLedgerTableAnnotationComposer,
          $$WalletLedgerTableCreateCompanionBuilder,
          $$WalletLedgerTableUpdateCompanionBuilder,
          (
            WalletLedgerRecord,
            BaseReferences<
              _$LifeGachaDatabase,
              $WalletLedgerTable,
              WalletLedgerRecord
            >,
          ),
          WalletLedgerRecord,
          PrefetchHooks Function()
        > {
  $$WalletLedgerTableTableManager(
    _$LifeGachaDatabase db,
    $WalletLedgerTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletLedgerTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WalletLedgerTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WalletLedgerTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> eventType = const Value.absent(),
                Value<int> deltaPoints = const Value.absent(),
                Value<String> referenceId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WalletLedgerCompanion(
                id: id,
                eventType: eventType,
                deltaPoints: deltaPoints,
                referenceId: referenceId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String eventType,
                required int deltaPoints,
                required String referenceId,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => WalletLedgerCompanion.insert(
                id: id,
                eventType: eventType,
                deltaPoints: deltaPoints,
                referenceId: referenceId,
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

typedef $$WalletLedgerTableProcessedTableManager =
    ProcessedTableManager<
      _$LifeGachaDatabase,
      $WalletLedgerTable,
      WalletLedgerRecord,
      $$WalletLedgerTableFilterComposer,
      $$WalletLedgerTableOrderingComposer,
      $$WalletLedgerTableAnnotationComposer,
      $$WalletLedgerTableCreateCompanionBuilder,
      $$WalletLedgerTableUpdateCompanionBuilder,
      (
        WalletLedgerRecord,
        BaseReferences<
          _$LifeGachaDatabase,
          $WalletLedgerTable,
          WalletLedgerRecord
        >,
      ),
      WalletLedgerRecord,
      PrefetchHooks Function()
    >;
typedef $$RewardCardsTableCreateCompanionBuilder =
    RewardCardsCompanion Function({
      required String id,
      required String content,
      required String rarity,
      required String status,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> drawnAt,
      Value<int> rowid,
    });
typedef $$RewardCardsTableUpdateCompanionBuilder =
    RewardCardsCompanion Function({
      Value<String> id,
      Value<String> content,
      Value<String> rarity,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> drawnAt,
      Value<int> rowid,
    });

final class $$RewardCardsTableReferences
    extends
        BaseReferences<
          _$LifeGachaDatabase,
          $RewardCardsTable,
          RewardCardRecord
        > {
  $$RewardCardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$GachaDrawsTable, List<GachaDrawRecord>>
  _gachaDrawsRefsTable(_$LifeGachaDatabase db) => MultiTypedResultKey.fromTable(
    db.gachaDraws,
    aliasName: $_aliasNameGenerator(
      db.rewardCards.id,
      db.gachaDraws.rewardCardId,
    ),
  );

  $$GachaDrawsTableProcessedTableManager get gachaDrawsRefs {
    final manager = $$GachaDrawsTableTableManager(
      $_db,
      $_db.gachaDraws,
    ).filter((f) => f.rewardCardId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_gachaDrawsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RewardCardsTableFilterComposer
    extends Composer<_$LifeGachaDatabase, $RewardCardsTable> {
  $$RewardCardsTableFilterComposer({
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

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rarity => $composableBuilder(
    column: $table.rarity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
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

  ColumnFilters<DateTime> get drawnAt => $composableBuilder(
    column: $table.drawnAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> gachaDrawsRefs(
    Expression<bool> Function($$GachaDrawsTableFilterComposer f) f,
  ) {
    final $$GachaDrawsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gachaDraws,
      getReferencedColumn: (t) => t.rewardCardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GachaDrawsTableFilterComposer(
            $db: $db,
            $table: $db.gachaDraws,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RewardCardsTableOrderingComposer
    extends Composer<_$LifeGachaDatabase, $RewardCardsTable> {
  $$RewardCardsTableOrderingComposer({
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

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rarity => $composableBuilder(
    column: $table.rarity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
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

  ColumnOrderings<DateTime> get drawnAt => $composableBuilder(
    column: $table.drawnAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RewardCardsTableAnnotationComposer
    extends Composer<_$LifeGachaDatabase, $RewardCardsTable> {
  $$RewardCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get rarity =>
      $composableBuilder(column: $table.rarity, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get drawnAt =>
      $composableBuilder(column: $table.drawnAt, builder: (column) => column);

  Expression<T> gachaDrawsRefs<T extends Object>(
    Expression<T> Function($$GachaDrawsTableAnnotationComposer a) f,
  ) {
    final $$GachaDrawsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gachaDraws,
      getReferencedColumn: (t) => t.rewardCardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GachaDrawsTableAnnotationComposer(
            $db: $db,
            $table: $db.gachaDraws,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RewardCardsTableTableManager
    extends
        RootTableManager<
          _$LifeGachaDatabase,
          $RewardCardsTable,
          RewardCardRecord,
          $$RewardCardsTableFilterComposer,
          $$RewardCardsTableOrderingComposer,
          $$RewardCardsTableAnnotationComposer,
          $$RewardCardsTableCreateCompanionBuilder,
          $$RewardCardsTableUpdateCompanionBuilder,
          (RewardCardRecord, $$RewardCardsTableReferences),
          RewardCardRecord,
          PrefetchHooks Function({bool gachaDrawsRefs})
        > {
  $$RewardCardsTableTableManager(
    _$LifeGachaDatabase db,
    $RewardCardsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RewardCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RewardCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RewardCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> rarity = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> drawnAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RewardCardsCompanion(
                id: id,
                content: content,
                rarity: rarity,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                drawnAt: drawnAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String content,
                required String rarity,
                required String status,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> drawnAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RewardCardsCompanion.insert(
                id: id,
                content: content,
                rarity: rarity,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                drawnAt: drawnAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RewardCardsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({gachaDrawsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (gachaDrawsRefs) db.gachaDraws],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (gachaDrawsRefs)
                    await $_getPrefetchedData<
                      RewardCardRecord,
                      $RewardCardsTable,
                      GachaDrawRecord
                    >(
                      currentTable: table,
                      referencedTable: $$RewardCardsTableReferences
                          ._gachaDrawsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$RewardCardsTableReferences(
                            db,
                            table,
                            p0,
                          ).gachaDrawsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.rewardCardId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RewardCardsTableProcessedTableManager =
    ProcessedTableManager<
      _$LifeGachaDatabase,
      $RewardCardsTable,
      RewardCardRecord,
      $$RewardCardsTableFilterComposer,
      $$RewardCardsTableOrderingComposer,
      $$RewardCardsTableAnnotationComposer,
      $$RewardCardsTableCreateCompanionBuilder,
      $$RewardCardsTableUpdateCompanionBuilder,
      (RewardCardRecord, $$RewardCardsTableReferences),
      RewardCardRecord,
      PrefetchHooks Function({bool gachaDrawsRefs})
    >;
typedef $$GachaDrawsTableCreateCompanionBuilder =
    GachaDrawsCompanion Function({
      required String id,
      required String drawType,
      required int costPoints,
      required String rolledRarity,
      required String rewardCardId,
      Value<String?> rngAuditHash,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$GachaDrawsTableUpdateCompanionBuilder =
    GachaDrawsCompanion Function({
      Value<String> id,
      Value<String> drawType,
      Value<int> costPoints,
      Value<String> rolledRarity,
      Value<String> rewardCardId,
      Value<String?> rngAuditHash,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$GachaDrawsTableReferences
    extends
        BaseReferences<_$LifeGachaDatabase, $GachaDrawsTable, GachaDrawRecord> {
  $$GachaDrawsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RewardCardsTable _rewardCardIdTable(_$LifeGachaDatabase db) =>
      db.rewardCards.createAlias(
        $_aliasNameGenerator(db.gachaDraws.rewardCardId, db.rewardCards.id),
      );

  $$RewardCardsTableProcessedTableManager get rewardCardId {
    final $_column = $_itemColumn<String>('reward_card_id')!;

    final manager = $$RewardCardsTableTableManager(
      $_db,
      $_db.rewardCards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_rewardCardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GachaDrawsTableFilterComposer
    extends Composer<_$LifeGachaDatabase, $GachaDrawsTable> {
  $$GachaDrawsTableFilterComposer({
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

  ColumnFilters<String> get drawType => $composableBuilder(
    column: $table.drawType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get costPoints => $composableBuilder(
    column: $table.costPoints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rolledRarity => $composableBuilder(
    column: $table.rolledRarity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rngAuditHash => $composableBuilder(
    column: $table.rngAuditHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$RewardCardsTableFilterComposer get rewardCardId {
    final $$RewardCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rewardCardId,
      referencedTable: $db.rewardCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RewardCardsTableFilterComposer(
            $db: $db,
            $table: $db.rewardCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GachaDrawsTableOrderingComposer
    extends Composer<_$LifeGachaDatabase, $GachaDrawsTable> {
  $$GachaDrawsTableOrderingComposer({
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

  ColumnOrderings<String> get drawType => $composableBuilder(
    column: $table.drawType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get costPoints => $composableBuilder(
    column: $table.costPoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rolledRarity => $composableBuilder(
    column: $table.rolledRarity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rngAuditHash => $composableBuilder(
    column: $table.rngAuditHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$RewardCardsTableOrderingComposer get rewardCardId {
    final $$RewardCardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rewardCardId,
      referencedTable: $db.rewardCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RewardCardsTableOrderingComposer(
            $db: $db,
            $table: $db.rewardCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GachaDrawsTableAnnotationComposer
    extends Composer<_$LifeGachaDatabase, $GachaDrawsTable> {
  $$GachaDrawsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get drawType =>
      $composableBuilder(column: $table.drawType, builder: (column) => column);

  GeneratedColumn<int> get costPoints => $composableBuilder(
    column: $table.costPoints,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rolledRarity => $composableBuilder(
    column: $table.rolledRarity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rngAuditHash => $composableBuilder(
    column: $table.rngAuditHash,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$RewardCardsTableAnnotationComposer get rewardCardId {
    final $$RewardCardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rewardCardId,
      referencedTable: $db.rewardCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RewardCardsTableAnnotationComposer(
            $db: $db,
            $table: $db.rewardCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GachaDrawsTableTableManager
    extends
        RootTableManager<
          _$LifeGachaDatabase,
          $GachaDrawsTable,
          GachaDrawRecord,
          $$GachaDrawsTableFilterComposer,
          $$GachaDrawsTableOrderingComposer,
          $$GachaDrawsTableAnnotationComposer,
          $$GachaDrawsTableCreateCompanionBuilder,
          $$GachaDrawsTableUpdateCompanionBuilder,
          (GachaDrawRecord, $$GachaDrawsTableReferences),
          GachaDrawRecord,
          PrefetchHooks Function({bool rewardCardId})
        > {
  $$GachaDrawsTableTableManager(_$LifeGachaDatabase db, $GachaDrawsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GachaDrawsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GachaDrawsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GachaDrawsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> drawType = const Value.absent(),
                Value<int> costPoints = const Value.absent(),
                Value<String> rolledRarity = const Value.absent(),
                Value<String> rewardCardId = const Value.absent(),
                Value<String?> rngAuditHash = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GachaDrawsCompanion(
                id: id,
                drawType: drawType,
                costPoints: costPoints,
                rolledRarity: rolledRarity,
                rewardCardId: rewardCardId,
                rngAuditHash: rngAuditHash,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String drawType,
                required int costPoints,
                required String rolledRarity,
                required String rewardCardId,
                Value<String?> rngAuditHash = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => GachaDrawsCompanion.insert(
                id: id,
                drawType: drawType,
                costPoints: costPoints,
                rolledRarity: rolledRarity,
                rewardCardId: rewardCardId,
                rngAuditHash: rngAuditHash,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GachaDrawsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({rewardCardId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (rewardCardId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.rewardCardId,
                                referencedTable: $$GachaDrawsTableReferences
                                    ._rewardCardIdTable(db),
                                referencedColumn: $$GachaDrawsTableReferences
                                    ._rewardCardIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GachaDrawsTableProcessedTableManager =
    ProcessedTableManager<
      _$LifeGachaDatabase,
      $GachaDrawsTable,
      GachaDrawRecord,
      $$GachaDrawsTableFilterComposer,
      $$GachaDrawsTableOrderingComposer,
      $$GachaDrawsTableAnnotationComposer,
      $$GachaDrawsTableCreateCompanionBuilder,
      $$GachaDrawsTableUpdateCompanionBuilder,
      (GachaDrawRecord, $$GachaDrawsTableReferences),
      GachaDrawRecord,
      PrefetchHooks Function({bool rewardCardId})
    >;
typedef $$CharacterProfilesTableCreateCompanionBuilder =
    CharacterProfilesCompanion Function({
      required String id,
      Value<String?> name,
      required int level,
      required int xp,
      required int stamina,
      required int intelligence,
      required int discipline,
      required int creativity,
      Value<String?> skinState,
      Value<String?> bodyType,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CharacterProfilesTableUpdateCompanionBuilder =
    CharacterProfilesCompanion Function({
      Value<String> id,
      Value<String?> name,
      Value<int> level,
      Value<int> xp,
      Value<int> stamina,
      Value<int> intelligence,
      Value<int> discipline,
      Value<int> creativity,
      Value<String?> skinState,
      Value<String?> bodyType,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$CharacterProfilesTableFilterComposer
    extends Composer<_$LifeGachaDatabase, $CharacterProfilesTable> {
  $$CharacterProfilesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get xp => $composableBuilder(
    column: $table.xp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stamina => $composableBuilder(
    column: $table.stamina,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intelligence => $composableBuilder(
    column: $table.intelligence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discipline => $composableBuilder(
    column: $table.discipline,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get creativity => $composableBuilder(
    column: $table.creativity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get skinState => $composableBuilder(
    column: $table.skinState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bodyType => $composableBuilder(
    column: $table.bodyType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CharacterProfilesTableOrderingComposer
    extends Composer<_$LifeGachaDatabase, $CharacterProfilesTable> {
  $$CharacterProfilesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get xp => $composableBuilder(
    column: $table.xp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stamina => $composableBuilder(
    column: $table.stamina,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intelligence => $composableBuilder(
    column: $table.intelligence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discipline => $composableBuilder(
    column: $table.discipline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get creativity => $composableBuilder(
    column: $table.creativity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get skinState => $composableBuilder(
    column: $table.skinState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bodyType => $composableBuilder(
    column: $table.bodyType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CharacterProfilesTableAnnotationComposer
    extends Composer<_$LifeGachaDatabase, $CharacterProfilesTable> {
  $$CharacterProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get xp =>
      $composableBuilder(column: $table.xp, builder: (column) => column);

  GeneratedColumn<int> get stamina =>
      $composableBuilder(column: $table.stamina, builder: (column) => column);

  GeneratedColumn<int> get intelligence => $composableBuilder(
    column: $table.intelligence,
    builder: (column) => column,
  );

  GeneratedColumn<int> get discipline => $composableBuilder(
    column: $table.discipline,
    builder: (column) => column,
  );

  GeneratedColumn<int> get creativity => $composableBuilder(
    column: $table.creativity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get skinState =>
      $composableBuilder(column: $table.skinState, builder: (column) => column);

  GeneratedColumn<String> get bodyType =>
      $composableBuilder(column: $table.bodyType, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CharacterProfilesTableTableManager
    extends
        RootTableManager<
          _$LifeGachaDatabase,
          $CharacterProfilesTable,
          CharacterProfileRecord,
          $$CharacterProfilesTableFilterComposer,
          $$CharacterProfilesTableOrderingComposer,
          $$CharacterProfilesTableAnnotationComposer,
          $$CharacterProfilesTableCreateCompanionBuilder,
          $$CharacterProfilesTableUpdateCompanionBuilder,
          (
            CharacterProfileRecord,
            BaseReferences<
              _$LifeGachaDatabase,
              $CharacterProfilesTable,
              CharacterProfileRecord
            >,
          ),
          CharacterProfileRecord,
          PrefetchHooks Function()
        > {
  $$CharacterProfilesTableTableManager(
    _$LifeGachaDatabase db,
    $CharacterProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CharacterProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CharacterProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CharacterProfilesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<int> xp = const Value.absent(),
                Value<int> stamina = const Value.absent(),
                Value<int> intelligence = const Value.absent(),
                Value<int> discipline = const Value.absent(),
                Value<int> creativity = const Value.absent(),
                Value<String?> skinState = const Value.absent(),
                Value<String?> bodyType = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CharacterProfilesCompanion(
                id: id,
                name: name,
                level: level,
                xp: xp,
                stamina: stamina,
                intelligence: intelligence,
                discipline: discipline,
                creativity: creativity,
                skinState: skinState,
                bodyType: bodyType,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> name = const Value.absent(),
                required int level,
                required int xp,
                required int stamina,
                required int intelligence,
                required int discipline,
                required int creativity,
                Value<String?> skinState = const Value.absent(),
                Value<String?> bodyType = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CharacterProfilesCompanion.insert(
                id: id,
                name: name,
                level: level,
                xp: xp,
                stamina: stamina,
                intelligence: intelligence,
                discipline: discipline,
                creativity: creativity,
                skinState: skinState,
                bodyType: bodyType,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CharacterProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$LifeGachaDatabase,
      $CharacterProfilesTable,
      CharacterProfileRecord,
      $$CharacterProfilesTableFilterComposer,
      $$CharacterProfilesTableOrderingComposer,
      $$CharacterProfilesTableAnnotationComposer,
      $$CharacterProfilesTableCreateCompanionBuilder,
      $$CharacterProfilesTableUpdateCompanionBuilder,
      (
        CharacterProfileRecord,
        BaseReferences<
          _$LifeGachaDatabase,
          $CharacterProfilesTable,
          CharacterProfileRecord
        >,
      ),
      CharacterProfileRecord,
      PrefetchHooks Function()
    >;
typedef $$AchievementsTableCreateCompanionBuilder =
    AchievementsCompanion Function({
      required String id,
      required String achievementType,
      Value<DateTime?> unlockedAt,
      Value<int> progressCounter,
      Value<int> rowid,
    });
typedef $$AchievementsTableUpdateCompanionBuilder =
    AchievementsCompanion Function({
      Value<String> id,
      Value<String> achievementType,
      Value<DateTime?> unlockedAt,
      Value<int> progressCounter,
      Value<int> rowid,
    });

class $$AchievementsTableFilterComposer
    extends Composer<_$LifeGachaDatabase, $AchievementsTable> {
  $$AchievementsTableFilterComposer({
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

  ColumnFilters<String> get achievementType => $composableBuilder(
    column: $table.achievementType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get progressCounter => $composableBuilder(
    column: $table.progressCounter,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AchievementsTableOrderingComposer
    extends Composer<_$LifeGachaDatabase, $AchievementsTable> {
  $$AchievementsTableOrderingComposer({
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

  ColumnOrderings<String> get achievementType => $composableBuilder(
    column: $table.achievementType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get progressCounter => $composableBuilder(
    column: $table.progressCounter,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AchievementsTableAnnotationComposer
    extends Composer<_$LifeGachaDatabase, $AchievementsTable> {
  $$AchievementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get achievementType => $composableBuilder(
    column: $table.achievementType,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get progressCounter => $composableBuilder(
    column: $table.progressCounter,
    builder: (column) => column,
  );
}

class $$AchievementsTableTableManager
    extends
        RootTableManager<
          _$LifeGachaDatabase,
          $AchievementsTable,
          AchievementRecord,
          $$AchievementsTableFilterComposer,
          $$AchievementsTableOrderingComposer,
          $$AchievementsTableAnnotationComposer,
          $$AchievementsTableCreateCompanionBuilder,
          $$AchievementsTableUpdateCompanionBuilder,
          (
            AchievementRecord,
            BaseReferences<
              _$LifeGachaDatabase,
              $AchievementsTable,
              AchievementRecord
            >,
          ),
          AchievementRecord,
          PrefetchHooks Function()
        > {
  $$AchievementsTableTableManager(
    _$LifeGachaDatabase db,
    $AchievementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AchievementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AchievementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AchievementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> achievementType = const Value.absent(),
                Value<DateTime?> unlockedAt = const Value.absent(),
                Value<int> progressCounter = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AchievementsCompanion(
                id: id,
                achievementType: achievementType,
                unlockedAt: unlockedAt,
                progressCounter: progressCounter,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String achievementType,
                Value<DateTime?> unlockedAt = const Value.absent(),
                Value<int> progressCounter = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AchievementsCompanion.insert(
                id: id,
                achievementType: achievementType,
                unlockedAt: unlockedAt,
                progressCounter: progressCounter,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AchievementsTableProcessedTableManager =
    ProcessedTableManager<
      _$LifeGachaDatabase,
      $AchievementsTable,
      AchievementRecord,
      $$AchievementsTableFilterComposer,
      $$AchievementsTableOrderingComposer,
      $$AchievementsTableAnnotationComposer,
      $$AchievementsTableCreateCompanionBuilder,
      $$AchievementsTableUpdateCompanionBuilder,
      (
        AchievementRecord,
        BaseReferences<
          _$LifeGachaDatabase,
          $AchievementsTable,
          AchievementRecord
        >,
      ),
      AchievementRecord,
      PrefetchHooks Function()
    >;
typedef $$DailyStreaksTableCreateCompanionBuilder =
    DailyStreaksCompanion Function({
      required String id,
      Value<int> currentStreak,
      Value<int> bestStreak,
      Value<DateTime?> lastQualifiedDate,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$DailyStreaksTableUpdateCompanionBuilder =
    DailyStreaksCompanion Function({
      Value<String> id,
      Value<int> currentStreak,
      Value<int> bestStreak,
      Value<DateTime?> lastQualifiedDate,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$DailyStreaksTableFilterComposer
    extends Composer<_$LifeGachaDatabase, $DailyStreaksTable> {
  $$DailyStreaksTableFilterComposer({
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

  ColumnFilters<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bestStreak => $composableBuilder(
    column: $table.bestStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastQualifiedDate => $composableBuilder(
    column: $table.lastQualifiedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyStreaksTableOrderingComposer
    extends Composer<_$LifeGachaDatabase, $DailyStreaksTable> {
  $$DailyStreaksTableOrderingComposer({
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

  ColumnOrderings<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bestStreak => $composableBuilder(
    column: $table.bestStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastQualifiedDate => $composableBuilder(
    column: $table.lastQualifiedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyStreaksTableAnnotationComposer
    extends Composer<_$LifeGachaDatabase, $DailyStreaksTable> {
  $$DailyStreaksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bestStreak => $composableBuilder(
    column: $table.bestStreak,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastQualifiedDate => $composableBuilder(
    column: $table.lastQualifiedDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DailyStreaksTableTableManager
    extends
        RootTableManager<
          _$LifeGachaDatabase,
          $DailyStreaksTable,
          DailyStreakRecord,
          $$DailyStreaksTableFilterComposer,
          $$DailyStreaksTableOrderingComposer,
          $$DailyStreaksTableAnnotationComposer,
          $$DailyStreaksTableCreateCompanionBuilder,
          $$DailyStreaksTableUpdateCompanionBuilder,
          (
            DailyStreakRecord,
            BaseReferences<
              _$LifeGachaDatabase,
              $DailyStreaksTable,
              DailyStreakRecord
            >,
          ),
          DailyStreakRecord,
          PrefetchHooks Function()
        > {
  $$DailyStreaksTableTableManager(
    _$LifeGachaDatabase db,
    $DailyStreaksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyStreaksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyStreaksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyStreaksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> currentStreak = const Value.absent(),
                Value<int> bestStreak = const Value.absent(),
                Value<DateTime?> lastQualifiedDate = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyStreaksCompanion(
                id: id,
                currentStreak: currentStreak,
                bestStreak: bestStreak,
                lastQualifiedDate: lastQualifiedDate,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<int> currentStreak = const Value.absent(),
                Value<int> bestStreak = const Value.absent(),
                Value<DateTime?> lastQualifiedDate = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => DailyStreaksCompanion.insert(
                id: id,
                currentStreak: currentStreak,
                bestStreak: bestStreak,
                lastQualifiedDate: lastQualifiedDate,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyStreaksTableProcessedTableManager =
    ProcessedTableManager<
      _$LifeGachaDatabase,
      $DailyStreaksTable,
      DailyStreakRecord,
      $$DailyStreaksTableFilterComposer,
      $$DailyStreaksTableOrderingComposer,
      $$DailyStreaksTableAnnotationComposer,
      $$DailyStreaksTableCreateCompanionBuilder,
      $$DailyStreaksTableUpdateCompanionBuilder,
      (
        DailyStreakRecord,
        BaseReferences<
          _$LifeGachaDatabase,
          $DailyStreaksTable,
          DailyStreakRecord
        >,
      ),
      DailyStreakRecord,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$LifeGachaDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
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

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$LifeGachaDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
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

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$LifeGachaDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$LifeGachaDatabase,
          $AppSettingsTable,
          AppSettingRecord,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSettingRecord,
            BaseReferences<
              _$LifeGachaDatabase,
              $AppSettingsTable,
              AppSettingRecord
            >,
          ),
          AppSettingRecord,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(
    _$LifeGachaDatabase db,
    $AppSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$LifeGachaDatabase,
      $AppSettingsTable,
      AppSettingRecord,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSettingRecord,
        BaseReferences<
          _$LifeGachaDatabase,
          $AppSettingsTable,
          AppSettingRecord
        >,
      ),
      AppSettingRecord,
      PrefetchHooks Function()
    >;

class $LifeGachaDatabaseManager {
  final _$LifeGachaDatabase _db;
  $LifeGachaDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$FocusSessionsTableTableManager get focusSessions =>
      $$FocusSessionsTableTableManager(_db, _db.focusSessions);
  $$WalletLedgerTableTableManager get walletLedger =>
      $$WalletLedgerTableTableManager(_db, _db.walletLedger);
  $$RewardCardsTableTableManager get rewardCards =>
      $$RewardCardsTableTableManager(_db, _db.rewardCards);
  $$GachaDrawsTableTableManager get gachaDraws =>
      $$GachaDrawsTableTableManager(_db, _db.gachaDraws);
  $$CharacterProfilesTableTableManager get characterProfiles =>
      $$CharacterProfilesTableTableManager(_db, _db.characterProfiles);
  $$AchievementsTableTableManager get achievements =>
      $$AchievementsTableTableManager(_db, _db.achievements);
  $$DailyStreaksTableTableManager get dailyStreaks =>
      $$DailyStreaksTableTableManager(_db, _db.dailyStreaks);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
