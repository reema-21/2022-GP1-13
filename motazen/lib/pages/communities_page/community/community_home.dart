import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motazen/models/post_model.dart';
import 'package:motazen/pages/communities_page/community/posts/community_post_design.dart';
import 'package:motazen/theme.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../Sidebar_and_navigation/navigation_bar.dart';
import '../../../controllers/auth_controller.dart';
import 'community_info.dart';

//DONE
class CommunityHomePage extends StatefulWidget {
  const CommunityHomePage(
      {Key? key,
      required this.comm,
      this.cameFromNotification,
      required this.fromInvite})
      : super(key: key);
  final dynamic comm;
  final dynamic cameFromNotification;
  final dynamic fromInvite;

  @override
  State<CommunityHomePage> createState() => _CommunityHomePageState();
}

class _CommunityHomePageState extends State<CommunityHomePage> {
  @override
  void initState() {
    _dbRef.ref('post_channels/${widget.comm.id}/isActive/').get().then((value) {
      loadfinished = true;
      if (value.value != null) {
        isActiveCommunity = value.value as bool;
      }
      setState(() {});
    });
    super.initState();
  }

  bool isActiveCommunity = true;
  bool loadfinished = false;
  String _post = '';
  final TextEditingController _postController = TextEditingController();
  final ItemScrollController itemScrollController = ItemScrollController();
  final _dbRef = FirebaseDatabase.instance;
  PostModel? replyingPost;
  bool isReplying = false;
  bool isSendingImage = false;
  int initialIndex = 0;
  bool initialCome = true;
  _addPost() {
    final user = FirebaseAuth.instance.currentUser;
    final time = DateTime.now().toUtc().millisecondsSinceEpoch;
    _dbRef
        .ref('post_channels/${widget.comm.id}/post/')
        .child('${time.toString()}${user!.uid}')
        .set({
      'post_type': 'text',
      'author': user.displayName,
      'author_id': user.uid,
      'time': time,
      'text': _post,
      'comment': [],
      'likes': [],
      'replied_post': replyingPost?.toJson()
    });
    if (replyingPost != null && replyingPost!.authorId != user.uid) {
      firestore
          .collection('user')
          .doc(replyingPost!.authorId)
          .collection('notifications')
          .add({
        'sender_avatar': authController.currentUser.value.avatarURL ?? "",
        'sender_id': firebaseAuth.currentUser!.uid,
        'creation_date': DateTime.now(),
        'type': 'reply',
        'reply': replyingPost!.postType == 'text'
            ? replyingPost!.text
            : 'Attachment (Image)',
        'community_link': widget.comm.id,
        'post': PostModel(
                text: _post,
                postType: 'text',
                author: user.displayName,
                authorId: user.uid,
                time: time,
                comments: [],
                likes: [],
                replyingPost: null,
                imageURL: null)
            .toJson(),
        'userName': user.displayName,
      });
    }
    setState(() {
      replyingPost = null;
      _post = '';
    });
  }

  AuthController authController = Get.find();

  _likeTheText(PostModel pst, String link) {
    final user = FirebaseAuth.instance.currentUser;
    var newList = List<dynamic>.from(pst.likes);
    newList.add(user!.uid);
    _dbRef.ref(link).child('likes').set(newList);
    if (pst.authorId != user.uid) {
      firestore
          .collection('user')
          .doc(pst.authorId)
          .collection('notifications')
          .add({
        'sender_avatar': authController.currentUser.value.avatarURL ?? "",
        'sender_id': firebaseAuth.currentUser!.uid,
        'creation_date': DateTime.now(),
        'community_link': widget.comm.id,
        'type': 'like',
        'post': pst.toJson(),
        'userName': user.displayName,
      });
    }
  }

  _unlikeTheText(PostModel pst, String link) {
    final user = FirebaseAuth.instance.currentUser;
    var newList = List<dynamic>.from(pst.likes);
    newList.remove(user!.uid);
    _dbRef.ref(link).child('likes').set(newList);

    firestore
        .collection('user')
        .doc(pst.authorId)
        .collection('notifications')
        .where('type', isEqualTo: 'like')
        .where('userName', isEqualTo: user.displayName)
        .where('post', isEqualTo: pst.toJson())
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }

