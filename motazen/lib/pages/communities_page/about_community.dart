// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/pages/communities_page/invite_friends_screen.dart';

import '../../controllers/community_controller.dart';

class AboutCommunityPage extends StatefulWidget {
  final comm;
  const AboutCommunityPage({super.key, required this.comm});

  @override
  State<AboutCommunityPage> createState() => _AboutCommunityPageState();
}

class _AboutCommunityPageState extends State<AboutCommunityPage> {
  CommunityController communityController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          title: const Text(
            'About the community',
            style: TextStyle(fontSize: 20, color: Colors.black),
          )),
      body: Column(
        children: [
          if (communityController.listOfCreatedCommunities
              .contains(widget.comm))
            InviteFriendWidget(comm: widget.comm),
          const Expanded(
              child: Center(child: Text("Community details coming soon..."))),
        ],
      ),
    );
  }
}
