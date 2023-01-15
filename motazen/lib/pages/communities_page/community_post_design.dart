// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motazen/models/post_model.dart';
import 'package:motazen/pages/communities_page/view_photo.dart';
import 'package:motazen/theme.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class PostDesign extends StatefulWidget {
  final PostModel post;
  final dbpathToPostChnl;
  final commentCallback;
  final likeCallback;
  final repliedPostScrollCallback;
  const PostDesign(
      {Key? key,
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
  @override
  Widget build(BuildContext context) {
    final authid = widget.post.authorId;
    final cuser = FirebaseAuth.instance.currentUser!.uid;
    if (authid == cuser) {
      return OwnMessageDesign(
        pst: widget.post,
        postLink: widget.dbpathToPostChnl,
        commentCallback: widget.commentCallback,
        likeCallback: widget.likeCallback,
        authID: cuser,
        repliedPostScrollCallback: widget.repliedPostScrollCallback,
      );
    } else {
      return OtherMessageDesign(
        pst: widget.post,
        postLink: widget.dbpathToPostChnl,
        commentCallback: widget.commentCallback,
        likeCallback: widget.likeCallback,
        authID: cuser,
        repliedPostScrollCallback: widget.repliedPostScrollCallback,
      );
    }
  }
}

class OwnMessageDesign extends StatelessWidget {
  const OwnMessageDesign(
      {Key? key,
      required this.commentCallback,
      required this.pst,
      required this.postLink,
      required this.likeCallback,
      required this.authID,
      required this.repliedPostScrollCallback})
      : super(key: key);
  final PostModel pst;
  final postLink;
  final commentCallback;
  final likeCallback;
  final authID;
  final repliedPostScrollCallback;

  @override
  Widget build(BuildContext context) {
    int minAgo = (DateTime.now().toUtc().millisecondsSinceEpoch - pst.time) ~/
        (60 * 1000);
    String unit = 'min';
    if (minAgo > 60) {
      minAgo = minAgo ~/ 60;
      unit = 'hour';
      if (minAgo > 24) {
        minAgo = minAgo ~/ 24;
        unit = 'day';
        if (minAgo > 30) {
          minAgo = minAgo ~/ 30;
          unit = 'month';
          if (minAgo > 12) {
            minAgo = minAgo ~/ 30;
            unit = 'year';
          }
        }
      }
    }
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 3,
        vertical: 10,
      ),
      child: Column(
        children: [
          if (pst.replyingPost != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              textDirection: TextDirection.rtl,
              children: [
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    repliedPostScrollCallback(pst.replyingPost);
                  },
                  child: Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width / 1.75,
                        minWidth: MediaQuery.of(context).size.width / 1.75),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      // boxShadow: [
                      //   // BoxShadow(
                      //   //   color: Colors.grey.withOpacity(0.5),
                      //   //   spreadRadius: 5,
                      //   //   blurRadius: 7,
                      //   //   offset: Offset(0, 3), // changes position of shadow
                      //   // ),
                      // ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      textDirection: TextDirection.rtl,
                      children: [
                        Text(
                          '${pst.replyingPost['author']}',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        if (pst.replyingPost['text'] != '')
                          Text(
                            pst.replyingPost['text'].length > 30
                                ? '...${pst.replyingPost['text'].substring(0, 30)}'
                                : '${pst.replyingPost['text']}',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        if (pst.replyingPost['post_type'] == 'image')
                          Container(
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.width / 5,
                              ),
                              child: CachedNetworkImage(
                                imageUrl: pst.replyingPost['image_url'],
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            textDirection: TextDirection.rtl,
            children: [
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.width / 5,
                        maxWidth: MediaQuery.of(context).size.width / 1.4,
                        minWidth: MediaQuery.of(context).size.width / 3),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 233, 240, 233),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20)),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.grey.withOpacity(0.5),
                      //     spreadRadius: 5,
                      //     blurRadius: 7,
                      //     offset: Offset(0, 3), // changes position of shadow
                      //   ),
                      // ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${pst.author}',
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 5, 5, 5),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 9,
                                ),

                                //! in this space here we need a star to be displayed if the user reached amount of intercation

                                // Icon(Icons.star , size: 18, color:  Colors.yellow,),
                              ],
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2.5,
                              height: 20,
                              child: LinearPercentIndicator(
                                curve: Curves.easeIn,
                                percent:
                                    0.5, //! this value is the user progress in the progresslist of this community . just fetch the value

                                lineHeight: 10,
                                isRTL: true,
                                progressColor: kPrimaryColor,
                                backgroundColor:
                                    const Color.fromARGB(179, 119, 117, 117),
                                barRadius: const Radius.circular(10),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        if (pst.text != '')
                          Text(
                            '${pst.text}',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        if (pst.postType == 'image')
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          viewPhoto(imgURL: pst.imageURL)));
                            },
                            child: Container(
                                constraints: BoxConstraints(
                                    maxHeight:
                                        MediaQuery.of(context).size.width /
                                            1.25),
                                child: CachedNetworkImage(
                                  imageUrl: pst.imageURL,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                )),
                          ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${minAgo.toString()} $unit ago',
                              style: TextStyle(
                                  color: Colors.grey[500], fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          commentCallback(pst);
                        },
                        child: const Icon(
                          Icons.reply,
                          color: Color.fromARGB(97, 66, 66, 66),
                          size: 20,
                        ),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      InkWell(
                        onTap: () {
                          likeCallback(pst,
                              '$postLink/${pst.time.toString()}${pst.authorId}/');
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => CommentPage(
                          //               minAgo: minAgo,
                          //               unit: unit,
                          //               dbPathToComment:
                          //                   '$postLink/${pst.time.toString()}${pst.authorId}/comment/',
                          //             )));
                        },
                        child: Icon(
                          size: 20,
                          pst.likes.contains(authID)
                              ? Icons.thumb_up_off_alt_sharp
                              : Icons.thumb_up_alt_outlined,
                          color: pst.likes.contains(authID)
                              ? Colors.blue
                              : const Color.fromARGB(97, 66, 66, 66),
                        ),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        '${pst.likes.length}',
                        style: TextStyle(color: Colors.grey[500], fontSize: 18),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

class OtherMessageDesign extends StatelessWidget {
  const OtherMessageDesign(
      {Key? key,
      required this.commentCallback,
      required this.likeCallback,
      required this.pst,
      required this.postLink,
      required this.authID,
      required this.repliedPostScrollCallback})
      : super(key: key);
  final PostModel pst;
  final postLink;
  final commentCallback;
  final likeCallback;
  final authID;
  final repliedPostScrollCallback;

  @override
  Widget build(BuildContext context) {
    int minAgo = (DateTime.now().toUtc().millisecondsSinceEpoch - pst.time) ~/
        (60 * 1000);
    String unit = 'min';
    if (minAgo > 60) {
      minAgo = minAgo ~/ 60;
      unit = 'hour';
      if (minAgo > 24) {
        minAgo = minAgo ~/ 24;
        unit = 'day';
        if (minAgo > 30) {
          minAgo = minAgo ~/ 30;
          unit = 'month';
          if (minAgo > 12) {
            minAgo = minAgo ~/ 30;
            unit = 'year';
          }
        }
      }
    }
    return Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 3,
          vertical: 10,
        ),
        child: Column(
          children: [
            if (pst.replyingPost != null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      repliedPostScrollCallback(pst.replyingPost);
                    },
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width / 1.75,
                          minWidth: MediaQuery.of(context).size.width / 1.75),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.grey.withOpacity(0.5),
                        //     spreadRadius: 5,
                        //     blurRadius: 7,
                        //     offset: Offset(0, 3), // changes position of shadow
                        //   ),
                        // ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        textDirection: TextDirection.rtl,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${pst.replyingPost['author']}',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 5, 5, 5),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 9,
                              ),

                              //! in this space here we need a star to be displayed if the user reached amount of intercation

                              // Icon(Icons.star , size: 18, color:  Colors.yellow,),
                            ],
                          ),
                          if (pst.replyingPost['text'] != '')
                            Text(
                              pst.replyingPost['text'].length > 30
                                  ? '...${pst.replyingPost['text'].substring(0, 30)}'
                                  : '${pst.replyingPost['text']}',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          if (pst.replyingPost['post_type'] == 'image')
                            Container(
                                constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.width / 5,
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: pst.replyingPost['image_url'],
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.width / 5,
                          maxWidth: MediaQuery.of(context).size.width / 1.6,
                          minWidth: MediaQuery.of(context).size.width / 3),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                              bottomRight: Radius.circular(15)),
                          boxShadow: const []),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        textDirection: TextDirection.rtl,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2.6,
                                height: 10,
                                child: LinearPercentIndicator(
                                  curve: Curves.easeIn,
                                  percent:
                                      0.5, //! this value is the user progress in the progresslist of this community . just fetch the value
                                  lineHeight: 10,
                                  isRTL: true,
                                  progressColor: kPrimaryColor,
                                  backgroundColor:
                                      const Color.fromARGB(255, 119, 117, 117),
                                  barRadius: const Radius.circular(10),
                                ),
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Text(
                                '${pst.author}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          if (pst.text != '')
                            Text(
                              '${pst.text}',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          if (pst.postType == 'image')
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            viewPhoto(imgURL: pst.imageURL)));
                              },
                              child: Container(
                                  constraints: BoxConstraints(
                                      maxHeight:
                                          MediaQuery.of(context).size.width /
                                              1.25),
                                  child: CachedNetworkImage(
                                    imageUrl: pst.imageURL,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  )),
                            ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '${minAgo.toString()} $unit ago',
                                style: TextStyle(
                                    color: Colors.grey[500], fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                likeCallback(pst,
                                    '$postLink/${pst.time.toString()}${pst.authorId}/');
                              },
                              child: Icon(
                                size: 20,
                                pst.likes.contains(authID)
                                    ? Icons.thumb_up
                                    : Icons.thumb_up_alt_outlined,
                                color: pst.likes.contains(authID)
                                    ? Colors.blue
                                    : const Color.fromARGB(97, 66, 66, 66),
                              ),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Text(
                              '${pst.likes.length}',
                              style: TextStyle(
                                  color: Colors.grey[500], fontSize: 18),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            InkWell(
                              onTap: () {
                                commentCallback(pst);
                              },
                              child: const Icon(
                                Icons.reply,
                                color: Color.fromARGB(97, 66, 66, 66),
                                size: 20,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          ],
        ));
  }
}
