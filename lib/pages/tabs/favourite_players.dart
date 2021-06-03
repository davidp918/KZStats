import 'package:flutter/material.dart';
import 'package:kzstats/cubit/user_cubit.dart';
import 'package:kzstats/data/shared_preferences.dart';
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
  late bool loggedIn;
  late List<String> _steamFriends;

  @override
  void initState() {
    super.initState();
    this._refreshController = RefreshController(initialRefresh: true);
    this._steamFriends = UserSharedPreferences.getSteamFriends();
  }

  // check if a user is a kzer by {await getPlayerRecords(player, false)}
  // non-kzer return result.length == 0
  void _onRefresh() async {
/*     print('refreshing friend records...');
    await refreshSteamFriends(context);
    await refreshFriendsRecords();
    print('refresh friend records done');
    setState(() {}); */
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
    this.loggedIn = !(userState.playerInfo.avatarfull == null &&
        userState.playerInfo.steamid == null);
  }
}
