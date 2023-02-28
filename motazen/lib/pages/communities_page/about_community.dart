// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names
//ours //new
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/Sidebar_and_navigation/navigation-bar.dart';
import 'package:motazen/controllers/auth_controller.dart';
import 'package:motazen/pages/communities_page/invite_friends_screen.dart';
import 'package:motazen/theme.dart';
import 'package:motazen/pages/communities_page/leave_delete_popup.dart';

import '../../controllers/community_controller.dart';
import '../../isar_service.dart';

class AboutCommunityPage extends StatefulWidget {
  final comm;
  const AboutCommunityPage({super.key, required this.comm});

  @override
  State<AboutCommunityPage> createState() => _AboutCommunityPageState();
}

class _AboutCommunityPageState extends State<AboutCommunityPage> {
  CommunityController communityController = Get.find();
  AuthController authController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.grey,
                  ));
            },
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          title: const Text(
            'خيارات المجتمع',
            style: TextStyle(fontSize: 20, color: Colors.black),
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (widget.comm.isPrivate &&
                communityController.listOfCreatedCommunities.indexWhere(
                        (element) => element.id == widget.comm.id) >=
                    0)
              InviteFriendWidget(comm: widget.comm),
            if (communityController.listOfCreatedCommunities
                    .indexWhere((element) => element.id == widget.comm.id) >=
                0)
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                child: InkWell(
                  onTap: () async {
                    shouldDelete(context).then((value) async {
                      if (value != null) {
                        await deleteCommunity();
                        setState(() {});
                        Navigator.pop(context); //Note: why is it duplicated
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const navBar(selectedIndex: 2)));
                      }
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.red),
                    child: const Text(
                      'حذف المجتمع',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            if (communityController.listOfCreatedCommunities
                    .indexWhere((element) => element.id == widget.comm.id) <
                0)
              Column(
                children: [
                  const SizedBox(height: 70),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                    child: InkWell(
                      onTap: () async {
                        shouldLeave(context).then((value) async {
                          if (value != null) {
                            await leaveCommunity();
                            setState(() {});
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const navBar(selectedIndex: 2)));
                          }
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.red),
                        child: const Text(
                          'غادر المجتمع',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  deleteCommunity() async {
    //delete messages
    FirebaseDatabase.instance
        .ref('post_channels/')
        .child('${widget.comm.id}')
        .child('isActive')
        .set(false);

//delete from public_communities
    IsarService iser = IsarService();
    iser.deleteCommunity(widget.comm.id);
    if (!widget.comm.isPrivate) {
      final t = firestore.collection('public_communities').doc(widget.comm.id);
      await t.delete();
    }

    // delete created communities
    iser.deleteCommunity(widget.comm.id);

    communityController.listOfCreatedCommunities
        .removeWhere((element) => element.id == widget.comm.id);
    await firestore
        .collection('user')
        .doc(firebaseAuth.currentUser!.uid)
        .update({
      'createdCommunities': communityController.listOfCreatedCommunities
          .map((e) => {
                'aspect': e.aspect,
                'communityName': e.communityName,
                'creationDate': e.creationDate,
                'founderUsername': e.founderUsername,
                'goalName': e.goalName,
                'isPrivate': e.isPrivate,
                '_id': e.id
              })
          .toList(),
    });
  }

  leaveCommunity() async {
    // delete joined community
    IsarService iser = IsarService();
    iser.deleteCommunity(widget.comm.id);
// here you want to add code to delete the member id from the list in the public/private collections
    // so first check if it is private or public and then do the rest
    dynamic CommunityDoc;

    if (widget.comm.isPrivate) {
      CommunityDoc = await firestore
          .collection('private_communities')
          .doc(widget.comm.id)
          .get();

      if (CommunityDoc.data() != null) {
        final CurrentCommunityDoc = CommunityDoc.data() as dynamic;

        List Communitiess = [];

        Communitiess = CurrentCommunityDoc['progress_list'];
        for (int i = 0; i < Communitiess.length; i++) {
          if (Communitiess[i][firebaseAuth.currentUser!.uid] != null) {
            Communitiess.removeAt(i);

            await firestore
                .collection('private_communities')
                .doc(widget.comm.id)
                .update({
              'progress_list': CurrentCommunityDoc['progress_list'],
            });
            break;
          }
        }
      }
    } else {
      //means it is public
      CommunityDoc = await firestore
          .collection('public_communities')
          .doc(widget.comm.id)
          .get();

      if (CommunityDoc.data() != null) {
        final CurrentCommunityDoc = CommunityDoc.data() as dynamic;

        List Communitiess = [];

        Communitiess = CurrentCommunityDoc['progress_list'];
        for (int i = 0; i < Communitiess.length; i++) {
          if (Communitiess[i][firebaseAuth.currentUser!.uid] != null) {
            Communitiess.removeAt(i);

            await firestore
                .collection('public_communities')
                .doc(widget.comm.id)
                .update({
              'progress_list': CurrentCommunityDoc['progress_list'],
            });
            break;
          }
        }
      }
    }
    communityController.listOfJoinedCommunities
        .removeWhere((element) => element.id == widget.comm.id);
    await firestore
        .collection('user')
        .doc(firebaseAuth.currentUser!.uid)
        .update({
      'joinedCommunities': communityController.listOfJoinedCommunities
          .map((e) => {
                'aspect': e.aspect,
                'communityName': e.communityName,
                'creationDate': e.creationDate,
                'progress_list': e.progressList,
                'founderUsername': e.founderUsername,
                'goalName': e.goalName,
                'isPrivate': e.isPrivate,
                '_id': e.id
              })
          .toList(),
    });
  }
}
