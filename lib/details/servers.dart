import 'package:flutter/material.dart';

import 'package:kzstats/common/topbar.dart';

class Servers extends StatelessWidget {
  final String currentPage = 'Servers';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Topbar(currentPage),
    );
  }
}
