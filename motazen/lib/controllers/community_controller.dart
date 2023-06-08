import 'dart:developer';
import 'package:get/get.dart';
import 'package:motazen/controllers/auth_controller.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/isar_service.dart';
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
    listOfCreatedCommunities.clear();
    listOfJoinedCommunities.clear();

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

        for (final community in createdCommunities) {
          final communityModel = Community(
            progressList: community['progress_list'],
            aspect: community['aspect'],
            founderUserID: community['founderUserID'],
            communityName: community['communityName'],
            creationDate: community['creationDate']?.toDate(),
            goalName: community['goalName'],
            isPrivate: community['isPrivate'],
            isDeleted: community['isDeleted'],
            id: community['_id'],
          );

          userCommunities.add(communityModel);
        }

        for (final community in joinedCommunities) {
          final communityModel = Community(
            progressList: community['progress_list'],
            aspect: community['aspect'],
            founderUserID: community['founderUserID'],
            communityName: community['communityName'],
            creationDate: community['creationDate']?.toDate(),
            goalName: community['goalName'],
            isPrivate: community['isPrivate'],
            isDeleted: community['isDeleted'],
            id: community['_id'],
          );

          userCommunities.add(communityModel);
        }
      }
    } on Exception catch (e) {
      log('error updating communities: $e');
    }

    // Notify any listeners that the usersList has been updated.
    update();
  }

  Future<void> createCommunity({
    required Community community,
  }) async {
    final batch = firestore.batch();
    final currentUserDoc =
        firestore.collection('user').doc(firebaseAuth.currentUser?.uid);

    try {
      final userDoc = await firestore
          .collection('user')
          .doc(firebaseAuth.currentUser?.uid)
          .get();
      final userData = userDoc.data();

      final createdCommunities = List<Map<String, dynamic>>.from(
          userData!['createdCommunities'] ?? <Map<String, dynamic>>[]);

      // Add the community to the appropriate collection based on its privacy status.
      final communityData = {
        'aspect': community.aspect,
        'communityName': community.communityName,
        'creationDate': community.creationDate,
        'progress_list': community.progressList,
        'founderUserID': community.founderUserID,
        'goalName': community.goalName,
        'isPrivate': community.isPrivate,
        'isDeleted': community.isDeleted,
        '_id': community.id
      };
      createdCommunities.add(communityData);

      batch.update(currentUserDoc, {'createdCommunities': createdCommunities});

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

  Future<void> acceptInvitation(String commId, bool fromInvite) async {
    String path = fromInvite ? 'private_communities' : 'public_communities';
    final batch = firestore.batch();
    final currentUserDoc =
        firestore.collection('user').doc(firebaseAuth.currentUser!.uid);
    final communityDoc = await firestore.collection(path).doc(commId).get();
    final community = communityDoc.data() as Map<String, dynamic>;
    try {
      final userDoc = await firestore
          .collection('user')
          .doc(firebaseAuth.currentUser?.uid)
          .get();
      final userData = userDoc.data();

      final joinedCommunities = List<Map<String, dynamic>>.from(
          userData!['joinedCommunities'] ?? <Map<String, dynamic>>[]);

      // Add the community to the appropriate collection based on its privacy status.
      final communityData = {
        'aspect': community['aspect'],
        'communityName': community['communityName'],
        'creationDate': community['creationDate'],
        'progress_list': community['progress_list'],
        'founderUserID': community['founderUserID'],
        'goalName': community['goalName'],
        'isPrivate': community['isPrivate'],
        'isDeleted': community['isDeleted'],
        '_id': community['_id']
      };
      joinedCommunities.add(communityData);

      batch.update(currentUserDoc, {'joinedCommunities': joinedCommunities});

      // Commit the batched write operation.
      await batch.commit();

      // await batch.commit();
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
          'founderUserID': e.founderUserID,
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
        'founderUserID': community.founderUserID,
        'goalName': community.goalName,
        'isPrivate': community.isPrivate,
        '_id': community.id
      });

      batch
          .update(currentUserDoc, {'joinedCommunities': joinedCommunitiesData});

      // Commit the batched write operation.
      await batch.commit();

      getSuccessSnackBar('تم الانضمام إلى المجتمع بنجاح');
    } catch (e) {
      getErrorSnackBar('حدث خطأ ما ،عاود المحاولة مرة أخرى');
    }
  }

  Future<void> deleteCommunity(Community community) async {
    final batch = firestore.batch();
    final currentUserDoc =
        firestore.collection('user').doc(firebaseAuth.currentUser!.uid);

    final userDoc = await firestore
        .collection('user')
        .doc(firebaseAuth.currentUser?.uid)
        .get();
    final userData = userDoc.data();
    String communityPath =
        community.isPrivate ? 'private_communities' : 'public_communities';
    final communityDoc = firestore.collection(communityPath).doc(community.id);
    String path = '';
    var communities;

    try {
      // If the user is the admin or the last member of the community, mark the community as deleted.
      final isAdmin = community.founderUserID == firebaseAuth.currentUser?.uid;
      final memberCount = community.progressList.length;
// if the member count is 1 or less delete the community
      if (memberCount <= 1) {
        await communityDoc.delete();
      } else if (isAdmin) {
        await communityDoc.update({
          'isDeleted': true,
        });
      }

      if (isAdmin) {
        communities = List<Map<String, dynamic>>.from(
            userData?['createdCommunities'] ?? <Map<String, dynamic>>[]);
        communities.removeWhere((element) => element['_id'] == community.id);
        path = 'createdCommunities';
      } else {
        communities = List<Map<String, dynamic>>.from(
            userData?['joinedCommunities'] ?? <Map<String, dynamic>>[]);
        communities.removeWhere((element) => element['_id'] == community.id);
        path = 'joinedCommunities';
      }

      batch.update(currentUserDoc, {path: communities});

      // Commit the batched write operation.
      await batch.commit();

      //update isar
      IsarService().deleteCommunity(community.id);
    } catch (e) {
      log('error leaving community: $e');
    }
  }
}
