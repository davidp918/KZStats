import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget getCachedNetworkImage(String url, AssetImage errorImage) {
  return CachedNetworkImage(
    placeholder: (context, url) => Center(
      child: SizedBox(
        child: CircularProgressIndicator(),
        height: 30,
        width: 30,
      ),
    ),
    errorWidget: (context, url, error) => Image(image: errorImage),
    imageUrl: url,
  );
}
