import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:kzstats/common/AppBar.dart';
import 'package:kzstats/common/Drawer.dart';
import 'package:kzstats/model/kztimer.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

List<KzTimer> kzTimerFromJson(String str) =>
    List<KzTimer>.from(json.decode(str).map((x) => KzTimer.fromJson(x)));

class _HomepageState extends State<Homepage> {
  final String currentPage = 'KZStats';
  List<KzTimer> result;

  var url =
      'https://kztimerglobal.com/api/v2.0/records/top/recent?modes_list_string=kz_timer&place_top_at_least=1&has_teleports=false&stage=0&limit=200&tickrate=128';

  Future<List<KzTimer>> _getLatest() async {
    try {
      var response = await http.get(Uri.parse(url));
      response.statusCode == HttpStatus.ok
          ? result = kzTimerFromJson(response.body)
          : print('something wrong');
    } catch (exception) {}

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomepageAppBar(currentPage),
      drawer: HomepageDrawer(),
      body: FutureBuilder<List<KzTimer>>(
        future: _getLatest(),
        builder: (BuildContext context, AsyncSnapshot<List<KzTimer>> snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      color: Colors.white,
                      margin: const EdgeInsets.all(20),
                      child: Text('${snapshot.data[index].mapName}'),
                    );
                  },
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        child: CircularProgressIndicator(),
                        width: 60,
                        height: 60,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Loading data from API...'),
                      )
                    ],
                  ),
                );
        },
      ),
    );
  }
}
