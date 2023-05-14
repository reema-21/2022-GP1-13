import 'dart:developer';
import 'package:get/get.dart';
import 'package:motazen/controllers/auth_controller.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/models/community.dart';
import 'package:motazen/models/user.dart';
import 'package:motazen/theme.dart';

class CommunityController extends GetxController {
  // Initialize lists
  RxList<Community> listOfCreatedCommunities = RxList<Community>();
  RxList<Community> listOfJoinedCommunities = RxList<Community>();
  RxList<Community> userCommunities = RxList<Community>();

  List<Community> findAspectComm(Aspect aspect) {
    return [
      ...listOfCreatedCommunities
          .where((community) => community.aspect == aspect.name),
      ...listOfJoinedCommunities
          .where((community) => community.aspect == aspect.name),
    ];
  }

  Future<void> getUserData() async {
    userCommunities.clear();

    try {
      final userDoc = await firestore
          .collection('user')
          .doc(firebaseAuth.currentUser?.uid)
          .get();

      final userData = userDoc.data();

      if (userData != null) {
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
      }
    } on Exception catch (e) {
      log('error updating communities: $e');
    }

    // Notify any listeners that the usersList has been updated.
    update();
  }

  void addCommunityIfNotExists(
    Map<String, dynamic> communityData,
    Set<String> communityIds,
  ) {
    final communityId = communityData['_id'] as String;
    if (communityIds.contains(communityId)) {
      // The set already contains the community ID, so return without doing anything.
      return;
    }

    final communityModel = Community(
      progressList: communityData['progress_list'],
      aspect: communityData['aspect'],
      founderUsername: communityData['founderUsername'],
      communityName: communityData['communityName'],
      creationDate: communityData['creationDate']?.toDate(),
      goalName: communityData['goalName'],
      isPrivate: communityData['isPrivate'],
      isDeleted: communityData['isDeleted'],
      id: communityId,
    );

    userCommunities.add(communityModel);
    communityIds.add(communityId);
  }

  Future<void> createCommunity({
    required Community community,
    required List<Userr> invitedUsers,
  }) async {
    final batch = firestore.batch();
    final currentUserDoc =
        firestore.collection('user').doc(firebaseAuth.currentUser?.uid);

    try {
      // Add the community to the list of created communities for the current user.
      final createdCommunitiesData = listOfCreatedCommunities.map((e) {
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
      }).toList();

      batch.update(
          currentUserDoc, {'createdCommunities': createdCommunitiesData});

      // Send invitations to other users if there are any.
      if (invitedUsers.isNotEmpty) {
        for (final user in invitedUsers) {
          final notificationsCollection = firestore
              .collection('user')
              .doc(user.userID)
              .collection('notifications');
          batch.set(notificationsCollection.doc(), {
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
          });
        }
      }

      // Add the community to the appropriate collection based on its privacy status.
      final communityData = {
        'aspect': community.aspect,
        'communityName': community.communityName,
        'creationDate': community.creationDate,
        'progress_list': community.progressList,
        'founderUsername': community.founderUsername,
        'goalName': community.goalName,
        'isPrivate': community.isPrivate,
        'isDeleted': community.isDeleted,
        '_id': community.id
      };

      final collection =
          community.isPrivate ? 'private_communities' : 'public_communities';
      batch.set(
          firestore.collection(collection).doc(community.id), communityData);

      // Commit the batched write operation.
      await batch.commit();

      getSuccessSnackBar('تم انشاء المجتمع بنجاح');
    } catch (e) {
      listOfCreatedCommunities.remove(community);
      getErrorSnackBar('حدث خطأ ما ،عاود التسجيل مرة أخرى ');
    }
  } //* this method adds a community to the joined communities list in Firebase

