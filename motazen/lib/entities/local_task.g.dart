// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_task.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLocalTaskCollection on Isar {
  IsarCollection<LocalTask> get localTasks => this.collection();
}

const LocalTaskSchema = CollectionSchema(
  name: r'LocalTask',
  id: -2302952909969641796,
  properties: {
    r'amountCompleted': PropertySchema(
      id: 0,
      name: r'amountCompleted',
      type: IsarType.long,
    ),
    r'completedForToday': PropertySchema(
      id: 1,
      name: r'completedForToday',
      type: IsarType.bool,
    ),
    r'duration': PropertySchema(
      id: 2,
      name: r'duration',
      type: IsarType.long,
    ),
    r'durationDescribtion': PropertySchema(
      id: 3,
      name: r'durationDescribtion',
      type: IsarType.string,
    ),
    r'lastCompletionDate': PropertySchema(
      id: 4,
      name: r'lastCompletionDate',
      type: IsarType.dateTime,
    ),
    r'name': PropertySchema(
      id: 5,
      name: r'name',
      type: IsarType.string,
    ),
    r'rank': PropertySchema(
      id: 6,
      name: r'rank',
      type: IsarType.double,
    ),
    r'taskCompletionPercentage': PropertySchema(
      id: 7,
      name: r'taskCompletionPercentage',
      type: IsarType.double,
    ),
    r'userID': PropertySchema(
      id: 8,
      name: r'userID',
      type: IsarType.string,
    )
  },
  estimateSize: _localTaskEstimateSize,
  serialize: _localTaskSerialize,
  deserialize: _localTaskDeserialize,
  deserializeProp: _localTaskDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'taskDependency': LinkSchema(
      id: -645007614003360191,
      name: r'taskDependency',
      target: r'LocalTask',
      single: false,
    ),
    r'goal': LinkSchema(
      id: 3936554597141504948,
      name: r'goal',
      target: r'Goal',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _localTaskGetId,
  getLinks: _localTaskGetLinks,
  attach: _localTaskAttach,
  version: '3.1.0+1',
);

int _localTaskEstimateSize(
  LocalTask object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.durationDescribtion.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.userID.length * 3;
  return bytesCount;
}

void _localTaskSerialize(
  LocalTask object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.amountCompleted);
  writer.writeBool(offsets[1], object.completedForToday);
  writer.writeLong(offsets[2], object.duration);
  writer.writeString(offsets[3], object.durationDescribtion);
  writer.writeDateTime(offsets[4], object.lastCompletionDate);
  writer.writeString(offsets[5], object.name);
  writer.writeDouble(offsets[6], object.rank);
  writer.writeDouble(offsets[7], object.taskCompletionPercentage);
  writer.writeString(offsets[8], object.userID);
}

LocalTask _localTaskDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocalTask(
    userID: reader.readString(offsets[8]),
  );
  object.amountCompleted = reader.readLong(offsets[0]);
  object.completedForToday = reader.readBool(offsets[1]);
  object.duration = reader.readLong(offsets[2]);
  object.durationDescribtion = reader.readString(offsets[3]);
  object.id = id;
  object.lastCompletionDate = reader.readDateTimeOrNull(offsets[4]);
  object.name = reader.readString(offsets[5]);
  object.rank = reader.readDouble(offsets[6]);
  object.taskCompletionPercentage = reader.readDouble(offsets[7]);
  return object;
}

