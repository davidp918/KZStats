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
        builder: (context, state) => FutureBuilder<List<List<MapTop>>>(
          future: Future.wait([
            getMapTopRecords(
              prevSnapshotData.mapName,
              state.mode,
              state.nub,
              100,
            ),
            getMapTopRecords(
              prevSnapshotData.mapName,
              state.mode,
              true,
              1,
            ),
            getMapTopRecords(
              prevSnapshotData.mapName,
              state.mode,
              false,
              1,
            ),
          ]),
          builder: (
            BuildContext context,
            AsyncSnapshot<List<List<MapTop>>> mapTopSnapshot,
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
                mapInfoSnapshot,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget transition(
    AsyncSnapshot<List<List<MapTop>>> mapTopSnapshot,
    AsyncSnapshot<Mapinfo> mapInfoSnapshot,
  ) {
    return mapTopSnapshot.connectionState == ConnectionState.done &&
            mapInfoSnapshot.connectionState == ConnectionState.done
        ? mainBody(
            // mapTopSnapshot index 0: top 100 records of current bloc state
            //                index 1: single instance of Maptop: nub wr
            //                index 2: single instance of Maptop: pro wr
            mapTopSnapshot.data[0],
            mapTopSnapshot.data[1][0],
            mapTopSnapshot.data[2][0],
            mapInfoSnapshot.data,
          )
        : loadingFromApi();
  }

  Widget mainBody(
    List<MapTop> mapTop,
    MapTop nubWr,
    MapTop proWr,
    Mapinfo mapInfo,
  ) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 100,
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
              imageUrl: '$imageBaseURL${mapInfo.name}}.webp',
            ),
          ),
          Text(
            '${prevSnapshotData.mapName}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          Text(
            'Tier: ${identifyTier(mapInfo.difficulty)}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          Row(
            children: [
              trophy(14, 14),
              SizedBox(
                width: 5,
              ),
              Text(
                'PRO  ${toMinSec(proWr.time)}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              Text(
                ' by ${proWr.playerName}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Row(
            children: [
              trophy(14, 14),
              SizedBox(
                width: 5,
              ),
              Text(
                'NUB  ${toMinSec(nubWr.time)}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              Text(
                ' by ${nubWr.playerName}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          buildDataTable(mapTop),
        ],
      ),
    );
  }

  Widget buildDataTable(List<MapTop> mapTop) {
    final columns = [
      'Rank',
      'Player',
      'Time',
      'Points',
      'TPs',
      'Date',
    ];

    List<DataColumn> getColumns(List<String> columns) => columns
        .map((String column) => DataColumn(
              label: Text(column),
            ))
        .toList();

    List<DataCell> getCells(List<dynamic> cells) =>
        cells.map((data) => DataCell(Text('$data'))).toList();

    List<DataRow> getRows(List<MapTop> mapTop) => mapTop.map((MapTop record) {
          final cells = [
            record.id,
            record.playerName,
            toMinSec(record.time),
            record.points,
            record.teleports,
            record.createdOn,
          ];
          return DataRow(cells: getCells(cells));
        }).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columns: getColumns(columns),
          rows: getRows(mapTop),
        ),
      ),
    );
  }
}
