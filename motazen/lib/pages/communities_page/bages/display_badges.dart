import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motazen/pages/communities_page/bages/display_badge_info.dart';
import 'package:motazen/theme.dart';

class BadgesPage extends StatelessWidget {
  BadgesPage(
      {super.key,
      required this.goalProgress,
      required this.userId,
      required this.avatar});
  final int goalProgress;
  final dynamic userId;
  final String avatar;

  final List badges = [
    {
      'name': 'مبتدئ',
      'state': '',
      'description':
          'يقدم هذا الوسام للمستخدم عندما يحصل على ٢٥ اعجاب في المجموعة',
      'badgePath': 'assets/badges/Artboard 2_1.png',
    },
    {
      'name': 'متوسط',
      'state': '',
      'description':
          'يقدم هذا الوسام للمستخدم عندما يحصل على ٥٠ اعجاب في المجموعة',
      'badgePath': 'assets/badges/Artboard 2_2.png',
    },
    {
      'name': 'محترف',
      'state': '',
      'description':
          'يقدم هذا الوسام للمستخدم عندما يحصل على ١٠٠ اعجاب في المجموعة',
      'badgePath': 'assets/badges/Artboard 2_3.png',
    }, //! the last value is random, change later
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assets/images/badges_background.png'),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'إنجازاتي', // أوسمتي
            style: titleText,
          ),
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
        ),
        body: FutureBuilder(
          future:
              FirebaseFirestore.instance.collection('user').doc(userId).get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Container();
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CupertinoActivityIndicator(); //! later replace with shimmer effect
            } else {
              final List listOfLikes =
                  snapshot.data!.data()?['messageLikedUserIds'] ?? [];

              if (listOfLikes.length < 25) {
                //if the user has less than 25 likes then all badges are inactive
                badges[0]['state'] = 'inactive';
                badges[1]['state'] = 'inactive';
                badges[2]['state'] = 'inactive';
              } else if (listOfLikes.length >= 25) {
                //if the user has at least 25 likes then only the first badge is active
                badges[0]['state'] = 'active';
                badges[1]['state'] = 'inactive';
                badges[2]['state'] = 'inactive';
              } else if (listOfLikes.length >= 50) {
                //if the user has at least 50 likes then the first and second badges are active
                badges[0]['state'] = 'active';
                badges[1]['state'] = 'active';
                badges[2]['state'] = 'inactive';
              } else {
                //if the user has at least xxx likes then all badges are active
                badges[0]['state'] = 'active';
                badges[1]['state'] = 'active';
                badges[2]['state'] = 'active';
              }
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                    width: 140.0,
                    height: 140.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CircleAvatar(
                          // display the avatar if added
                          backgroundImage: avatar == ""
                              ? null
                              : CachedNetworkImageProvider(avatar,
                                  errorListener: () {}),
                          radius: 60,
                          backgroundColor: Colors.transparent,
                          child: avatar != ""
                              ? null
                              : const Icon(
                                  Icons.account_circle_sharp,
                                  color: Color.fromARGB(31, 0, 0, 0),
                                  size: 150,
                                )),
                    )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      snapshot.hasData ? '${snapshot.data!['firstName']}' : '',
                      textScaleFactor: 1.5,
                      overflow: TextOverflow.visible,
                    ),
                    Text(
                      snapshot.hasData ? '${snapshot.data!['userName']}@' : '',
                      textScaleFactor: 1,
                      overflow: TextOverflow.visible,
                      style: const TextStyle(height: 1),
                    )
                  ],
                ), //user image

                Text(
                  "${goalProgress.round()}% ",
                  textScaleFactor: 2,
                  overflow: TextOverflow.visible,
                  style: titleText3,
                ),
                const Divider(
                  thickness: 1,
                  endIndent: 20,
                  indent: 20,
                ),
                const SizedBox(
                  height: 40,
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Center(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => badges[index]['state'] == 'active'
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return BadgeInfo(
                                          badge: badges[index],
                                        );
                                      },
                                    ),
                                  )
                                : null, //! later set a condition to see if achieved is true
                            child: Container(
                              width: 150.0,
                              height: 150.0,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage(
                                          badges[index]['badgePath']),
                                      colorFilter:
                                          badges[index]['state'] != 'active'
                                              ? ColorFilter.mode(
                                                  Colors.grey[800]!,
                                                  BlendMode.modulate,
                                                )
                                              : null)),
                            ), //the clickable image
                            //the name of the badge
                          ),
                          Text(
                            badges[index]['name'],
                            textScaleFactor: 1.3,
                            overflow: TextOverflow.visible,
                            style: const TextStyle(height: 2),
                          ),
                        ],
                      ));
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
