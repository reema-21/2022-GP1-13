import 'package:flutter/material.dart';
import 'package:motazen/theme.dart';

class ListDialog extends StatelessWidget {
  const ListDialog({
    super.key,
    required this.title,
    required this.description,
  });
  final String title, description;
  // final Image image;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor:
          Colors.transparent, // later if possible add an image or animation
      child: dialogContext(context),
      //! add dissmissible true somehow
    );
  }

  dialogContext(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 82, bottom: 16, left: 16, right: 16),
            margin: const EdgeInsets.only(top: 66),
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[700]!,
                      blurRadius: 10,
                      offset: const Offset(0, 10))
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 24,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('رائع', style: textButton)),
                )
              ],
            ),
          ),
          const Positioned(
            left: 16,
            right: 16,
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 66,
              //!later add the image
            ),
          )
        ],
      ),
    );
  }
}
