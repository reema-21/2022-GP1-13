import 'package:flutter/material.dart';
import 'package:motazen/pages/communities_page/bages/display_badge_info.dart';
import 'package:motazen/theme.dart';

class BadgesPage extends StatelessWidget {
  const BadgesPage({super.key});
  //! later it should get the bages from the user
  //! have the unachieved ones deactivated

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'إنجازاتي', // أوسمتي
              style: titleText,
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
                width: 190.0,
                height: 190.0,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                            "https://i.imgur.com/BoN9kdC.png")))), //user image

            const Text("John Doe", textScaleFactor: 1.5), // user name
            //? should I also display the goal progress here?
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemCount: 1, //* set a fixed number temporarly
                itemBuilder: (context, index) {
                  return Center(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const BadgeInfo();
                            },
                          ),
                        ), //! later set a condition to see if achieved is true
                        child: Container(
                            width: 190.0,
                            height: 190.0,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                        "https://i.imgur.com/BoN9kdC.png")))),
                      ), //the clickable image
                      const Text("John Doe",
                          textScaleFactor: 1.5) //the name of the badge
                    ],
                  ));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
