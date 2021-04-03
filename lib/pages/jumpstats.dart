import 'package:flutter/material.dart';

import 'package:kzstats/common/topbar.dart';

class Jumpstats extends StatelessWidget {
  final String currentPage = 'Jumpstats';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Topbar(currentPage),
    );
  }
}
