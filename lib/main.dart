import 'package:flutter/material.dart';

import './homepageAppBar.dart';
import './homepageDrawer.dart';

void main() => runApp(myApp());

// ignore: camel_case_types
class myApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return myAppState();
  }
}

// ignore: camel_case_types
class myAppState extends State<myApp> {
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.blue,
      ),
      home: MaterialApp(
        home: Scaffold(
          appBar: HomepageAppBar(),
          drawer: homepageDrawer(),
        ),
      ),
    );
  }
}
