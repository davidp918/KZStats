import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:kzstats/common/AppBar.dart';
import 'package:kzstats/common/Drawer.dart';
import 'package:kzstats/common/error.dart';
import 'package:kzstats/common/loading.dart';
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
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait(
          [
            getRequest(
              globalApiAllMaps(),
              mapinfoFromJson,
            ),
          ],
        ),
        builder: (
          BuildContext context,
          AsyncSnapshot<List<dynamic>> snapshot,
        ) {
          return transition(snapshot);
        },
      ),
    );
  }

  Widget transition(
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
  }

  Widget mainBody(
    List<MapInfo>? allMaps,
  ) {
    return PagewiseGridView.count(
      pageSize: 10,
      crossAxisCount: 2,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      childAspectRatio: 0.555,
      padding: EdgeInsets.all(15.0),
      itemBuilder: (context, entry, index) {
        throw (UnimplementedError);
        // return a widget that displays the entry's data
      },
      pageFuture: (pageIndex) {
        throw (UnimplementedError);
        // return a Future that resolves to a list containing the page's data
      },
    );
  }
}
