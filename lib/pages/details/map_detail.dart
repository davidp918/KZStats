import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:kzstats/common/AppBar.dart';
import 'package:kzstats/common/loading.dart';
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
      body: FutureBuilder<List<MapTop>>(
        future: getMapTopRecords(
          prevSnapshotData.mapName,
          prevSnapshotData.mode,
          false,
        ),
        builder: (
          BuildContext mapTopContext,
          AsyncSnapshot<List<MapTop>> mapTopSnapshot,
        ) {
          return FutureBuilder<Mapinfo>(
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
    );
  }

  Widget transition(
    AsyncSnapshot<List<MapTop>> mapTopSnapshot,
    AsyncSnapshot<Mapinfo> mapInfoSnapshot,
  ) {
    return mapTopSnapshot.connectionState == ConnectionState.done
        ? mainBody(
            mapTopSnapshot,
            mapInfoSnapshot,
          )
        : loadingFromApi();
  }

  Widget mainBody(
    AsyncSnapshot<List<MapTop>> mapTopSnapshot,
    AsyncSnapshot<Mapinfo> mapInfoSnapshot,
  ) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10.0),
          child: Row(
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
                  imageUrl: '$imageBaseURL${prevSnapshotData.mapName}}.webp',
                ),
              ),
              Column(
                children: <Widget>[
                  Text('${prevSnapshotData.mapName}}'),
                  Text(
                      'Tier: ${identifyTier(mapInfoSnapshot.data.difficulty)}'),
                ],
              ),
              /* DataTable(
                      columns: [
                        DataColumn(label: Text('Rank')),
                        DataColumn(label: Text('Player')),
                        DataColumn(label: Text('Time')),
                        DataColumn(label: Text('Points')),
                        DataColumn(label: Text('TPs')),
                        DataColumn(label: Text('Date')),
                        DataColumn(label: Text('Server')),
                      ],
                      rows: [],
                    ), */
            ],
          ),
        ),
      ],
    );
  }
}
