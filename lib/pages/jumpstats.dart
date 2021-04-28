import 'package:flutter/material.dart';
import 'package:kzstats/common/AppBar.dart';
import 'package:kzstats/common/Drawer.dart';

class Jumpstats extends StatelessWidget {
  final String currentPage = 'Jumpstats';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomepageAppBar(currentPage),
      drawer: HomepageDrawer(),
    );
  }
}
