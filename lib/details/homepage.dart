import 'package:flutter/material.dart';

import '../homepageAppBar.dart';
import '../homepageDrawer.dart';

class MyHomepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: HomepageAppBar(),
        drawer: HomepageDrawer(),
      ),
    );
  }
}
