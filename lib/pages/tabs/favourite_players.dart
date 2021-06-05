import 'package:flutter/material.dart';
import 'package:kzstats/common/customDivider.dart';
import 'package:kzstats/common/networkImage.dart';
import 'package:kzstats/common/none.dart';
import 'package:kzstats/cubit/mark_cubit.dart';
import 'package:kzstats/cubit/user_cubit.dart';
import 'package:kzstats/data/shared_preferences.dart';
import 'package:kzstats/utils/timeConversion.dart';
import 'package:kzstats/web/getRequest.dart';
import 'package:kzstats/web/json/record_json.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@pragma("vm:entry-point")
class FavouritePlayers extends StatefulWidget {
  FavouritePlayers({Key? key}) : super(key: key);

  @override
  FavouritePlayersState createState() => FavouritePlayersState();
}

class FavouritePlayersState extends State<FavouritePlayers>
    with AutomaticKeepAliveClientMixin<FavouritePlayers> {
  late RefreshController _refreshController;
  late UserState userState;
  late MarkState markState;
  late bool loggedIn;
  late List<String> subscribedPlayersSteam64id;
  late List<Record> latestRecords;
  late Map<String, Map<String, dynamic>> playerDetails;
  late Map<String, List<Record>> playerRecords;
  late int curPageSize;
  int pageSize = 15;

  @override
  void initState() {
    super.initState();
    this.curPageSize = pageSize;
    this.playerDetails = {};
    this.playerRecords = {};
    this.subscribedPlayersSteam64id = [];
    this.latestRecords = [];
    this._refreshController = RefreshController(initialRefresh: true);
  }

  void _onRefresh() async {
    print('refreshing ${this.markState.playerIds.length} friends records...');
    await refreshFavouritePlayersRecords(this.markState.playerIds);
    this._setPlayerDetails();
    loadLatestRecords(this.pageSize);
    print('refresh friend records done');
    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    this.loadLatestRecords(this.latestRecords.length + this.pageSize);
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (this.subscribedPlayersSteam64id.length == 0)
      return noneView(
        title: 'No Favourite Players Yet...',
        subTitle: 'Go mark a few and keep an eye out of their runs',
      );
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      controller: _refreshController,
      onRefresh: () => _onRefresh(),
      onLoading: () => _onLoading(),
      scrollDirection: Axis.vertical,
      child: ListView(
        shrinkWrap: true,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(16, 10, 14, 2),
            child: Text(
              'Latest runs',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ),
          SingleChildScrollView(
            primary: true,
            child: Container(
              child: Row(
                children: playerHeaders(),
              ),
            ),
          ),
          customDivider(16),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: _itemBuilder,
            itemCount: this.latestRecords.length,
          ),
        ],
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    Record curRecord = this.latestRecords[index];
    String steamid64 = curRecord.steamid64.toString();
    String name = curRecord.playerName ?? '';
    double radius = 21;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              getAvatar(steamid64, radius),
              SizedBox(width: 8),
              Column(
                children: [
                  InkWell(
                    child: Text('$name'),
                    onTap: () => Navigator.of(context).pushNamed(
                      '/player_detail',
                      arguments: [curRecord.steamid64, curRecord.playerName],
                    ),
                  ),
                  Text(
                    '${diffofNow(curRecord.createdOn)}',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
        customDivider(16),
      ],
    );
  }

  List<Widget> playerHeaders() {
    double radius = 26;
    return <Widget>[
      for (String steamid64 in this.subscribedPlayersSteam64id)
        Container(
          height: 112,
          padding: const EdgeInsets.fromLTRB(14, 14, 2, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              getAvatar(steamid64, radius),
              SizedBox(height: 10),
              SizedBox(
                width: radius * 2 + 6,
                child: Text(
                  '${this.playerDetails[steamid64]?['info']?.personaname ?? 'Unknown name'}',
                  softWrap: true,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w300,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
    ];
  }

  Widget getAvatar(String steamid64, double radius) => CircleAvatar(
        radius: radius,
        backgroundColor: Colors.transparent,
        child: ClipOval(
          child: getNetworkImage(
            steamid64,
            this.playerDetails[steamid64]?['info']?.avatarfull ?? '',
            AssetImage('assets/icon/noimage.png'),
          ),
        ),
      );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.userState = context.watch<UserCubit>().state;
    this.markState = context.watch<MarkCubit>().state;
    this.loggedIn = !(userState.playerInfo.avatarfull == null &&
        userState.playerInfo.steamid == null);
    this.subscribedPlayersSteam64id = markState.playerIds;
    _setPlayerDetails();
    loadLatestRecords(this.pageSize);
  }

  void _setPlayerDetails() {
    for (String steamid64 in this.subscribedPlayersSteam64id) {
      this.playerRecords[steamid64] =
          UserSharedPreferences.getPlayerRecords(steamid64);
      this.playerDetails[steamid64] = {
        'info': UserSharedPreferences.readPlayerInfo(steamid64),
        'records': UserSharedPreferences.getPlayerRecords(steamid64),
      };
    }
  }

  void loadLatestRecords(int range) {
    List<Record> latest = [
      for (List<Record> each in this.playerRecords.values.take(range).toList())
        ...each
    ];
    latest.sort((b, a) {
      if (a.createdOn != null || b.createdOn != null)
        return a.createdOn!.compareTo(b.createdOn!);
      return 0;
    });
    this.latestRecords = latest.take(range).toList();
  }

  Future refreshFavouritePlayersRecords(List<String> playerIds) async {
    List<List<Record>> records = await Future.wait([
      for (String steamid64 in playerIds) getPlayerRecords(steamid64, false)
    ]);
    for (int i = 0; i < playerIds.length; i++) {
      List<Record> curRecords = records[i];
      String curSteamid64 = playerIds[i];
      curRecords.sort((b, a) {
        if (a.createdOn != null || b.createdOn != null)
          return a.createdOn!.compareTo(b.createdOn!);
        return 0;
      });
      await UserSharedPreferences.setPlayerRecords(curSteamid64, curRecords);
    }
  }

  @override
  void dispose() {
    this._refreshController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
