//TODO: make everything works here (leave , delete the comm , invite , leaderboard)
//TODO : check if the member list is right if delete or leave for both admin and not
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:motazen/controllers/aspect_controller.dart';
import 'package:motazen/models/user_info.dart';
import 'package:motazen/pages/communities_page/community/invite/invite.dart';
import 'package:motazen/pages/communities_page/community/leaderboard_page.dart';
import 'package:motazen/theme.dart';
import 'package:provider/provider.dart';
import '../../../Sidebar_and_navigation/navigation_bar.dart';
import '../../../controllers/community_controller.dart';
import '../../../isar_service.dart';
import '../../assesment_page/alert_dialog.dart';
import '../bages/display_badges.dart';

class CommunityInfo extends StatefulWidget {
  final dynamic comm;
  final dynamic fromInvite;
  const CommunityInfo({super.key, this.comm, required this.fromInvite});

  @override
  State<CommunityInfo> createState() => _CommunityInfoState();
}

class _CommunityInfoState extends State<CommunityInfo> {
  CommunityController communityController = Get.find();
  int membercount = 0;

  bool isadmin =
      true; // this varible will be used to display delete and add widget for admins only
  List<dynamic> completedUsersId =
      []; // to be used to display the number of members and members usernames and avatar
  List<dynamic> membersUsername = [];
  String adminName =
      ""; //this one will be used to diaply the admin next to the righT name
  late Future<dynamic> dbFuture1;
  late Future<dynamic> dbFuture2;
  List<UserInfo> userlist = [];
  getDataName() async {
    //* return the list of the members in the community // make sure they are a member by checking there joind  list .
    // first check whther it is proivate or public then check the collction in firebase then of null take it form the user joned or created list
    dynamic communityDoc;
    if (widget.comm.isPrivate) {
      communityDoc = await firestore
          .collection('private_communities')
          .doc(widget.comm.id)
          .get();
    } else {
      communityDoc = await firestore
          .collection('public_communities')
          .doc(widget.comm.id)
          .get();
    }

    final cuurentCommunityDoc = communityDoc.data()! as dynamic;
    List progressList = cuurentCommunityDoc['progress_list'];
    // To alwyas display you at fiRst member in the list
    //for loop just to add you as the first index and breaks out

    for (int i = 0; i < progressList.length; i++) {
      String x = progressList[i].toString();
      String userId = x.substring(1, x.indexOf(':'));
      if (userId == firebaseAuth.currentUser!.uid) {
        //TO display أنت instead my the current user name
        dynamic userDoc = await firestore.collection("user").doc(userId).get();

        final users = userDoc.data()! as dynamic;
        adminName = users["firstName"];
        membersUsername.add("أنت");
        if (users["avatarURL"] == null) {
          membersUsername.add("");
        } else {
          membersUsername.add(users["avatarURL"]);
        }
        UserInfo user = UserInfo(userId, users["avatarURL"] ?? "", "أنت",
            progressList[i][userId].toDouble());
//                     .toDouble(););
        userlist.add(user);
        break;
      }
    }

    //make sure to not add your self again in here so continue when it is you
    //here i would check if the community is deleted then i will delete the admin id
    //here i would also check  if the user in the progress list are still users or not
    for (int i = 0; i < progressList.length; i++) {
      String x = progressList[i].toString();
      String userId = x.substring(1, x.indexOf(':'));

      if (userId == firebaseAuth.currentUser!.uid) {
        continue;
      } else {
        dynamic userDoc = await firestore.collection("user").doc(userId).get();

        final users = userDoc.data()! as dynamic;
        if (users["userID"] == widget.comm.founderUsername) {
          if (widget.comm.isDeleted) {
            continue;
          } else {
            completedUsersId.add(x.substring(1, x.indexOf(':')));

            membersUsername.add(users["firstName"]);
            if (users["avatarURL"] == null) {
              membersUsername.add("");
            } else {
              membersUsername.add(users["avatarURL"]);
            }
            UserInfo user = UserInfo(
                x.substring(1, x.indexOf(':')),
                users["avatarURL"] ?? "",
                users["firstName"],
                progressList[i][x.substring(1, x.indexOf(':'))].toDouble());

            userlist.add(user);
          }
        }

        bool ismember = false;
        List join = users["joinedCommunities"];

        for (int i = 0; i < join.length; i++) {
          if (join[i]["_id"] == widget.comm.id) {
            ismember = true;
          }
        }

        if (ismember) {
          completedUsersId.add(x.substring(1, x.indexOf(':')));

          membersUsername.add(users["firstName"]);
          if (users["avatarURL"] == null) {
            membersUsername.add("");
          } else {
            membersUsername.add(users["avatarURL"]);
          }
          UserInfo user = UserInfo(
              x.substring(1, x.indexOf(':')),
              users["avatarURL"] ?? "",
              users["firstName"],
              progressList[i][x.substring(1, x.indexOf(':'))].toDouble());
          userlist.add(user);
        }
      }
    }

    return userlist;
  }

