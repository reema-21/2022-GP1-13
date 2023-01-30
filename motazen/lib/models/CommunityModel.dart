// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/foundation.dart';

class CommunityModel {
  String communityName;
  String founderUsername;
  String aspect;
  String goalName;
  bool isPrivate;
  String creationDate;
  String id;
  String creatorId;
  List<String> joinedUserIds;
  CommunityModel({
    required this.communityName,
    required this.founderUsername,
    required this.aspect,
    required this.goalName,
    required this.isPrivate,
    required this.creationDate,
    required this.id,
    required this.creatorId,
    required this.joinedUserIds,
  });

  CommunityModel copyWith({
    String? communityName,
    String? founderUsername,
    String? aspect,
    String? goalName,
    bool? isPrivate,
    String? tillDate,
    String? creationDate,
    List? listOfTasks,
    String? id,
    String? creatorId,
    List<String>? joinedUserIds,
  }) {
    return CommunityModel(
      communityName: communityName ?? this.communityName,
      founderUsername: founderUsername ?? this.founderUsername,
      aspect: aspect ?? this.aspect,
      goalName: goalName ?? this.goalName,
      isPrivate: isPrivate ?? this.isPrivate,
      creationDate: creationDate ?? this.creationDate,
      id: id ?? this.id,
      creatorId: creatorId ?? this.creatorId,
      joinedUserIds: joinedUserIds ?? this.joinedUserIds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'communityName': communityName,
      'founderUsername': founderUsername,
      'aspect': aspect,
      'goalName': goalName,
      'isPrivate': isPrivate,
      'creationDate': creationDate,
      'id': id,
      'creatorId': creatorId,
      'joinedUserIds': joinedUserIds,
    };
  }

  factory CommunityModel.fromMap(Map<String, dynamic> map) {
    return CommunityModel(
      communityName: map['communityName'] ?? '',
      founderUsername: map['founderUsername'] ?? '',
      aspect: map['aspect'] ?? '',
      goalName: map['goalName'] ?? '',
      isPrivate: map['isPrivate'] ?? false,
      creationDate: map['creationDate'] ?? '',
      id: map['id'] ?? '',
      creatorId: map['creatorId'] ?? '',
      joinedUserIds: List<String>.from(map['joinedUserIds']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CommunityModel.fromJson(String source) =>
      CommunityModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CommunityModel(communityName: $communityName, founderUsername: $founderUsername, aspect: $aspect, goalName: $goalName, isPrivate: $isPrivate,  creationDate: $creationDate,  id: $id, creatorId: $creatorId, joinedUserIds: $joinedUserIds)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CommunityModel &&
        other.communityName == communityName &&
        other.founderUsername == founderUsername &&
        other.aspect == aspect &&
        other.goalName == goalName &&
        other.isPrivate == isPrivate &&
        other.creationDate == creationDate &&
        other.id == id &&
        other.creatorId == creatorId &&
        listEquals(other.joinedUserIds, joinedUserIds);
  }

  @override
  int get hashCode {
    return communityName.hashCode ^
        founderUsername.hashCode ^
        aspect.hashCode ^
        goalName.hashCode ^
        isPrivate.hashCode ^
        creationDate.hashCode ^
        id.hashCode ^
        creatorId.hashCode ^
        joinedUserIds.hashCode;
  }
}
