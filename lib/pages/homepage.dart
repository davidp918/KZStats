import 'package:flutter/material.dart';
import 'package:kzstats/common/appbars/appbar_widgets.dart';
import 'package:kzstats/common/appbars/baseAppbar.dart';
import 'package:kzstats/pages/tabs/bans.dart';
import 'package:kzstats/pages/tabs/latest.dart';
import 'package:kzstats/pages/tabs/leaderboard.dart';
import 'package:kzstats/look/colors.dart';

class Homepage extends StatefulWidget {
  Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<Homepage> {
  late List<Widget> tabs, tabsTitle;
  late Widget appbar;
  late ScrollController _scrollController;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    this._scrollController = ScrollController();
    this.appbar = BaseAppBar(
      'KZStats',
      true,
      [searchWidget(context), PopUpModeSelect()],
      kToolbarHeight * 0.8,
    );
    this.tabs = [
      Latest(),
      Leaderboard(type: 'Points'),
      Leaderboard(type: 'Records'),
      Bans(),
      //Jumpstats(),
    ];
    this.tabsTitle = [
      'Latest',
      'Points',
      'Records',
      'Bans',
      //'Jumpstats',
    ]
        .map(
          (data) => Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(
              data,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NestedScrollView(
      controller: this._scrollController,
      headerSliverBuilder: (BuildContext context, _) => <Widget>[this.appbar],
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: appbarColor(),
              child: Center(
                child: TabBar(
                  tabs: this.tabsTitle,
                  isScrollable: false,
                  indicatorColor: Colors.white,
                  indicatorWeight: 1.4,
                  indicatorSize: TabBarIndicatorSize.label,
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: backgroundColor(),
                child: TabBarView(children: this.tabs),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    this._scrollController.dispose();
    super.dispose();
  }
}
