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
import 'package:kzstats/others/modifyDate.dart';
import 'package:kzstats/others/strCheckLen.dart';
import 'package:kzstats/theme/colors.dart';

class MapDetail extends StatefulWidget {
  final KzTime prevSnapshotData;
  const MapDetail({Key key, this.prevSnapshotData}) : super(key: key);

  @override
  _MapDetailState createState() => _MapDetailState();
}

class _MapDetailState extends State<MapDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomepageAppBar('${widget.prevSnapshotData.mapName}'),
      body: BlocBuilder<ModeCubit, ModeState>(
        builder: (context, state) => FutureBuilder<List<List<MapTop>>>(
          future: Future.wait([
            getMapTopRecords(
              widget.prevSnapshotData.mapName,
              state.mode,
              state.nub,
              100,
            ),
            getMapTopRecords(
              widget.prevSnapshotData.mapName,
              state.mode,
              true,
              1,
            ),
            getMapTopRecords(
              widget.prevSnapshotData.mapName,
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
              future: getMapInfo(widget.prevSnapshotData.mapId.toString()),
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
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                imageUrl:
                    '$imageBaseURL${widget.prevSnapshotData.mapName}}.webp',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
            SizedBox(
              height: 3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
            SizedBox(
              height: 8,
            ),
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.black),
              child: buildDataTable(mapTop),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDataTable(List<MapTop> mapTop) {
    final columns = [
      '#',
      'Player',
      'Time',
      'TPs',
      'Date',
      'Server',
    ];
    List<DataColumn> getColumns(List<String> columns) => columns
        .map((String column) => DataColumn(
              label: Text('$column'),
            ))
        .toList();

    return SingleChildScrollView(
      child: PaginatedDataTable(
        columns: getColumns(columns),
        source: RecordsSource(records: mapTop),
        dataRowHeight: 50,
      ),
    );
  }
}

class RecordsSource extends DataTableSource {
  final List<MapTop> _records;
  RecordsSource({
    @required List<MapTop> records,
  }) : _records = records;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _records.length) return null;
    final MapTop record = _records[index];
    return DataRow.byIndex(
      index: index,
      color: MaterialStateColor.resolveWith(
        (states) {
          if (index % 2 == 0) {
            return Color(0xff4a5568);
          } else {
            return Color(0xff242d3d);
          }
        },
      ),
      cells: <DataCell>[
        DataCell(Text(
          '#${[index, 1].reduce((a, b) => a + b)}',
          style: TextStyle(
            color: Colors.white,
          ),
        )),
        DataCell(Text(
          '${lenCheck(record.playerName, 15)}',
          style: TextStyle(color: inkwellBlue()),
        )),
        DataCell(Text(
          '${toMinSec(record.time)}',
          style: TextStyle(
            color: Colors.white,
          ),
        )),
        DataCell(Text(
          '${record.teleports}',
          style: TextStyle(
            color: Colors.white,
          ),
        )),
        DataCell(
          Text(
            '${record.createdOn.toString()}',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        DataCell(
          Text(
            '${record.serverName}',
            style: TextStyle(
              color: inkwellBlue(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _records.length;

  @override
  int get selectedRowCount => 0;
}
