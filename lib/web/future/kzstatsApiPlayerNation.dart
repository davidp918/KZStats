import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kzstats/web/get/getPlayerKzstatsApi.dart';
import 'package:kzstats/web/json/kztime_json.dart';

Future<List<String>> getPlayerKzstatsNation(
  List<Wr> kzInfosnapshot,
) async {
  return Future.wait(
    kzInfosnapshot.map(
      (item) {
        return getPlayerKzstatsApi(item.steamid64).then(
          (value) {
            return value.loccountrycode.toLowerCase();
          },
        );
      },
    ),
  );
}
