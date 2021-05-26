import 'package:evil_icons_flutter/evil_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:kzstats/common/AppBar.dart';
import 'package:kzstats/pages/bans.dart';
import 'package:kzstats/pages/homepage.dart';
import 'package:kzstats/pages/maps.dart';
import 'package:kzstats/pages/settings.dart';
import 'package:kzstats/theme/colors.dart';

import 'leaderboard.dart';

class Base extends StatefulWidget {
  Base({Key? key}) : super(key: key);

  @override
  _BaseState createState() => _BaseState();
}

class _BaseState extends State<Base> {
  late int curIndex;
  late String title;
  late List<Widget> pages;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    this.curIndex = 0;
    this.title = 'Latest';
    this.pages = [Homepage(), Leaderboard(), Maps(), Bans(), Settings()];
    this._pageController = PageController();
  }

  void onTap(int index) {
    this._pageController.jumpToPage(index);
    setState(() {
      if (index == 0) this.title = 'Latest';
      if (index == 1) this.title = 'Leaderboard';
      if (index == 2) this.title = 'Maps';
      if (index == 3) this.title = 'Bans';
      if (index == 4) this.title = 'Settings';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(this.title, true),
      body: PageView(
        controller: this._pageController,
        children: pages,
        onPageChanged: (page) => setState(() => this.curIndex = page),
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 22,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        backgroundColor: bottomColor(),
        currentIndex: this.curIndex,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey.shade500,
        fixedColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Latest',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_sharp),
            label: 'Maps',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.not_interested),
            label: 'Bans',
          ),
          BottomNavigationBarItem(
            icon: Icon(EvilIcons.gear),
            label: 'Settings',
          ),
        ],
        onTap: onTap,
      ),
    );
  }
}
