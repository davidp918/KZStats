import 'package:community_material_icon/community_material_icon.dart';
import 'package:evil_icons_flutter/evil_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:kzstats/common/appbars/baseAppBar.dart';
import 'package:kzstats/pages/Favourites.dart';
import 'package:kzstats/pages/details/explore.dart';
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
    this.title = 'KZStats';
    this.pages = [Homepage(), Explore(), Favourites(), Settings()];
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
    if (index == 1) this.title = 'Explore';
    if (index == 2) this.title = 'Favourites';
    if (index == 3) this.title = 'Settings';
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
        bottomNavigationBar: SizedBox(
          height: kToolbarHeight,
          child: BottomNavigationBar(
            backgroundColor: appbarColor(),
            currentIndex: this.curIndex,
            onTap: onTap,
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
}
