import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget loadingFromApi() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          child: Image.asset('assets/icon/loading.gif'),
          width: 120,
          height: 120,
        ),
        Text(
          'Loading...',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ],
    ),
  );
}
