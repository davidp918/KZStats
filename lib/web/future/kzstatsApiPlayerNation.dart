import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kzstats/web/get/getPlayerKzstatsApi.dart';
import 'package:kzstats/web/json/kztime_json.dart';

Future<List<String>> getPlayerKzstatsNation(
    AsyncSnapshot<List<KzTime>> kzInfosnapshot) async {
  List<String> steam64s = [];

  for (var i = 0; i < kzInfosnapshot.data.length; i++) {
    steam64s.add(kzInfosnapshot.data[i].steamid64);
  }

  return Future.wait(
    steam64s.map(
      (item) => getPlayerKzstatsApi(item).then(
        (value) => value.loccountrycode.toLowerCase(),
      ),
    ),
  );
}
