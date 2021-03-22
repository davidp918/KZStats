import 'package:flutter/material.dart';

import 'package:kzstats/common/topbar.dart';

class Maps extends StatelessWidget {
  final String currentPage = 'Maps';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Topbar(currentPage),
    );
  }
}
