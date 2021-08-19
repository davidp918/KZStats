import 'dart:math';

import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kzstats/common/detailed_pages.dart';
import 'package:kzstats/common/error.dart';
import 'package:kzstats/common/loading.dart';
import 'package:kzstats/common/networkImage.dart';
import 'package:kzstats/common/datatable.dart';
import 'package:kzstats/cubit/mode_cubit.dart';
import 'package:kzstats/look/colors.dart';
import 'package:kzstats/utils/svg.dart';
import 'package:kzstats/utils/tierIdentifier.dart';
import 'package:kzstats/utils/timeConversion.dart';
import 'package:kzstats/web/getRequest.dart';
import 'package:kzstats/web/json/mapinfo_json.dart';
import 'package:kzstats/web/json/record_json.dart';
import 'package:kzstats/web/urls.dart';

class MapDetail extends StatefulWidget {
  final List<dynamic> mapInfo;
  const MapDetail({
    Key? key,
    required this.mapInfo,
  }) : super(key: key);

  @override
  _MapDetailState createState() => _MapDetailState();
}

class _MapDetailState extends State<MapDetail> {
  late Future<List<dynamic>> _future;
  late ModeState state;
  late int? mapId;
  late String? mapName;

  @override
  void initState() {
    super.initState();
    this.mapId = widget.mapInfo[0];
    this.mapName = widget.mapInfo[1];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.state = context.watch<ModeCubit>().state;
    this._future = Future.wait(
      [
        getRequest(
          globalApiMaptopRecordsUrl(
            this.mapId,
            state.mode,
            state.nub,
            100,
          ),
          recordFromJson,
        ),
        getRequest(
          globalApiMaptopRecordsUrl(
            this.mapId,
            state.mode,
            true,
            1,
          ),
          recordFromJson,
        ),
        getRequest(
          globalApiMaptopRecordsUrl(
            this.mapId,
            state.mode,
            false,
            1,
          ),
          recordFromJson,
        ),
        getRequest(
          globalApiMapInfoUrl(this.mapId.toString()),
          mapInfoFromJson,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DetailedPage(
      markedType: 'map',
      current: this.mapId.toString(),
      title: this.mapName ?? 'kz_unknown',
      builder: (BuildContext context) {
        return AsyncBuilder<List<dynamic>>(
          retain: true,
          future: this._future,
          waiting: (context) => loadingFromApi(),
          error: (context, object, stacktrace) => errorScreen(),
          builder: (context, value) {
            if (value?[0] == null &&
                value?[1] == null &&
                value?[2] == null &&
                value?[3] == null) return errorScreen();
            return mainBody(
              // index 0: top 100 records of current bloc state
              // index 1: single instance of Maptop: nub wr
              // index 2: single instance of Maptop: pro wr
              // index 3: map info
              value?.elementAt(0),
              value?.elementAt(1)?.elementAt(0),
              value?.elementAt(2)?.elementAt(0),
              value?.elementAt(3),
            );
          },
        );
      },
    );
  }

  Widget mainBody(
      dynamic maptop, dynamic nubWr, dynamic proWr, MapInfo? mapInfo) {
    Size size = MediaQuery.of(context).size;
    double ratio = 113 / 200;
    double imageWidth = 200;
    double crossHeight = min((size.height - 56) / 6.4, imageWidth * ratio);
    return Scrollbar(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 14),
            Container(
              height: crossHeight,
              child: getNetworkImage(
                '${this.mapName}',
                '$imageBaseURL${this.mapName}.webp',
                AssetImage('assets/icon/noimage.png'),
              ),
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

  dynamic recordSection(dynamic proWr, dynamic nubWr, dynamic maptop) {
    return (proWr == null && nubWr == null)
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
            CustomDataTable(
              data: maptop,
              columns: [
                '#',
                'Player',
                'Time',
                'Points',
                'TPs',
                'Date',
                'Server'
              ],
            ),
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
