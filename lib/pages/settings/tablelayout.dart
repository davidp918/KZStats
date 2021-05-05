import 'package:flutter/material.dart';
import 'package:kzstats/global/responsive.dart';

class SettingsTableLayout extends StatefulWidget {
  SettingsTableLayout({Key? key}) : super(key: key);

  @override
  _SettingsTableLayoutState createState() => _SettingsTableLayoutState();
}

class _SettingsTableLayoutState extends State<SettingsTableLayout> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      ifDrawer: false,
      currentPage: 'Layout',
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [],
          ),
        );
      },
    );
  }
}
