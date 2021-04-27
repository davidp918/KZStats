import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:kzstats/web/json/steamplayer_json.dart';

import 'package:kzstats/web/urls.dart';
import '../json/steamplayer_json.dart';

late Player playerSteam;

Future<PlayerElement> getPlayerSteam(String steam64) async {
  try {
    var response1 = await http.get(
      Uri.parse(steamApiPlayerInfoUrl(steam64)),
    );
    response1.statusCode == HttpStatus.ok
        ? playerSteam = playerFromJson(response1.body)
        : print('something wrong');
  } catch (exception) {}

  return playerSteam.response!.players![0];
}
