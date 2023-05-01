import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:motazen/theme.dart';

class ListDialog extends StatefulWidget {
  const ListDialog({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
  });
  final String title, description;
  final String imagePath;
  @override
  State<ListDialog> createState() => _ListDialogState();
}

class _ListDialogState extends State<ListDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
    _controller.forward();
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
                  widget.title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  widget.description,
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
          Positioned(
            left: 16,
            right: 16,
            child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 77,
                child: Stack(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/images/popup_background.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    Lottie.network(
                      widget
                          .imagePath, //replace the link with the link provided
                      fit: BoxFit.contain,
                      controller: _controller,
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
