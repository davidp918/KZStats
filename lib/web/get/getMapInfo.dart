import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:kzstats/web/urls.dart';
import 'package:kzstats/web/json/mapinfo_json.dart';

Mapinfo mapInformation;

Future<Mapinfo> getMapInfo(String mapId) async {
  try {
    var response = await http.get(
      Uri.parse('$kz_map_info$mapId'),
    );
    response.statusCode == HttpStatus.ok
        ? mapInformation = mapinfoFromJson(response.body)
        : print('something wrong');
  } catch (exception) {}
  return mapInformation;
}
