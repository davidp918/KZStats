import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget loadingFromApi() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          child: CircularProgressIndicator(),
          width: 60,
          height: 60,
        ),
        Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text(
              'Loading data from API...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ))
      ],
    ),
  );
}