P _localTaskDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _localTaskGetId(LocalTask object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _localTaskGetLinks(LocalTask object) {
  return [object.taskDependency, object.goal];
}

void _localTaskAttach(IsarCollection<dynamic> col, Id id, LocalTask object) {
  object.id = id;
  object.taskDependency
      .attach(col, col.isar.collection<LocalTask>(), r'taskDependency', id);
  object.goal.attach(col, col.isar.collection<Goal>(), r'goal', id);
}

extension LocalTaskQueryWhereSort
    on QueryBuilder<LocalTask, LocalTask, QWhere> {
  QueryBuilder<LocalTask, LocalTask, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LocalTaskQueryWhere
    on QueryBuilder<LocalTask, LocalTask, QWhereClause> {
  QueryBuilder<LocalTask, LocalTask, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension LocalTaskQueryFilter
    on QueryBuilder<LocalTask, LocalTask, QFilterCondition> {
  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition>
      amountCompletedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amountCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition>
      amountCompletedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amountCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition>
      amountCompletedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amountCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition>
      amountCompletedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amountCompleted',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition>
      completedForTodayEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedForToday',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition> durationEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'duration',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition> durationGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'duration',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition> durationLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'duration',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition> durationBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'duration',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition>
      durationDescribtionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationDescribtion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition>
      durationDescribtionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationDescribtion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition>
      durationDescribtionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationDescribtion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition>
      durationDescribtionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationDescribtion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition>
      durationDescribtionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'durationDescribtion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition>
      durationDescribtionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'durationDescribtion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition>
      durationDescribtionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'durationDescribtion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition>
      durationDescribtionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'durationDescribtion',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition>
      durationDescribtionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationDescribtion',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition>
      durationDescribtionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'durationDescribtion',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition>
      lastCompletionDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastCompletionDate',
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition>
      lastCompletionDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastCompletionDate',
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition>
      lastCompletionDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastCompletionDate',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition>
      lastCompletionDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastCompletionDate',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition>
      lastCompletionDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastCompletionDate',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition>
      lastCompletionDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastCompletionDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition> rankEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rank',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition> rankGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rank',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition> rankLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rank',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition> rankBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rank',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition>
      taskCompletionPercentageEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskCompletionPercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition>
      taskCompletionPercentageGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taskCompletionPercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition>
      taskCompletionPercentageLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taskCompletionPercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition>
      taskCompletionPercentageBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taskCompletionPercentage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition> userIDEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition> userIDGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition> userIDLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition> userIDBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userID',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition> userIDStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition> userIDEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition> userIDContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition> userIDMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userID',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition> userIDIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userID',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition> userIDIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userID',
        value: '',
      ));
    });
  }
}

extension LocalTaskQueryObject
    on QueryBuilder<LocalTask, LocalTask, QFilterCondition> {}

extension LocalTaskQueryLinks
    on QueryBuilder<LocalTask, LocalTask, QFilterCondition> {
  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition> taskDependency(
      FilterQuery<LocalTask> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'taskDependency');
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition>
      taskDependencyLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'taskDependency', length, true, length, true);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition>
      taskDependencyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'taskDependency', 0, true, 0, true);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition>
      taskDependencyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'taskDependency', 0, false, 999999, true);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition>
      taskDependencyLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'taskDependency', 0, true, length, include);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition>
      taskDependencyLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'taskDependency', length, include, 999999, true);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition>
      taskDependencyLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'taskDependency', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition> goal(
      FilterQuery<Goal> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'goal');
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterFilterCondition> goalIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'goal', 0, true, 0, true);
    });
  }
}

extension LocalTaskQuerySortBy on QueryBuilder<LocalTask, LocalTask, QSortBy> {
  QueryBuilder<LocalTask, LocalTask, QAfterSortBy> sortByAmountCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountCompleted', Sort.asc);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterSortBy> sortByAmountCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountCompleted', Sort.desc);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterSortBy> sortByCompletedForToday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedForToday', Sort.asc);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterSortBy>
      sortByCompletedForTodayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedForToday', Sort.desc);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterSortBy> sortByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.asc);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterSortBy> sortByDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.desc);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterSortBy> sortByDurationDescribtion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationDescribtion', Sort.asc);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterSortBy>
      sortByDurationDescribtionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationDescribtion', Sort.desc);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterSortBy> sortByLastCompletionDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompletionDate', Sort.asc);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterSortBy>
      sortByLastCompletionDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompletionDate', Sort.desc);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterSortBy> sortByRank() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rank', Sort.asc);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterSortBy> sortByRankDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rank', Sort.desc);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterSortBy>
      sortByTaskCompletionPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskCompletionPercentage', Sort.asc);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterSortBy>
      sortByTaskCompletionPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskCompletionPercentage', Sort.desc);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterSortBy> sortByUserID() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userID', Sort.asc);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterSortBy> sortByUserIDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userID', Sort.desc);
    });
  }
}

