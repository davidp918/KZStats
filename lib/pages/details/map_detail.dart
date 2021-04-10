import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:kzstats/common/AppBar.dart';
import 'package:kzstats/web/json/kztime_json.dart';
import 'package:kzstats/web/urls.dart';
import 'package:kzstats/svg.dart';
import 'package:kzstats/web/get/getMapTop.dart';
import 'package:kzstats/web/json/mapTop_json.dart';

class MapDetail extends StatelessWidget {
  final String currentPage = 'KZStats';
  final KzTime prevSnapshotData;

  const MapDetail({Key key, this.prevSnapshotData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MapTop>>(
      future: getMapTopRecords('bkz_apricity_v3', 'Kztimer', false),
      builder: (BuildContext mapTopContext,
          AsyncSnapshot<List<MapTop>> mapTopSnapshot) {
        return Scaffold(
          appBar: HomepageAppBar('Records'),
          body: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    CachedNetworkImage(
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
                          '$imageBaseURL${prevSnapshotData.mapName}}.webp',
                    ),
                    Column(
                      children: <Widget>[
                        Text('${prevSnapshotData.mapName}}'),
                        Text('Tier: Easy'),
                        Row(
                          children: [
                            trophy(14, 14),
                            Text('${mapTopSnapshot.data[0]}'),
                          ],
                        ),
                        Row(
                          children: [
                            trophy(14, 14),
                            Text('TP'),
                            Text('time'),
                            Text('playerName'),
                          ],
                        ),
                      ],
                    ),
                    DataTable(
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
