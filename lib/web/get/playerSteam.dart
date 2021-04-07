import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:kzstats/web/urls.dart';
import '../json/steamPlayer.dart';

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
