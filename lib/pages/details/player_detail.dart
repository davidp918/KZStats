import 'dart:math';

import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kzstats/common/widgets/datatable.dart';
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
import 'package:kzstats/cubit/playerdisplay_cubit.dart';
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

class _PlayerDetailState extends State<PlayerDetail> {
  final String steamid64;
  final String playerName;
  late Future<List<dynamic>> _future;
  late ModeState modeState;
  late MarkState markState;
  _PlayerDetailState(this.steamid64, this.playerName);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.modeState = context.watch<ModeCubit>().state;
    BlocProvider.of<MarkCubit>(context).setIfReady(false);
    this._future = Future.wait([
      UserSharedPreferences.getPlayerInfo(steamid64),
      getPlayerRecords(modeState.nub, 99999, steamid64, modeState.mode),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return DetailedPage(
      markedType: 'player',
      current: this.steamid64,
      title: this.playerName,
      builder: (BuildContext context) {
        return AsyncBuilder<dynamic>(
          future: this._future,
          waiting: (context) => loadingFromApi(),
          error: (context, object, stacktrace) => errorScreen(),
          builder: (context, value) {
            if (mounted) BlocProvider.of<MarkCubit>(context).setIfReady(true);
            return Column(
              children: [
                playerHeader(value[0], pointsSum(value[1])),
                MainBody(steamId64: this.steamid64, records: value[1]),
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
              height: 130,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
}

class MainBody extends StatelessWidget {
  final String steamId64;
  final List<Record>? records;

  const MainBody({
    Key? key,
    required this.steamId64,
    required this.records,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (this.records == null || this.records?.length == 0) {
      return Align(
        alignment: Alignment.center,
        child: Text('No data available'),
      );
    }
    Size size = MediaQuery.of(context).size;
    final playerDisplayState = context.watch<PlayerdisplayCubit>().state;
    if (playerDisplayState.playerDisplay == 'records') {
      return CustomDataTable(
        data: records!,
        columns: ['Map', 'Time', 'Points', 'TPs', 'Date', 'Server'],
        initialSortedColumnIndex: 4,
        initialAscending: false,
      );
    } else if (playerDisplayState.playerDisplay == 'stats') {
      return PlayerDetailStats(records: records!);
    }
    // minus 395 to make the loading icon center
    return Container(height: size.height - 395, child: loadingFromApi());
  }
}
