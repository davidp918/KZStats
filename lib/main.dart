import 'package:flutter/material.dart';

import './homepageAppBar.dart';

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
      home: Scaffold(
        appBar: HomepageAppBar(),
        drawer: Drawer(),
      ),
    );
  }
}
