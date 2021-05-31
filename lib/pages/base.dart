import 'package:community_material_icon/community_material_icon.dart';
import 'package:evil_icons_flutter/evil_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:kzstats/pages/mapsPage.dart';
import 'package:kzstats/pages/explore.dart';
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
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    this.curIndex = 0;
    this.pages = [Homepage(), Explore(), MapsPage(), Settings()];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        body: IndexedStack(children: this.pages, index: this.curIndex),
        bottomNavigationBar: SizedBox(
          height: kToolbarHeight,
          child: BottomNavigationBar(
            onTap: (index) => setState(() => this.curIndex = index),
            backgroundColor: appbarColor(),
            currentIndex: this.curIndex,
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: Colors.grey.shade300,
            selectedIconTheme: IconThemeData(color: Colors.white),
            iconSize: 22,
            selectedFontSize: 12,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w300),
            unselectedFontSize: 12,
            selectedItemColor: Colors.white,
            items: [
              BottomNavigationBarItem(
                icon: Icon(CommunityMaterialIcons.home_outline),
                label: 'Homepage',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border_rounded),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map_sharp),
                label: 'Maps',
              ),
              BottomNavigationBarItem(
                icon: Icon(EvilIcons.gear),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
