import 'package:flutter/material.dart';
import 'package:motazen/theme.dart';

class BadgeInfo extends StatelessWidget {
  const BadgeInfo({super.key});

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
                            "https://i.imgur.com/BoN9kdC.png")))), //achievement image

            const Text("John Doe", textScaleFactor: 1.5), //achievement name
            const Expanded(
                child: Card(
              child: Text('achievement info'),
            ))
          ],
        ),
      ),
    );
  }
}
