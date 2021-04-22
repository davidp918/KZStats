// Latest wr records
const kz_wr =
    "https://kztimerglobal.com/api/v2.0/records/top/recent?modes_list_string=mode!&place_top_at_least=1ifnub!&stage=0&limit=amount!&tickrate=128";

String topRecordsSelect(String mode, bool ifNub, int amount) {
  String trueMode = mode == 'Kztimer'
      ? 'kz_timer'
      : mode == 'SimpleKZ'
          ? 'kz_simple'
          : 'kz_vanilla';
  return kz_wr
      .replaceAll('mode!', trueMode)
      .replaceAll('ifnub!', ifNub ? '' : '&has_teleports=false')
      .replaceAll('amount!', amount.toString());
}

// Top records of a specific map
const kz_mapTopRecords =
    "https://kztimerglobal.com/api/v1.0/records/top?map_name=!mapName&tickrate=128&stage=0&modes_list_string=!mode!ifNub&limit=!amount";

String mapTopRecordsSelect(
    String mapName, String mode, bool ifNub, int amount) {
  return kz_mapTopRecords
      .replaceAll('!mapName', mapName)
      .replaceAll('!mode', mode)
      .replaceAll('!ifNub', ifNub ? '' : '&has_teleports=false')
      .replaceAll('!amount', amount.toString());
}

// WR of NUB and PRO of a map

// Map information, such as tier - followed by map id(e.g 200)
const kz_map_info = 'https://kztimerglobal.com/api/v1/maps/';

// Map image url, add map name e.g kz_ladderall.jpg after the url
const imageBaseURL =
    "${proxy}https://raw.githubusercontent.com/KZGlobalTeam/map-images/public/webp/thumb/";
// proxy
const proxy = "https://gokz-globalstats.bakar.workers.dev/?";

// player data from steam api
// e.g: http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002?key=D382A350B768E5203415355D707065FD&steamids=76561198149087452
const webApiKey = 'D382A350B768E5203415355D707065FD';
const steam_player_url =
    'https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002?key=';
const steam_player_url_connector = '&steamids=';
const kzstats_api_player = "http://www.kzstats.com/api/player/";
const kzstats_api_player_end = "/steam";
