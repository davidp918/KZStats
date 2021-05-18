import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class GetNetworkImage extends StatefulWidget {
  final String fileName;
  final String url;
  final AssetImage errorImage;
  GetNetworkImage({
    Key? key,
    required this.fileName,
    required this.url,
    required this.errorImage,
  }) : super(key: key);

  @override
  _GetNetworkImageState createState() => _GetNetworkImageState();
}

class _GetNetworkImageState extends State<GetNetworkImage> {
  String imagePath = '';
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
      // write the data into the folder '/images/'
      file.writeAsBytes(response.bodyBytes);

      if (this.mounted) {
        setState(() {
          imagePath = filePath;
          dataLoaded = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Container(
        child: loadImage(),
      ),
    );
  }

  Widget loadImage() {
    if (dataLoaded) {
      Image image = Image.file(
        File(imagePath),
        errorBuilder: (context, object, stacktrace) {
          print('${widget.url}');
          return Image(image: widget.errorImage);
        },
      );
      return image;
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }
}
