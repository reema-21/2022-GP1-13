// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetGoalCollection on Isar {
  IsarCollection<Goal> get goals => this.collection();
}

const GoalSchema = CollectionSchema(
  name: r'Goal',
  id: 4693499363663894908,
  properties: {
    r'DescriptiveGoalDuration': PropertySchema(
      id: 0,
      name: r'DescriptiveGoalDuration',
      type: IsarType.string,
    ),
    r'endDate': PropertySchema(
      id: 1,
      name: r'endDate',
      type: IsarType.dateTime,
    ),
    r'goalDuration': PropertySchema(
      id: 2,
      name: r'goalDuration',
      type: IsarType.long,
    ),
    r'goalProgressPercentage': PropertySchema(
      id: 3,
      name: r'goalProgressPercentage',
      type: IsarType.double,
    ),
    r'importance': PropertySchema(
      id: 4,
      name: r'importance',
      type: IsarType.long,
    ),
    r'startData': PropertySchema(
      id: 5,
      name: r'startData',
      type: IsarType.dateTime,
    ),
    r'titel': PropertySchema(
      id: 6,
      name: r'titel',
      type: IsarType.string,
    ),
    r'userID': PropertySchema(
      id: 7,
      name: r'userID',
      type: IsarType.string,
    )
  },
  estimateSize: _goalEstimateSize,
  serialize: _goalSerialize,
  deserialize: _goalDeserialize,
  deserializeProp: _goalDeserializeProp,
  idName: r'id',
  indexes: {
    r'importance': IndexSchema(
      id: 7482907954609298545,
      name: r'importance',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'importance',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {
    r'goalDependency': LinkSchema(
      id: 3154268426504510286,
      name: r'goalDependency',
      target: r'Goal',
      single: true,
    ),
    r'aspect': LinkSchema(
      id: 4586871702802348301,
      name: r'aspect',
      target: r'Aspect',
      single: true,
    ),
    r'task': LinkSchema(
      id: 1307600547408402184,
      name: r'task',
      target: r'LocalTask',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _goalGetId,
  getLinks: _goalGetLinks,
  attach: _goalAttach,
  version: '3.0.2',
);

int _goalEstimateSize(
  Goal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.DescriptiveGoalDuration.length * 3;
  bytesCount += 3 + object.titel.length * 3;
  bytesCount += 3 + object.userID.length * 3;
  return bytesCount;
}

void _goalSerialize(
  Goal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.DescriptiveGoalDuration);
  writer.writeDateTime(offsets[1], object.endDate);
  writer.writeLong(offsets[2], object.goalDuration);
  writer.writeDouble(offsets[3], object.goalProgressPercentage);
  writer.writeLong(offsets[4], object.importance);
  writer.writeDateTime(offsets[5], object.startData);
  writer.writeString(offsets[6], object.titel);
  writer.writeString(offsets[7], object.userID);
}

Goal _goalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Goal(
    userID: reader.readString(offsets[7]),
  );
  object.DescriptiveGoalDuration = reader.readString(offsets[0]);
  object.endDate = reader.readDateTime(offsets[1]);
  object.goalDuration = reader.readLong(offsets[2]);
  object.goalProgressPercentage = reader.readDouble(offsets[3]);
  object.id = id;
  object.importance = reader.readLong(offsets[4]);
  object.startData = reader.readDateTime(offsets[5]);
  object.titel = reader.readString(offsets[6]);
  return object;
}

P _goalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _goalGetId(Goal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _goalGetLinks(Goal object) {
  return [object.goalDependency, object.aspect, object.task];
}

void _goalAttach(IsarCollection<dynamic> col, Id id, Goal object) {
  object.id = id;
  object.goalDependency
      .attach(col, col.isar.collection<Goal>(), r'goalDependency', id);
  object.aspect.attach(col, col.isar.collection<Aspect>(), r'aspect', id);
  object.task.attach(col, col.isar.collection<LocalTask>(), r'task', id);
}

extension GoalQueryWhereSort on QueryBuilder<Goal, Goal, QWhere> {
  QueryBuilder<Goal, Goal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Goal, Goal, QAfterWhere> anyImportance() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'importance'),
      );
    });
  }
}

