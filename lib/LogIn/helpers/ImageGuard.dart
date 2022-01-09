import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageGuard {
  Widget imageGuard(image, boxFit) {
    return ClipRRect(
      borderRadius: BorderRadius.zero,
      child: CachedNetworkImage(
        alignment: Alignment.center,
        imageUrl: image,
        fit: boxFit,
        fadeInCurve: Curves.easeIn,
        fadeInDuration: Duration(milliseconds: 20),
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(value: downloadProgress.progress),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }

  Widget networkImageGuard(image, boxFit) {
    return CachedNetworkImage(
      alignment: Alignment.center,
      imageUrl: image,
      fit: boxFit,
      fadeInCurve: Curves.easeIn,
      fadeInDuration: Duration(milliseconds: 20),
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
