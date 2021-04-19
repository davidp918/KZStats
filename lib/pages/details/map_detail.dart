import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kzstats/common/AppBar.dart';
import 'package:kzstats/common/loading.dart';
import 'package:kzstats/cubit/cubit_update.dart';
import 'package:kzstats/others/timeConversion.dart';
import 'package:kzstats/web/json/kztime_json.dart';
import 'package:kzstats/web/urls.dart';
import 'package:kzstats/svg.dart';
import 'package:kzstats/web/get/getMapTop.dart';
import 'package:kzstats/web/json/mapTop_json.dart';
import 'package:kzstats/web/json/mapinfo_json.dart';
import 'package:kzstats/web/get/getMapInfo.dart';
import 'package:kzstats/others/tierIdentifier.dart';

class MapDetail extends StatelessWidget {
  final String currentPage = 'KZStats';
  final KzTime prevSnapshotData;

  const MapDetail({Key key, this.prevSnapshotData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomepageAppBar('Records'),
      body: BlocBuilder<ModeCubit, ModeState>(
        builder: (context, state) {
          return FutureBuilder<List<MapTop>>(
            // get top 100 records
            future: getMapTopRecords(
              prevSnapshotData.mapName,
              state.mode,
              state.nub,
              100,
            ),
            builder: (
              BuildContext mapTopContext,
              AsyncSnapshot<List<MapTop>> mapTopSnapshot,
            ) {
              return FutureBuilder<List<MapTop>>(
                // get tp wr
                future: getMapTopRecords(
                  prevSnapshotData.mapName,
                  state.mode,
                  true,
                  1,
                ),
                builder: (
                  BuildContext nubWrContext,
                  AsyncSnapshot<List<MapTop>> nubWrSnapshot,
                ) {
                  return FutureBuilder<List<MapTop>>(
                    // get tp wr
                    future: getMapTopRecords(
                      prevSnapshotData.mapName,
                      state.mode,
                      false,
                      1,
                    ),
                    builder: (
                      BuildContext proWrContext,
                      AsyncSnapshot<List<MapTop>> proWrSnapshot,
                    ) {
                      return FutureBuilder<Mapinfo>(
                        // get map info, e.g tier
                        future: getMapInfo(prevSnapshotData.mapId.toString()),
                        builder: (
                          BuildContext mapInfoContext,
                          AsyncSnapshot<Mapinfo> mapInfoSnapshot,
                        ) =>
                            transition(
                          mapTopSnapshot,
                          nubWrSnapshot,
                          proWrSnapshot,
                          mapInfoSnapshot,
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget transition(
    AsyncSnapshot<List<MapTop>> mapTopSnapshot,
    AsyncSnapshot<List<MapTop>> nubWrSnapshot,
    AsyncSnapshot<List<MapTop>> proWrSnapshot,
    AsyncSnapshot<Mapinfo> mapInfoSnapshot,
  ) {
    return mapTopSnapshot.connectionState == ConnectionState.done &&
            nubWrSnapshot.connectionState == ConnectionState.done &&
            proWrSnapshot.connectionState == ConnectionState.done &&
            mapInfoSnapshot.connectionState == ConnectionState.done
        ? mainBody(
            mapTopSnapshot,
            nubWrSnapshot,
            proWrSnapshot,
            mapInfoSnapshot,
          )
        : loadingFromApi();
  }

  Widget mainBody(
    AsyncSnapshot<List<MapTop>> mapTopSnapshot,
    AsyncSnapshot<List<MapTop>> nubWrSnapshot,
    AsyncSnapshot<List<MapTop>> proWrSnapshot,
    AsyncSnapshot<Mapinfo> mapInfoSnapshot,
  ) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
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
                  errorWidget: (context, url, error) => Image(
                    image: AssetImage('assets/icon/noimage.png'),
                  ),
                  imageUrl: '$imageBaseURL${mapInfoSnapshot.data.name}}.webp',
                ),
              ),
              Column(
                children: <Widget>[
                  Text(
                    '${prevSnapshotData.mapName}',
                  ),
                  Text(
                    'Tier: ${identifyTier(mapInfoSnapshot.data.difficulty)}',
                  ),
                  Row(
                    children: [
                      trophy(14, 14),
                      SizedBox(
                        width: 5,
                      ),
                      Text('PRO  ${toMinSec(proWrSnapshot.data[0].time)}'),
                      Text(' by ${proWrSnapshot.data[0].playerName}'),
                    ],
                  ),
                  Row(
                    children: [
                      trophy(14, 14),
                      SizedBox(
                        width: 5,
                      ),
                      Text('NUB  ${toMinSec(nubWrSnapshot.data[0].time)}'),
                      Text(' by ${nubWrSnapshot.data[0].playerName}'),
                    ],
                  ),
                ],
              ),
            ],
          ),
          buildDataTable(),
        ],
      ),
    );
  }

  Widget buildDataTable() {
    final columns = [
      'Rank',
      'Player',
      'Time',
      'Points',
      'TPs',
      'Date',
      'Server',
    ];

    List<DataColumn> getColumns(List<String> columns) => columns
        .map((String column) => DataColumn(
              label: Text(column),
            ))
        .toList();

    return DataTable(
      columns: getColumns(columns),
      rows: [],
    );
  }
}