extension GoalQueryWhere on QueryBuilder<Goal, Goal, QWhereClause> {
  QueryBuilder<Goal, Goal, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Goal, Goal, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Goal, Goal, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Goal, Goal, QAfterWhereClause> idBetween(
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

  QueryBuilder<Goal, Goal, QAfterWhereClause> importanceEqualTo(
      int importance) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'importance',
        value: [importance],
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterWhereClause> importanceNotEqualTo(
      int importance) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'importance',
              lower: [],
              upper: [importance],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'importance',
              lower: [importance],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'importance',
              lower: [importance],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'importance',
              lower: [],
              upper: [importance],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Goal, Goal, QAfterWhereClause> importanceGreaterThan(
    int importance, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'importance',
        lower: [importance],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterWhereClause> importanceLessThan(
    int importance, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'importance',
        lower: [],
        upper: [importance],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterWhereClause> importanceBetween(
    int lowerImportance,
    int upperImportance, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'importance',
        lower: [lowerImportance],
        includeLower: includeLower,
        upper: [upperImportance],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension GoalQueryFilter on QueryBuilder<Goal, Goal, QFilterCondition> {
  QueryBuilder<Goal, Goal, QAfterFilterCondition>
      descriptiveGoalDurationEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'DescriptiveGoalDuration',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition>
      descriptiveGoalDurationGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'DescriptiveGoalDuration',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition>
      descriptiveGoalDurationLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'DescriptiveGoalDuration',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition>
      descriptiveGoalDurationBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'DescriptiveGoalDuration',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition>
      descriptiveGoalDurationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'DescriptiveGoalDuration',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition>
      descriptiveGoalDurationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'DescriptiveGoalDuration',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition>
      descriptiveGoalDurationContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'DescriptiveGoalDuration',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition>
      descriptiveGoalDurationMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'DescriptiveGoalDuration',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition>
      descriptiveGoalDurationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'DescriptiveGoalDuration',
        value: '',
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition>
      descriptiveGoalDurationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'DescriptiveGoalDuration',
        value: '',
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> endDateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> endDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> endDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> endDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> goalDurationEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'goalDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> goalDurationGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'goalDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> goalDurationLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'goalDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> goalDurationBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'goalDuration',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> goalProgressPercentageEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'goalProgressPercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition>
      goalProgressPercentageGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'goalProgressPercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition>
      goalProgressPercentageLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'goalProgressPercentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> goalProgressPercentageBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'goalProgressPercentage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Goal, Goal, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Goal, Goal, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Goal, Goal, QAfterFilterCondition> importanceEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'importance',
        value: value,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> importanceGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'importance',
        value: value,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> importanceLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'importance',
        value: value,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> importanceBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'importance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> startDataEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startData',
        value: value,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> startDataGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startData',
        value: value,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> startDataLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startData',
        value: value,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> startDataBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startData',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> titelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'titel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> titelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'titel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> titelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'titel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> titelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'titel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> titelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'titel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> titelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'titel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> titelContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'titel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> titelMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'titel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> titelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'titel',
        value: '',
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> titelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'titel',
        value: '',
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> userIDEqualTo(
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

  QueryBuilder<Goal, Goal, QAfterFilterCondition> userIDGreaterThan(
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

  QueryBuilder<Goal, Goal, QAfterFilterCondition> userIDLessThan(
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

  QueryBuilder<Goal, Goal, QAfterFilterCondition> userIDBetween(
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

  QueryBuilder<Goal, Goal, QAfterFilterCondition> userIDStartsWith(
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

  QueryBuilder<Goal, Goal, QAfterFilterCondition> userIDEndsWith(
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

  QueryBuilder<Goal, Goal, QAfterFilterCondition> userIDContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> userIDMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userID',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> userIDIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userID',
        value: '',
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> userIDIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userID',
        value: '',
      ));
    });
  }
}

extension GoalQueryObject on QueryBuilder<Goal, Goal, QFilterCondition> {}

extension GoalQueryLinks on QueryBuilder<Goal, Goal, QFilterCondition> {
  QueryBuilder<Goal, Goal, QAfterFilterCondition> goalDependency(
      FilterQuery<Goal> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'goalDependency');
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> goalDependencyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'goalDependency', 0, true, 0, true);
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> aspect(
      FilterQuery<Aspect> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'aspect');
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> aspectIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'aspect', 0, true, 0, true);
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> task(
      FilterQuery<LocalTask> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'task');
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> taskLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'task', length, true, length, true);
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> taskIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'task', 0, true, 0, true);
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> taskIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'task', 0, false, 999999, true);
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> taskLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'task', 0, true, length, include);
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> taskLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'task', length, include, 999999, true);
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> taskLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'task', lower, includeLower, upper, includeUpper);
    });
  }
}

