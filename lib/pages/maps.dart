import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:kzstats/common/AppBar.dart';
import 'package:kzstats/common/Drawer.dart';
import 'package:kzstats/common/networkImage.dart';
import 'package:kzstats/web/getRequest.dart';
import 'package:kzstats/web/json/mapinfo_json.dart';
import 'package:kzstats/web/urls.dart';

class Maps extends StatelessWidget {
  final String currentPage = 'Maps';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HomepageAppBar(currentPage),
        drawer: HomepageDrawer(),
        body: MapsGridView()

        /* FutureBuilder<List<dynamic>>(
        future: Future.wait(
          [
            getRequest(
              globalApiAllMaps(),
              multiMapInfoFromJson,
            ),
          ],
        ),
        builder: (
          BuildContext context,
          AsyncSnapshot<List<dynamic>> snapshot,
        ) {
          return transition(snapshot);
        },
      ), */
        );
  }
}

/*   Widget transition(
    AsyncSnapshot<List<dynamic>> snapshot,
  ) {
    return snapshot.connectionState == ConnectionState.done
        ? snapshot.hasData
            ? mainBody(
                // [0]: all maps info
                snapshot.data?.elementAt(0),
              )
            : errorScreen()
        : loadingFromApi();
  } */

class MapsGridView extends StatelessWidget {
  static const int pageSize = 6;

  @override
  Widget build(BuildContext context) {
    return PagewiseGridView.count(
      pageSize: pageSize,
      crossAxisCount: 2,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      childAspectRatio: 0.555,
      padding: EdgeInsets.all(15.0),
      itemBuilder: this._itemBuilder,
      pageFuture: (pageIndex) => this._loadMore(pageIndex! * pageSize),
    );
  }

  Future<List<MapInfo>> _loadMore(int limit) async {
    return getMultiRequest(
      globalApiAllMaps(limit),
      multiMapInfoFromJson,
    );
  }

  Widget _itemBuilder(BuildContext context, MapInfo entry, _) {
    return Card(
      child: Column(
        children: [
          GetNetworkImage(
            fileName: entry.name!,
            url: '$imageBaseURL${entry.name!}.webp',
            errorImage: AssetImage('assets/icon/noimage.png'),
            borderWidth: 0,
            height: 120,
          ),
          SizedBox(height: 4),
          Text(
            '${entry.name!}',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
