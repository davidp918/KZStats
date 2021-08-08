import 'dart:math';

import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kzstats/common/datatable.dart';
import 'package:kzstats/common/detailed_pages.dart';
import 'package:kzstats/cubit/mark_cubit.dart';
import 'package:kzstats/data/shared_preferences.dart';
import 'package:kzstats/web/json/kzstatsApiPlayer_json.dart';
import 'package:kzstats/web/json/record_json.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kzstats/common/error.dart';
import 'package:kzstats/common/loading.dart';
import 'package:kzstats/common/networkImage.dart';
import 'package:kzstats/cubit/mode_cubit.dart';
import 'package:kzstats/pages/details/player_detail_stats.dart';
import 'package:kzstats/look/colors.dart';
import 'package:kzstats/utils/pointsSum.dart';
import 'package:kzstats/web/getRequest.dart';

class PlayerDetail extends StatefulWidget {
  final List<dynamic> playerInfo;
  const PlayerDetail({Key? key, required this.playerInfo}) : super(key: key);

  @override
  _PlayerDetailState createState() => _PlayerDetailState(
        // need further test about: if a player does not have any records,
        // will this null checks break as it's a list of null
        playerInfo[0],
        playerInfo[1],
      );
}

class _PlayerDetailState extends State<PlayerDetail>
    with SingleTickerProviderStateMixin {
  final String? steamid64;
  final String? playerName;
  late Future<List<dynamic>> _future;
  late ModeState modeState;
  late MarkState markState;
  late List<Widget> tabs;
  late TabController _tabController;
  late int curIndex;
  _PlayerDetailState(this.steamid64, this.playerName);

  @override
  void initState() {
    super.initState();
    this.curIndex = 0;
    this._tabController = new TabController(
      length: 2,
      vsync: this,
      initialIndex: curIndex,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.modeState = context.watch<ModeCubit>().state;
    BlocProvider.of<MarkCubit>(context).setIfReady(false);
    this._future = Future.wait([
      UserSharedPreferences.getPlayerInfo(steamid64 ?? ''),
      getTopRecords(modeState.nub, 99999, steamid64 ?? '', modeState.mode),
    ]);
  }

  List<Record> filterTopRecords(dynamic data) {
    if (data == null) return [];
    List<Record> res = [];
    for (Record each in data) {
      if (each.points != 0) res.add(each);
    }
    res.sort((a, b) {
      if (a.createdOn != null && b.createdOn != null) {
        return b.createdOn!.compareTo(a.createdOn!);
      } else {
        return 0;
      }
    });
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return DetailedPage(
      markedType: 'player',
      current: this.steamid64 ?? '',
      title: this.playerName ?? '',
      builder: (BuildContext context) {
        return AsyncBuilder<dynamic>(
          future: this._future,
          waiting: (context) => loadingFromApi(),
          error: (context, object, stacktrace) => errorScreen(),
          builder: (context, value) {
            if (mounted) BlocProvider.of<MarkCubit>(context).setIfReady(true);
            List<Record> records = filterTopRecords(value[1]);
            this.tabs = [
              CustomDataTable(
                data: records,
                columns: ['Map', 'Time', 'Points', 'TPs', 'Date', 'Server'],
              ),
              PlayerDetailStats(records: records),
            ];
            return Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: appbarColor(),
                  child: TabBar(
                    controller: this._tabController,
                    indicatorColor: Colors.white,
                    indicatorWeight: 1.4,
                    indicatorSize: TabBarIndicatorSize.label,
                    onTap: (int index) {
                      if (mounted)
                        setState(() {
                          this.curIndex = index;
                          this._tabController.animateTo(index);
                        });
                    },
                    tabs: ['Records', 'Statistics']
                        .map(
                          (data) => Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Text(
                              data,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      playerHeader(value[0], pointsSum(value[1])),
                      IndexedStack(
                        children: this.tabs,
                        index: this.curIndex,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget playerHeader(KzstatsApiPlayer? kzstatsPlayerInfo, int totalPoints) {
    Size size = MediaQuery.of(context).size;
    double avatarSize = min(140, size.width / 3);
    kzstatsPlayerInfo ??= KzstatsApiPlayer();
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          SizedBox(width: 2),
          Container(
            width: avatarSize,
            height: avatarSize,
            child: getNetworkImage(
              '${kzstatsPlayerInfo.steamid}',
              kzstatsPlayerInfo.avatarfull ?? '',
              AssetImage('assets/icon/noimage.png'),
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Container(
              height: avatarSize,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${kzstatsPlayerInfo.personaname}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                          fontSize: 28,
                        ),
                      ),
                      Text(
                        '(${kzstatsPlayerInfo.steamid32})',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Points: ${totalPoints.toString()}',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                  ),
                  kzstatsPlayerInfo.loccountrycode != null &&
                          kzstatsPlayerInfo.loccountrycode != ''
                      ? Row(
                          children: <Widget>[
                            Image(
                              image: AssetImage(
                                'assets/flag/${kzstatsPlayerInfo.loccountrycode?.toLowerCase()}.png',
                              ),
                            ),
                            SizedBox(width: 6),
                            Text(
                              '${kzstatsPlayerInfo.country}',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  InkWell(
                    child: Text(
                      'steam profile',
                      style: TextStyle(
                        color: inkWellBlue(),
                        fontSize: 14,
                      ),
                    ),
                    onTap: () async {
                      String url = '${kzstatsPlayerInfo?.profileurl}';
                      await canLaunch(url)
                          ? await launch(url)
                          : throw ('could not launch $url');
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