extension GoalQuerySortBy on QueryBuilder<Goal, Goal, QSortBy> {
  QueryBuilder<Goal, Goal, QAfterSortBy> sortByDescriptiveGoalDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'DescriptiveGoalDuration', Sort.asc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> sortByDescriptiveGoalDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'DescriptiveGoalDuration', Sort.desc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> sortByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.asc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> sortByEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.desc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> sortByGoalDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalDuration', Sort.asc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> sortByGoalDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalDuration', Sort.desc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> sortByGoalProgressPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalProgressPercentage', Sort.asc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> sortByGoalProgressPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalProgressPercentage', Sort.desc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> sortByImportance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'importance', Sort.asc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> sortByImportanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'importance', Sort.desc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> sortByStartData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startData', Sort.asc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> sortByStartDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startData', Sort.desc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> sortByTitel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titel', Sort.asc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> sortByTitelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titel', Sort.desc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> sortByUserID() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userID', Sort.asc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> sortByUserIDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userID', Sort.desc);
    });
  }
}

extension GoalQuerySortThenBy on QueryBuilder<Goal, Goal, QSortThenBy> {
  QueryBuilder<Goal, Goal, QAfterSortBy> thenByDescriptiveGoalDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'DescriptiveGoalDuration', Sort.asc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> thenByDescriptiveGoalDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'DescriptiveGoalDuration', Sort.desc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> thenByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.asc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> thenByEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.desc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> thenByGoalDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalDuration', Sort.asc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> thenByGoalDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalDuration', Sort.desc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> thenByGoalProgressPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalProgressPercentage', Sort.asc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> thenByGoalProgressPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalProgressPercentage', Sort.desc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> thenByImportance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'importance', Sort.asc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> thenByImportanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'importance', Sort.desc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> thenByStartData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startData', Sort.asc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> thenByStartDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startData', Sort.desc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> thenByTitel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titel', Sort.asc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> thenByTitelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titel', Sort.desc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> thenByUserID() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userID', Sort.asc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> thenByUserIDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userID', Sort.desc);
    });
  }
}

extension GoalQueryWhereDistinct on QueryBuilder<Goal, Goal, QDistinct> {
  QueryBuilder<Goal, Goal, QDistinct> distinctByDescriptiveGoalDuration(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'DescriptiveGoalDuration',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Goal, Goal, QDistinct> distinctByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endDate');
    });
  }

  QueryBuilder<Goal, Goal, QDistinct> distinctByGoalDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'goalDuration');
    });
  }

  QueryBuilder<Goal, Goal, QDistinct> distinctByGoalProgressPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'goalProgressPercentage');
    });
  }

  QueryBuilder<Goal, Goal, QDistinct> distinctByImportance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'importance');
    });
  }

  QueryBuilder<Goal, Goal, QDistinct> distinctByStartData() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startData');
    });
  }

  QueryBuilder<Goal, Goal, QDistinct> distinctByTitel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'titel', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Goal, Goal, QDistinct> distinctByUserID(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userID', caseSensitive: caseSensitive);
    });
  }
}

extension GoalQueryProperty on QueryBuilder<Goal, Goal, QQueryProperty> {
  QueryBuilder<Goal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Goal, String, QQueryOperations>
      DescriptiveGoalDurationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'DescriptiveGoalDuration');
    });
  }

  QueryBuilder<Goal, DateTime, QQueryOperations> endDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endDate');
    });
  }

  QueryBuilder<Goal, int, QQueryOperations> goalDurationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'goalDuration');
    });
  }

  QueryBuilder<Goal, double, QQueryOperations>
      goalProgressPercentageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'goalProgressPercentage');
    });
  }

  QueryBuilder<Goal, int, QQueryOperations> importanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'importance');
    });
  }

  QueryBuilder<Goal, DateTime, QQueryOperations> startDataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startData');
    });
  }

  QueryBuilder<Goal, String, QQueryOperations> titelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'titel');
    });
  }

  QueryBuilder<Goal, String, QQueryOperations> userIDProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userID');
    });
  }
}
