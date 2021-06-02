import 'dart:io';

import 'package:async_builder/async_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kzstats/common/progressIndicator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

Widget getNetworkImage(String fileName, String url, AssetImage errorImage) {
  Future<String> _future = loadImage(fileName, url);
  return ClipRRect(
    borderRadius: BorderRadius.circular(4),
    child: AsyncBuilder<String>(
      retain: true,
      future: _future,
      waiting: (context) => progressIndicator(),
      error: (context, object, stacktrace) => Image(image: errorImage),
      builder: (context, value) => Image.file(
        File(value!),
        errorBuilder: (context, object, stacktrace) {
          return Image(image: errorImage);
        },
      ),
    ),
  );
}

//<String,dynamic>
Future<String> loadImage(String fileName, String url) async {
  Directory documentDirectory = await getApplicationDocumentsDirectory();
  String path = documentDirectory.path;
  String folderPath = path + '/images';
  String filePath = path + '/images/$fileName';
  bool exists = await File('$filePath').exists();
  if (!exists) {
    http.Response response = await http.get(Uri.parse(url));
    // creates the folder path if the folder directory does not exists
    await Directory(folderPath).create(recursive: true);
    File file = new File(filePath);
    // write the data into the folder '/images/'
    file.writeAsBytes(response.bodyBytes);
  }
  return filePath;
}
