// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CommunityID.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetCommunityIDCollection on Isar {
  IsarCollection<CommunityID> get communityIDs => this.collection();
}

const CommunityIDSchema = CollectionSchema(
  name: r'CommunityID',
  id: 5082505318590053175,
  properties: {
    r'CommunityId': PropertySchema(
      id: 0,
      name: r'CommunityId',
      type: IsarType.string,
    ),
    r'userID': PropertySchema(
      id: 1,
      name: r'userID',
      type: IsarType.string,
    )
  },
  estimateSize: _communityIDEstimateSize,
  serialize: _communityIDSerialize,
  deserialize: _communityIDDeserialize,
  deserializeProp: _communityIDDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _communityIDGetId,
  getLinks: _communityIDGetLinks,
  attach: _communityIDAttach,
  version: '3.0.5',
);

int _communityIDEstimateSize(
  CommunityID object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.CommunityId.length * 3;
  bytesCount += 3 + object.userID.length * 3;
  return bytesCount;
}

void _communityIDSerialize(
  CommunityID object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.CommunityId);
  writer.writeString(offsets[1], object.userID);
}

CommunityID _communityIDDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CommunityID(
    userID: reader.readString(offsets[1]),
  );
  object.CommunityId = reader.readString(offsets[0]);
  object.id = id;
  return object;
}

P _communityIDDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _communityIDGetId(CommunityID object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _communityIDGetLinks(CommunityID object) {
  return [];
}

void _communityIDAttach(
    IsarCollection<dynamic> col, Id id, CommunityID object) {
  object.id = id;
}

extension CommunityIDQueryWhereSort
    on QueryBuilder<CommunityID, CommunityID, QWhere> {
  QueryBuilder<CommunityID, CommunityID, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CommunityIDQueryWhere
    on QueryBuilder<CommunityID, CommunityID, QWhereClause> {
  QueryBuilder<CommunityID, CommunityID, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CommunityID, CommunityID, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<CommunityID, CommunityID, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CommunityID, CommunityID, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CommunityID, CommunityID, QAfterWhereClause> idBetween(
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

extension CommunityIDQueryFilter
    on QueryBuilder<CommunityID, CommunityID, QFilterCondition> {
  QueryBuilder<CommunityID, CommunityID, QAfterFilterCondition>
      communityIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'CommunityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommunityID, CommunityID, QAfterFilterCondition>
      communityIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'CommunityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommunityID, CommunityID, QAfterFilterCondition>
      communityIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'CommunityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommunityID, CommunityID, QAfterFilterCondition>
      communityIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'CommunityId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommunityID, CommunityID, QAfterFilterCondition>
      communityIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'CommunityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommunityID, CommunityID, QAfterFilterCondition>
      communityIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'CommunityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommunityID, CommunityID, QAfterFilterCondition>
      communityIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'CommunityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommunityID, CommunityID, QAfterFilterCondition>
      communityIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'CommunityId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommunityID, CommunityID, QAfterFilterCondition>
      communityIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'CommunityId',
        value: '',
      ));
    });
  }

  QueryBuilder<CommunityID, CommunityID, QAfterFilterCondition>
      communityIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'CommunityId',
        value: '',
      ));
    });
  }

  QueryBuilder<CommunityID, CommunityID, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CommunityID, CommunityID, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<CommunityID, CommunityID, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<CommunityID, CommunityID, QAfterFilterCondition> idBetween(
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

  QueryBuilder<CommunityID, CommunityID, QAfterFilterCondition> userIDEqualTo(
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

  QueryBuilder<CommunityID, CommunityID, QAfterFilterCondition>
      userIDGreaterThan(
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

  QueryBuilder<CommunityID, CommunityID, QAfterFilterCondition> userIDLessThan(
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

  QueryBuilder<CommunityID, CommunityID, QAfterFilterCondition> userIDBetween(
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

  QueryBuilder<CommunityID, CommunityID, QAfterFilterCondition>
      userIDStartsWith(
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

  QueryBuilder<CommunityID, CommunityID, QAfterFilterCondition> userIDEndsWith(
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

  QueryBuilder<CommunityID, CommunityID, QAfterFilterCondition> userIDContains(
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

  QueryBuilder<CommunityID, CommunityID, QAfterFilterCondition> userIDMatches(
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

  QueryBuilder<CommunityID, CommunityID, QAfterFilterCondition>
      userIDIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userID',
        value: '',
      ));
    });
  }

  QueryBuilder<CommunityID, CommunityID, QAfterFilterCondition>
      userIDIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userID',
        value: '',
      ));
    });
  }
}

extension CommunityIDQueryObject
    on QueryBuilder<CommunityID, CommunityID, QFilterCondition> {}

extension CommunityIDQueryLinks
    on QueryBuilder<CommunityID, CommunityID, QFilterCondition> {}

extension CommunityIDQuerySortBy
    on QueryBuilder<CommunityID, CommunityID, QSortBy> {
  QueryBuilder<CommunityID, CommunityID, QAfterSortBy> sortByCommunityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'CommunityId', Sort.asc);
    });
  }

  QueryBuilder<CommunityID, CommunityID, QAfterSortBy> sortByCommunityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'CommunityId', Sort.desc);
    });
  }

  QueryBuilder<CommunityID, CommunityID, QAfterSortBy> sortByUserID() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userID', Sort.asc);
    });
  }

  QueryBuilder<CommunityID, CommunityID, QAfterSortBy> sortByUserIDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userID', Sort.desc);
    });
  }
}

extension CommunityIDQuerySortThenBy
    on QueryBuilder<CommunityID, CommunityID, QSortThenBy> {
  QueryBuilder<CommunityID, CommunityID, QAfterSortBy> thenByCommunityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'CommunityId', Sort.asc);
    });
  }

  QueryBuilder<CommunityID, CommunityID, QAfterSortBy> thenByCommunityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'CommunityId', Sort.desc);
    });
  }

  QueryBuilder<CommunityID, CommunityID, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CommunityID, CommunityID, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CommunityID, CommunityID, QAfterSortBy> thenByUserID() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userID', Sort.asc);
    });
  }

  QueryBuilder<CommunityID, CommunityID, QAfterSortBy> thenByUserIDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userID', Sort.desc);
    });
  }
}

extension CommunityIDQueryWhereDistinct
    on QueryBuilder<CommunityID, CommunityID, QDistinct> {
  QueryBuilder<CommunityID, CommunityID, QDistinct> distinctByCommunityId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'CommunityId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CommunityID, CommunityID, QDistinct> distinctByUserID(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userID', caseSensitive: caseSensitive);
    });
  }
}

extension CommunityIDQueryProperty
    on QueryBuilder<CommunityID, CommunityID, QQueryProperty> {
  QueryBuilder<CommunityID, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CommunityID, String, QQueryOperations> CommunityIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'CommunityId');
    });
  }

  QueryBuilder<CommunityID, String, QQueryOperations> userIDProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userID');
    });
  }
}
