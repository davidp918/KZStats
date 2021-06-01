import 'package:evil_icons_flutter/evil_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:kzstats/common/Popup_mode.dart';
import 'package:kzstats/common/appbars/baseAppbar.dart';
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
  late List<Widget> tabs, tabsTitle;
  late Widget appbar;
  late int curIndex;
  late ScrollController _scrollController;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    this._scrollController = ScrollController();
    this.appbar = BaseAppBar('KZStats', true, [
      IconButton(
        icon: Icon(EvilIcons.search),
        onPressed: () => Navigator.pushNamed(context, '/search'),
      ),
      PopUpModeSelect(),
    ]);
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
    return NestedScrollView(
      controller: this._scrollController,
      headerSliverBuilder: (BuildContext context, _) => <Widget>[this.appbar],
      body: DefaultTabController(
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
      ),
    );
  }
}