  Future<void> acceptInvitation() async {
    final batch = firestore.batch();
    final currentUserDoc =
        firestore.collection('user').doc(firebaseAuth.currentUser!.uid);

    try {
      batch.update(currentUserDoc, {
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

      await batch.commit();
    } catch (e) {
      log('error: $e');
    }
  }

  Community? getCommunityById(String communityId) {
    final community = userCommunities.firstWhere(
      (community) => community.id == communityId,
    );
    return community.id.isEmpty ? null : community;
  }

// Returns true if the user with the given userId has joined the community with the given communityId, false otherwise.
  bool isJoined(String communityId, String userId) {
    final community = userCommunities.firstWhere(
      (community) => community.id == communityId,
      orElse: () => Community(
        isDeleted: true,
        isPrivate: true,
        progressList: [],
        id: '',
      ),
    );

    if (community.isDeleted) {
      // Community not found or deleted, so the user can't have joined it.
      return false;
    }

    final user = Get.find<AuthController>().usersList.firstWhere(
          (user) => user.userID == userId,
          orElse: () => Userr(
            createdCommunities: [],
            joinedCommunities: [],
            userID: '',
          ),
        );

    final joinedCommunities = user.joinedCommunities;

    return joinedCommunities!
        .any((joinedCommunity) => joinedCommunity.id == communityId);
  }

  Future<void> joinPublicCommunity(Community community) async {
    final batch = firestore.batch();
    final currentUserDoc =
        firestore.collection('user').doc(firebaseAuth.currentUser?.uid);

    try {
      // Add the community to the list of joined communities for the current user.
      final joinedCommunitiesData = listOfJoinedCommunities.map((e) {
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
      }).toList();

      joinedCommunitiesData.add({
        'aspect': community.aspect,
        'isDeleted': community.isDeleted,
        'communityName': community.communityName,
        'creationDate': community.creationDate,
        'progress_list': community.progressList,
        'founderUsername': community.founderUsername,
        'goalName': community.goalName,
        'isPrivate': community.isPrivate,
        '_id': community.id
      });

      batch
          .update(currentUserDoc, {'joinedCommunities': joinedCommunitiesData});

      // Add the user to the list of members for the community.
      final membersCollection = firestore
          .collection('public_communities')
          .doc(community.id)
          .collection('members');
      batch.set(membersCollection.doc(firebaseAuth.currentUser!.uid), {});

      // Commit the batched write operation.
      await batch.commit();

      getSuccessSnackBar('تم الانضمام إلى المجتمع بنجاح');
    } catch (e) {
      getErrorSnackBar('حدث خطأ ما ،عاود المحاولة مرة أخرى');
    }
  }

//   deleteCommunity(Community community) async {
//     // Update community document to mark it as deleted
//     if (community.isPrivate) {
//       await firestore
//           .collection('private_communities')
//           .doc(community.id)
//           .update({'isDeleted': true});
//     } else {
//       await firestore
//           .collection('public_communities')
//           .doc(community.id)
//           .update({'isDeleted': true});
//     }

//     // Update joined communities of all users to mark this community as deleted
//     final communityDoc = await firestore
//         .collection(
//             community.isPrivate ? 'private_communities' : 'public_communities')
//         .doc(community.id)
//         .get();
//     final cuurentCommunityDoc = communityDoc.data()!;
//     final progressList = cuurentCommunityDoc['progress_list'] as List<dynamic>;
//     for (final progress in progressList) {
//       final userId =
//           progress.toString().substring(1, progress.toString().indexOf(':'));
//       final userDoc = await firestore.collection('user').doc(userId).get();
//       final userData = userDoc.data()!;
//       final joinedCommunities =
//           List<Map<String, dynamic>>.from(userData['joinedCommunities']);
//       final communityIndex =
//           joinedCommunities.indexWhere((c) => c['_id'] == community.id);
//       if (communityIndex != -1) {
//         joinedCommunities[communityIndex]['isDeleted'] = true;
//         await firestore
//             .collection('user')
//             .doc(userId)
//             .update({'joinedCommunities': joinedCommunities});
//       }
//     }

//     // Delete community from local database
//     final iser = IsarService();
//     iser.deleteCommunity(community.id);

//     // Delete community from public or private communities collection if this is the last member
//     final memberCount = progressList.length;
//     if (memberCount == 1) {
//       final collectionName =
//           community.isPrivate ? 'private_communities' : 'public_communities';
//       final t = firestore.collection(collectionName).doc(community.id);
//       await t.delete();
//     }

//     // Update user's created communities list
//     listOfCreatedCommunities.removeWhere((c) => c.id == community.id);
//     await firestore
//         .collection('user')
//         .doc(firebaseAuth.currentUser!.uid)
//         .update({
//       'createdCommunities': listOfCreatedCommunities
//           .map((c) => {
//                 'aspect': c.aspect,
//                 'communityName': c.communityName,
//                 'creationDate': c.creationDate,
//                 'founderUsername': c.founderUsername,
//                 'goalName': c.goalName,
//                 'isPrivate': c.isPrivate,
//                 'progress_list': c.progressList,
//                 '_id': c.id,
//                 'isDeleted': c.isDeleted,
//               })
//           .toList(),
//     });
//   }

//   leaveCommunity(Community community) async {
//     // Delete community from local database
//     IsarService iser = IsarService();
//     iser.deleteCommunity(community.id);
//     // Remove community from user's list of joined communities
//     listOfJoinedCommunities
//         .removeWhere((element) => element.id == community.id);
//     await firestore
//         .collection('user')
//         .doc(firebaseAuth.currentUser!.uid)
//         .update({
//       'joinedCommunities': listOfJoinedCommunities
//           .map((e) => {
//                 'aspect': e.aspect,
//                 'communityName': e.communityName,
//                 'creationDate': e.creationDate,
//                 'progress_list': e.progressList,
//                 'founderUsername': e.founderUsername,
//                 'goalName': e.goalName,
//                 'isPrivate': e.isPrivate,
//                 'isDeleted': e.isDeleted,
//                 '_id': e.id
//               })
//           .toList(),
//     });

//     // If this is the last member, delete the public or private community
//     final membercount = await getMembersForCommunity(community);
//     if (membercount == 1) {
//       if (!community.isPrivate) {
//         final t = firestore.collection('public_communities').doc(community.id);
//         await t.delete();
//       } else {
//         final t = firestore.collection('private_communities').doc(community.id);
//         await t.delete();
//       }
//     }
//   }
// // int listOfMembersCount(String communityId) {
// //   // Get the list of members for the community with the given ID
// //   List<String> members = getMembersForCommunity(communityId);

// //   // Return the number of members in the list
// //   return members.length;
// // }
//   Future<int> getMembersForCommunity(Community community) async {
//     final FirebaseFirestore firestore = FirebaseFirestore.instance;

//     // Loop through every user in the user collection and check their createdCommunities and joinedCommunities fields for a match
//     final QuerySnapshot<Map<String, dynamic>> usersSnapshot =
//         await firestore.collection('users').get();
//     final List<QueryDocumentSnapshot<Map<String, dynamic>>> usersDocs =
//         usersSnapshot.docs;

//     int memberCount = 0;

//     for (final QueryDocumentSnapshot<Map<String, dynamic>> userDoc
//         in usersDocs) {
//       final Map<String, dynamic> userData = userDoc.data();

//       final List<dynamic>? createdCommunities = userData['createdCommunities'];
//       final List<dynamic>? joinedCommunities = userData['joinedCommunities'];

//       if (createdCommunities != null &&
//           createdCommunities.contains(community.id)) {
//         memberCount++;
//       }

//       if (joinedCommunities != null &&
//           joinedCommunities.contains(community.id)) {
//         memberCount++;
//       }
//     }

//     return memberCount;
//   }
}
