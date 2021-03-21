import 'package:flutter/material.dart';

import 'package:kzstats/homepageDrawer.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      drawer: HomepageDrawer(),
      body: Center(),
    );
  }
}
