// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

CachedNetworkImage cachedImage(
  BuildContext context, {
  double? height,
  double? width,
  required String url,
  required bool isProfilePicture,
}) {
  return CachedNetworkImage(
    height: height,
    width: width,
    imageUrl: url,
    imageBuilder: (context, imageProvider) {
      return isProfilePicture
          ? profileImageContainer(height, width, url)
          : imageContainer(height, width, url);
    },
    progressIndicatorBuilder: (context, url, progress) {
      if (url.isEmpty) {
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: isProfilePicture ? null : BorderRadius.circular(20),
            shape: isProfilePicture ? BoxShape.circle : BoxShape.rectangle,
          ),
        );
      }
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: isProfilePicture ? null : BorderRadius.circular(20),
          shape: isProfilePicture ? BoxShape.circle : BoxShape.rectangle,
        ),
      );
    },
    errorWidget: (context, url, error) => Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: isProfilePicture ? null : BorderRadius.circular(20),
        shape: isProfilePicture ? BoxShape.circle : BoxShape.rectangle,
      ),
    ),
  );
}

Container profileImageContainer(double? height, double? width, String url) {
  return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(url),
          fit: BoxFit.fill,
        ),
      ));
}

Container imageContainer(double? height, double? width, String url) {
  return Container(
    width: width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
      image: DecorationImage(
          colorFilter:
              ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
          image: NetworkImage(url),
          fit: BoxFit.fill),
    ),
  );
}
