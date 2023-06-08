// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHabitCollection on Isar {
  IsarCollection<Habit> get habits => this.collection();
}

const HabitSchema = CollectionSchema(
  name: r'Habit',
  id: 3896650575830519340,
  properties: {
    r'completedForToday': PropertySchema(
      id: 0,
      name: r'completedForToday',
      type: IsarType.bool,
    ),
    r'durationInNumber': PropertySchema(
      id: 1,
      name: r'durationInNumber',
      type: IsarType.long,
    ),
    r'durationIndString': PropertySchema(
      id: 2,
      name: r'durationIndString',
      type: IsarType.long,
    ),
    r'frequency': PropertySchema(
      id: 3,
      name: r'frequency',
      type: IsarType.string,
    ),
    r'titel': PropertySchema(
      id: 4,
      name: r'titel',
      type: IsarType.string,
    ),
    r'userID': PropertySchema(
      id: 5,
      name: r'userID',
      type: IsarType.string,
    )
  },
  estimateSize: _habitEstimateSize,
  serialize: _habitSerialize,
  deserialize: _habitDeserialize,
  deserializeProp: _habitDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'aspect': LinkSchema(
      id: 2255526401914356842,
      name: r'aspect',
      target: r'Aspect',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _habitGetId,
  getLinks: _habitGetLinks,
  attach: _habitAttach,
  version: '3.1.0+1',
);

int _habitEstimateSize(
  Habit object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.frequency.length * 3;
  bytesCount += 3 + object.titel.length * 3;
  bytesCount += 3 + object.userID.length * 3;
  return bytesCount;
}

void _habitSerialize(
  Habit object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.completedForToday);
  writer.writeLong(offsets[1], object.durationInNumber);
  writer.writeLong(offsets[2], object.durationIndString);
  writer.writeString(offsets[3], object.frequency);
  writer.writeString(offsets[4], object.titel);
  writer.writeString(offsets[5], object.userID);
}

Habit _habitDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Habit(
    userID: reader.readString(offsets[5]),
  );
  object.completedForToday = reader.readBool(offsets[0]);
  object.durationInNumber = reader.readLong(offsets[1]);
  object.durationIndString = reader.readLong(offsets[2]);
  object.frequency = reader.readString(offsets[3]);
  object.id = id;
  object.titel = reader.readString(offsets[4]);
  return object;
}

