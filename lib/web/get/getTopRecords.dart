import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:kzstats/web/json/kztime_json.dart';

import 'package:kzstats/web/urls.dart';

List<KzTime> topRecords;

Future<List<KzTime>> getTopRecords(String currentMode, bool ifNub) async {
  try {
    var response = await http.get(
      Uri.parse(topRecordsSelect(currentMode, ifNub)),
    );
    response.statusCode == HttpStatus.ok
        ? topRecords = kzInfoFromJson(response.body)
        : print('something wrong');
  } catch (exception) {}
  return topRecords;
}
