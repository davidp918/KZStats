import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:kzstats/web/urls.dart';
import 'package:kzstats/web/json/kzstatsApiPlayer_json.dart';

KzstatsApiPlayer kzstatsPlayer;

Future<KzstatsApiPlayer> getPlayerKzstatsApi(String steam64) async {
  try {
    var response = await http.get(
      Uri.parse(kzstatsApiPlayerInfoUrl(steam64)),
    );
    response.statusCode == HttpStatus.ok
        ? kzstatsPlayer = kzstatsApiPlayerFromJson(response.body)
        : print('something wrong');
  } catch (exception) {}

  return kzstatsPlayer;
}
