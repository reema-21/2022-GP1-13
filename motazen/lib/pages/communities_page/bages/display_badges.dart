import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motazen/pages/communities_page/bages/display_badge_info.dart';
import 'package:motazen/theme.dart';

class BadgesPage extends StatelessWidget {
  BadgesPage({super.key});
  //! later it should get the bages from the user
  //! have the unachieved ones deactivated
  final userID =
      FirebaseAuth.instance.currentUser; //! later fix with provider auth
  List badges = [
    {
      'name': '1',
      'state': 'active',
      'description':
          'يقدم هذا الوسام للمستخدم عنما يحصل على ١٠ اعجابات في المجموعة'
    },
    {
      'name': '2',
      'state': 'active',
      'description':
          'يقدم هذا الوسام للمستخدم عنما يحصل على ٣٠ اعجابات في المجموعة'
    },
    {
      'name': '3',
      'state': 'active',
      'description':
          'يقدم هذا الوسام للمستخدم عنما يحصل على ٥٠ اعجابات في المجموعة'
    },
    {
      'name': '4',
      'state': 'inactive',
      'description':
          'يقدم هذا الوسام للمستخدم عنما يحصل على ٨٠ اعجابات في المجموعة'
    },
    {
      'name': '5',
      'state': 'inactive',
      'description':
          'يقدم هذا الوسام للمستخدم عنما يحصل على ١٥٠ اعجابات في المجموعة'
    },
    {
      'name': '6',
      'state': 'inactive',
      'description':
          'يقدم هذا الوسام للمستخدم عنما يحصل على ٥٠٠ اعجابات في المجموعة'
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'إنجازاتي', // أوسمتي
          style: titleText,
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                      color: kPrimaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: kPrimaryColor.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 0), // changes position of shadow
                        ),
                      ],
                      shape: BoxShape.circle,
                      image: const DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                              'https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-social-media-user-portrait-176256935.jpg')))), //user image

              Text(
                '${FirebaseAuth.instance.currentUser!.displayName}',
                textScaleFactor: 1.5,
                overflow: TextOverflow.visible,
              ),
              StreamBuilder(
                stream: firestore
                    .collection('user')
                    .doc(firebaseAuth.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  return snapshot.hasData && snapshot.data!['userName'] != null
                      ? Text(
                          snapshot.hasData
                              ? '${snapshot.data!['userName']}@'
                              : '',
                          textScaleFactor: 1,
                          overflow: TextOverflow.visible,
                          style: const TextStyle(height: 1),
                        )
                      : const SizedBox();
                },
              ), // username
              //? should I also display the goal progress here?
              Text(
                "30% ",
                textScaleFactor: 2,
                overflow: TextOverflow.visible,
                style: titleText3,
              ),
              const Divider(thickness: 1),
              // ignore: prefer_const_constructors
              SizedBox(
                height: 40,
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: 6, //* set a fixed number temporarly
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
                            width: 100.0,
                            height: 100.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage(
                                        "assets/images/BADGE${badges[index]['name']}.png"),
                                    colorFilter:
                                        badges[index]['state'] == 'inactive'
                                            ? ColorFilter.mode(
                                                Colors.grey.withOpacity(0.8),
                                                BlendMode.modulate,
                                              )
                                            : null)),
                          ), //the clickable image
                          //the name of the badge
                        ),
                        Expanded(
                          child: Text(
                            badges[index]['name'],
                            textScaleFactor: 1.3,
                            overflow: TextOverflow.visible,
                            style: const TextStyle(height: 2),
                          ),
                        ),
                      ],
                    ));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
