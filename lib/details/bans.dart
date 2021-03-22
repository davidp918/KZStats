import 'package:flutter/material.dart';

import 'package:kzstats/common/topbar.dart';

class Bans extends StatelessWidget {
  final String currentPage = 'Bans';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Topbar(currentPage),
    );
  }
}
