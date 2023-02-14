// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/pages/communities_page/about_community.dart';
import 'package:motazen/theme.dart';

class CommunityLeaderboardPage extends StatefulWidget {
  final comm;
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
  List<dynamic> CompletedUsersId = [];
  List<dynamic> CompletedUsersname = [];

  getData() async {
    dynamic CommunityDoc;
    CommunityDoc = await firestore
        .collection('public_communities')
        .doc(widget.comm.id)
        .get();
    if (CommunityDoc.data() == null) {
      CommunityDoc = await firestore
          .collection('private_communities')
          .doc(widget.comm.id)
          .get();
    }
    final cuurentCommunityDoc = CommunityDoc.data()! as dynamic;
    List communitiess = cuurentCommunityDoc['progress_list'];
    for (int i = 0; i < communitiess.length; i++) {
      String x = communitiess[i].toString();
      if (x.substring(x.indexOf(' ') + 1, x.length - 1) == "1.0") {
        //add
        CompletedUsersId.add(x.substring(1, x.indexOf(':')));
      }
    }
    for (int i = 0; i < CompletedUsersId.length; i++) {}

    for (int i = 0; i < CompletedUsersId.length; i++) {
      dynamic UserDoc =
          await firestore.collection("user").doc(CompletedUsersId[i]).get();
      final users = UserDoc.data()! as dynamic;
      CompletedUsersname.add(users["firstName"]);
    }
    return CompletedUsersname;
  }

  @override
  initState() {
    dbFuture = getData();

    super.initState();
  }

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
          leading: IconButton(
              onPressed: () {
                Get.to(AboutCommunityPage(comm: widget.comm));
              },
              icon: const Icon(
                Icons.more_horiz,
                color: Colors.white,
              )),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          actions: [
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ));
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '${widget.comm.communityName}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 30,
                    letterSpacing: 0.54,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              const SizedBox(height: 2.50),
              FutureBuilder<dynamic>(
                  future: dbFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data;
                      if (data.length != 0) {
                        return Text(
                          "${data.length} أعضاء",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        );
                      } else {
                        return const Text("");
                      }
                    } else {
                      return const Text("");
                    }
                  }),
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
                      int i = 1;
                      data.forEach((post) {
                        listItems.add(Container(
                            height: 75,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20.0)),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withAlpha(100),
                                      blurRadius: 10.0),
                                ]),
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 10),
                                child: ListTile(
                                  dense: true,
                                  visualDensity:
                                      const VisualDensity(vertical: -3),
                                  title: Text(
                                    "$post",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 16.0),
                                  leading: const SizedBox(
                                    width: 50,
                                    child: CircleAvatar(
                                        backgroundImage: AssetImage(
                                            "assets/images/Profile Image.webp")),
                                  ),
                                  trailing: Image.asset(
                                      'assets/images/medal.png',
                                      width: 40),
                                ))));
                      });

                      return ListView.builder(
                        controller: controller,
                        itemCount: listItems.length,
                        itemBuilder: (context, index) {
                          return Align(
                            heightFactor: 0.7,
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
