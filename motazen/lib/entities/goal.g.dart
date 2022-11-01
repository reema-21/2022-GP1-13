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
    r'dueDate': PropertySchema(
      id: 1,
      name: r'dueDate',
      type: IsarType.dateTime,
    ),
    r'goalDuration': PropertySchema(
      id: 2,
      name: r'goalDuration',
      type: IsarType.long,
    ),
    r'importance': PropertySchema(
      id: 3,
      name: r'importance',
      type: IsarType.long,
    ),
    r'titel': PropertySchema(
      id: 4,
      name: r'titel',
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
    r'task': LinkSchema(
      id: 1307600547408402184,
      name: r'task',
      target: r'Task',
      single: true,
    ),
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
  return bytesCount;
}

void _goalSerialize(
  Goal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.DescriptiveGoalDuration);
  writer.writeDateTime(offsets[1], object.dueDate);
  writer.writeLong(offsets[2], object.goalDuration);
  writer.writeLong(offsets[3], object.importance);
  writer.writeString(offsets[4], object.titel);
}

Goal _goalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Goal();
  object.DescriptiveGoalDuration = reader.readString(offsets[0]);
  object.dueDate = reader.readDateTime(offsets[1]);
  object.goalDuration = reader.readLong(offsets[2]);
  object.id = id;
  object.importance = reader.readLong(offsets[3]);
  object.titel = reader.readString(offsets[4]);
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
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _goalGetId(Goal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _goalGetLinks(Goal object) {
  return [object.task, object.goalDependency, object.aspect];
}

void _goalAttach(IsarCollection<dynamic> col, Id id, Goal object) {
  object.id = id;
  object.task.attach(col, col.isar.collection<Task>(), r'task', id);
  object.goalDependency
      .attach(col, col.isar.collection<Goal>(), r'goalDependency', id);
  object.aspect.attach(col, col.isar.collection<Aspect>(), r'aspect', id);
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

  QueryBuilder<Goal, Goal, QAfterFilterCondition> dueDateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dueDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> dueDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dueDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> dueDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dueDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> dueDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dueDate',
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
}

extension GoalQueryObject on QueryBuilder<Goal, Goal, QFilterCondition> {}

extension GoalQueryLinks on QueryBuilder<Goal, Goal, QFilterCondition> {
  QueryBuilder<Goal, Goal, QAfterFilterCondition> task(FilterQuery<Task> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'task');
    });
  }

  QueryBuilder<Goal, Goal, QAfterFilterCondition> taskIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'task', 0, true, 0, true);
    });
  }

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

  QueryBuilder<Goal, Goal, QAfterSortBy> sortByDueDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dueDate', Sort.asc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> sortByDueDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dueDate', Sort.desc);
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

  QueryBuilder<Goal, Goal, QAfterSortBy> thenByDueDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dueDate', Sort.asc);
    });
  }

  QueryBuilder<Goal, Goal, QAfterSortBy> thenByDueDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dueDate', Sort.desc);
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
}

extension GoalQueryWhereDistinct on QueryBuilder<Goal, Goal, QDistinct> {
  QueryBuilder<Goal, Goal, QDistinct> distinctByDescriptiveGoalDuration(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'DescriptiveGoalDuration',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Goal, Goal, QDistinct> distinctByDueDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dueDate');
    });
  }

  QueryBuilder<Goal, Goal, QDistinct> distinctByGoalDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'goalDuration');
    });
  }

  QueryBuilder<Goal, Goal, QDistinct> distinctByImportance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'importance');
    });
  }

  QueryBuilder<Goal, Goal, QDistinct> distinctByTitel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'titel', caseSensitive: caseSensitive);
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

  QueryBuilder<Goal, DateTime, QQueryOperations> dueDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dueDate');
    });
  }

  QueryBuilder<Goal, int, QQueryOperations> goalDurationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'goalDuration');
    });
  }

  QueryBuilder<Goal, int, QQueryOperations> importanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'importance');
    });
  }

  QueryBuilder<Goal, String, QQueryOperations> titelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'titel');
    });
  }
}
