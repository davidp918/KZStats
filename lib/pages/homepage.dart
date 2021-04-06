import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:kzstats/common/AppBar.dart';
import 'package:kzstats/common/Drawer.dart';
import 'package:kzstats/cubit/cubit_update.dart';
import 'package:kzstats/model/kzjson.dart';
import 'package:kzstats/others/strCheckLen.dart';
import 'package:kzstats/web/get.dart';
import 'package:kzstats/web/urls.dart';
import 'package:kzstats/others/timeConversion.dart';

class Homepage extends StatelessWidget {
  final String currentPage = 'KZStats';
  final Widget trophy = SvgPicture.asset(
    'assets/icon/trophy.svg',
    height: 14,
    width: 14,
  );

  void notifySwitching(String mode, bool nub, BuildContext context) {
    String temp;
    nub ? temp = 'Nub' : temp = 'Pro';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Switching to $temp $mode'),
        duration: Duration(milliseconds: 4000),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xff4a5568),
      ),
      home: Scaffold(
        appBar: HomepageAppBar(currentPage),
        drawer: HomepageDrawer(),
        body: BlocConsumer<ModeCubit, ModeState>(
          listener: (context, state) =>
              notifySwitching('${state.mode}', state.nub, context),
          builder: (context, state) => FutureBuilder<List<KzTime>>(
            future: getTopRecords(state.mode, state.nub),
            builder: (
              BuildContext context,
              AsyncSnapshot<List<KzTime>> kzInfosnapshot,
            ) =>
                mainBody(context, kzInfosnapshot),
          ),
        ),
      ),
    );
  }

  Widget mainBody(
    BuildContext context,
    AsyncSnapshot<List<KzTime>> snapshot,
  ) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: (snapshot.connectionState == ConnectionState.done)
          ? EasyRefresh(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => snippet(context, snapshot, index),
                      childCount: snapshot.data.length,
                    ),
                  )
                ],
              ),
              onRefresh: () async =>
                  BlocProvider.of<ModeCubit>(context).refresh(),
              // avoid rebuilding the whole widget so previous
              // list is not replaced by the refresh indicator
              // while loading
              onLoad: () async {
                await Future.delayed(Duration(seconds: 2));
              },
              // need to accomplish onRefresh rebuild first as
              // loading more will rebuild the whole widget
              // tree as well
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    child: CircularProgressIndicator(),
                    width: 60,
                    height: 60,
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        'Loading data from API...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ))
                ],
              ),
            ),
    );
  }

  Widget snippet(BuildContext context, AsyncSnapshot<List<KzTime>> snapshot,
          int index) =>
      Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(35, 15, 0, 15),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 11),
                child: Container(
                  height: 90,
                  width: 160.71,
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Center(
                      child: SizedBox(
                        child: CircularProgressIndicator(),
                        height: 30,
                        width: 30,
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.error_outline,
                      color: Colors.red.shade200,
                    ),
                    imageUrl:
                        '$imageBaseURL${snapshot.data[index].mapName}.webp',
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    child: Text(
                      '${lenCheck(snapshot.data[index].mapName, 20)}',
                      style: TextStyle(
                        color: Colors.blue.shade100,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {},
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        '${toMinSec(snapshot.data[index].time)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      trophy,
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        snapshot.data[index].teleports == 1
                            ? '(${snapshot.data[index].teleports.toString()} tp)'
                            : snapshot.data[index].teleports > 1
                                ? '(${snapshot.data[index].teleports.toString()} tps)'
                                : '',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Text(
                        'by ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.5,
                        ),
                      ),
                      InkWell(
                        child: Text(
                          '${lenCheck(snapshot.data[index].playerName, 15)}',
                          style: TextStyle(
                            color: Colors.blue.shade100,
                            fontSize: 14.5,
                          ),
                        ),
                        onTap: () {
                          print(snapshot.data);
                        },
                      ),
                      SizedBox(
                        width: 4.5,
                      ),
                      FutureBuilder(
                        future:
                            getPlayerSteam('${snapshot.data[index].steamid64}'),
                        builder: (BuildContext steamPlayerContext,
                            AsyncSnapshot<Player> playerSteamSnapshot) {
                          return playerSteamSnapshot.hasData
                              ? playerSteamSnapshot.data.response.players[0]
                                          .loccountrycode !=
                                      null
                                  ? Image(
                                      image: AssetImage(
                                          'assets/flag/${playerSteamSnapshot.data.response.players[0].loccountrycode.toLowerCase()}.png'),
                                    )
                                  : Container()
                              : Icon(Icons.ac_unit);
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    '${diffofNow(snapshot.data[index].createdOn)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(
          height: 1.0,
          indent: 0,
          color: Colors.black,
        ),
      ]);
}
