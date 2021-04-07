import 'package:flutter/material.dart';
import 'package:kzstats/common/AppBar.dart';

class MapDetail extends StatelessWidget {
  final String currentPage = 'KZStats';
  final String mapName;

  const MapDetail({Key key, this.mapName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomepageAppBar('Records'),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[Text('$mapName')],
            ),
          ),
        ],
      ),
    );
  }
}
