import 'package:evil_icons_flutter/evil_icons_flutter.dart';
import 'package:flutter/material.dart';

Widget errorScreen() {
  return Stack(
    children: <Widget>[
      ListView(),
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              EvilIcons.exclamation,
              size: 120,
              color: Colors.red.shade300,
            ),
            Text(
              'Global API is down',
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
            ),
            Text(
              'Try again later',
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}