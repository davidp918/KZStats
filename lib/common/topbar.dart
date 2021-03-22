import 'package:flutter/material.dart';

import 'AppBar.dart';
import 'Drawer.dart';

class Topbar extends StatelessWidget {
  final String currentPage;
  Topbar(this.currentPage);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomepageAppBar(currentPage),
      drawer: HomepageDrawer(),
    );
  }
}
