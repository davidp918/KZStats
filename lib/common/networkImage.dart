import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kzstats/theme/colors.dart';

Widget getCachedNetworkImage(
  String url,
  AssetImage errorImage, {
  required double borderWidth,
  double? height,
  double? width,
}) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      border: Border.all(
        color: imageBorderColor(),
        width: borderWidth,
      ),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: CachedNetworkImage(
        placeholder: (context, url) => Center(
          child: SizedBox(
            child: CircularProgressIndicator(),
            height: 30,
            width: 30,
          ),
        ),
        errorWidget: (context, url, error) => Image(image: errorImage),
        imageUrl: url,
      ),
    ),
  );
}
