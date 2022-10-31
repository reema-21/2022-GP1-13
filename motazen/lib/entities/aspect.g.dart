// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aspect.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetAspectCollection on Isar {
  IsarCollection<Aspect> get aspects => this.collection();
}

const AspectSchema = CollectionSchema(
  name: r'Aspect',
  id: -736734253211991172,
  properties: {
    r'color': PropertySchema(
      id: 0,
      name: r'color',
      type: IsarType.long,
    ),
    r'isSelected': PropertySchema(
      id: 1,
      name: r'isSelected',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(
      id: 2,
      name: r'name',
      type: IsarType.string,
    ),
    r'percentagePoints': PropertySchema(
      id: 3,
      name: r'percentagePoints',
      type: IsarType.double,
    )
  },
  estimateSize: _aspectEstimateSize,
  serialize: _aspectSerialize,
  deserialize: _aspectDeserialize,
  deserializeProp: _aspectDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _aspectGetId,
  getLinks: _aspectGetLinks,
  attach: _aspectAttach,
  version: '3.0.2',
);

int _aspectEstimateSize(
  Aspect object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _aspectSerialize(
  Aspect object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.color);
  writer.writeBool(offsets[1], object.isSelected);
  writer.writeString(offsets[2], object.name);
  writer.writeDouble(offsets[3], object.percentagePoints);
}

Aspect _aspectDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Aspect();
  object.color = reader.readLong(offsets[0]);
  object.id = id;
  object.isSelected = reader.readBool(offsets[1]);
  object.name = reader.readString(offsets[2]);
  object.percentagePoints = reader.readDouble(offsets[3]);
  return object;
}

P _aspectDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _aspectGetId(Aspect object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _aspectGetLinks(Aspect object) {
  return [];
}

void _aspectAttach(IsarCollection<dynamic> col, Id id, Aspect object) {
  object.id = id;
}

extension AspectQueryWhereSort on QueryBuilder<Aspect, Aspect, QWhere> {
  QueryBuilder<Aspect, Aspect, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AspectQueryWhere on QueryBuilder<Aspect, Aspect, QWhereClause> {
  QueryBuilder<Aspect, Aspect, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Aspect, Aspect, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Aspect, Aspect, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Aspect, Aspect, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Aspect, Aspect, QAfterWhereClause> idBetween(
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

extension AspectQueryFilter on QueryBuilder<Aspect, Aspect, QFilterCondition> {
  QueryBuilder<Aspect, Aspect, QAfterFilterCondition> colorEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'color',
        value: value,
      ));
    });
  }

  QueryBuilder<Aspect, Aspect, QAfterFilterCondition> colorGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'color',
        value: value,
      ));
    });
  }

  QueryBuilder<Aspect, Aspect, QAfterFilterCondition> colorLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'color',
        value: value,
      ));
    });
  }

  QueryBuilder<Aspect, Aspect, QAfterFilterCondition> colorBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'color',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Aspect, Aspect, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Aspect, Aspect, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Aspect, Aspect, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Aspect, Aspect, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Aspect, Aspect, QAfterFilterCondition> isSelectedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSelected',
        value: value,
      ));
    });
  }

  QueryBuilder<Aspect, Aspect, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<Aspect, Aspect, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<Aspect, Aspect, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<Aspect, Aspect, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<Aspect, Aspect, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<Aspect, Aspect, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<Aspect, Aspect, QAfterFilterCondition> nameContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Aspect, Aspect, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<Aspect, Aspect, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Aspect, Aspect, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Aspect, Aspect, QAfterFilterCondition> percentagePointsEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'percentagePoints',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Aspect, Aspect, QAfterFilterCondition>
      percentagePointsGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'percentagePoints',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Aspect, Aspect, QAfterFilterCondition> percentagePointsLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'percentagePoints',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Aspect, Aspect, QAfterFilterCondition> percentagePointsBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'percentagePoints',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension AspectQueryObject on QueryBuilder<Aspect, Aspect, QFilterCondition> {}

extension AspectQueryLinks on QueryBuilder<Aspect, Aspect, QFilterCondition> {}

extension AspectQuerySortBy on QueryBuilder<Aspect, Aspect, QSortBy> {
  QueryBuilder<Aspect, Aspect, QAfterSortBy> sortByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.asc);
    });
  }

  QueryBuilder<Aspect, Aspect, QAfterSortBy> sortByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.desc);
    });
  }

  QueryBuilder<Aspect, Aspect, QAfterSortBy> sortByIsSelected() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSelected', Sort.asc);
    });
  }

  QueryBuilder<Aspect, Aspect, QAfterSortBy> sortByIsSelectedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSelected', Sort.desc);
    });
  }

  QueryBuilder<Aspect, Aspect, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Aspect, Aspect, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Aspect, Aspect, QAfterSortBy> sortByPercentagePoints() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentagePoints', Sort.asc);
    });
  }

  QueryBuilder<Aspect, Aspect, QAfterSortBy> sortByPercentagePointsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentagePoints', Sort.desc);
    });
  }
}

extension AspectQuerySortThenBy on QueryBuilder<Aspect, Aspect, QSortThenBy> {
  QueryBuilder<Aspect, Aspect, QAfterSortBy> thenByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.asc);
    });
  }

  QueryBuilder<Aspect, Aspect, QAfterSortBy> thenByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.desc);
    });
  }

  QueryBuilder<Aspect, Aspect, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Aspect, Aspect, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Aspect, Aspect, QAfterSortBy> thenByIsSelected() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSelected', Sort.asc);
    });
  }

  QueryBuilder<Aspect, Aspect, QAfterSortBy> thenByIsSelectedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSelected', Sort.desc);
    });
  }

  QueryBuilder<Aspect, Aspect, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Aspect, Aspect, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Aspect, Aspect, QAfterSortBy> thenByPercentagePoints() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentagePoints', Sort.asc);
    });
  }

  QueryBuilder<Aspect, Aspect, QAfterSortBy> thenByPercentagePointsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentagePoints', Sort.desc);
    });
  }
}

extension AspectQueryWhereDistinct on QueryBuilder<Aspect, Aspect, QDistinct> {
  QueryBuilder<Aspect, Aspect, QDistinct> distinctByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'color');
    });
  }

  QueryBuilder<Aspect, Aspect, QDistinct> distinctByIsSelected() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSelected');
    });
  }

  QueryBuilder<Aspect, Aspect, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Aspect, Aspect, QDistinct> distinctByPercentagePoints() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'percentagePoints');
    });
  }
}

extension AspectQueryProperty on QueryBuilder<Aspect, Aspect, QQueryProperty> {
  QueryBuilder<Aspect, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Aspect, int, QQueryOperations> colorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'color');
    });
  }

  QueryBuilder<Aspect, bool, QQueryOperations> isSelectedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSelected');
    });
  }

  QueryBuilder<Aspect, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Aspect, double, QQueryOperations> percentagePointsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'percentagePoints');
    });
  }
}
