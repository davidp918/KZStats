import 'package:community_material_icon/community_material_icon.dart';
import 'package:evil_icons_flutter/evil_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:kzstats/pages/maps.dart';
import 'package:kzstats/pages/favourites.dart';
import 'package:kzstats/pages/homepage.dart';
import 'package:kzstats/pages/settings.dart';
import 'package:kzstats/look/colors.dart';

class Base extends StatefulWidget {
  Base({Key? key}) : super(key: key);

  @override
  _BaseState createState() => _BaseState();
}

class _BaseState extends State<Base> with AutomaticKeepAliveClientMixin<Base> {
  late int curIndex;
  late List<Widget> pages;
  late bool reverseAnimation;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    this.curIndex = 0;
    this.reverseAnimation = false;
    this._pageController = PageController();
    this.pages = [Homepage(), Favourites(), Maps(), Settings()];
  }

  void onTap(index) {
    if (mounted)
      setState(() {
        this.reverseAnimation = index < this.curIndex;
        this.curIndex = index;
        this._pageController.jumpToPage(index);
      });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor(),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: this._pageController,
          children: this.pages,
        ),
        bottomNavigationBar: SizedBox(
          height: kToolbarHeight,
          child: BottomNavigationBar(
            onTap: onTap,
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
                label: 'Favourites',
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
  void dispose() {
    this._pageController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
