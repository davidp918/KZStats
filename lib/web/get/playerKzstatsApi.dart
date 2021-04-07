import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:kzstats/web/urls.dart';
import 'package:kzstats/web/json/kzstatsApiPlayer.dart';

KzstatsApiPlayer kzstatsPlayer;

Future<KzstatsApiPlayer> getPlayerKzstatsApi(String steam64) async {
  try {
    var response = await http.get(
      Uri.parse('$proxy$kzstats_api_player$steam64$kzstats_api_player_end'),
    );
    response.statusCode == HttpStatus.ok
        ? kzstatsPlayer = kzstatsApiPlayerFromJson(response.body)
        : print('something wrong');
  } catch (exception) {}

  return kzstatsPlayer;
}
