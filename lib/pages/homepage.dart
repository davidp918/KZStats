import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'package:kzstats/common/error.dart';
import 'package:kzstats/common/loading.dart';
import 'package:kzstats/common/networkImage.dart';
import 'package:kzstats/cubit/mode_cubit.dart';
import 'package:kzstats/global/responsive.dart';
import 'package:kzstats/global/sizeInfo_class.dart';
import 'package:kzstats/utils/strCheckLen.dart';
import 'package:kzstats/utils/timeConversion.dart';
import 'package:kzstats/utils/svg.dart';
import 'package:kzstats/theme/colors.dart';
import 'package:kzstats/web/future/kzstatsApiPlayerNation.dart';
import 'package:kzstats/web/urls.dart';
import 'package:kzstats/web/getRequest.dart';
import 'package:kzstats/web/json.dart';

class Homepage extends StatelessWidget {
  void notifySwitching(String mode, bool nub, BuildContext context) {
    String temp;
    nub ? temp = 'Nub' : temp = 'Pro';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Switching to $temp ${mode.substring(3, mode.length)}'),
        duration: Duration(milliseconds: 1600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      currentPage: 'KZStats',
      ifDrawer: true,
      builder: (context, constraints) => BlocConsumer<ModeCubit, ModeState>(
        listenWhen: (previous, current) {
          return previous.mode != current.mode || previous.nub != current.nub;
        },
        listener: (context, state) =>
            notifySwitching('${state.mode}', state.nub, context),
        builder: (context, state) {
          return FutureBuilder<List<dynamic>>(
            future: Future.wait(
              [
                getRequest(
                  globalApiWrRecordsUrl(state.mode, state.nub, 20),
                  wrFromJson,
                ),
                getRequest(
                  globalApiWrRecordsUrl(state.mode, state.nub, 20),
                  wrFromJson,
                ).then((value) => getPlayerKzstatsNation(value!)),
              ],
            ),
            builder: (
              BuildContext context,
              AsyncSnapshot<List<dynamic>> snapshot,
            ) {
              return transition(context, snapshot, constraints);
            },
          );
        },
      ),
    );
  }

  Widget transition(
    BuildContext context,
    AsyncSnapshot<List<dynamic>> snapshot,
    SizeInfo constraints,
  ) {
    return snapshot.connectionState == ConnectionState.done
        ? snapshot.hasData
            ? mainBody(
                // [0] - wr records
                // [1] - nations
                context,
                snapshot.data![0],
                snapshot.data![1],
                constraints,
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
    SizeInfo constraints,
  ) {
    return EasyRefresh(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => snippet(
                  context, index, records[index], nations![index], constraints),
              childCount: records.length,
            ),
          )
        ],
      ),
      onRefresh: () async => BlocProvider.of<ModeCubit>(context).refresh(),
      onLoad: () async {
        await Future.delayed(Duration(seconds: 2));
      },
    );
  }

  Widget snippet(BuildContext context, int index, Wr record, String nation,
      SizeInfo constraints) {
    double halfWidth = constraints.width / 2;
    double crossWidth = halfWidth * 33 / 40 - 7;
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GetNetworkImage(
                fileName: '${record.mapName}',
                url: '$imageBaseURL${record.mapName}.webp',
                errorImage: AssetImage('assets/icon/noimage.png'),
                borderWidth: 0,
                width: crossWidth,
              ),
              SizedBox(width: 14),
              Container(
                width: crossWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        child: Text(
                          record.mapName!,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: inkWellBlue(),
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '${toMinSec(record.time!)}',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        goldSvg(14, 14),
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
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('by ', style: TextStyle(fontSize: 14.5)),
                          Flexible(
                            fit: FlexFit.loose,
                            child: InkWell(
                              child: Text(
                                '${lenCheck(record.playerName!, 15)}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.blue.shade100,
                                    fontSize: 14.5),
                              ),
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  '/player_detail',
                                  arguments: [
                                    record.steamid64!,
                                    record.playerName
                                  ],
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          nation != 'null'
                              ? Image(
                                  image: AssetImage('assets/flag/$nation.png'),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    Text(
                      '${diffofNow(record.createdOn!)}',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(height: 4, color: dividerColor()),
      ],
    );
  }
}
