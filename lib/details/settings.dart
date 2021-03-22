import 'package:flutter/material.dart';

import 'package:kzstats/common/topbar.dart';

class Settings extends StatelessWidget {
  final String currentPage = 'Settings';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Topbar(currentPage),
    );
  }
}
