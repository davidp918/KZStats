import 'package:flutter/material.dart';
import 'package:kzstats/pages/tabs/maps.dart';
import 'package:kzstats/theme/colors.dart';

class MapsPage extends StatefulWidget {
  MapsPage({Key? key}) : super(key: key);

  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late List<Widget> _tabsTitle, _tabs;

  @override
  void initState() {
    super.initState();
    this._tabs = [Maps(), Maps()];
    this._tabsTitle = ['All', 'Marked']
        .map((data) => Text(data,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w300,
            )))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight * 0.8),
          child: Container(
            color: appbarColor(),
            alignment: Alignment.bottomCenter,
            child: TabBar(
              tabs: this._tabsTitle,
              isScrollable: true,
              indicatorColor: Colors.white,
              indicatorWeight: 1.4,
              indicatorSize: TabBarIndicatorSize.label,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(children: this._tabs),
            ),
          ],
        ),
      ),
    );
  }
}
