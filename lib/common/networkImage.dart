import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kzstats/theme/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class GetNetworkImage extends StatefulWidget {
  final String fileName;
  final String url;
  final AssetImage errorImage;
  final double borderWidth;
  final double? height;
  final double? width;
  GetNetworkImage({
    Key? key,
    required this.fileName,
    required this.url,
    required this.errorImage,
    required this.borderWidth,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  _GetNetworkImageState createState() => _GetNetworkImageState();
}

class _GetNetworkImageState extends State<GetNetworkImage> {
  String? imagePath;
  bool dataLoaded = false;

  @override
  void initState() {
    _loadImage();
    super.initState();
  }

  _loadImage() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = documentDirectory.path;
    String folderPath = path + '/images';
    String filePath = path + '/images/${widget.fileName}';
    bool exists = await File('$filePath').exists();

    if (exists) {
      if (this.mounted) {
        setState(
          () {
            imagePath = filePath;
            dataLoaded = true;
          },
        );
      }
    } else {
      http.Response response = await http.get(Uri.parse(widget.url));
      // creates the folder path if the folder directory does not exists
      await Directory(folderPath).create(recursive: true);
      File file = new File(filePath);
      // write the data into the folder '/images'
      file.writeAsBytesSync(response.bodyBytes);

      if (this.mounted) {
        setState(
          () {
            imagePath = filePath;
            dataLoaded = true;
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        border: Border.all(
          color: imageBorderColor(),
          width: widget.borderWidth,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: dataLoaded
            ? Image.file(File(imagePath!))
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
