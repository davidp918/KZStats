import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kzstats/common/appbars/appbar_widgets.dart';
import 'package:kzstats/common/error.dart';
import 'package:kzstats/common/loading.dart';
import 'package:kzstats/cubit/mapFilter_cubit.dart';
import 'package:kzstats/data/shared_preferences.dart';
import 'package:kzstats/pages/tabs/maps_cards_view.dart';
import 'package:kzstats/look/colors.dart';
import 'package:kzstats/web/json/mapinfo_json.dart';

class Maps extends StatefulWidget {
  Maps({Key? key}) : super(key: key);

  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> with AutomaticKeepAliveClientMixin<Maps> {
  late List<MapInfo> mapInfo;
  late Future _loadMaps;
  late FilterState filterState;

  @override
  void initState() {
    super.initState();
    this._loadMaps = UserSharedPreferences.updateMapData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.filterState = context.watch<FilterCubit>().state;
    List<MapInfo> data = UserSharedPreferences.getMapData();
    this.mapInfo = filterMapData(data);
  }

  List<MapInfo> filterMapData(List<MapInfo> data) {
    List<MapInfo> newData = [];
    List<int> tiers = [for (int tier in filterState.tier) tier + 1];
    int sortBy = filterState.sortBy;
    for (MapInfo info in data)
      if (tiers.contains(info.difficulty)) newData.add(info);
    if (sortBy == 0)
      newData.sort((a, b) => a.mapName.compareTo(b.mapName));
    else if (sortBy == 1)
      newData.sort((b, a) => a.mapName.compareTo(b.mapName));
    else if (sortBy == 2)
      newData.sort((a, b) => a.difficulty.compareTo(b.difficulty));
    else if (sortBy == 3)
      newData.sort((b, a) => a.difficulty.compareTo(b.difficulty));
    else if (sortBy == 4)
      newData.sort((b, a) => a.mapId.compareTo(b.mapId));
    else if (sortBy == 5)
      newData.sort((a, b) => a.updatedOn.compareTo(b.updatedOn));
    else if (sortBy == 6)
      newData.sort((b, a) => a.filesize.compareTo(b.filesize));
    else if (sortBy == 7)
      newData.sort((a, b) => a.filesize.compareTo(b.filesize));
    return newData;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight * 0.9),
          child: AppBar(
            backwardsCompatibility: false,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: appbarColor(),
              statusBarBrightness: Brightness.dark,
            ),
            backgroundColor: appbarColor(),
            leading: userLeadingIcon(context),
            title: Text(
              'Maps',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            actions: <Widget>[
              searchWidget(context),
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
          ),
        ),
        body: FutureBuilder(
          future: this._loadMaps,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState != ConnectionState.done)
              return loadingFromApi();
            List<MapInfo> data = UserSharedPreferences.getMapData();
            if (data.length == 0) return errorScreen();
            this.mapInfo = filterMapData(data);
            return MapCards(prevInfo: this.mapInfo, marked: false);
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
