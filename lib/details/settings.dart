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

//fenggexian

class ToggleButton extends StatefulWidget {
  final List<String> list;
  ToggleButton(this.list);

  @override
  State createState() => new _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  List<bool> _selections = [true, false, false];

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.blue.shade200,
      child: ToggleButtons(
        isSelected: _selections,
        fillColor: Colors.lightBlue,
        color: Colors.black,
        selectedColor: Colors.white,
        renderBorder: false,
        children: <Widget>[
          ...(list as List<String>).map((str) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                str,
                style: TextStyle(fontSize: 18),
              ),
            );
          }).toList(),
        ],
        onPressed: (int index) {
          setState(() {
            for (int i = 0; i < _selections.length; i++) {
              if (index == i) {
                _selections[i] = true;
              } else {
                _selections[i] = false;
              }
            }
          });
        },
      ),
    );
  }
}
