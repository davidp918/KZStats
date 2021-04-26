import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kzstats/common/AppBar.dart';
import 'package:kzstats/common/error.dart';
import 'package:kzstats/common/loading.dart';
import 'package:kzstats/common/networkImage.dart';
import 'package:kzstats/cubit/cubit_update.dart';
import 'package:kzstats/theme/colors.dart';
import 'package:kzstats/web/get/getPlayerKzstatsApi.dart';
import 'package:kzstats/web/json/kzstatsApiPlayer_json.dart';

class PlayerDetail extends StatefulWidget {
  final List<dynamic> playerInfo;
  const PlayerDetail({Key key, this.playerInfo}) : super(key: key);

  @override
  _MapDetailState createState() => _MapDetailState(
        playerInfo[0],
        playerInfo[1],
      );
}

class _MapDetailState extends State<PlayerDetail> {
  final int steamId64;
  final String playerName;

  _MapDetailState(this.steamId64, this.playerName);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomepageAppBar(playerName),
      body: BlocBuilder<ModeCubit, ModeState>(
        builder: (
          context,
          state,
        ) {
          return FutureBuilder<List<dynamic>>(
            future: Future.wait(
              [
                getPlayerKzstatsApi(steamId64.toString()),
              ],
            ),
            builder: (
              BuildContext context,
              AsyncSnapshot<List<dynamic>> snapshot,
            ) {
              return transition(snapshot);
            },
          );
        },
      ),
    );
  }

  Widget transition(
    AsyncSnapshot<List<dynamic>> snapshot,
  ) {
    return snapshot.connectionState == ConnectionState.done
        ? snapshot.hasData
            ? mainBody(
                // [0]: kzstats player info
                snapshot.data[0],
              )
            : errorScreen()
        : loadingFromApi();
  }

  Widget mainBody(
    KzstatsApiPlayer kzstatsPlayerInfo,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        padding: EdgeInsets.fromLTRB(5, 14, 5, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(width: 9),
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xff606060),
                      width: 1,
                    ),
                  ),
                  child: getCachedNetworkImage(
                    kzstatsPlayerInfo.avatarfull,
                    AssetImage(
                      'assets/icon/noimage.png',
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 120,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${kzstatsPlayerInfo.personaname}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                              ),
                            ),
                            Text(
                              '(${kzstatsPlayerInfo.steamid32})',
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Points: 293528',
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Image(
                              image: AssetImage(
                                'assets/flag/${kzstatsPlayerInfo.loccountrycode.toLowerCase()}.png',
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
                        ),
                        InkWell(
                          child: Text(
                            'steam profile',
                            style: TextStyle(
                              color: inkwellBlue(),
                              fontSize: 14,
                            ),
                          ),
                          onTap: () {},
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // buildPaginatedDataTable(),
          ],
        ),
      ),
    );
  }
}
