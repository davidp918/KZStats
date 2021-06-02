import 'package:flutter/material.dart';
import 'package:kzstats/common/appbars/appbar_widgets.dart';
import 'package:kzstats/look/colors.dart';

class Explore extends StatefulWidget {
  Explore({Key? key}) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  late List<Widget> _tabsTitle, _tabs;

  @override
  void initState() {
    super.initState();
    this._tabsTitle = ['Friends', 'Favourites']
        .map((data) => Align(
            alignment: Alignment.center,
            child: Text(data,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ))))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight * 0.9),
          child: AppBar(
            backgroundColor: appbarColor(),
            leading: userLeadingIcon(context),
            actions: <Widget>[searchWidget(context), PopUpModeSelect()],
            flexibleSpace: Center(
              child: TabBar(
                tabs: this._tabsTitle,
                isScrollable: true,
                indicatorColor: Colors.white,
                indicatorWeight: 1.4,
                indicatorSize: TabBarIndicatorSize.label,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
