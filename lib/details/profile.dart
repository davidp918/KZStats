import 'package:flutter/material.dart';

import 'package:kzstats/common/topbar.dart';

class Profile extends StatelessWidget {
  final String currentPage = 'Profile';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Topbar(currentPage),
    );
  }
}
