import 'package:kzstats/utils/getModeId.dart';

const imageBaseURL =
    "${proxy}https://raw.githubusercontent.com/KZGlobalTeam/map-images/public/webp/thumb/";
const proxy = "https://gokz-globalstats.bakar.workers.dev/?";

// Latest wr records
String globalApiWrRecordsUrl(String mode, bool ifNub, int amount, int offset) {
  const kz_wr =
      "https://kztimerglobal.com/api/v2.0/records/top/recent?modes_list_string=!mode!&place_top_at_least=1ifnub!&stage=0&limit=amount!&tickrate=128&offset=!offset";
  return kz_wr
      .replaceAll('!mode!', mode)
      .replaceAll('ifnub!', ifNub ? '' : '&has_teleports=false')
      .replaceAll('amount!', amount.toString())
      .replaceAll('!offset', offset.toString());
}

// Top records of a specific map
String globalApiMaptopRecordsUrl(
  int? mapId,
  String mode,
  bool ifNub,
  int amount,
) {
  final kzMapTopRecords =
      "https://kztimerglobal.com/api/v2.0/records/top?modes_list_string=!mode&map_id=!mapId&stage=0!ifNub&limit=!amount&tickrate=128"
          .replaceAll('!mapId', mapId.toString())
          .replaceAll('!mode', mode)
          .replaceAll('!ifNub', ifNub ? '' : '&has_teleports=false')
          .replaceAll('!amount', amount.toString());
  print(kzMapTopRecords);
  return kzMapTopRecords;
}

// top records of a specific player
String globalApiTopRecordsUrl({
  required bool ifNub,
  required int limit,
  required String steamid64,
  String? mode,
}) =>
    "https://kztimerglobal.com/api/v2.0/records/top?steamid64=!steamid64&tickrate=128&stage=0!ifNub&modes_list_string=!mode&limit=!limit"
        .replaceAll('!mode', mode == null ? '' : '$mode')
        .replaceAll('!steamid64', steamid64)
        .replaceAll('!limit', limit.toString())
        .replaceAll('!ifNub', ifNub ? '' : '&has_teleports=false');

// recent records of a specific player
String globalApiRecentRecordsUrl(
    bool ifNub, int limit, String steamId64, String? mode) {
  const kz_mapTopRecords =
      "https://kztimerglobal.com/api/v2.0/records/top/recent?steamid64=!steamId64!ifNub&tickrate=128&stage=0!mode";
  return kz_mapTopRecords
      .replaceAll('!mode', mode == null ? '' : '&modes_list_string=$mode')
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
String globalApiAllMaps(int limit, int offset, int tier) {
  const kz_map_all =
      'https://kztimerglobal.com/api/v2.0/maps?limit=!max&offset=!offset&difficulty=!tier';
  return kz_map_all
      .replaceAll('!max', limit.toString())
      .replaceAll('!offset', offset.toString())
      .replaceAll('!tier', tier == 0 ? '' : tier.toString());
}

// player data from steam api
const webApiKey = 'D382A350B768E5203415355D707065FD';
String steamApiPlayerInfoUrl(String steamId64) {
  const webApiKey = 'D382A350B768E5203415355D707065FD';
  const steam_player_url =
      'https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002?key=';
  const steam_player_url_connector = '&steamids=';
  return '$proxy$steam_player_url$webApiKey$steam_player_url_connector$steamId64';
}

String steamApiPlayerFriendList(String steamId64) =>
    '${proxy}http://api.steampowered.com/ISteamUser/GetFriendList/v0001?key=$webApiKey&steamid=$steamId64&relationship=friend';

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
      .replaceAll(
          'ifNub!', ifNub ? '&has_teleports=true' : '&has_teleports=false');
}

String globalApiLeaderboardRecords(
  String mode,
  bool ifNub,
  int limit,
) {
  const leaderboardRecordsUrl =
      'https://kztimerglobal.com/api/v2.0/records/top/world_records?stages=0&mode_ids=modeid!&tickrates=128ifNub!&limit=limit!';

  return leaderboardRecordsUrl
      .replaceAll('modeid!', getModeId(mode).toString())
      .replaceAll('limit!', limit.toString())
      .replaceAll(
          'ifNub!', ifNub ? '&has_teleports=true' : '&has_teleports=false');
}

String globalApiBans(
  int limit,
  int offset,
) {
  const bans =
      'https://kztimerglobal.com/api/v2.0/bans?offset=offset!&limit=limit!';
  return bans
      .replaceAll('offset!', offset.toString())
      .replaceAll('limit!', limit.toString());
}

String globalApiPastWrs() {
  return 'https://kztimerglobal.com/api/v2.0/records/top/recent?map_name=kz_zhop_function3&has_teleports=false&tickrate=128&stage=0&modes_list_string=kz_timer&place_top_at_least=1&limit=99';
}