  @override
  initState() {
    if (widget.comm.founderUsername != firebaseAuth.currentUser!.uid) {
      setState(() {
        isadmin = false;
      });
    }

    if (communityController.listOfCreatedCommunities
            .indexWhere((element) => element.id == widget.comm.id) <
        0) // this means you are not an admin

    {
      setState(() {
        isadmin = false;
      });
    }

    if (widget.fromInvite) {
      setState(() {
        isadmin = false;
      });
    }
    dbFuture1 = getDataName();

    // dbFuture2 = getDataprofile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var aspectList = Provider.of<AspectController>(context);

    final scrollController = ScrollController();

    return Scaffold(
        // specify a backgroundcolor
        backgroundColor: const Color.fromARGB(255, 243, 244, 246),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                      ));
                },
              ),

              backgroundColor: aspectList.getSelectedColor(widget.comm.aspect),
              actions: [
                GestureDetector(
                    onTap: () {
// we should check whether there is

                      Get.to(CommunityLeaderboardPage(comm: widget.comm));
                    },
                    child: Column(
                      children: const [
                        Image(
                            height: 35,
                            width: 35,
                            image: AssetImage('assets/images/score.png')),
                        Text(
                          "لوحة منجزي الهدف",
                          style: TextStyle(fontSize: 10),
                        )
                      ],
                    )),
                SizedBox(width: screenWidth(context) * 0.05),
              ],
              expandedHeight: 300,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            "assets/images/${widget.comm.aspect}.png"),
                        fit: BoxFit.cover),
                  ),
                  child: Center(
                    child: SizedBox(
                      // height:MediaQuery.of(context).size.height/2 ,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 9,
                            ),
                            Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 4,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor),
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //       spreadRadius: 2,
                                  //       blurRadius: 10,
                                  //       color: Colors.black.withOpacity(0.1),
                                  //       offset: const Offset(0, 10))
                                  // ],
                                  shape: BoxShape.circle,
                                ),
                                child: aspectList.getSelectedIcon(
                                    widget.comm.aspect,
                                    size: 70)),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              '${widget.comm.communityName}',
                              style: const TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (isadmin && widget.comm.isPrivate)
                                  GestureDetector(
                                      onTap: () {
                                        Get.to(() => Invite(comm: widget.comm));
                                      },
                                      child: const Icon(
                                        Icons.person_add,
                                        color:
                                            Color.fromARGB(255, 252, 254, 255),
                                        size: 30,
                                      )),
                                const SizedBox(
                                  width: 15,
                                ),
                                //show number of members
                                FutureBuilder<dynamic>(
                                    future: dbFuture1,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        final data = snapshot.data;
                                        int y = data.length;
                                        membercount = y;
                                        if (data.length / 2 > 1) {
                                          return Text(
                                            "$y أعضاء",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 37, 37, 37),
                                                fontSize: 25,
                                                fontWeight: FontWeight.w900),
                                          );
                                        } else {
                                          //! this case will ocure when i do the eextraction of my id from the list
                                          return Text(
                                            "$y عضو",
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 243, 243),
                                                fontSize: 25,
                                                fontWeight: FontWeight.w900),
                                          );
                                        }
                                      } else {
                                        //! this case will happen when having an error
                                        return const CircularProgressIndicator();
                                      }
                                    }),
                                // invite friends
                                //! see what he did to be showed only to the admin of the private community
                              ],
                            )
                          ]),
                    ),
                  ),
                ),
              ),
              // here display the aspect Icon then the nmae then the number of participants
            ),
            FutureBuilder<dynamic>(
                future: dbFuture1,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data;
                    // if (data.length != 0 ) {
                    return SliverPadding(
                      padding: const EdgeInsets.only(top: 15),
                      sliver: MediaQuery.removeViewInsets(
                        removeRight: true,
                        removeLeft: true,
                        removeTop: true,
                        removeBottom: true,
                        context: context,
                        child: SliverList(
                          // ignore: unnecessary_new
                          delegate: new SliverChildListDelegate([
                            MediaQuery.removeViewInsets(
                              removeRight: true,
                              removeLeft: true,
                              removeTop: true,
                              removeBottom: true,
                              context: context,
                              child: Card(
                                margin: const EdgeInsets.all(0),
                                child: MediaQuery.removeViewInsets(
                                    removeRight: true,
                                    removeLeft: true,
                                    removeTop: true,
                                    removeBottom: true,
                                    context: context,
                                    child: ListView.builder(
                                      //  add the same scrollController here
                                      controller: scrollController,
                                      shrinkWrap: true,
                                      itemCount: (data.length),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return SizedBox(
                                            height: 75,
                                            // margin: const EdgeInsets.symmetric(
                                            //     horizontal: 20, vertical: 10),

                                            child: ListTile(
                                                minLeadingWidth: 60,
                                                //!كلمة المشرف ما طلعت
                                                trailing: data[index]
                                                            .id == // this one was or i will make it and and
                                                        widget.comm
                                                            .founderUsername
                                                    ? const Text("المشرف")
                                                    : null,
                                                visualDensity:
                                                    const VisualDensity(
                                                        vertical: -3),
                                                title: Text(
                                                  data[index].firstname,
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 0.0,
                                                        horizontal: 16.0),
                                                leading: GestureDetector(
                                                  onTap: () => Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            BadgesPage(
                                                          avatar: data[index]
                                                              .avatar,
                                                          goalProgress: (data[
                                                                          index]
                                                                      .currentCommunityProgress *
                                                                  100)
                                                              .round()
                                                              .toInt(),
                                                          userId:
                                                              data[index].id,
                                                        ),
                                                      )),
                                                  child: SizedBox(
                                                    width: 50,
                                                    child: CircleAvatar(
                                                        // display the avatar if added
                                                        backgroundImage: data[
                                                                        index]
                                                                    .avatar ==
                                                                ""
                                                            ? null
                                                            : CachedNetworkImageProvider(
                                                                data[index]
                                                                    .avatar!,
                                                                errorListener:
                                                                    () {}),
                                                        radius: 60,
                                                        backgroundColor:
                                                            kWhiteColor,

                                                        // ignore: prefer_const_constructors
                                                        child: data[index]
                                                                    .avatar !=
                                                                ""
                                                            ? null
                                                            : GestureDetector(
                                                                child:
                                                                    const Icon(
                                                                  Icons
                                                                      .account_circle_sharp, //? is better to have the same icon as the one in the side bar
                                                                  color: Color
                                                                      .fromARGB(
                                                                          31,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  size: 50,
                                                                ),
                                                              )),
                                                  ),
                                                )));
                                      },
                                    )),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ]),
                        ),
                      ),
                    );
                  } else {
                    //! this case will happen when having an error
                    return const SliverToBoxAdapter(child: Text(""));
                  }
                }),
          ],
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () async {
              // display an alert and then the method
              final action = await AlertDialogs.yesCancelDialog(
                  context,
                  isadmin
                      ? ' هل انت متاكد من حذف و مغادرة المجتمع ؟'
                      : "هل أنت متأكد من مغادرة المجتمع",
                  '');
              if (action == DialogsAction.yes) {
                if (isadmin) {
                  await deleteCommunity();
                  setState(() {});
                  if (mounted) {
                    Navigator.pop(context); //Note: why is it duplicated
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const NavBar(selectedIndex: 2)));
                  }
                } else {
                  await leaveCommunity();
                  setState(() {});
                  if (mounted) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const NavBar(selectedIndex: 2)));
                  }
                }
              }
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 40),
              child: Row(
                children: [
                  const Icon(
                    Icons.exit_to_app,
                    color: Colors.red,
                  ),
                  //! try to check whther it is right for members or not
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        isadmin ? "حذف و مغادرة المجتمع" : "مغادرة المجتمع ",
                        style: const TextStyle(color: Colors.red),
                      )),
                ],
              ),
            ),
          ),
        ));
  }

