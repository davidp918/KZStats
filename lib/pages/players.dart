import 'package:flutter/material.dart';

import 'package:kzstats/common/topbar.dart';

class Players extends StatelessWidget {
  final String currentPage = 'Players';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Topbar(currentPage),
    );
  }
}