P _habitDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _habitGetId(Habit object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _habitGetLinks(Habit object) {
  return [object.aspect];
}

void _habitAttach(IsarCollection<dynamic> col, Id id, Habit object) {
  object.id = id;
  object.aspect.attach(col, col.isar.collection<Aspect>(), r'aspect', id);
}

extension HabitQueryWhereSort on QueryBuilder<Habit, Habit, QWhere> {
  QueryBuilder<Habit, Habit, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension HabitQueryWhere on QueryBuilder<Habit, Habit, QWhereClause> {
  QueryBuilder<Habit, Habit, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Habit, Habit, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterWhereClause> idBetween(
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

extension HabitQueryFilter on QueryBuilder<Habit, Habit, QFilterCondition> {
  QueryBuilder<Habit, Habit, QAfterFilterCondition> completedForTodayEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedForToday',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> durationInNumberEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationInNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> durationInNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationInNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> durationInNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationInNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> durationInNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationInNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> durationIndStringEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationIndString',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition>
      durationIndStringGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationIndString',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> durationIndStringLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationIndString',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> durationIndStringBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationIndString',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> frequencyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'frequency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> frequencyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'frequency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> frequencyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'frequency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> frequencyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'frequency',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> frequencyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'frequency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> frequencyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'frequency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> frequencyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'frequency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> frequencyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'frequency',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> frequencyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'frequency',
        value: '',
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> frequencyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'frequency',
        value: '',
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Habit, Habit, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Habit, Habit, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Habit, Habit, QAfterFilterCondition> titelEqualTo(
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

  QueryBuilder<Habit, Habit, QAfterFilterCondition> titelGreaterThan(
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

  QueryBuilder<Habit, Habit, QAfterFilterCondition> titelLessThan(
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

  QueryBuilder<Habit, Habit, QAfterFilterCondition> titelBetween(
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

  QueryBuilder<Habit, Habit, QAfterFilterCondition> titelStartsWith(
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

  QueryBuilder<Habit, Habit, QAfterFilterCondition> titelEndsWith(
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

  QueryBuilder<Habit, Habit, QAfterFilterCondition> titelContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'titel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> titelMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'titel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> titelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'titel',
        value: '',
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> titelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'titel',
        value: '',
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> userIDEqualTo(
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

  QueryBuilder<Habit, Habit, QAfterFilterCondition> userIDGreaterThan(
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

  QueryBuilder<Habit, Habit, QAfterFilterCondition> userIDLessThan(
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

  QueryBuilder<Habit, Habit, QAfterFilterCondition> userIDBetween(
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

  QueryBuilder<Habit, Habit, QAfterFilterCondition> userIDStartsWith(
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

  QueryBuilder<Habit, Habit, QAfterFilterCondition> userIDEndsWith(
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

  QueryBuilder<Habit, Habit, QAfterFilterCondition> userIDContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> userIDMatches(
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

  QueryBuilder<Habit, Habit, QAfterFilterCondition> userIDIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userID',
        value: '',
      ));
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> userIDIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userID',
        value: '',
      ));
    });
  }
}

extension HabitQueryObject on QueryBuilder<Habit, Habit, QFilterCondition> {}

extension HabitQueryLinks on QueryBuilder<Habit, Habit, QFilterCondition> {
  QueryBuilder<Habit, Habit, QAfterFilterCondition> aspect(
      FilterQuery<Aspect> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'aspect');
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> aspectIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'aspect', 0, true, 0, true);
    });
  }
}

extension HabitQuerySortBy on QueryBuilder<Habit, Habit, QSortBy> {
  QueryBuilder<Habit, Habit, QAfterSortBy> sortByCompletedForToday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedForToday', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByCompletedForTodayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedForToday', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByDurationInNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInNumber', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByDurationInNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInNumber', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByDurationIndString() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationIndString', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByDurationIndStringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationIndString', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequency', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequency', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByTitel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titel', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByTitelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titel', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByUserID() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userID', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByUserIDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userID', Sort.desc);
    });
  }
}

extension HabitQuerySortThenBy on QueryBuilder<Habit, Habit, QSortThenBy> {
  QueryBuilder<Habit, Habit, QAfterSortBy> thenByCompletedForToday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedForToday', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByCompletedForTodayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedForToday', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByDurationInNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInNumber', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByDurationInNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInNumber', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByDurationIndString() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationIndString', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByDurationIndStringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationIndString', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequency', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequency', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByTitel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titel', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByTitelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titel', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByUserID() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userID', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByUserIDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userID', Sort.desc);
    });
  }
}

extension HabitQueryWhereDistinct on QueryBuilder<Habit, Habit, QDistinct> {
  QueryBuilder<Habit, Habit, QDistinct> distinctByCompletedForToday() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedForToday');
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctByDurationInNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationInNumber');
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctByDurationIndString() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationIndString');
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctByFrequency(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'frequency', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctByTitel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'titel', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctByUserID(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userID', caseSensitive: caseSensitive);
    });
  }
}

extension HabitQueryProperty on QueryBuilder<Habit, Habit, QQueryProperty> {
  QueryBuilder<Habit, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Habit, bool, QQueryOperations> completedForTodayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedForToday');
    });
  }

  QueryBuilder<Habit, int, QQueryOperations> durationInNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationInNumber');
    });
  }

  QueryBuilder<Habit, int, QQueryOperations> durationIndStringProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationIndString');
    });
  }

  QueryBuilder<Habit, String, QQueryOperations> frequencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'frequency');
    });
  }

  QueryBuilder<Habit, String, QQueryOperations> titelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'titel');
    });
  }

  QueryBuilder<Habit, String, QQueryOperations> userIDProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userID');
    });
  }
}
