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
import 'package:kzstats/svg.dart';
import 'package:kzstats/web/get/getMapInfo.dart';
import 'package:kzstats/web/get/getMapTop.dart';
import 'package:kzstats/web/json/kztime_json.dart';
import 'package:kzstats/web/json/mapTop_json.dart';
import 'package:kzstats/web/json/mapinfo_json.dart';
import 'package:kzstats/web/urls.dart';

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
            ],
          ),
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
        ? mapTopSnapshot.hasData
            ? mainBody(
                // mapTopSnapshot index 0: top 100 records of current bloc state
                //                index 1: single instance of Maptop: nub wr
                //                index 2: single instance of Maptop: pro wr
                mapTopSnapshot.data[0],
                mapTopSnapshot.data[1][0],
                mapTopSnapshot.data[2][0],
                mapInfoSnapshot.data,
              )
            : errorScreen()
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
              height: 10,
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
                trophy(15, 15),
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
                trophy(15, 15),
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
