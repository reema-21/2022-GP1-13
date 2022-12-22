// ignore_for_file: prefer_typing_uninitialized_variables, library_private_types_in_public_api, prefer_final_fields

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:motazen/models/post_model.dart';
import 'package:motazen/pages/communities_page/community_post_design.dart';

class CommunityHomePage extends StatefulWidget {
  const CommunityHomePage({Key? key, required this.comm}) : super(key: key);
  final comm;

  @override
  _CommunityHomePageState createState() => _CommunityHomePageState();
}

class _CommunityHomePageState extends State<CommunityHomePage> {
  String _post = '';
  TextEditingController _postController = TextEditingController();
  final _dbRef = FirebaseDatabase.instance;
  PostModel? replyingPost;
  bool isReplying = false;
  _addPost() {
    final user = FirebaseAuth.instance.currentUser;
    final time = DateTime.now().toUtc().millisecondsSinceEpoch;
    _dbRef
        .ref('post_channels/${widget.comm.id}/post/')
        .child('${time.toString()}${user!.uid}')
        .set({
      'author': user.displayName,
      'author_id': user.uid,
      'time': time,
      'text': _post,
      'comment': [],
      'likes': 0,
      'replied_post': replyingPost?.toJson()
    });
    // print('object');
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
        title: Text(
          '${widget.comm.communityName}',
          style: const TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
      body: Padding(
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
                  // print('snapshot=> $snapshot');
                  List<PostModel> postList = [];
                  if (snapshot.hasData &&
                      snapshot.data != null &&
                      (snapshot.data!).snapshot.value != null) {
                    final myPosts = Map<dynamic, dynamic>.from((snapshot.data!)
                        .snapshot
                        .value as Map<dynamic, dynamic>);
                    myPosts.forEach((key, value) {
                      final currentPost = Map<String, dynamic>.from(value);

                      postList.add(PostModel(
                          author: currentPost['author'],
                          authorId: currentPost['author_id'],
                          text: currentPost['text'],
                          time: currentPost['time'],
                          likes: currentPost['likes'],
                          comments: currentPost['comment'],
                          replyingPost: currentPost['replied_post']));
                    });
                    if (postList.length > 1) {
                      postList.sort((b, a) => a.time.compareTo(b.time));
                    }

                    // print(postList.isEmpty);
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      reverse: true,
                      itemCount: postList.length,
                      itemBuilder: (context, index) {
                        return PostDesign(
                          post: postList[index],
                          dbpathToPostChnl:
                              'post_channels/${widget.comm.id}/post',
                          callback: (PostModel pst) {
                            setState(() {
                              isReplying = true;
                              replyingPost = pst;
                            });
                          },
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text(
                        '...ارسل مرحبا',
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
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
                          textDirection: TextDirection.rtl,
                          children: [
                            const SizedBox(width: 8),
                            Container(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width / 1.4,
                                  minWidth:
                                      MediaQuery.of(context).size.width / 1.4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                textDirection: TextDirection.rtl,
                                children: [
                                  Text(
                                    '${replyingPost!.author}',
                                    style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${replyingPost!.text}',
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {},
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
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 17),
                            cursorColor: Colors.black,
                            controller: _postController,
                            decoration: InputDecoration(
                              hintText: 'شارك برسالة...',
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
                            textCapitalization: TextCapitalization.sentences,
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
                            onPressed: _post == ''
                                ? null
                                : () {
                                    _postController.clear();
                                    _addPost();
                                    setState(() {
                                      _post = '';
                                      isReplying = false;
                                      replyingPost = null;
                                    });
                                  },
                            icon: Icon(
                              Icons.send,
                              color: _post == '' ? Colors.grey : Colors.green,
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
    );
  }
}
