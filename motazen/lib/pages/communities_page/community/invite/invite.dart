import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/controllers/auth_controller.dart';
import 'package:motazen/models/user.dart';
import 'package:motazen/theme.dart';

//DONEnNOW
// import 'package:flutter_slidable/flutter_slidable.dart';
class User {
  final String name;
  final String username;
  final String image;
  bool isFollowedByMe;

  User(this.name, this.username, this.image, this.isFollowedByMe);
}

class Invite extends StatefulWidget {
  final dynamic comm;
  const Invite({Key? key, required this.comm}) : super(key: key);

  @override
  State<Invite> createState() => _InviteState();
}

class _InviteState extends State<Invite> {
  final _searchController = TextEditingController();
  String _search = "";

  AuthController authController = Get.find();
  FutureGroup futureGroup = FutureGroup();
  List<Userr> _members = [];
  List<Userr> _foundedUsers = [];
  bool isinvite = true;

// add an attribute to the user model inviteIsSended  and then make it false for all thne check the invitaion collection in firebase and then adjust the boolean ans use that bool eversince
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_updateText);

    setState(() {
//assign member to the userlist after seleting your account

      _members = authController.usersList
        ..removeWhere(
            (element) => element.userID == firebaseAuth.currentUser!.uid);
    });
    // here give value to isinited
    for (int i = 0; i < _members.length; i++) {
      //fetch notification collection
      final communityNotification = {
        'userName': firebaseAuth.currentUser!.displayName,
        'sender_avatar': authController.currentUser.value.avatarURL ?? "",
        'sender_id': firebaseAuth.currentUser!.uid,
        'creation_date': widget.comm.creationDate,
        'type': 'invite',
        'community': {
          'progress_list': widget.comm.progressList,
          'aspect': widget.comm.aspect,
          'communityName': widget.comm.communityName,
          'creationDate': widget.comm.creationDate,
          'founderUsername': widget.comm.founderUsername,
          'goalName': widget.comm.goalName,
          'isPrivate': widget.comm.isPrivate,
          "isDeleted": widget.comm.isDeleted,
          '_id': widget.comm.id
        }
      };
      firestore
          .collection('user')
          .doc(_members[i].userID)
          .collection('notifications')
          .where('type', isEqualTo: 'invite')
          .where('community', isEqualTo: communityNotification['community'])
          .get()
          .then((value) {
        if (value.docs.isEmpty) {
        } else {
          setState(() {
            _members[i].isinvited = true;
          });
        }
      });
      // check whether there or not
    }
  }

  void _updateText() {
    setState(() {
      _search = _searchController.text;
    });
  }

  onSearch(String search) {
    setState(() {
      if (search == "" || search.isEmpty) {
        _foundedUsers = [];
        _search = "";
      } else {
        _foundedUsers = _members
            .where((user) => user.userName!.toLowerCase().contains(search))
            .toList();
      }
    });
  }

  bool isJoined({required Userr user}) {
    //* this method to check whether the user is a member or not
    if (user.joinedCommunities != null && user.joinedCommunities!.isNotEmpty) {
      for (var element in user.joinedCommunities!) {
        if (element.id == widget.comm.id) {
          return true;
        }
      }
    }

    return false;
  }

  inviteUser({required Userr user}) {
    final communityNotification = {
      'userName': firebaseAuth.currentUser!.displayName,
      'sender_avatar': authController.currentUser.value.avatarURL ?? "",
      'sender_id': firebaseAuth.currentUser!.uid,
      'creation_date': widget.comm.creationDate,
      'type': 'invite',
      'community': {
        'progress_list': widget.comm.progressList,
        'aspect': widget.comm.aspect,
        'communityName': widget.comm.communityName,
        'creationDate': widget.comm.creationDate,
        'founderUsername': widget.comm.founderUsername,
        'goalName': widget.comm.goalName,
        'isPrivate': widget.comm.isPrivate,
        "isDeleted": widget.comm.isDeleted,
        '_id': widget.comm.id
      }
    };
    firestore
        .collection('user')
        .doc(user.userID)
        .collection('notifications')
        .add(communityNotification);
  }

  // first step show the users with right info
  // to check if  the user a member see if the id is in the joined
  // if not added before with add button
  //click on add and changes to added and  send notification
  //accept notification and see whether now they showd as added before
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 240, 240, 240), //!change
        title: SizedBox(
          height: 38,
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              onSearch(value);
            },
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[450], //!change
                contentPadding: const EdgeInsets.all(0),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade500,
                ), //!change
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none),
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                hintText: "أبحث عن الأصدقاء"),
          ),
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
      body: Container(
          padding: const EdgeInsets.only(right: 20, left: 20),
          color: const Color.fromARGB(255, 240, 240, 240),
          child: _foundedUsers.isNotEmpty
              ? ListView.builder(
                  itemCount: _foundedUsers.length,
                  itemBuilder: (context, index) {
                    return userComponent(user: _foundedUsers[index]);
                  },
                )
              : _search != ""
                  ? Center(
                      child: Text(
                      "لايوجد هذا المستخدم ",
                      style: TextStyle(color: Colors.grey[950]),
                    ))
                  : null),
    );
  }

  userComponent({required Userr user}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            SizedBox(
                width: 60,
                height: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CircleAvatar(
                      // display the avatar if added
                      backgroundImage: user.avatarURL == null
                          ? null
                          : CachedNetworkImageProvider(user.avatarURL!,
                              errorListener: () {}),
                      radius: 60,
                      backgroundColor: kWhiteColor,
                      child: user.avatarURL != null
                          ? null
                          : const Icon(
                              Icons
                                  .account_circle_sharp, //? is better to have the same icon as the one in the side bar
                              color: Color.fromARGB(31, 0, 0, 0),
                              size: 60,
                            )),
                )),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(user.firstName!,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 7, 6, 6),
                      fontWeight: FontWeight.w500)),
              const SizedBox(
                height: 5,
              ),
              Text(user.userName!, style: TextStyle(color: Colors.grey[900])),
            ])
          ]),
          GestureDetector(
            onTap: () {
              if (!user.isinvited) {
                inviteUser(user: user);
                setState(() {
                  user.isinvited = true;
                });
              }
            },
            //TODO try it when a user has no joined community
            child: AnimatedContainer(
                height: 35,
                width: 110,
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                    //! here you need to check baout the state of the uuser whether it is invite a member of nothing
                    color: isJoined(user: user)
                        ? const Color.fromARGB(54, 161, 161, 161)
                        : user.isinvited
                            ? const Color.fromARGB(151, 25, 118, 210)
                            : const Color(0x00ffffff),
                    // : Color(0xffffff),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: isJoined(user: user)
                          ? const Color.fromARGB(0, 0, 0, 0)
                          : Colors.grey.shade700,
                    )),
                child: Center(
                    child: Text(
                        isJoined(user: user)
                            ? 'مضاف مسبقاً'
                            : user.isinvited
                                ? 'تمت دعوته'
                                : "إضافة",
                        style: TextStyle(
                            color: isJoined(user: user)
                                ? const Color.fromARGB(255, 142, 139, 143)
                                : user.isinvited
                                    ? Colors.white
                                    : Colors.black)))),
          )
        ],
      ),
    );
  }
}
