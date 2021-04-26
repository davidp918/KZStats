import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:kzstats/web/json/mapTop_json.dart';

import 'package:kzstats/web/urls.dart';

List<MapTop> mapTopRecords;

Future<List<MapTop>> getMapTopRecords(
  int mapId,
  String currentMode,
  bool ifNub,
  int amount,
) async {
  try {
    var response = await http.get(
      Uri.parse(
        globalApiMaptopRecordsUrl(mapId, currentMode, ifNub, amount),
      ),
    );
    response.statusCode == HttpStatus.ok
        ? mapTopRecords = mapTopFromJson(response.body)
        : print('something wrong');
  } catch (exception) {
    throw UnimplementedError();
  }

  return mapTopRecords;
}
