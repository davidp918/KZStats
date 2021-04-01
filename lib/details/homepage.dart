import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';

import 'package:kzstats/common/AppBar.dart';
import 'package:kzstats/common/Drawer.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final String currentPage = 'KZStats';
  var _latest = [];
  _getLatest() async {
    var url =
        'https://kztimerglobal.com/api/v2.0/records/top/recent?stage=0&tickrate=128&modes_list_string=kz_timer&limit=23';
    var httpClient = new HttpClient();
    var result;
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        var json = await response.transform(utf8.decoder).join();
        var data = jsonDecode(json);
        result = data;
      } else {}
    } catch (exception) {}
    if (!mounted) return;
    setState(() {
      _latest = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: HomepageAppBar(currentPage),
        drawer: HomepageDrawer(),
        body: ListView.builder(
          itemCount: 20,
          itemBuilder: (context, index) {
            return new Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              color: Colors.blue,
              margin: const EdgeInsets.all(20),
              child: Text('${_latest[index]}' ?? 'null'),
            );
          },
        ),
        floatingActionButton: Builder(builder: (builderContext) {
          return FloatingActionButton(onPressed: () {
            _getLatest();
          });
        }),
      ),
    );
  }
}
