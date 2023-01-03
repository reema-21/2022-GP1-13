// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/pages/communities_page/about_community.dart';

class CommunityLeaderboardPage extends StatefulWidget {
  final comm;
  const CommunityLeaderboardPage({super.key, required this.comm});

  @override
  State<CommunityLeaderboardPage> createState() =>
      _CommunityLeaderboardPageState();
}

class _CommunityLeaderboardPageState extends State<CommunityLeaderboardPage> {
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
          'Leaderboard',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(AboutCommunityPage(comm: widget.comm));
              },
              icon: const Icon(Icons.more_horiz))
        ],
      ),
      body: const Center(
        child: Text("Leaderboard coming soon..."),
      ),
    );
  }
}
