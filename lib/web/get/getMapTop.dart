import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:kzstats/web/json/mapTop_json.dart';

import 'package:kzstats/web/urls.dart';

List<MapTop> mapTopRecords;

Future<List<MapTop>> getMapTopRecords(
  String mapName,
  String currentMode,
  bool ifNub,
  int amount,
) async {
  try {
    var response = await http.get(
      Uri.parse(
        mapTopRecordsSelect(mapName, currentMode, ifNub, amount),
      ),
    );
    response.statusCode == HttpStatus.ok
        ? mapTopRecords = mapTopFromJson(response.body)
        : print('something wrong');
  } catch (exception) {}

  return mapTopRecords;
}
