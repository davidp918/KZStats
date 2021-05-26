import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kzstats/global/detailed_pages.dart';
import 'package:kzstats/pages/details/shown/map_detail_datatable.dart';
import 'package:kzstats/common/error.dart';
import 'package:kzstats/common/loading.dart';
import 'package:kzstats/common/networkImage.dart';
import 'package:kzstats/cubit/mode_cubit.dart';
import 'package:kzstats/theme/colors.dart';
import 'package:kzstats/utils/svg.dart';
import 'package:kzstats/utils/tierIdentifier.dart';
import 'package:kzstats/utils/timeConversion.dart';
import 'package:kzstats/web/getRequest.dart';
import 'package:kzstats/web/json.dart';
import 'package:kzstats/web/urls.dart';

class MapDetail extends StatefulWidget {
  final dynamic mapInfo;
  const MapDetail({Key? key, this.mapInfo}) : super(key: key);

  @override
  _MapDetailState createState() => _MapDetailState();
}

class _MapDetailState extends State<MapDetail> {
  late Future<List<dynamic>> _future;
  late ModeState state;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.state = context.watch<ModeCubit>().state;
    this._future = Future.wait(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return DetailedPage(
      title: widget.mapInfo.mapName,
      builder: (BuildContext context) {
        return FutureBuilder<List<dynamic>>(
          future: this._future,
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) =>
                  transition(
            context,
            snapshot,
          ),
        );
      },
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
    Size size = MediaQuery.of(context).size;
    double ratio = 113 / 200;
    double imageWidth = 200;
    double crossHeight = min((size.height - 56) / 6.4, imageWidth * ratio);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        padding: EdgeInsets.fromLTRB(5, 14, 5, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: crossHeight,
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

  Widget worldRecordRow(String prefix, dynamic wr) {
    return wr == null
        ? Container()
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              goldSvg(15, 15),
              SizedBox(
                width: 4,
              ),
              Text(
                '$prefix  ${toMinSec(wr?.time)} by ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              InkWell(
                child: Text(
                  '${wr.playerName}',
                  style: TextStyle(
                    color: inkWellBlue(),
                    fontSize: 15,
                  ),
                ),
                onTap: () => Navigator.of(context).pushNamed(
                  '/player_detail',
                  arguments: [wr.steamid64, wr.playerName],
                ),
              ),
              SizedBox(
                height: 3,
              ),
            ],
          );
  }
}
