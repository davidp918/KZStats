import 'package:flutter/material.dart';

import 'package:kzstats/common/topbar.dart';

class Homepage extends StatelessWidget {
  final String currentPage = 'KZStats';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Topbar(currentPage),
    );
  }
}
