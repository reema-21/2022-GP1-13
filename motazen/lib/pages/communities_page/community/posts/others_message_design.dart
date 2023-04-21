import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motazen/models/post_model.dart';
import 'package:motazen/pages/communities_page/bages/display_badges.dart';
import 'package:motazen/pages/communities_page/view_photo.dart';
import 'package:motazen/theme.dart';

class OtherMessageDesign extends StatelessWidget {
  const OtherMessageDesign(
      {Key? key,
      required this.avatar,
      required this.progressValue,
      required this.commentCallback,
      required this.likeCallback,
      required this.pst,
      required this.postLink,
      required this.authID,
      required this.repliedPostScrollCallback})
      : super(key: key);
  final String avatar;
  final PostModel pst;
  final String postLink;
  final dynamic commentCallback;
  final dynamic likeCallback;
  final String authID;
  final double progressValue;
  final dynamic repliedPostScrollCallback;

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
    return SafeArea(
      child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 3,
            vertical: 10,
          ),
          child: Column(
            children: [
              if (pst.replyingPost != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
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
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return BadgesPage(
                                          avatar: avatar,
                                          goalProgress: progressValue.toInt(),
                                          userId: authID,
                                        );
                                      },
                                    ),
                                  ),
                                  child: SizedBox(
                                      width: 35.0,
                                      height: 35.0,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: CircleAvatar(
                                            // display the avatar if added
                                            backgroundImage: avatar == ""
                                                ? null
                                                : CachedNetworkImageProvider(
                                                    avatar,
                                                    errorListener: () {}),
                                            radius: 60,
                                            backgroundColor: Colors.transparent,
                                            child: avatar != ""
                                                ? null
                                                : const Icon(
                                                    Icons.account_circle_sharp,
                                                    color: Color.fromARGB(
                                                        31, 0, 0, 0),
                                                    size: 35,
                                                  )),
                                      )),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
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
                              ],
                            ),
                            const Divider(
                              thickness: 0.8,
                            ),
                            const SizedBox(
                              height: 8,
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
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(
                    width: 8,
                  ),
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
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                              bottomRight: Radius.circular(15)),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${pst.author}',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: FutureBuilder(
                                      future: FirebaseFirestore.instance
                                          .collection('user')
                                          .doc(pst.authorId)
                                          .get(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Container();
                                        }
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CupertinoActivityIndicator();
                                        } else {
                                          final List listOfLikes =
                                              snapshot.data!.data()?[
                                                      'messageLikedUserIds'] ??
                                                  [];

                                          String badgePath = '';

                                          if (listOfLikes.length >= 25) {
                                            badgePath =
                                                'assets/badges/Artboard 2_1.png';
                                          } else if (listOfLikes.length >= 50) {
                                            badgePath =
                                                'assets/badges/Artboard 2_2.png';
                                          } else {
                                            badgePath =
                                                'assets/badges/Artboard 2_3.png';
                                          }

                                          return listOfLikes.length < 25
                                              ? Container()
                                              : Image.asset(
                                                  badgePath,
                                                );
                                        }
                                      }),
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Text(
                                    ' ${(progressValue * 100).round().toString()} %',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: kPrimaryColor,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(thickness: 0.8),
                            const SizedBox(
                              height: 8,
                            ),
                            if (pst.text != '')
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${pst.text}',
                                      style: TextStyle(
                                        color: Colors.grey[800],
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
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
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
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
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BadgesPage(
                            avatar: avatar,
                            goalProgress: (progressValue * 100).round().toInt(),
                            userId: pst.authorId,
                          ),
                        )),
                    child: SizedBox(
                        width: 35.0,
                        height: 35.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: CircleAvatar(
                              // display the avatar if added
                              backgroundImage: avatar == ""
                                  ? null
                                  : CachedNetworkImageProvider(avatar,
                                      errorListener: () {}),
                              radius: 60,
                              backgroundColor: kWhiteColor,
                              child: avatar != ""
                                  ? null
                                  : const Icon(
                                      Icons.account_circle_sharp,
                                      color: Color.fromARGB(31, 0, 0, 0),
                                      size: 35,
                                    )),
                        )),
                  ),
                  //user image
                ],
              ),
            ],
          )),
    );
  }
}
