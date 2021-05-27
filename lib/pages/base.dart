import 'package:evil_icons_flutter/evil_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:kzstats/common/AppBar.dart';
import 'package:kzstats/pages/homepage.dart';
import 'package:kzstats/pages/settings.dart';
import 'package:kzstats/theme/colors.dart';

class Base extends StatefulWidget {
  Base({Key? key}) : super(key: key);

  @override
  _BaseState createState() => _BaseState();
}

class _BaseState extends State<Base> with AutomaticKeepAliveClientMixin<Base> {
  late int curIndex;
  late String title;
  late List<Widget> pages;
  late ScrollController _scrollController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    this.curIndex = 0;
    this.title = 'Homepage';
    this.pages = [Homepage(), Settings()];
    this._scrollController = ScrollController();
  }

  void onTap(int index) {
    setState(() {
      this.curIndex = index;
      changeTitle(index);
    });
  }

  void changeTitle(int index) {
    if (index == 0) this.title = 'KZStats';
    if (index == 1) this.title = 'Settings';
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          controller: this._scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              BaseAppBar(this.title, true),
            ];
          },
          body: IndexedStack(children: this.pages, index: this.curIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          iconSize: 22,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          backgroundColor: appbarColor(),
          currentIndex: this.curIndex,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.grey.shade500,
          fixedColor: Colors.white,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Homepage',
            ),
            BottomNavigationBarItem(
              icon: Icon(EvilIcons.gear),
              label: 'Settings',
            ),
          ],
          onTap: onTap,
        ),
      ),
    );
  }
}
