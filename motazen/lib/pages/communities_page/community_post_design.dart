// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motazen/models/post_model.dart';

class PostDesign extends StatefulWidget {
  final PostModel post;
  final dbpathToPostChnl;
  final callback;
  const PostDesign(
      {Key? key,
      required this.post,
      required this.dbpathToPostChnl,
      this.callback})
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
        callback: widget.callback,
      );
    } else {
      return OtherMessageDesign(
        pst: widget.post,
        postLink: widget.dbpathToPostChnl,
        callback: widget.callback,
      );
    }
  }
}

class OwnMessageDesign extends StatelessWidget {
  const OwnMessageDesign(
      {Key? key,
      required this.callback,
      required this.pst,
      required this.postLink})
      : super(key: key);
  final PostModel pst;
  final postLink;
  final callback;

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
                Container(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection: TextDirection.rtl,
                    children: [
                      Text(
                        '${pst.replyingPost['author']}',
                        style: const TextStyle(
                            color: Colors.red,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        pst.replyingPost['text'].length > 40
                            ? '...${pst.replyingPost['text'].substring(0, 40)}'
                            : '${pst.replyingPost['text']}',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
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
                  color: Colors.green[100],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15)),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: TextDirection.rtl,
                  children: [
                    Text(
                      '${pst.author}',
                      style: const TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${minAgo.toString()} $unit ago',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      '${pst.text}',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            callback(pst);
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
                            Icons.reply,
                            color: Colors.grey[800],
                            size: 25,
                          ),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        InkWell(
                          onTap: () {},
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          '${pst.likes}',
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 18),
                        ),
                      ],
                    )
                  ],
                ),
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
      required this.callback,
      required this.pst,
      required this.postLink})
      : super(key: key);
  final PostModel pst;
  final postLink;
  final callback;

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
                  Container(
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      textDirection: TextDirection.rtl,
                      children: [
                        Text(
                          '${pst.replyingPost['author']}',
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          pst.replyingPost['text'].length > 40
                              ? '...${pst.replyingPost['text'].substring(0, 40)}'
                              : '${pst.replyingPost['text']}',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
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
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    textDirection: TextDirection.rtl,
                    children: [
                      Text(
                        '${pst.author}',
                        style: const TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${minAgo.toString()} $unit ago',
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        '${pst.text}',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {},
                            child: const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            '${pst.likes}',
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 18),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          InkWell(
                            onTap: () {
                              callback(pst);
                            },
                            child: Icon(
                              Icons.reply,
                              color: Colors.grey[800],
                              size: 25,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ));
  }
}
