import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kzstats/common/AppBar.dart';
import 'package:kzstats/common/datatable.dart';
import 'package:kzstats/common/error.dart';
import 'package:kzstats/common/loading.dart';
import 'package:kzstats/common/networkImage.dart';
import 'package:kzstats/cubit/cubit_update.dart';
import 'package:kzstats/others/tierIdentifier.dart';
import 'package:kzstats/others/timeConversion.dart';
import 'package:kzstats/others/svg.dart';
import 'package:kzstats/web/get/getMapInfo.dart';
import 'package:kzstats/web/get/getMapTop.dart';
import 'package:kzstats/web/json/record_json.dart';
import 'package:kzstats/web/json/mapTop_json.dart';
import 'package:kzstats/web/json/mapinfo_json.dart';
import 'package:kzstats/web/urls.dart';

class MapDetail extends StatefulWidget {
  final Wr prevSnapshotData;
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
        builder: (context, state) => FutureBuilder<List<dynamic>>(
          future: Future.wait(
            [
              getMapTopRecords(
                widget.prevSnapshotData.mapId,
                state.mode,
                state.nub,
                100,
              ),
              getMapTopRecords(
                widget.prevSnapshotData.mapId,
                state.mode,
                true,
                1,
              ),
              getMapTopRecords(
                widget.prevSnapshotData.mapId,
                state.mode,
                false,
                1,
              ),
              getMapInfo(widget.prevSnapshotData.mapId.toString()),
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
        ),
      ),
    );
  }

  Widget transition(
      BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
    return snapshot.connectionState == ConnectionState.done
        ? snapshot.hasData
            ? mainBody(
                // index 0: top 100 records of current bloc state
                // index 1: single instance of Maptop: nub wr
                // index 2: single instance of Maptop: pro wr
                // index 3: map info
                snapshot.data[0],
                snapshot.data[1][0],
                snapshot.data[2][0],
                snapshot.data[3],
              )
            : errorScreen()
        : loadingFromApi();
  }

  Widget mainBody(
    List<Record> mapTop,
    Record nubWr,
    Record proWr,
    Mapinfo mapInfo,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        padding: EdgeInsets.fromLTRB(5, 14, 5, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 120,
              child: getCachedNetworkImage(
                '$imageBaseURL${widget.prevSnapshotData.mapName}.webp',
                AssetImage(
                  'assets/icon/noimage.png',
                ),
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              'Tier: ${identifyTier(mapInfo.difficulty)}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                gold(15, 15),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'PRO  ${toMinSec(proWr.time)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                Text(
                  ' by ${proWr.playerName}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
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
                gold(15, 15),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'NUB  ${toMinSec(nubWr.time)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                Text(
                  ' by ${nubWr.playerName}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            buildPaginatedDataTable(context, mapTop),
          ],
        ),
      ),
    );
  }
}