//! add code to delete the documnet of the communinity from the collection when last member leave
  deleteCommunity() async {
    //in here after making isDeleted = true on the collection i should also change it to true in the joined of all members
    dynamic communityDoc;
// loop through all users and their joined community of the id is equal than make isDeleted = true;

    if (widget.comm.isPrivate) {
      await firestore
          .collection('private_communities')
          .doc(widget.comm.id)
          .update({'isDeleted': true});
      communityDoc = await firestore
          .collection('private_communities')
          .doc(widget.comm.id)
          .get();

      final cuurentCommunityDoc = communityDoc.data()! as dynamic;
      List progressList = cuurentCommunityDoc['progress_list'];
      for (int i = 0; i < progressList.length; i++) {
        String x = progressList[i].toString();
        String userId = x.substring(1, x.indexOf(':'));
        dynamic userDoc = await firestore.collection("user").doc(userId).get();
        final users = userDoc.data()! as dynamic;
        List join = users["joinedCommunities"];
        //try to use joinedCommunitiess in the authcontroller
        for (int i = 0; i < join.length; i++) {
          if (join[i]["_id"] == widget.comm.id) {
            join[i]["isDeleted"] = true;
            await firestore
                .collection('user')
                .doc(userId)
                .update({'joinedCommunities': join});
          }
        }
      }
    } else {
      await firestore
          .collection('public_communities')
          .doc(widget.comm.id)
          .update({'isDeleted': true});
      communityDoc = await firestore
          .collection('public_communities')
          .doc(widget.comm.id)
          .get();
      final cuurentCommunityDoc = communityDoc.data()! as dynamic;
      List progressList = cuurentCommunityDoc['progress_list'];
      for (int i = 0; i < progressList.length; i++) {
        String x = progressList[i].toString();
        String userId = x.substring(1, x.indexOf(':'));
        dynamic userDoc = await firestore.collection("user").doc(userId).get();
        final users = userDoc.data()! as dynamic;
        List join = users["joinedCommunities"];
        //try to use joinedCommunitiess in the authcontroller
        for (int i = 0; i < join.length; i++) {
          if (join[i]["_id"] == widget.comm.id) {
            join[i]["isDeleted"] = true;
            await firestore
                .collection('user')
                .doc(userId)
                .update({'joinedCommunities': join});
          }
        }
      }
    }

    //delete messages
    // FirebaseDatabase.instance
    //     .ref('post_channels/')
    //     .child('${widget.comm.id}')
    //     .child('isActive')
    //     .set(false);

//delete from public_communities
    IsarService iser = IsarService();
    iser.deleteCommunity(widget.comm.id);
//try the goal check if the link goes and see of the collection delted then cimpien code
    //! you were trying to delete the community of you werer the lase memer

    if (membercount == 1) {
      if (!widget.comm.isPrivate) {
        final t =
            firestore.collection('public_communities').doc(widget.comm.id);
        await t.delete();
      } else {
        final t =
            firestore.collection('private_communities').doc(widget.comm.id);
        await t.delete();
      }
    }

//! see what to do with the private collection when it is deleted it

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
                'progress_list': e.progressList,
                '_id': e.id,
                "isDeleted": e.isDeleted
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
//! this code for adjusting the progress list after a member leaves but i commented it cause we would like to save those who completed the goal even if they left
    // if (widget.comm.isPrivate) {
    //   communityDoc = await firestore
    //       .collection('private_communities')
    //       .doc(widget.comm.id)
    //       .get();

    //   if (communityDoc.data() != null) {
    //     final CurrentCommunityDoc = communityDoc.data() as dynamic;

    //     List communities = [];

    //     communities = CurrentCommunityDoc['progress_list'];
    //     for (int i = 0; i < communities.length; i++) {
    //       if (communities[i][firebaseAuth.currentUser!.uid] != null) {
    //         communities.removeAt(i);

    //         await firestore
    //             .collection('private_communities')
    //             .doc(widget.comm.id)
    //             .update({
    //           'progress_list': CurrentCommunityDoc['progress_list'],
    //         });
    //         break;
    //       }
    //     }
    //   }
    // } else {
    //   //means it is public
    //   communityDoc = await firestore
    //       .collection('public_communities')
    //       .doc(widget.comm.id)
    //       .get();

    //   if (communityDoc.data() != null) {
    //     final CurrentCommunityDoc = communityDoc.data() as dynamic;

    //     List communities = [];

    //     communities = CurrentCommunityDoc['progress_list'];
    //     for (int i = 0; i < communities.length; i++) {
    //       if (communities[i][firebaseAuth.currentUser!.uid] != null) {
    //         communities.removeAt(i);

    //         await firestore
    //             .collection('public_communities')
    //             .doc(widget.comm.id)
    //             .update({
    //           'progress_list': CurrentCommunityDoc['progress_list'],
    //         });
    //         break;
    //       }
    //     }
    //   }
    // }
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
                "isDeleted": e.isDeleted,
                '_id': e.id
              })
          .toList(),
    });

    if (membercount == 1) {
      if (!widget.comm.isPrivate) {
        final t =
            firestore.collection('public_communities').doc(widget.comm.id);
        await t.delete();
      } else {
        final t =
            firestore.collection('private_communities').doc(widget.comm.id);
        await t.delete();
      }
    }
  }
}
