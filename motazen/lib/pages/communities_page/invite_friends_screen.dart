// ignore_for_file: depend_on_referenced_packages, prefer_typing_uninitialized_variables

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/create_otp.dart';
import 'package:motazen/theme.dart';
import 'package:searchfield/searchfield.dart';

import '../../controllers/auth_controller.dart';
import '../../models/user.dart';

class InviteFriendWidget extends StatefulWidget {
  final comm;
  const InviteFriendWidget({super.key, required this.comm});

  @override
  State<InviteFriendWidget> createState() => _InviteFriendWidgetState();
}

class _InviteFriendWidgetState extends State<InviteFriendWidget> {
  AuthController authController = Get.find();
  TextEditingController inviteFriendsController = TextEditingController();
  FocusNode inviteFriendsFocusNode = FocusNode();
  List<Userr> selectedUsers = [];
  List<Userr> newSelectedUsersList = [];
  FutureGroup futureGroup = FutureGroup();
  bool shouldEnabled = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  txt(txt: "دعوة الأصدقاء", fontSize: 16),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          shouldEnabled = true;
                        });
                        inviteFriendsController.text = '';
                        inviteFriendsFocusNode.requestFocus();
                      },
                      child: const Icon(
                        Icons.add,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: shouldEnabled || newSelectedUsersList.isEmpty
                        ? inviteFriendssearchField(context)
                        : inviteFriendsListView(context),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
            SizedBox(
              height: screenHeight(context) * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    if (selectedUsers.isNotEmpty) {
                      final communityNotification = {
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
                          'listOfTasks': widget.comm.listOfTasks!.isNotEmpty
                              ? widget.comm.listOfTasks!
                                  .map((e) => e.toJson())
                                  .toList()
                              : [],
                          'tillDate': widget.comm.tillDate,
                          '_id': widget.comm.id
                        }
                      };
                      for (var user in selectedUsers) {
                        firestore
                            .collection('user')
                            .doc(user.userID)
                            .collection('notifications')
                            .where('type', isEqualTo: 'invite')
                            .where('community',
                                isEqualTo: communityNotification['community'])
                            .get()
                            .then((value) {
                          if (value.docs.isEmpty) {
                            futureGroup.add(firestore
                                .collection('user')
                                .doc(user.userID)
                                .collection('notifications')
                                .add(communityNotification));
                            setState(() {
                              selectedUsers.clear();
                              newSelectedUsersList.clear();
                              inviteFriendsController.clear();
                            });
                            getSuccessSnackBar("تمت الدعوة");
                            sendInvitation('${user.email}', widget.comm,
                                '${firebaseAuth.currentUser!.displayName}');
                          } else {
                            getWarningSnackBar(
                                'المستخدم ${user.email} مضاف مسبقا');
                          }
                        });
                      }
                    } else {
                      getWarningSnackBar('اختر صديقا لإضافته');
                    }
                  },
                  child: Container(
                    height: screenHeight(context) * 0.05,
                    width: screenWidth(context) * 0.4,
                    decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                        child: txt(
                            txt: 'دعوة',
                            fontSize: 16,
                            fontColor: Colors.white)),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  SizedBox inviteFriendsListView(BuildContext context) {
    return SizedBox(
      height: screenHeight(context) * 0.07,
      child: ListView(
        reverse: true,
        scrollDirection: Axis.horizontal,
        children: newSelectedUsersList.map((Userr user) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all()),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 12,
                    ),
                    child: txt(
                      txt: user.email!,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    width: screenWidth(context) * 0.05,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            newSelectedUsersList.remove(user);
                            selectedUsers.remove(user);
                            if (newSelectedUsersList.isEmpty) {
                              inviteFriendsController.text = '';
                            }
                          });
                        },
                        child: const Icon(
                          Icons.close,
                          color: kPrimaryColor,
                        )),
                  )
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Padding inviteFriendssearchField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: SearchField(
          searchInputDecoration:
              const InputDecoration(border: InputBorder.none),
          focusNode: inviteFriendsFocusNode,
          controller: inviteFriendsController,
          onSuggestionTap: (p0) {
            newSelectedUsersList.clear();
            setState(() {
              inviteFriendsFocusNode.unfocus();
              shouldEnabled = false;
            });

            for (var user in authController.usersList) {
              if (user.email == p0.searchKey) {
                selectedUsers.add(user);
                break;
              }
            }

            newSelectedUsersList = selectedUsers.toSet().toList();
            for (var user in newSelectedUsersList) {
              if (user.userID == firebaseAuth.currentUser!.uid) {
                newSelectedUsersList.remove(user);
              }
            }
          },
          suggestions: ((authController.usersList)
                ..removeWhere((e) =>
                    e.userID == firebaseAuth.currentUser!.uid ||
                    (e.createdCommunities != null &&
                        e.createdCommunities!.isNotEmpty &&
                        e.createdCommunities!.indexWhere(
                                (element) => element.id == widget.comm.id) >=
                            0) ||
                    (e.joinedCommunities != null &&
                        e.joinedCommunities!.isNotEmpty &&
                        e.joinedCommunities!.indexWhere(
                                (element) => element.id == widget.comm.id) >=
                            0)))
              .map(
                (e) => SearchFieldListItem(
                  e.email!,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        txt(txt: e.email!, fontSize: 16),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
          suggestionState: Suggestion.expand,
          textInputAction: TextInputAction.next,
          hint: 'مثلا: مستحدم1, مستخدم2...',
          hasOverlay: false,
          searchStyle: TextStyle(
            fontSize: 18,
            color: Colors.black.withOpacity(0.8),
          ),
          itemHeight: screenHeight(context) * 0.07,
        ),
      ),
    );
  }
}
