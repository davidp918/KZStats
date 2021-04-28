import 'package:flutter/material.dart';
import 'package:kzstats/common/AppBar.dart';
import 'package:kzstats/common/Drawer.dart';

class Bans extends StatelessWidget {
  final String currentPage = 'Bans';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomepageAppBar(currentPage),
      drawer: HomepageDrawer(),
    );
  }
}
