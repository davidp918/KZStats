import 'package:flutter/material.dart';
import 'package:kzstats/common/AppBar.dart';
import 'package:kzstats/pages/homepage.dart';
import 'package:kzstats/theme/colors.dart';

import 'leaderboard.dart';

class Base extends StatefulWidget {
  Base({Key? key}) : super(key: key);

  @override
  _BaseState createState() => _BaseState();
}

class _BaseState extends State<Base> {
  int curIndex = 0;
  final pages = [
    Homepage(),
    Leaderboard(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar('currentPage'),
      body: pages[this.curIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: appbarColor().withOpacity(0.9),
        currentIndex: this.curIndex,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(color: Colors.white),
        unselectedLabelStyle: TextStyle(color: Colors.white),
        fixedColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Leaderboard',
          ),
        ],
        onTap: (index) {
          setState(() {
            this.curIndex = index;
          });
        },
      ),
    );
  }
}
