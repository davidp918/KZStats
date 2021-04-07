import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:kzstats/web/json/kztime.dart';

import 'package:kzstats/web/urls.dart';

List<KzTime> topRecords;

Future<List<KzTime>> getTopRecords(String currentMode, bool ifNub) async {
  try {
    var response = await http.get(
      Uri.parse(
        ifNub
            ? currentMode == 'Kztimer'
                ? kz_timerTopRecords_nub
                : currentMode == 'SimpleKZ'
                    ? kz_simpleTopRecords_nub
                    : kz_vanillaTopRecords_nub
            : currentMode == 'Kztimer'
                ? kz_timerTopRecords
                : currentMode == 'SimpleKZ'
                    ? kz_simpleTopRecords
                    : kz_vanillaTopRecords,
      ),
    );
    response.statusCode == HttpStatus.ok
        ? topRecords = kzInfoFromJson(response.body)
        : print('something wrong');
  } catch (exception) {}
  return topRecords;
}
