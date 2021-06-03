import 'package:flutter/material.dart';
import 'package:kzstats/common/networkImage.dart';
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
  late List<String> players;

  @override
  void initState() {
    super.initState();
    this._refreshController = RefreshController(initialRefresh: true);
  }

  void _onRefresh() async {
    print('refreshing ${this.markState.playerIds.length} friends records...');
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
    return Container(
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        controller: _refreshController,
        onRefresh: () => _onRefresh(),
        onLoading: () => _onLoading(),
        scrollDirection: Axis.vertical,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 15,
                itemBuilder: (BuildContext context, int index) => Card(
                  child: Center(child: Text('Dummy Card Text')),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: 10,
                itemBuilder: (ctx, int) {
                  return Card(
                    child: ListTile(
                        title: Text('Motivation $int'),
                        subtitle:
                            Text('this is a description of the motivation')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget playerHeaderBuilder(
      {required String steamid64,
      required String name,
      required String avatarUrl}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30.0,
          backgroundColor: Colors.transparent,
          child: ClipOval(
            child: getNetworkImage(
              steamid64,
              avatarUrl,
              AssetImage('assets/icon/noimage.png'),
            ),
          ),
        ),
        Text('$name'),
      ],
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
