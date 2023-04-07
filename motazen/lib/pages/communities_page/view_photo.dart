// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables
//REEMAS
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class viewPhoto extends StatefulWidget {
  const viewPhoto({super.key, this.imgURL});
  final imgURL;
  @override
  State<viewPhoto> createState() => _viewPhotoState();
}

class _viewPhotoState extends State<viewPhoto> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(width: 5),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.grey,
                  ))
            ],
          ),
          Expanded(
            child: PhotoView(
              imageProvider: NetworkImage(widget.imgURL),
              loadingBuilder: (context, event) => const Center(
                  child: SizedBox(
                      height: 50,
                      width: 50,
                      child:
                          CircularProgressIndicator())), //! replace with shimmer effects
            ),
          ),
        ],
      ),
    );
  }
}