extension LocalTaskQuerySortThenBy
    on QueryBuilder<LocalTask, LocalTask, QSortThenBy> {
  QueryBuilder<LocalTask, LocalTask, QAfterSortBy> thenByAmountCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountCompleted', Sort.asc);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterSortBy> thenByAmountCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountCompleted', Sort.desc);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterSortBy> thenByCompletedForToday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedForToday', Sort.asc);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterSortBy>
      thenByCompletedForTodayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedForToday', Sort.desc);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterSortBy> thenByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.asc);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterSortBy> thenByDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.desc);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterSortBy> thenByDurationDescribtion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationDescribtion', Sort.asc);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterSortBy>
      thenByDurationDescribtionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationDescribtion', Sort.desc);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterSortBy> thenByLastCompletionDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompletionDate', Sort.asc);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterSortBy>
      thenByLastCompletionDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompletionDate', Sort.desc);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterSortBy> thenByRank() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rank', Sort.asc);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterSortBy> thenByRankDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rank', Sort.desc);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterSortBy>
      thenByTaskCompletionPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskCompletionPercentage', Sort.asc);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterSortBy>
      thenByTaskCompletionPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskCompletionPercentage', Sort.desc);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterSortBy> thenByUserID() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userID', Sort.asc);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QAfterSortBy> thenByUserIDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userID', Sort.desc);
    });
  }
}

extension LocalTaskQueryWhereDistinct
    on QueryBuilder<LocalTask, LocalTask, QDistinct> {
  QueryBuilder<LocalTask, LocalTask, QDistinct> distinctByAmountCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amountCompleted');
    });
  }

  QueryBuilder<LocalTask, LocalTask, QDistinct> distinctByCompletedForToday() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedForToday');
    });
  }

  QueryBuilder<LocalTask, LocalTask, QDistinct> distinctByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'duration');
    });
  }

  QueryBuilder<LocalTask, LocalTask, QDistinct> distinctByDurationDescribtion(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationDescribtion',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QDistinct> distinctByLastCompletionDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastCompletionDate');
    });
  }

  QueryBuilder<LocalTask, LocalTask, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalTask, LocalTask, QDistinct> distinctByRank() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rank');
    });
  }

  QueryBuilder<LocalTask, LocalTask, QDistinct>
      distinctByTaskCompletionPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taskCompletionPercentage');
    });
  }

  QueryBuilder<LocalTask, LocalTask, QDistinct> distinctByUserID(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userID', caseSensitive: caseSensitive);
    });
  }
}

extension LocalTaskQueryProperty
    on QueryBuilder<LocalTask, LocalTask, QQueryProperty> {
  QueryBuilder<LocalTask, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LocalTask, int, QQueryOperations> amountCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amountCompleted');
    });
  }

  QueryBuilder<LocalTask, bool, QQueryOperations> completedForTodayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedForToday');
    });
  }

  QueryBuilder<LocalTask, int, QQueryOperations> durationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'duration');
    });
  }

  QueryBuilder<LocalTask, String, QQueryOperations>
      durationDescribtionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationDescribtion');
    });
  }

  QueryBuilder<LocalTask, DateTime?, QQueryOperations>
      lastCompletionDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastCompletionDate');
    });
  }

  QueryBuilder<LocalTask, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<LocalTask, double, QQueryOperations> rankProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rank');
    });
  }

  QueryBuilder<LocalTask, double, QQueryOperations>
      taskCompletionPercentageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taskCompletionPercentage');
    });
  }

  QueryBuilder<LocalTask, String, QQueryOperations> userIDProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userID');
    });
  }
}