  File? imageFile;
  Future getImage() async {
    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imageFile = File(image.path);
      setState(() {
        isSendingImage = true;
      });
    }
  }

  Future uploadImage() async {
    final user = FirebaseAuth.instance.currentUser;
    final time = DateTime.now().toUtc().millisecondsSinceEpoch;
    final ref = FirebaseStorage.instance
        .ref()
        .child('images')
        .child('${user!.uid}_$time.jpg');
    var putFile = await ref.putFile(imageFile!);
    String imageURL = await putFile.ref.getDownloadURL();

    _dbRef
        .ref('post_channels/${widget.comm.id}/post/')
        .child('${time.toString()}${user.uid}')
        .set({
      'post_type': 'image',
      'author': user.displayName,
      'author_id': user.uid,
      'time': time,
      'text': _post,
      'comment': [],
      'likes': [],
      'image_url': imageURL,
      'replied_post': replyingPost?.toJson()
    });

    if (replyingPost != null && replyingPost!.authorId != user.uid) {
      firestore
          .collection('user')
          .doc(replyingPost!.authorId)
          .collection('notifications')
          .add({
        'sender_avatar': authController.currentUser.value.avatarURL ?? "",
        'sender_id': firebaseAuth.currentUser!.uid,
        // 'sender_id': firebaseAuth.currentUser!.uid,
        'creation_date': DateTime.now(),
        'type': 'reply',
        'reply': replyingPost!.postType == 'text'
            ? replyingPost!.text
            : 'Attachment (Image)',
        'community_link': widget.comm.id,
        'post': PostModel(
                text: _post,
                postType: 'text',
                author: user.displayName,
                authorId: user.uid,
                time: time,
                comments: [],
                likes: [],
                replyingPost: null,
                imageURL: null)
            .toJson(),
        'userName': user.displayName,
      });
    }
    setState(() {
      _post = '';
      replyingPost = null;
      imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const NavBar(selectedIndex: 2)));
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.grey,
                ));
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: GestureDetector(
          onTap: () {
            Get.to(() => CommunityInfo(
                comm: widget.comm, fromInvite: widget.fromInvite));
          },
          child: Text(
            '${widget.comm.communityName}',
            style: const TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: StreamBuilder(
                  stream: _dbRef
                      .ref('post_channels/${widget.comm.id}')
                      .child('post')
                      .onValue,
                  builder: (context, snapshot) {
                    List<PostModel> postList = [];
                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        (snapshot.data!).snapshot.value != null) {
                      final myPosts = Map<dynamic, dynamic>.from(
                          (snapshot.data!).snapshot.value
                              as Map<dynamic, dynamic>);
                      myPosts.forEach((key, value) {
                        final currentPost = Map<String, dynamic>.from(value);

                        postList.add(PostModel(
                            author: currentPost['author'],
                            authorId: currentPost['author_id'],
                            text: currentPost['text'],
                            time: currentPost['time'],
                            likes: currentPost['likes'] ?? [],
                            comments: currentPost['comment'] ?? [],
                            replyingPost: currentPost['replied_post'],
                            postType: currentPost['post_type'] ?? 'text',
                            imageURL: currentPost['image_url']));
                      });
                      if (postList.length > 1) {
                        postList.sort((b, a) => a.time.compareTo(b.time));
                        if (initialCome &&
                            widget.cameFromNotification != null) {
                          initialIndex = postList.indexWhere((element) =>
                              element.authorId ==
                                  widget.cameFromNotification['author_id'] &&
                              element.time ==
                                  widget.cameFromNotification['time']);
                        }
                      }

                      return ScrollablePositionedList.builder(
                        physics: const BouncingScrollPhysics(),
                        reverse: true,
                        itemCount: postList.length,
                        itemScrollController: itemScrollController,
                        initialScrollIndex: initialIndex,
                        itemBuilder: (context, index) {
                          return PostDesign(
                              communityId: widget.comm.id,
                              post: postList[index],
                              dbpathToPostChnl:
                                  'post_channels/${widget.comm.id}/post',
                              commentCallback: (PostModel pst) {
                                setState(() {
                                  isReplying = true;
                                  replyingPost = pst;
                                });
                              },
                              likeCallback: (PostModel pst, String link) {
                                final currentUserId =
                                    FirebaseAuth.instance.currentUser!.uid;
                                if (currentUserId == pst.authorId) {
                                  log('cant like your own message');
                                  return;
                                }
                                if (pst.likes.contains(currentUserId)) {
                                  _unlikeTheText(pst, link);
                                  FirebaseFirestore.instance
                                      .collection('user')
                                      .doc(pst.authorId)
                                      .update({
                                    'messageLikedUserIds':
                                        FieldValue.arrayRemove(
                                      [
                                        currentUserId,
                                      ],
                                    )
                                  });
                                } else {
                                  _likeTheText(pst, link);
                                  FirebaseFirestore.instance
                                      .collection('user')
                                      .doc(pst.authorId)
                                      .update({
                                    'messageLikedUserIds':
                                        FieldValue.arrayUnion(
                                      [
                                        currentUserId,
                                      ],
                                    )
                                  });
                                }
                              },
                              repliedPostScrollCallback: (final pst) {
                                itemScrollController.scrollTo(
                                    index: postList.indexWhere((element) =>
                                        element.authorId == pst['author_id'] &&
                                        element.time == pst['time']),
                                    duration: const Duration(seconds: 1),
                                    curve: Curves.easeInOutCubic);
                              });
                        },
                      );
                    } else {
                      return Center(
                        child: widget.comm.isDeleted
                            ? null
                            : const Text(
                                'قل مرحبا...',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 21,
                                    fontWeight: FontWeight.w400),
                              ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              if (!loadfinished)
                Container(
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              if (isActiveCommunity && loadfinished && !widget.comm.isDeleted)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        if (isReplying)
                          Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 3,
                              vertical: 10,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(width: 8),
                                Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width /
                                              1.4,
                                      minWidth:
                                          MediaQuery.of(context).size.width /
                                              1.4),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${replyingPost!.author}',
                                        style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      if (replyingPost!.text != '')
                                        Text(
                                          '${replyingPost!.text}',
                                          style: TextStyle(
                                            color: Colors.grey[800],
                                            fontSize: 12,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      if (replyingPost!.postType == 'image')
                                        Container(
                                            constraints: BoxConstraints(
                                              maxHeight: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3,
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: replyingPost!.imageURL,
                                              placeholder: (context, url) =>
                                                  const CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ))
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isReplying = false;
                                        isSendingImage = false;
                                        replyingPost = null;
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.green,
                                      size: 30,
                                    ))
                              ],
                            ),
                          ),
                        if (isSendingImage)
                          Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 3,
                              vertical: 10,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(width: 8),
                                Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width /
                                              1.4),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                      constraints: BoxConstraints(
                                        maxHeight:
                                            MediaQuery.of(context).size.width /
                                                1.75,
                                      ),
                                      child: Image.file(imageFile!)),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isSendingImage = false;
                                        imageFile = null;
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.green,
                                      size: 30,
                                    ))
                              ],
                            ),
                          ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: () async {
                                  await getImage();
                                },
                                icon: Transform.rotate(
                                  angle: 1600 * 3.14,
                                  child: const Icon(
                                    Icons.attach_file,
                                    color: Colors.green,
                                    size: 30,
                                  ),
                                )),
                            Expanded(
                              child: TextField(
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 17),
                                cursorColor: Colors.black,
                                controller: _postController,
                                decoration: InputDecoration(
                                  hintText: 'أرسل شيئا...',
                                  hintStyle: TextStyle(
                                      color: Colors.grey[400], fontSize: 16),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.all(10),
                                ),
                                textCapitalization:
                                    TextCapitalization.sentences,
                                minLines: 1,
                                maxLines: 5,
                                onChanged: (value) {
                                  setState(() {
                                    _post = value;
                                  });
                                },
                              ),
                            ),
                            IconButton(
                                onPressed: _post == '' && imageFile == null
                                    ? null
                                    : imageFile == null
                                        ? () {
                                            setState(() {
                                              isReplying = false;
                                              _postController.clear();
                                              _addPost();
                                            });
                                          }
                                        : () {
                                            setState(() {
                                              isReplying = false;
                                              _postController.clear();
                                              isSendingImage = false;
                                              uploadImage();
                                            });
                                          },
                                icon: Icon(
                                  Icons.send,
                                  color: _postController.text == '' &&
                                          imageFile == null
                                      ? Colors.grey
                                      : Colors.green,
                                  size: 30,
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
      bottomSheet: (!isActiveCommunity && loadfinished) || widget.comm.isDeleted
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.priority_high,
                    color: Color.fromARGB(255, 105, 104, 104)),
                Padding(
                    padding: EdgeInsets.all(13.0),
                    child: Text(
                      "لايمكنك الإرسال ،هذا المجتمع محذوف ",
                      style:
                          TextStyle(color: Color.fromARGB(255, 105, 104, 104)),
                    )),
              ],
            )
          : null,
    );
  }
}
