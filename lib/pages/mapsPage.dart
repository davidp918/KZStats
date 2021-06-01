import 'dart:math';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kzstats/common/error.dart';
import 'package:kzstats/common/loading.dart';
import 'package:kzstats/common/networkImage.dart';
import 'package:kzstats/cubit/tier_cubit.dart';
import 'package:kzstats/cubit/user_cubit.dart';
import 'package:kzstats/data/shared_preferences.dart';
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
  late Future _loadMaps;
  late FilterState filterState;

  @override
  void initState() {
    super.initState();
    this._loadMaps = UserSharedPreferences.updateMapData();
    this._scrollController = ScrollController();
    //this._tabs = [Maps(), Maps()];
    this._tabsTitle = ['All', 'Marked']
        .map(
          (data) => Align(
            alignment: Alignment.center,
            child: Text(
              data,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        )
        .toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.filterState = context.watch<FilterCubit>().state;
    this.mapInfo = filterMapData(UserSharedPreferences.getMapData());
  }

  List<MapInfo> filterMapData(List<MapInfo> data) {
    List<MapInfo> newData = [];
    for (MapInfo info in data) {
      if (filterState.tier.contains(info.difficulty)) newData.add(info);
    }
    return newData;
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
            leading: BlocBuilder<UserCubit, UserState>(
              builder: (context, userState) => IconButton(
                icon: Icon(Icons.person),
                onPressed: () => userState.info.avatarUrl == '' &&
                        userState.info.steam32 == ''
                    ? Navigator.pushNamed(context, '/login')
                    : Navigator.pushNamed(
                        context,
                        '/player_detail',
                        arguments: [
                          userState.info.steam64,
                          userState.info.name
                        ],
                      ),
              ),
            ),
            actions: <Widget>[
              Align(
                alignment: Alignment.bottomCenter,
                child: IconButton(
                  icon: Icon(CommunityMaterialIcons.filter_outline),
                  onPressed: () {
                    Navigator.pushNamed(context, '/filter');
                  },
                ),
              )
            ],
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
        body: FutureBuilder(
          future: this._loadMaps,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState != ConnectionState.done)
              return loadingFromApi();
            List<MapInfo> data = UserSharedPreferences.getMapData();
            if (data == []) return errorScreen();
            this.mapInfo = filterMapData(data);
            return CustomScrollView(
              controller: this._scrollController,
              slivers: <Widget>[
                SliverPadding(
                  padding: EdgeInsets.all(15.0),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          _itemBuilder(context, mapInfo[index], index),
                      childCount: this.mapInfo.length,
                      addAutomaticKeepAlives: true,
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
            );
          },
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
            child: getNetworkImage(
              entry.mapName!,
              '$imageBaseURL${entry.mapName!}.webp',
              AssetImage('assets/icon/noimage.png'),
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
