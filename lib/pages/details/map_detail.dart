import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kzstats/common/AppBar.dart';
import 'package:kzstats/pages/details/shown/map_detail_datatable.dart';
import 'package:kzstats/common/error.dart';
import 'package:kzstats/common/loading.dart';
import 'package:kzstats/common/networkImage.dart';
import 'package:kzstats/cubit/mode_cubit.dart';
import 'package:kzstats/utils/tierIdentifier.dart';
import 'package:kzstats/web/getRequest.dart';
import 'package:kzstats/web/json.dart';
import 'package:kzstats/web/urls.dart';
import 'package:kzstats/common/widgets/worldRecord.dart';

class MapDetail extends StatefulWidget {
  final dynamic mapInfo;
  const MapDetail({Key? key, this.mapInfo}) : super(key: key);

  @override
  _MapDetailState createState() => _MapDetailState();
}

class _MapDetailState extends State<MapDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomepageAppBar('${widget.mapInfo.mapName}'),
      body: BlocBuilder<ModeCubit, ModeState>(
        builder: (context, state) => FutureBuilder<List<dynamic>>(
          future: Future.wait(
            [
              getRequest(
                globalApiMaptopRecordsUrl(
                  widget.mapInfo!.mapId,
                  state.mode,
                  state.nub,
                  100,
                ),
                recordFromJson,
              ),
              getRequest(
                globalApiMaptopRecordsUrl(
                  widget.mapInfo!.mapId,
                  state.mode,
                  true,
                  1,
                ),
                recordFromJson,
              ),
              getRequest(
                globalApiMaptopRecordsUrl(
                  widget.mapInfo!.mapId,
                  state.mode,
                  false,
                  1,
                ),
                recordFromJson,
              ),
              getRequest(
                globalApiMapInfoUrl(widget.mapInfo!.mapId.toString()),
                mapInfoFromJson,
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
    dynamic maptop,
    dynamic nubWr,
    dynamic proWr,
    MapInfo? mapInfo,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        padding: EdgeInsets.fromLTRB(5, 14, 5, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: GetNetworkImage(
                fileName: '${widget.mapInfo.mapName}',
                url: '$imageBaseURL${widget.mapInfo!.mapName}.webp',
                errorImage: AssetImage('assets/icon/noimage.png'),
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
            Center(
              child: Text(
                'No one has beaten this map yet!',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ]
        : <Widget>[
            worldRecordRow('Pro', proWr),
            worldRecordRow('Nub', nubWr),
            SizedBox(height: 4),
            MapDetailTable(records: mapTop),
          ];
  }
}
