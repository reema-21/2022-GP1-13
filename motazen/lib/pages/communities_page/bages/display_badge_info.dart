import 'package:flutter/material.dart';
import 'package:motazen/theme.dart';

class BadgeInfo extends StatelessWidget {
  const BadgeInfo({super.key, required this.badge});

  final badge;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          badge['name'], // أوسمتي
          style: titleText,
        ), //badge name
        //! add as a variable later
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),

              Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: kPrimaryColor.withOpacity(0.3),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: const Offset(
                              -2, -2), // changes position of shadow
                        ),
                      ],
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(
                              "assets/images/BADGE${badge['name']}.png")))), //user image
              //achievement image
              const SizedBox(
                height: 50,
              ),
              Card(
                elevation: 0,
                color: Colors.green[50]!.withOpacity(0.5),
                child: Padding(
                  padding: kDefaultPadding,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'معلومات الوسام',
                        textScaleFactor: 2,
                        overflow: TextOverflow.visible,
                        style: titleText2,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        badge['description'],
                        textScaleFactor: 1.5,
                        overflow: TextOverflow.visible,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
