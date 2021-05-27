import 'package:flutter/material.dart';
import 'package:kzstats/pages/bans.dart';
import 'package:kzstats/pages/latest.dart';
import 'package:kzstats/pages/leaderboard.dart';
import 'package:kzstats/pages/maps.dart';
import 'package:kzstats/theme/colors.dart';

class Homepage extends StatefulWidget {
  Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<Homepage> {
  late TabController _tabController;
  late List tabs;
  late int curIndex;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    this._tabController = TabController(length: 4, vsync: this);
    this.tabs = [Latest(), Leaderboard(), Maps(), Bans()];
    this.curIndex = 0;
  }

  @override
  void dispose() {
    this._tabController.dispose();
    super.dispose();
  }

  void onTap(int index) {
    setState(() {
      this.curIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          color: appbarColor(),
          child: Center(
            child: TabBar(
              onTap: onTap,
              tabs: tabsTitle(),
              controller: _tabController,
              isScrollable: true,
              indicatorColor: colorLight(),
              indicatorWeight: 1.8,
              indicatorSize: TabBarIndicatorSize.label,
            ),
          ),
        ),
        Expanded(child: this.tabs[curIndex]),
      ],
    );
  }

  List<Widget> tabsTitle() {
    List<List<dynamic>> titles = [
      ['Latest', 60.0],
      ['Leaderboard', 100.0],
      ['Maps', 40.0],
      ['Bans', 40.0],
    ];
    return titles
        .map(
          (data) => Text(
            '${data[0]}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        )
        .toList();
  }
}
