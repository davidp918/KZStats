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
  late int curIndex;
  late List<Widget> pages;
  late PageController _pageController;
  @override
  void initState() {
    super.initState();
    this.curIndex = 0;
    this.pages = [Homepage(), Leaderboard()];
    this._pageController = PageController();
  }

  void onTap(int index) {
    this._pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar('currentPage'),
      body: PageView(
        controller: this._pageController,
        children: pages,
        onPageChanged: (page) {
          setState(() {
            this.curIndex = page;
          });
        },
      ),
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
        onTap: onTap,
      ),
    );
  }
}
