import 'dart:developer';
import 'package:async/async.dart';
import 'package:get/get.dart';
import 'package:motazen/controllers/auth_controller.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/models/community.dart';
import 'package:motazen/models/user.dart';
import '../theme.dart';

class CommunityController extends GetxController {
  RxList<Community> listOfCreatedCommunities = <Community>[].obs;
  RxList<Community> listOfJoinedCommunities = <Community>[].obs;
  RxList<Community> userCommunities = <Community>[].obs;
  AuthController authController = Get.put(AuthController());

  List<Community> findAspectComm(Aspect aspect) {
    List<Community> aspectCommunities = [];
    for (var community in listOfCreatedCommunities) {
      if (community.aspect == aspect.name) {
        aspectCommunities.add(community);
      }
    }
    for (var community in listOfJoinedCommunities) {
      if (community.aspect == aspect.name) {
        aspectCommunities.add(community);
      }
    }
    return aspectCommunities;
  }

  void removeDuplicateCommunities() {
    final uniqueCommunities = <Community>{};
    final duplicates = <Community>[];

    for (final community in userCommunities) {
      if (!uniqueCommunities.add(community)) {
        // Community already exists, add to duplicates list
        duplicates.add(community);
      }
    }

    // Remove duplicates from userCommunities list
    userCommunities.removeWhere((community) => duplicates.contains(community));
    update();
  }

  Future<void> getUserData() async {
    userCommunities.clear();

    final userDoc = await firestore
        .collection('user')
        .doc(firebaseAuth.currentUser!.uid)
        .get();

    final userData = userDoc.data()!;

    final createdCommunities = List<Map<String, dynamic>>.from(
        userData['createdCommunities'] ?? <Map<String, dynamic>>[]);
    final joinedCommunities = List<Map<String, dynamic>>.from(
        userData['joinedCommunities'] ?? <Map<String, dynamic>>[]);

    final communityIds = <String>{};

    for (final community in createdCommunities) {
      addCommunityIfNotExists(
        community,
        communityIds,
      );
    }

    for (final community in joinedCommunities) {
      addCommunityIfNotExists(
        community,
        communityIds,
      );
    }

    update();
  }

  void addCommunityIfNotExists(
    Map<String, dynamic> communityData,
    Set<String> communityIds,
  ) {
    final communityId = communityData['_id'] as String;
    if (communityIds.contains(communityId)) return;

    final communityModel = Community(
      progressList: communityData['progress_list'],
      aspect: communityData['aspect'],
      founderUsername: communityData['founderUsername'],
      communityName: communityData['communityName'],
      creationDate: communityData['creationDate'].toDate(),
      goalName: communityData['goalName'],
      isPrivate: communityData['isPrivate'],
      isDeleted: communityData['isDeleted'],
      id: communityId,
    );

    userCommunities.add(communityModel);
    communityIds.add(communityId);
  }

  createCommunity({
    required Community community,
    required List<Userr> invitedUsers,
  }) async {
    FutureGroup futureGroup = FutureGroup();
    //* adding the coomunity to the list of created communities
    try {
      await firestore
          .collection('user')
          .doc(firebaseAuth.currentUser!.uid)
          .update({
        'createdCommunities': listOfCreatedCommunities.map((e) {
          return {
            'aspect': e.aspect,
            'isDeleted': e.isDeleted,
            'communityName': e.communityName,
            'creationDate': e.creationDate,
            'progress_list': e.progressList,
            'founderUsername': e.founderUsername,
            'goalName': e.goalName,
            'isPrivate': e.isPrivate,
            '_id': e.id
          };
        }).toList(),
      }).then((value) async {
        //* sending invitations to other users
        if (invitedUsers.isNotEmpty) {
          for (var user in invitedUsers) {
            futureGroup.add(firestore
                .collection('user')
                .doc(user.userID)
                .collection('notifications')
                .add({
              'creation_date': community.creationDate,
              'type': 'invite',
              'community': {
                'isDeleted': community.isDeleted,
                'progress_list': community.progressList,
                'aspect': community.aspect,
                'communityName': community.communityName,
                'creationDate': community.creationDate,
                'founderUsername': community.founderUsername,
                'goalName': community.goalName,
                'isPrivate': community.isPrivate,
                '_id': community.id
              }
            }));
          }
        }
        //* adding a community to the public_communities collection
        if (!(community.isPrivate)) {
          await firestore
              .collection('public_communities')
              .doc(community.id)
              .set({
            'aspect': community.aspect,
            'communityName': community.communityName,
            'creationDate': community.creationDate,
            'progress_list': community.progressList,
            'founderUsername': community.founderUsername,
            'goalName': community.goalName,
            'isPrivate': community.isPrivate,
            'isDeleted': community.isDeleted,
            '_id': community.id
          });
        } else {
          //* adding a community to the private_communities collection
          await firestore
              .collection('private_communities')
              .doc(community.id)
              .set({
            'aspect': community.aspect,
            'communityName': community.communityName,
            'creationDate': community.creationDate,
            'progress_list': community.progressList,
            'founderUsername': community.founderUsername,
            'goalName': community.goalName,
            'isPrivate': community.isPrivate,
            'isDeleted': community.isDeleted,
            '_id': community.id
          });
        }
      });
      futureGroup.close();
      getSuccessSnackBar('تم انشاء المجتمع بنجاح');
    } catch (e) {
      listOfCreatedCommunities.remove(community);
      getErrorSnackBar('حدث خطأ ما ،عاود التسجيل مرة أخرى ');
    }
  }

  acceptInvitation() async {
    try {
      await firestore
          .collection('user')
          .doc(firebaseAuth.currentUser!.uid)
          .update({
        'joinedCommunities': listOfJoinedCommunities
            .map((e) => {
                  'aspect': e.aspect,
                  'communityName': e.communityName,
                  'creationDate': e.creationDate,
                  'progress_list': e.progressList,
                  'founderUsername': e.founderUsername,
                  'goalName': e.goalName,
                  'isPrivate': e.isPrivate,
                  '_id': e.id,
                  'isDeleted': e.isDeleted,
                })
            .toList(),
      });
    } catch (e) {
      log('error: $e');
    }
  }
}
