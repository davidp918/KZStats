import 'package:flutter/material.dart';
import 'package:kzstats/pages/tabs/bans.dart';
import 'package:kzstats/pages/inner/latest.dart';
import 'package:kzstats/pages/inner/leaderboard.dart';
import 'package:kzstats/pages/tabs/maps.dart';
import 'package:kzstats/theme/colors.dart';

class Homepage extends StatefulWidget {
  Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<Homepage> {
  late TabController _tabController;
  late List<Widget> tabs;
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
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: appbarColor(),
            child: Center(
              child: TabBar(
                tabs: tabsTitle(),
                isScrollable: true,
                indicatorColor: Colors.white,
                indicatorWeight: 1.8,
                indicatorSize: TabBarIndicatorSize.label,
              ),
            ),
          ),
          Expanded(child: TabBarView(children: this.tabs)),
        ],
      ),
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
