import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kzstats/common/appbars/appbar_widgets.dart';
import 'package:kzstats/data/shared_preferences.dart';
import 'package:kzstats/look/colors.dart';
import 'package:kzstats/pages/tabs/favourite_players.dart';
import 'package:kzstats/pages/tabs/maps_cards_view.dart';

class Favourites extends StatefulWidget {
  Favourites({Key? key}) : super(key: key);

  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites>
    with AutomaticKeepAliveClientMixin<Favourites> {
  late List<Widget> _tabsTitle, _tabs;

  @override
  void initState() {
    super.initState();
    this._tabs = [
      FavouritePlayers(),
      MapCards(prevInfo: UserSharedPreferences.getMapData(), marked: true),
    ];
    this._tabsTitle = ['Players', 'Maps']
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
    super.build(context);
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        bottom: false,
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
              actions: <Widget>[searchWidget(context)],
              flexibleSpace: SafeArea(
                child: Center(
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
          ),
          body: TabBarView(
            children: this._tabs,
          ), //SteamFriends(),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
