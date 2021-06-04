import 'package:flutter/material.dart';
import 'package:kzstats/common/networkImage.dart';
import 'package:kzstats/common/none.dart';
import 'package:kzstats/cubit/mark_cubit.dart';
import 'package:kzstats/cubit/user_cubit.dart';
import 'package:kzstats/data/shared_preferences.dart';
import 'package:kzstats/look/colors.dart';
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

class FavouritePlayersState extends State<FavouritePlayers> {
  late RefreshController _refreshController;
  late UserState userState;
  late MarkState markState;
  late bool loggedIn;
  late List<String> players;
  late Map<String, Map<String, dynamic>> playerDetails;

  @override
  void initState() {
    super.initState();
    this.playerDetails = {};
    this.players = [];
    this._refreshController = RefreshController(initialRefresh: true);
  }

  void _onRefresh() async {
    print('refreshing ${this.markState.playerIds.length} friends records...');
    await refreshFavouritePlayersRecords(this.markState.playerIds);
    for (String steamid64 in this.players) {
      this.playerDetails[steamid64] = {
        'info': UserSharedPreferences.getPlayerInfo(steamid64),
        'records': UserSharedPreferences.getPlayerRecords(steamid64),
      };
    }
    print('refresh friend records done');
    setState(() {});
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // load more
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    if (this.players.length == 0)
      return noneView(
        title: 'No Favourite Players Yet...',
        subTitle: 'Go mark a few and keep an eye out of their runs',
      );
    return Container(
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        controller: _refreshController,
        onRefresh: () => _onRefresh(),
        onLoading: () => _onLoading(),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.fromLTRB(16, 10, 14, 0),
              child: Text(
                'Latest runs',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: ClampingScrollPhysics(),
                children: [
                  ...playerHeaders(),
                  SizedBox(width: 12),
                ],
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  List<Widget> playerHeaders() => <Widget>[
        for (String steamid64 in this.players)
          playerHeaderBuilder(
            steamid64: steamid64,
            name: this.playerDetails[steamid64]?['info']?.personaname ??
                'Unknown name',
            avatarUrl: this.playerDetails[steamid64]?['info']?.avatarfull ?? '',
          ),
      ];

  Widget playerHeaderBuilder(
      {required String steamid64,
      required String name,
      required String avatarUrl}) {
    double radius = 26;
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 2, 14),
      child: Column(
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: getNetworkImage(
                steamid64,
                avatarUrl,
                AssetImage('assets/icon/noimage.png'),
              ),
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            width: radius * 2 + 6,
            child: Text(
              '$name',
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
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.userState = context.watch<UserCubit>().state;
    this.markState = context.watch<MarkCubit>().state;
    this.loggedIn = !(userState.playerInfo.avatarfull == null &&
        userState.playerInfo.steamid == null);
    this.players = markState.playerIds;
    getPlayerDetails();
  }

  void getPlayerDetails() {
    for (String steamid64 in this.players) {
      this.playerDetails[steamid64] = {
        'info': UserSharedPreferences.readPlayerInfo(steamid64),
        'records': UserSharedPreferences.getPlayerRecords(steamid64),
      };
    }
  }

  Future refreshFavouritePlayersRecords(List<String> playerIds) async {
    List<List<Record>> records = await Future.wait([
      for (String steamid64 in playerIds) getPlayerRecords(steamid64, false)
    ]);

    for (int i = 0; i < playerIds.length; i++) {
      List<Record> curRecords = records[i];
      String curSteamid64 = playerIds[i];
      curRecords.sort((a, b) {
        if (a.createdOn != null || b.createdOn != null)
          return a.createdOn!.compareTo(b.createdOn!);
        return 0;
      });
      await UserSharedPreferences.setPlayerRecords(curSteamid64, curRecords);
    }
  }
}
