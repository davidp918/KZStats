import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kzstats/common/AppBar.dart';
import 'package:kzstats/common/datatable.dart';
import 'package:kzstats/common/error.dart';
import 'package:kzstats/common/loading.dart';
import 'package:kzstats/common/networkImage.dart';
import 'package:kzstats/cubit/cubit_update.dart';
import 'package:kzstats/theme/colors.dart';
import 'package:kzstats/web/getRequest.dart';
import 'package:kzstats/web/json.dart';
import 'package:kzstats/web/urls.dart';

class PlayerDetail extends StatefulWidget {
  final List<String> playerInfo;
  const PlayerDetail({Key? key, required this.playerInfo}) : super(key: key);

  @override
  _MapDetailState createState() => _MapDetailState(
        // need further test about: if a player does not have any records,
        // will this null checks break as it's a list of null
        playerInfo[0],
        playerInfo[1],
      );
}

class _MapDetailState extends State<PlayerDetail> {
  final String steamId64;
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
                getRequest(
                  kzstatsApiPlayerInfoUrl(steamId64),
                  kzstatsApiPlayerFromJson,
                ),
                getRequest(
                  globalApiPlayerRecordsUrl(
                    state.mode!,
                    state.nub!,
                    99999,
                    steamId64,
                  ),
                  mapTopFromJson,
                ),
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
                // [1]: global api player all records
                snapshot.data![0],
                snapshot.data![1],
              )
            : errorScreen()
        : loadingFromApi();
  }

  Widget mainBody(
    KzstatsApiPlayer kzstatsPlayerInfo,
    List<Record>? records,
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
                getCachedNetworkImage(
                  kzstatsPlayerInfo.avatarfull!,
                  AssetImage(
                    'assets/icon/noimage.png',
                  ),
                  borderWidth: 3,
                  height: 130,
                  width: 130,
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Container(
                    height: 130,
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
                                fontSize: 28,
                              ),
                            ),
                            SizedBox(height: 1),
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
                          'Points: 293528',
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        kzstatsPlayerInfo.loccountrycode != null
                            ? Row(
                                children: <Widget>[
                                  Image(
                                    image: AssetImage(
                                      'assets/flag/${kzstatsPlayerInfo.loccountrycode!.toLowerCase()}.png',
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
            SizedBox(height: 6),
            BuildDataTable(
              records: records,
              tableType: 'player_detail',
            ),
          ],
        ),
      ),
    );
  }
}
