import 'package:animations/animations.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:evil_icons_flutter/evil_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:kzstats/pages/indexedTransition.dart';
import 'package:kzstats/pages/maps.dart';
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
  late bool reverseAnimation;

  @override
  void initState() {
    super.initState();
    this.curIndex = 0;
    this.reverseAnimation = false;
    this.pages = [Homepage(), Explore(), Maps(), Settings()];
  }

  void onTap(index) {
    setState(() {
      this.reverseAnimation = index < this.curIndex;
      this.curIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor(),
        body: IndexedTransitionSwitcher(
          index: this.curIndex,
          duration: const Duration(milliseconds: 300),
          reverse: this.reverseAnimation,
          transitionBuilder: (
            Widget child,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return SharedAxisTransition(
              child: child,
              animation: animation,
              fillColor: backgroundColor(),
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
            );
          },
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
