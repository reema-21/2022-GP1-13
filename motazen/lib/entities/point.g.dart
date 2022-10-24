// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetPointCollection on Isar {
  IsarCollection<Point> get points => this.collection();
}

const PointSchema = CollectionSchema(
  name: r'Point',
  id: -1948583515862884236,
  properties: {
    r'finalValues': PropertySchema(
      id: 0,
      name: r'finalValues',
      type: IsarType.double,
    )
  },
  estimateSize: _pointEstimateSize,
  serialize: _pointSerialize,
  deserialize: _pointDeserialize,
  deserializeProp: _pointDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'aspect': LinkSchema(
      id: -2822999210665073060,
      name: r'aspect',
      target: r'Aspect',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _pointGetId,
  getLinks: _pointGetLinks,
  attach: _pointAttach,
  version: '3.0.2',
);

int _pointEstimateSize(
  Point object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _pointSerialize(
  Point object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.finalValues);
}

Point _pointDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Point();
  object.finalValues = reader.readDouble(offsets[0]);
  object.id = id;
  return object;
}

P _pointDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _pointGetId(Point object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _pointGetLinks(Point object) {
  return [object.aspect];
}

void _pointAttach(IsarCollection<dynamic> col, Id id, Point object) {
  object.id = id;
  object.aspect.attach(col, col.isar.collection<Aspect>(), r'aspect', id);
}

extension PointQueryWhereSort on QueryBuilder<Point, Point, QWhere> {
  QueryBuilder<Point, Point, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PointQueryWhere on QueryBuilder<Point, Point, QWhereClause> {
  QueryBuilder<Point, Point, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Point, Point, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Point, Point, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Point, Point, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Point, Point, QAfterWhereClause> idBetween(
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

extension PointQueryFilter on QueryBuilder<Point, Point, QFilterCondition> {
  QueryBuilder<Point, Point, QAfterFilterCondition> finalValuesEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'finalValues',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Point, Point, QAfterFilterCondition> finalValuesGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'finalValues',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Point, Point, QAfterFilterCondition> finalValuesLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'finalValues',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Point, Point, QAfterFilterCondition> finalValuesBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'finalValues',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Point, Point, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Point, Point, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Point, Point, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Point, Point, QAfterFilterCondition> idBetween(
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
}

extension PointQueryObject on QueryBuilder<Point, Point, QFilterCondition> {}

extension PointQueryLinks on QueryBuilder<Point, Point, QFilterCondition> {
  QueryBuilder<Point, Point, QAfterFilterCondition> aspect(
      FilterQuery<Aspect> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'aspect');
    });
  }

  QueryBuilder<Point, Point, QAfterFilterCondition> aspectIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'aspect', 0, true, 0, true);
    });
  }
}

extension PointQuerySortBy on QueryBuilder<Point, Point, QSortBy> {
  QueryBuilder<Point, Point, QAfterSortBy> sortByFinalValues() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalValues', Sort.asc);
    });
  }

  QueryBuilder<Point, Point, QAfterSortBy> sortByFinalValuesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalValues', Sort.desc);
    });
  }
}

extension PointQuerySortThenBy on QueryBuilder<Point, Point, QSortThenBy> {
  QueryBuilder<Point, Point, QAfterSortBy> thenByFinalValues() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalValues', Sort.asc);
    });
  }

  QueryBuilder<Point, Point, QAfterSortBy> thenByFinalValuesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalValues', Sort.desc);
    });
  }

  QueryBuilder<Point, Point, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Point, Point, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension PointQueryWhereDistinct on QueryBuilder<Point, Point, QDistinct> {
  QueryBuilder<Point, Point, QDistinct> distinctByFinalValues() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'finalValues');
    });
  }
}

extension PointQueryProperty on QueryBuilder<Point, Point, QQueryProperty> {
  QueryBuilder<Point, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Point, double, QQueryOperations> finalValuesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'finalValues');
    });
  }
}
