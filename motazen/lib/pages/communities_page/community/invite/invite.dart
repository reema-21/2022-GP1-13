import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/controllers/auth_controller.dart';
import 'package:motazen/models/user.dart';
import 'package:motazen/theme.dart';
import 'package:motazen/controllers/notification_controller.dart';

class User {
  final String name;
  final String username;
  final String image;
  bool isFollowedByMe;

  User(this.name, this.username, this.image, this.isFollowedByMe);
}

class Invite extends StatefulWidget {
  final dynamic comm;
  final List<String> selected;
  const Invite({Key? key, required this.comm, required this.selected})
      : super(key: key);

  @override
  State<Invite> createState() => _InviteState();
}

class _InviteState extends State<Invite> {
  // Define the _searchController and _search variables
  final _searchController = TextEditingController();
  String _search = "";

  // Define the authController and futureGroup variables
  AuthController authController = Get.find<AuthController>();
  FutureGroup futureGroup = FutureGroup();

  //Create an instance of the NotificationController
  NotificationController notificationController = NotificationController();

  // Define the _members and _foundedUsers lists, and the isinvite boolean
  List<Userr> _members = [];
  List<Userr> _foundedUsers = [];
  bool isinvite = true;

  // Initialize the state of the Invite class
  @override
  void initState() {
    super.initState();

    // Add a listener to the _searchController variable
    _searchController.addListener(_updateText);
    // Set the state of the _members list
    setState(() {
      _members = authController.usersList
        ..removeWhere(
            (element) => element.userID == firebaseAuth.currentUser!.uid);
    });

    //Call the listenToNotifications method
    notificationController.listenToNotifications(widget.selected);
  }

  @override
  void dispose() {
    notificationController
        .cancelNotificationsSubscription(); // Cancel the subscription here
    super.dispose();
  }

  // Update the _search variable with the current text
  void _updateText() {
    setState(() {
      _search = _searchController.text;
    });
  }

  // Search for users based on the provided search parameter
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

  // Check if the provided user is a member of the community
  bool isJoined({required Userr user}) {
    if (user.joinedCommunities != null && user.joinedCommunities!.isNotEmpty) {
      for (var element in user.joinedCommunities!) {
        if (element.id == widget.comm.id) {
          return true;
        }
      }
    }

    return false;
  }

  // Invite a user to the community
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
        'founderUserID': widget.comm.founderUserID,
        'goalName': widget.comm.goalName,
        'isPrivate': widget.comm.isPrivate,
        "isDeleted": widget.comm.isDeleted,
        '_id': widget.comm.id
      }
    };

    // Add the community notification to the user's notifications collection
    firestore
        .collection('user')
        .doc(user.userID)
        .collection('notifications')
        .add(communityNotification);
  }

  _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      title: SizedBox(
        height: 38,
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            onSearch(value);
          },
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[450],
              contentPadding: const EdgeInsets.all(0), // Add const here
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey.shade500,
              ),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
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

  static const _nameTextStyle = TextStyle(
    color: Color.fromARGB(255, 7, 6, 6),
    fontWeight: FontWeight.w500,
  );

  static const _usernameTextStyle = TextStyle(
    color: Colors.grey,
  );

  Widget userComponent({required Userr user}) {
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
                      backgroundImage: user.avatarURL == null
                          ? null
                          : CachedNetworkImageProvider(user.avatarURL!,
                              errorListener: () {}),
                      radius: 60,
                      backgroundColor: kWhiteColor,
                      child: user.avatarURL != null
                          ? null
                          : const Icon(
                              Icons.account_circle_sharp,
                              color: Color.fromARGB(31, 0, 0, 0),
                              size: 60,
                            )),
                )),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(user.firstName!, style: _nameTextStyle),
              const SizedBox(
                height: 5,
              ),
              Text(user.userName!, style: _usernameTextStyle),
            ])
          ]),
          _buildInviteButton(user),
        ],
      ),
    );
  }

  Widget _buildInviteButton(Userr user) {
    return GestureDetector(
      onTap: () {
        if (!user.isinvited) {
          notificationController.sendNotification(user.userID!,
              senderId: firebaseAuth.currentUser!.uid,
              type: 'invite',
              userName: firebaseAuth.currentUser!.displayName!,
              senderAvatar: user.avatarURL ?? "",
              community: {
                'progress_list': widget.comm.progressList,
                'aspect': widget.comm.aspect,
                'communityName': widget.comm.communityName,
                'creationDate': widget.comm.creationDate,
                'founderUserID': widget.comm.founderUserID,
                'goalName': widget.comm.goalName,
                'isPrivate': widget.comm.isPrivate,
                "isDeleted": widget.comm.isDeleted,
                '_id': widget.comm.id
              });
          setState(() {
            user.isinvited = true;
          });
        }
      },
      child: AnimatedContainer(
          height: 35,
          width: 110,
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
              color: isJoined(user: user)
                  ? const Color.fromARGB(54, 161, 161, 161)
                  : user.isinvited
                      ? const Color.fromARGB(151, 25, 118, 210)
                      : const Color(0x00ffffff),
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
    );
  }
}
