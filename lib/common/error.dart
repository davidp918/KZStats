import 'package:evil_icons_flutter/evil_icons_flutter.dart';
import 'package:flutter/material.dart';

Widget errorScreen({String? exception}) {
  if (exception == 'none') {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Text(
            'This player does not yet have a record',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  return Center(
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
          'Internet Error',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        Text(
          'Try again later',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        SizedBox(height: 100),
      ],
    ),
  );
}
