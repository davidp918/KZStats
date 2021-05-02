import 'package:kzstats/utils/getModeId.dart';

const imageBaseURL =
    "${proxy}https://raw.githubusercontent.com/KZGlobalTeam/map-images/public/webp/thumb/";
const proxy = "https://gokz-globalstats.bakar.workers.dev/?";

// Latest wr records
String globalApiWrRecordsUrl(
  String mode,
  bool ifNub,
  int amount,
) {
  const kz_wr =
      "https://kztimerglobal.com/api/v2.0/records/top/recent?modes_list_string=!mode!&place_top_at_least=1ifnub!&stage=0&limit=amount!&tickrate=128";
  return kz_wr
      .replaceAll('!mode!', mode)
      .replaceAll('ifnub!', ifNub ? '' : '&has_teleports=false')
      .replaceAll('amount!', amount.toString());
}

// Top records of a specific map
String globalApiMaptopRecordsUrl(
  int? mapId,
  String mode,
  bool ifNub,
  int amount,
) {
  const kz_mapTopRecords =
      "https://kztimerglobal.com/api/v2.0/records/top?modes_list_string=!mode&map_id=!mapId&stage=0!ifNub&limit=!amount&tickrate=128";
  return kz_mapTopRecords
      .replaceAll('!mapId', mapId.toString())
      .replaceAll('!mode', mode)
      .replaceAll('!ifNub', ifNub ? '' : '&has_teleports=false')
      .replaceAll('!amount', amount.toString());
}

// all records of a specific player
String globalApiPlayerRecordsUrl(
  String mode,
  bool ifNub,
  int limit,
  String steamId64,
) {
  const kz_mapTopRecords =
      "https://kztimerglobal.com/api/v2.0/records/top?steamid64=!steamId64&modes_list_string=!mode!ifNub&limit=!limit&stage=0";
  return kz_mapTopRecords
      .replaceAll('!mode', mode)
      .replaceAll('!steamId64', steamId64)
      .replaceAll('!limit', limit.toString())
      .replaceAll('!ifNub', ifNub ? '' : '&has_teleports=false');
}

// Map information, such as tier - followed by map id(e.g 200)
String globalApiMapInfoUrl(String mapId) {
  const kz_map_info = 'https://kztimerglobal.com/api/v2.0/maps/';
  return '$kz_map_info$mapId';
}

// All map info
String globalApiAllMaps(
  int limit,
  int offset,
  int tier,
) {
  const kz_map_all =
      'https://kztimerglobal.com/api/v2.0/maps?limit=!max&offset=!offset&difficulty=!tier';
  return kz_map_all
      .replaceAll('!max', limit.toString())
      .replaceAll('!offset', offset.toString())
      .replaceAll('!tier', tier == 0 ? '' : tier.toString());
}

// player data from steam api
String steamApiPlayerInfoUrl(String steamId64) {
  const webApiKey = 'D382A350B768E5203415355D707065FD';
  const steam_player_url =
      'https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002?key=';
  const steam_player_url_connector = '&steamids=';
  return '$proxy$steam_player_url$webApiKey$steam_player_url_connector$steamId64';
}

// player data from kzstats api
String kzstatsApiPlayerInfoUrl(String? steamId64) {
  const kzstats_api_player = "http://www.kzstats.com/api/player/";
  const kzstats_api_player_end = "/steam";
  return '$proxy$kzstats_api_player$steamId64$kzstats_api_player_end';
}

// player points leaderboard
String globalApiLeaderboardPoints(
  String mode,
  bool ifNub,
  int limit,
) {
  const leaderboardPointsUrl =
      'https://kztimerglobal.com/api/v2.0/player_ranks?finishes_greater_than=0&mode_ids=modeid!ifNub!&limit=limit!&tickrates=128';
  return leaderboardPointsUrl
      .replaceAll('modeid!', getModeId(mode).toString())
      .replaceAll('limit!', limit.toString())
      .replaceAll('ifNub!', ifNub ? '' : '&has_teleports=false');
}
