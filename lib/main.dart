import 'package:flutter/material.dart';

import 'details/homepage.dart';

void main() => runApp(myApp());

// ignore: camel_case_types
class myApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<myApp> {
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.blue,
      ),
      home: Homepage(),
    );
  }
}
