import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'package:kzstats/common/AppBar.dart';
import 'package:kzstats/common/Drawer.dart';
import 'package:kzstats/common/error.dart';
import 'package:kzstats/common/loading.dart';
import 'package:kzstats/common/networkImage.dart';
import 'package:kzstats/cubit/cubit_update.dart';
import 'package:kzstats/utils/strCheckLen.dart';
import 'package:kzstats/utils/timeConversion.dart';
import 'package:kzstats/utils/svg.dart';
import 'package:kzstats/theme/colors.dart';
import 'package:kzstats/web/future/kzstatsApiPlayerNation.dart';
import 'package:kzstats/web/urls.dart';
import 'package:kzstats/web/getRequest.dart';
import 'package:kzstats/web/json.dart';

class Homepage extends StatelessWidget {
  final String currentPage = 'KZStats';

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
    return Scaffold(
      appBar: HomepageAppBar(currentPage),
      drawer: HomepageDrawer(),
      body: BlocConsumer<ModeCubit, ModeState>(
        listenWhen: (previous, current) {
          return previous.mode != current.mode || previous.nub != current.nub;
        },
        listener: (context, state) => notifySwitching(
          '${state.mode}',
          state.nub!,
          context,
        ),
        builder: (context, state) {
          return FutureBuilder<List<dynamic>>(
            future: Future.wait(
              [
                //getTopRecords(state.mode!, state.nub!, 20),
                getRequest(
                  globalApiWrRecordsUrl(
                    state.mode!,
                    state.nub!,
                    20,
                  ),
                  wrFromJson,
                ),
                getRequest(
                  globalApiWrRecordsUrl(
                    state.mode!,
                    state.nub!,
                    20,
                  ),
                  wrFromJson,
                ).then(
                  (value) => getPlayerKzstatsNation(value!),
                ),
              ],
            ),
            builder: (
              BuildContext context,
              AsyncSnapshot<List<dynamic>> snapshot,
            ) {
              return transition(
                context,
                snapshot,
              );
            },
          );
        },
      ),
    );
  }

  Widget transition(
    BuildContext context,
    AsyncSnapshot<List<dynamic>> snapshot,
  ) {
    return snapshot.connectionState == ConnectionState.done
        ? snapshot.hasData
            ? mainBody(
                // [0] - wr records
                // [1] - nations
                context,
                snapshot.data![0],
                snapshot.data![1],
              )
            : RefreshIndicator(
                child: errorScreen(),
                onRefresh: () async =>
                    BlocProvider.of<ModeCubit>(context).refresh(),
              )
        : loadingFromApi();
  }

  Widget mainBody(
    BuildContext context,
    List<Wr> records,
    List<String>? nations,
  ) {
    return EasyRefresh(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => snippet(
                context,
                index,
                records[index],
                nations![index],
              ),
              childCount: records.length,
            ),
          )
        ],
      ),
      onRefresh: () async => BlocProvider.of<ModeCubit>(context).refresh(),
      // avoid rebuilding the whole widget so previous
      // list is not replaced by the refresh indicator
      // while loading
      onLoad: () async {
        await Future.delayed(Duration(seconds: 2));
      },
      // need to accomplish onRefresh rebuild first as
      // loading more will rebuild the whole widget
      // tree as well
    );
  }

  Widget snippet(
    BuildContext context,
    int index,
    Wr record,
    String nation,
  ) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(35, 15, 0, 15),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 11),
                child: getCachedNetworkImage(
                  '$imageBaseURL${record.mapName}.webp',
                  AssetImage('assets/icon/noimage.png'),
                  borderWidth: 0,
                  height: 90,
                  width: 169,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    child: Container(
                      width: 145,
                      child: Text(
                        record.mapName!,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: inkwellBlue(),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        '/map_detail',
                        arguments: record,
                      );
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        '${toMinSec(record.time!)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      gold(14, 14),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        record.teleports == 1
                            ? '(${record.teleports.toString()} tp)'
                            : record.teleports! > 1
                                ? '(${record.teleports.toString()} tps)'
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
                          '${lenCheck(record.playerName!, 15)}',
                          style: TextStyle(
                            color: Colors.blue.shade100,
                            fontSize: 14.5,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            '/player_detail',
                            // [0]: steam64, [1]: player name,
                            arguments: [
                              record.steamid64!,
                              record.playerName!,
                            ],
                          );
                        },
                      ),
                      SizedBox(
                        width: 4.5,
                      ),
                      nation != 'null'
                          ? Image(
                              image: AssetImage(
                                'assets/flag/$nation.png',
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    '${diffofNow(record.createdOn!)}',
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
          height: 2,
          indent: 0,
          color: dividerColor(),
        ),
      ],
    );
  }
}
