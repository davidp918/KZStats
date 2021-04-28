import 'package:flutter/material.dart';
import 'package:kzstats/common/AppBar.dart';
import 'package:kzstats/common/Drawer.dart';

class Maps extends StatelessWidget {
  final String currentPage = 'Maps';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomepageAppBar(currentPage),
      drawer: HomepageDrawer(),
    );
  }
}
