import 'package:flutter/material.dart';
import 'package:kzstats/cubit/mark_cubit.dart';
import 'package:kzstats/cubit/user_cubit.dart';
import 'package:kzstats/data/shared_preferences.dart';
import 'package:kzstats/web/getRequest.dart';
import 'package:kzstats/web/json/record_json.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  @override
  void initState() {
    super.initState();
    this._refreshController = RefreshController(initialRefresh: true);
  }

  void _onRefresh() async {
    print('refreshing friend records...');
    await refreshFavouritePlayersRecords(this.markState.playerIds);
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
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      controller: _refreshController,
      onRefresh: () => _onRefresh(),
      onLoading: () => _onLoading(),
      child: Container(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.userState = context.watch<UserCubit>().state;
    this.markState = context.watch<MarkCubit>().state;
    this.loggedIn = !(userState.playerInfo.avatarfull == null &&
        userState.playerInfo.steamid == null);
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
