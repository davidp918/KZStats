import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:kzstats/web/urls.dart';
import '../model/kzjson.dart';

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

Player playerSteam;

Future<Player> getPlayerSteam(String steam64) async {
  const steamPlayer_join =
      '$proxy$steam_player_url$webApiKey$steam_player_url_connector';
  try {
    var response1 = await http.get(
      Uri.parse('$steamPlayer_join$steam64'),
    );
    response1.statusCode == HttpStatus.ok
        ? playerSteam = playerFromJson(response1.body)
        : print('something wrong');
  } catch (exception) {}

  return playerSteam;
}
