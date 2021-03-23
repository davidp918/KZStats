import 'package:flutter/material.dart';

import 'package:kzstats/common/AppBar.dart';
import 'package:kzstats/common/Drawer.dart';

import '../toggleButton.dart';

class Settings extends StatelessWidget {
  final String currentPage = 'Settings';
  static const _modes = [
    {
      'mode': ['KZTimer', 'SimpleKZ', 'Vanilla']
    },
    {
      'tickrate': [128, 102, 64]
    },
  ];
  static int mode = 0;
  static int tickrate = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: HomepageAppBar(currentPage),
        drawer: HomepageDrawer(),
        body: Padding(
          padding: EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildHeader(
                  title: 'Mode',
                  child: ToggleButton(_modes[0]['mode']),
                ),
                SizedBox(height: 32),
                buildHeader(
                  title: 'Tick rate',
                  child: ToggleButton(_modes[1]['tickrate']),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildHeader({@required String title, @required Widget child}) => Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        child,
      ],
    );
