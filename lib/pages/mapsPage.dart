import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kzstats/common/error.dart';
import 'package:kzstats/common/loading.dart';
import 'package:kzstats/cubit/mapFilter_cubit.dart';
import 'package:kzstats/cubit/user_cubit.dart';
import 'package:kzstats/data/shared_preferences.dart';
import 'package:kzstats/pages/tabs/maps_cards_view.dart';
import 'package:kzstats/theme/colors.dart';
import 'package:kzstats/web/json.dart';

class MapsPage extends StatefulWidget {
  MapsPage({Key? key}) : super(key: key);

  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late List<MapInfo> mapInfo;
  late List<Widget> _tabsTitle, _tabs;
  late Future _loadMaps;
  late FilterState filterState;

  @override
  void initState() {
    super.initState();
    this._loadMaps = UserSharedPreferences.updateMapData();
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
  }

  List<MapInfo> filterMapData(List<MapInfo> data) {
    List<MapInfo> newData = [];
    List<int> tiers = [for (int tier in filterState.tier) tier + 1];
    int sortBy = filterState.sortBy;
    for (MapInfo info in data)
      if (tiers.contains(info.difficulty)) newData.add(info);
    if (sortBy == 0) newData.sort((a, b) => a.mapName.compareTo(b.mapName));
    if (sortBy == 1) newData.sort((b, a) => a.mapName.compareTo(b.mapName));
    if (sortBy == 2)
      newData.sort((a, b) => a.difficulty.compareTo(b.difficulty));
    if (sortBy == 3)
      newData.sort((b, a) => a.difficulty.compareTo(b.difficulty));
    if (sortBy == 4) newData.sort((b, a) => a.mapId.compareTo(b.mapId));
    if (sortBy == 5) newData.sort((a, b) => a.updatedOn.compareTo(b.updatedOn));
    if (sortBy == 6) newData.sort((b, a) => a.filesize.compareTo(b.filesize));
    if (sortBy == 7) newData.sort((a, b) => a.filesize.compareTo(b.filesize));
    return newData;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
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
            this._tabs = [
              MapCards(info: this.mapInfo, marked: false),
              MapCards(info: this.mapInfo, marked: true),
            ];
            return TabBarView(children: this._tabs);
          },
        ),
      ),
    );
  }
}
