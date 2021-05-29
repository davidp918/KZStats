import 'package:flutter/material.dart';
import 'package:kzstats/pages/tabs/bans.dart';
import 'package:kzstats/pages/tabs/jumpstats.dart';
import 'package:kzstats/pages/tabs/latest.dart';
import 'package:kzstats/pages/tabs/leaderboard.dart';
import 'package:kzstats/theme/colors.dart';

class Homepage extends StatefulWidget {
  Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<Homepage> {
  late TabController _tabController;
  late List<Widget> tabs, tabsTitle;
  late int curIndex;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    this._tabController = TabController(length: 5, vsync: this);
    this.tabs = [
      Latest(),
      Leaderboard(type: 'Points'),
      Leaderboard(type: 'Records'),
      Bans(),
      Jumpstats(),
    ];
    this.tabsTitle = [
      'Latest',
      'Points',
      'Records',
      'Bans',
      'Jumpstats',
    ]
        .map((data) => Text(data,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w300,
            )))
        .toList();
    this.curIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 5,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: appbarColor(),
            child: Center(
              child: TabBar(
                tabs: this.tabsTitle,
                isScrollable: true,
                indicatorColor: Colors.white,
                indicatorWeight: 1.4,
                indicatorSize: TabBarIndicatorSize.label,
              ),
            ),
          ),
          Expanded(child: TabBarView(children: this.tabs)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    this._tabController.dispose();
    super.dispose();
  }
}
