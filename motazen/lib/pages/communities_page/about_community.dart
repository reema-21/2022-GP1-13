// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/Sidebar_and_navigation/navigation-bar.dart';
import 'package:motazen/controllers/auth_controller.dart';
import 'package:motazen/pages/communities_page/invite_friends_screen.dart';
import 'package:motazen/theme.dart';

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
                    await deleteCommunity();
                    setState(() {});
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const navBar(selectedIndex: 2)));
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
                        await leaveCommunity();
                        setState(() {});
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const navBar(selectedIndex: 2)));
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
      final t =
          await firestore.collection('public_communities').doc(widget.comm.id);
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
                // 'listOfTasks': e.listOfTasks!.isNotEmpty
                //     ? e.listOfTasks!.map((e) => e.toJson()).toList()
                //     : [],
                // 'tillDate': e.tillDate,
                '_id': e.id
              })
          .toList(),
    });
    //removing from joined users
    // for (int i = 0; i < authController.usersList.length; i++) {
    //   if (authController.usersList[i].joinedCommunities != null &&
    //       authController.usersList[i].joinedCommunities!
    //               .indexWhere((element) => element.id == widget.comm.id) >=
    //           0) {
    //     authController.usersList[i].joinedCommunities!
    //         .removeWhere((element) => element.id == widget.comm.id);
    //     firestore
    //         .collection('user')
    //         .doc(authController.usersList[i].userID)
    //         .update({
    //       'joinedCommunities': authController.usersList[i].joinedCommunities!
    //           .map((e) => {
    //                 'aspect': e.aspect,
    //                 'communityName': e.communityName,
    //                 'creationDate': e.creationDate,
    //                 'founderUsername': e.founderUsername,
    //                 'goalName': e.goalName,
    //                 'isPrivate': e.isPrivate,
    //                 'listOfTasks': e.listOfTasks!.isNotEmpty
    //                     ? e.listOfTasks!.map((e) => e.toJson()).toList()
    //                     : [],
    //                 'tillDate': e.tillDate,
    //                 '_id': e.id
    //               })
    //           .toList(),
    //     });
    //   }
    // }
  }

  leaveCommunity() async {
    // delete joined community
    IsarService iser = IsarService();
    iser.deleteCommunity(widget.comm.id);

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
                // 'listOfTasks': e.listOfTasks!.isNotEmpty
                //     ? e.listOfTasks!.map((e) => e.toJson()).toList()
                //     : [],
                // 'tillDate': e.tillDate,
                '_id': e.id
              })
          .toList(),
    });
  }
}
