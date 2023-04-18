import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/controllers/auth_controller.dart';
import 'package:motazen/models/post_model.dart';
import 'package:motazen/pages/communities_page/view_photo.dart';
import 'package:motazen/theme.dart';

// ignore: must_be_immutable
class OwnMessageDesign extends StatelessWidget {
  AuthController authController = Get.find();
  OwnMessageDesign(
      {Key? key,
      required this.commentCallback,
      required this.pst,
      required this.postLink,
      required this.likeCallback,
      required this.authID,
      required this.repliedPostScrollCallback,
      required this.progressList})
      : super(key: key);
  final PostModel pst;
  final String postLink;
  final dynamic commentCallback;
  final dynamic likeCallback;
  final String authID;
  final dynamic repliedPostScrollCallback;
  final int progressList;

  @override
  Widget build(BuildContext context) {
    int minAgo = (DateTime.now().toUtc().millisecondsSinceEpoch - pst.time) ~/
        (60 * 1000);
    String unit = 'دقيقة';
    if (minAgo > 60) {
      minAgo = minAgo ~/ 60;
      unit = 'ساعة';
      if (minAgo > 24) {
        minAgo = minAgo ~/ 24;
        unit = 'يوم';
        if (minAgo > 30) {
          minAgo = minAgo ~/ 30;
          unit = 'شهر';
          if (minAgo > 12) {
            minAgo = minAgo ~/ 30;
            unit = 'سنة';
          }
        }
      }
    }
    return Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 3,
          vertical: 10,
        ),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                                maxWidth:
                                    MediaQuery.of(context).size.width / 1.75,
                                minWidth:
                                    MediaQuery.of(context).size.width / 1.75),
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
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // the message replied to
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      //! uncomment this section to make the avatar appear in the message being replyed to
                                      // GestureDetector(
                                      //     onTap: () => Navigator.push(
                                      //           context,
                                      //           MaterialPageRoute(
                                      //             builder: (context) {
                                      //               return BadgesPage(
                                      //                 goalProgress:
                                      //                     progressList,
                                      //                 userId: authID,
                                      //               );
                                      //             },
                                      //           ),
                                      //         ),
                                      //     child: CircleAvatar(
                                      //       maxRadius: 15,
                                      //       backgroundImage: authController
                                      //                   .currentUser
                                      //                   .value
                                      //                   .avatarURL ==
                                      //               null
                                      //           ? const CachedNetworkImageProvider(
                                      //               'https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-social-media-user-portrait-176256935.jpg')
                                      //           : CachedNetworkImageProvider(
                                      //               authController.currentUser
                                      //                   .value.avatarURL!,
                                      //               errorListener: () {}),
                                      //     )),
                                      // const SizedBox(
                                      //   width: 10,
                                      // ),
                                      Text(
                                        '${pst.replyingPost['author']}',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ]),
                                const SizedBox(
                                  height: 15,
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
                                  ),
                                if (pst.replyingPost['post_type'] == 'image')
                                  Container(
                                      constraints: BoxConstraints(
                                        maxHeight:
                                            MediaQuery.of(context).size.width /
                                                5,
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

                  // the reply message
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.width / 5,
                            maxWidth: MediaQuery.of(context).size.width / 1.5,
                            minWidth: MediaQuery.of(context).size.width / 3),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 233, 240, 233),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: kDarkGreyColor.withOpacity(0.3),
                              spreadRadius: 0,
                              blurRadius: 3,
                              offset: const Offset(
                                  -1, -1), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (pst.text != '')
                              Text(
                                '${pst.text}',
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 14,
                                ),
                              ),
                            if (pst.postType == 'image')
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ViewPhoto(imgURL: pst.imageURL)));
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
                                  'قبل ${minAgo.toString()} $unit',
                                  style: TextStyle(
                                      color: Colors.grey[500], fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                            },
                            child: Icon(
                              //! the icon should not be displayed when the user is the author of the post
                              size: 20,
                              pst.likes.contains(authID)
                                  ? Icons.thumb_up_off_alt_sharp
                                  : Icons.thumb_up_alt_outlined,
                              color: pst.likes.contains(authID)
                                  ? Colors.blue
                                  : const Color.fromARGB(97, 66, 66, 66),
                            ), //if the post was by user return null
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            '${pst.likes.length}',
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 18),
                          ), //if the post was by user return null
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ]));
  }
}
