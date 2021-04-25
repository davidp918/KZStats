import 'package:flutter/material.dart';

import 'package:kzstats/theme/colors.dart';

class HomepageDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: secondarythemeBlue(),
        child: ListView(
          children: <Widget>[],
        ),
      ),
    );
  }
}
