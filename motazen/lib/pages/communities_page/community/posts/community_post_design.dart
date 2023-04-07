// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motazen/models/post_model.dart';
import 'package:motazen/pages/communities_page/community/posts/others_message_design.dart';
import 'package:motazen/pages/communities_page/community/posts/own_messages_design.dart';
import 'package:motazen/theme.dart';

class PostDesign extends StatefulWidget {
  final communityId;
  final PostModel post;
  final dbpathToPostChnl;
  final commentCallback;
  final likeCallback;
  final repliedPostScrollCallback;
  const PostDesign(
      {Key? key,
      required this.communityId,
      required this.post,
      required this.dbpathToPostChnl,
      this.commentCallback,
      this.likeCallback,
      this.repliedPostScrollCallback})
      : super(key: key);

  @override
  State<PostDesign> createState() => _PostDesignState();
}

class _PostDesignState extends State<PostDesign> {
  late Future<dynamic> dbFuture;
  String avatar = "";
  Future<dynamic> getData() async {
    dynamic userDoc;
    userDoc =
        await firestore.collection('user').doc(widget.post.authorId).get();
    final cuurentuserDoc = userDoc.data()! as dynamic;
    if (cuurentuserDoc["avatarURL"] != null) {
      avatar = cuurentuserDoc["avatarURL"];
    }

    //here i just check if the community data is null meaning it is a private community
    dynamic communityDoc;
    communityDoc = await firestore
        .collection('public_communities')
        .doc(widget.communityId)
        .get();
    if (communityDoc.data() == null) {
      communityDoc = await firestore
          .collection('private_communities')
          .doc(widget.communityId)
          .get();
    }
    final cuurentcommunityDoc = communityDoc.data()! as dynamic;

    return cuurentcommunityDoc;
  }

  @override
  initState() {
    dbFuture = getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: dbFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Container(); // your widget while loading //! here we must use any indicator
          }

          if (snapshot.hasData) {
            final data = snapshot.data; //your Map<String,dynamic>
            List communitiess = [];
            communitiess = data['progress_list'];
            late double authProgress;
            for (int i = 0; i < communitiess.length; i++) {
              if (communitiess[i][widget.post.authorId] != null) {
                authProgress = communitiess[i][widget.post.authorId]
                    .toDouble(); // the casting is a must cause if it is zero it will reutrn int
                break;
              }
            }
            final authid = widget.post.authorId;

            final cuser = FirebaseAuth.instance.currentUser!.uid;
            // try to get the avatar of the user with this id

            if (authid == cuser) {
              return OwnMessageDesign(
                  pst: widget.post,
                  postLink: widget.dbpathToPostChnl,
                  commentCallback: widget.commentCallback,
                  likeCallback: widget.likeCallback,
                  authID: cuser,
                  repliedPostScrollCallback: widget.repliedPostScrollCallback,
                  progressList: authProgress.toInt());
            } else {
              return OtherMessageDesign(
                  avatar: avatar,
                  pst: widget.post,
                  postLink: widget.dbpathToPostChnl,
                  commentCallback: widget.commentCallback,
                  likeCallback: widget.likeCallback,
                  authID: cuser,
                  repliedPostScrollCallback: widget.repliedPostScrollCallback,
                  progressValue: authProgress);
            }
          } else {
            return Container();
          }
          // } else {
          //   final authid = widget.post.authorId;
          //   final cuser = FirebaseAuth.instance.currentUser!.uid;
          //   if (authid == cuser) {
          //     return OwnMessageDesign(
          //       pst: widget.post,
          //       postLink: widget.dbpathToPostChnl,
          //       commentCallback: widget.commentCallback,
          //       likeCallback: widget.likeCallback,
          //       authID: cuser,
          //       repliedPostScrollCallback: widget.repliedPostScrollCallback,
          //       progressList: 0,
          //     );
          //   } else {
          //     return OtherMessageDesign(
          //       avatar: avatar,
          //       pst: widget.post,
          //       postLink: widget.dbpathToPostChnl,
          //       commentCallback: widget.commentCallback,
          //       likeCallback: widget.likeCallback,
          //       authID: cuser,
          //       repliedPostScrollCallback: widget.repliedPostScrollCallback,
          //       progressValue: 0.0,
          //     );
          //   }
          // }
        });
  }
}
