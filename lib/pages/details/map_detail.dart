import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kzstats/common/AppBar.dart';
import 'package:kzstats/common/datatable.dart';
import 'package:kzstats/common/error.dart';
import 'package:kzstats/common/loading.dart';
import 'package:kzstats/common/networkImage.dart';
import 'package:kzstats/cubit/cubit_update.dart';
import 'package:kzstats/others/tierIdentifier.dart';
import 'package:kzstats/web/getRequest.dart';
import 'package:kzstats/web/json.dart';
import 'package:kzstats/web/urls.dart';
import 'package:kzstats/common/widgets/worldRecord.dart';

class MapDetail extends StatefulWidget {
  final Wr? prevSnapshotData;
  const MapDetail({Key? key, this.prevSnapshotData}) : super(key: key);

  @override
  _MapDetailState createState() => _MapDetailState();
}

class _MapDetailState extends State<MapDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomepageAppBar('${widget.prevSnapshotData!.mapName}'),
      body: BlocBuilder<ModeCubit, ModeState>(
        builder: (context, state) => FutureBuilder<List<dynamic>>(
          future: Future.wait(
            [
              getRequest(
                globalApiMaptopRecordsUrl(
                  widget.prevSnapshotData!.mapId,
                  state.mode!,
                  state.nub!,
                  100,
                ),
                mapTopFromJson,
              ),
              getRequest(
                globalApiMaptopRecordsUrl(
                  widget.prevSnapshotData!.mapId,
                  state.mode!,
                  true,
                  1,
                ),
                mapTopFromJson,
              ),
              getRequest(
                globalApiMaptopRecordsUrl(
                  widget.prevSnapshotData!.mapId,
                  state.mode!,
                  false,
                  1,
                ),
                mapTopFromJson,
              ),
              getRequest(
                globalApiMapInfoUrl(widget.prevSnapshotData!.mapId.toString()),
                mapinfoFromJson,
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
                snapshot.data?.elementAt(0),
                snapshot.data?.elementAt(1)?.elementAt(0),
                snapshot.data?.elementAt(2)?.elementAt(0),
                snapshot.data?.elementAt(3),
              )
            : errorScreen()
        : loadingFromApi();
  }

  Widget mainBody(
    dynamic? maptop,
    dynamic? nubWr,
    dynamic? proWr,
    Mapinfo? mapInfo,
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
                '$imageBaseURL${widget.prevSnapshotData!.mapName}.webp',
                AssetImage(
                  'assets/icon/noimage.png',
                ),
                borderWidth: 0,
                height: 120,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            mapInfo == null
                ? Container()
                : Text(
                    'Tier: ${identifyTier(mapInfo.difficulty)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
            SizedBox(
              height: 4,
            ),
            ...recordSection(proWr, nubWr, maptop),
          ],
        ),
      ),
    );
  }

  dynamic recordSection(
    dynamic proWr,
    dynamic nubWr,
    dynamic mapTop,
  ) {
    return proWr == null && nubWr == null
        ? <Widget>[
            Container(
              child: Text(
                'No one has beaten this map yet!',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ]
        : <Widget>[
            worldRecordRow('Pro', proWr),
            worldRecordRow('Nub', nubWr),
            SizedBox(height: 4),
            BuildDataTable(
              records: mapTop,
              tableType: 'map_detail',
            ),
          ];
  }
}
