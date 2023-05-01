import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/controllers/community_controller.dart';
import 'package:motazen/models/user_info.dart';
import 'package:motazen/pages/communities_page/bages/display_badges.dart';
import 'package:motazen/theme.dart';

class CommunityLeaderboardPage extends StatefulWidget {
  final dynamic comm;
  const CommunityLeaderboardPage({super.key, required this.comm});

  @override
  State<CommunityLeaderboardPage> createState() =>
      _CommunityLeaderboardPageState();
}

class _CommunityLeaderboardPageState extends State<CommunityLeaderboardPage> {
  late Future<dynamic> dbFuture;
  late int numberOfMembers;
  ScrollController controller = ScrollController();
  double topContainer = 0;
  List<dynamic> completedUsersId = [];
  List<dynamic> completedUsersname = [];
  List<UserInfo> userlist = [];

  getData() async {
    dynamic communityDoc;
    communityDoc = await firestore
        .collection('public_communities')
        .doc(widget.comm.id)
        .get();
    if (communityDoc.data() == null) {
      communityDoc = await firestore
          .collection('private_communities')
          .doc(widget.comm.id)
          .get();
    }
    final cuurentCommunityDoc = communityDoc.data()! as dynamic;
    List communitiess = cuurentCommunityDoc['progress_list'];
    for (int i = 0; i < communitiess.length; i++) {
      String x = communitiess[i].toString();
      if (x.substring(x.indexOf(' ') + 1, x.length - 1) == "1.0") {
        //add
        completedUsersId.add(x.substring(1, x.indexOf(':')));
      }
    }

    for (int i = 0; i < completedUsersId.length; i++) {
      dynamic userDoc =
          await firestore.collection("user").doc(completedUsersId[i]).get();
      final users = userDoc.data()! as dynamic;
      completedUsersname.add(users["firstName"]);
      UserInfo user = UserInfo(
          completedUsersId[i], users["avatarURL"] ?? "", users["firstName"], 1);
      userlist.add(user);
    }
    return userlist;
  }

  @override
  initState() {
    dbFuture = getData();

    super.initState();
  }

  CommunityController communityController = Get.find();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/Leaderboard_background.png"),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: FutureBuilder<dynamic>(
              future: dbFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data;
                  if (data.length != 0) {
                    return Center(
                      child: Row(
                        children: [
                          Text(
                            "${data.length} أعضاء ",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 25, 48, 29),
                                fontSize: 23,
                                fontWeight: FontWeight.w800),
                          ),
                          const Text(
                            " قاموا بتحقيق الهدف",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Text("");
                  }
                } else {
                  return const Text("");
                }
              }),
          backgroundColor: Colors.transparent,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ));
            },
          ),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 2.50),
              Column(
                children: [
                  //! you need to syle
                  Container(
                    margin: const EdgeInsets.all(24),
                    padding: const EdgeInsets.all(8),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        SizedBox(
                          width: 8,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                width: size.width,
                alignment: Alignment.topCenter,
                height: size.height * 0.30,
                child: const SizedBox(
                  height: 180,
                  width: 250,
                ),
              ),
              Expanded(
                  child: FutureBuilder<dynamic>(
                future: dbFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length != 0) {
                      final data = snapshot.data;
                      List<Widget> listItems = [];
                      data.forEach((post) {
                        listItems.add(Container(
                          //  margin: const EdgeInsets.symmetric(
                          //       horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20.0)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withAlpha(100),
                                    blurRadius: 10.0),
                              ]),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          padding: const EdgeInsets.only(
                              top: 12, bottom: 12, right: 12),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: GestureDetector(
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => BadgesPage(
                                                avatar: post.avatar,
                                                goalProgress:
                                                    (post.currentCommunityProgress *
                                                            100)
                                                        .round()
                                                        .toInt(),
                                                userId: post.id,
                                              ),
                                            )),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: CircleAvatar(
                                              // display the avatar if added
                                              backgroundImage: post.avatar ==
                                                          null ||
                                                      post.avatar == ""
                                                  ? null
                                                  : CachedNetworkImageProvider(
                                                      post.avatar!,
                                                      errorListener: () {}),
                                              radius: 60,
                                              backgroundColor: kWhiteColor,
                                              child: post.avatar != null ||
                                                      post.avatar != ""
                                                  ? null
                                                  : const Icon(
                                                      Icons
                                                          .account_circle_sharp, //? is better to have the same icon as the one in the side bar
                                                      color: Color.fromARGB(
                                                          31, 0, 0, 0),
                                                      size: 60,
                                                    )),
                                        ),
                                      )),
                                  const SizedBox(width: 20),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(post.firstname,
                                            style: const TextStyle(
                                                fontSize: 20,
                                                color: Color.fromARGB(
                                                    255, 7, 6, 6),
                                                fontWeight: FontWeight.w600)),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                      ])
                                ]),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset('assets/images/medal.png',
                                      width: 43),
                                )
                              ]),
                        ));
                      });

                      return ListView.builder(
                        controller: controller,
                        itemCount: listItems.length,
                        itemBuilder: (context, index) {
                          return Align(
                            alignment: Alignment.topCenter,
                            child: listItems[index],
                          );
                        },
                      );
                    } else {
                      //this for what is displayed if no member finishes the goal yet
                      return Padding(
                        padding: const EdgeInsets.all(80.0),
                        child: Column(
                          children: const [
                            SizedBox(
                              child: Text(
                                //! i don't know how to do it
                                'لايوجد أعضاء حتى الان ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w200,
                                    color: Color.fromARGB(255, 255, 255, 255)),
                              ),
                            ),
                            SizedBox(
                              child: Text(
                                //! i don't know how to do it
                                'سارع بتحقيق هدفك ليظهر اسمك في القائمة',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }

                  /// handles others as you did on question

                  else {
                    return const Padding(
                      padding: EdgeInsets.all(80.0),
                      child: SizedBox(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
