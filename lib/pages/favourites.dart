import 'package:flutter/material.dart';
import 'package:kzstats/common/appbars/appbar_widgets.dart';
import 'package:kzstats/cubit/user_cubit.dart';
import 'package:kzstats/data/shared_preferences.dart';
import 'package:kzstats/look/colors.dart';
import 'package:kzstats/web/future/steamApiFirends.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Favourites extends StatefulWidget {
  Favourites({Key? key}) : super(key: key);

  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  late List<Widget> _tabsTitle, _tabs;

  @override
  void initState() {
    super.initState();
    this._tabsTitle = ['Maps', 'Players']
        .map((data) => Align(
            alignment: Alignment.center,
            child: Text(data,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ))))
        .toList();
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
            leading: userLeadingIcon(context),
            actions: <Widget>[searchWidget(context), PopUpModeSelect()],
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
        body: SteamFriends(),
      ),
    );
  }
}

class SteamFriends extends StatefulWidget {
  SteamFriends({Key? key}) : super(key: key);

  @override
  SteamFriendsState createState() => SteamFriendsState();
}

class SteamFriendsState extends State<SteamFriends> {
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
    if (!this.loggedIn) return notLoggedInView();
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      controller: _refreshController,
      onRefresh: () => _onRefresh(),
      onLoading: () => _onLoading(),
      child: Container(),
    );
  }

  Widget notLoggedInView() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You have not logged in',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 2),
            Text(
              "Log in to view your friends' latest records",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 6),
            InkWell(
              onTap: () => Navigator.pushNamed(context, '/login'),
              child: Container(
                height: 40,
                width: 170,
                child: Card(
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  color: primarythemeBlue(),
                  child: Center(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.userState = context.watch<UserCubit>().state;
    this.loggedIn = !(userState.playerInfo.avatarfull == null &&
        userState.playerInfo.steamid == null);
  }
}
