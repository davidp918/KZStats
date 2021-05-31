import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kzstats/common/networkImage.dart';
import 'package:kzstats/data/shared_preferences.dart';
import 'package:kzstats/pages/tabs/maps.dart';
import 'package:kzstats/theme/colors.dart';
import 'package:kzstats/utils/tierIdentifier.dart';
import 'package:kzstats/web/json.dart';
import 'package:kzstats/web/urls.dart';

class MapsPage extends StatefulWidget {
  MapsPage({Key? key}) : super(key: key);

  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late List<MapInfo> mapInfo;
  late List<Widget> _tabsTitle, _tabs;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    this.mapInfo = UserSharedPreferences.getMapData() ?? [];
    this._scrollController = ScrollController();
    this._tabs = [Maps(), Maps()];
    this._tabsTitle = ['All', 'Marked']
        .map((data) => Text(data,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w300,
            )))
        .toList();
    this.mapInfo = this.mapInfo.take(10).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight * 0.85),
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
        body: CustomScrollView(
          controller: this._scrollController,
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              toolbarHeight: kToolbarHeight * 0.6,
              flexibleSpace: Container(
                height: kToolbarHeight * 0.6,
                color: primarythemeBlue(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: ['Sorted by', 'Tier', 'Mapper']
                      .map((each) => InkWell(
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '$each',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300),
                                  ),
                                  SizedBox(width: 3),
                                  Icon(
                                    Icons.keyboard_arrow_down_sharp,
                                    color: Colors.white,
                                    size: 13,
                                  ),
                                ]),
                            onTap: () {},
                          ))
                      .toList(),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(15.0),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      _itemBuilder(context, mapInfo[index], index),
                  childCount: this.mapInfo.length,
                ),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200.0,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  childAspectRatio: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, MapInfo entry, _) {
    return Card(
      color: primarythemeBlue(),
      elevation: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 200 / 113,
            child: GetNetworkImage(
              fileName: entry.mapName!,
              url: '$imageBaseURL${entry.mapName!}.webp',
              errorImage: AssetImage('assets/icon/noimage.png'),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1.5),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        '/map_detail',
                        arguments: [entry.mapId, entry.mapName],
                      );
                    },
                    child: Text(
                      '${entry.mapName}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: inkWellBlue(),
                        fontSize: 17.5,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1.5),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Tier: ${identifyTier(entry.difficulty)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
