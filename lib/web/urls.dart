// Latest wr records
const kz_simpleTopRecords =
    "https://kztimerglobal.com/api/v2.0/records/top/recent?modes_list_string=kz_simple&place_top_at_least=1&has_teleports=false&stage=0&limit=20&tickrate=128";
const kz_timerTopRecords =
    "https://kztimerglobal.com/api/v2.0/records/top/recent?modes_list_string=kz_timer&place_top_at_least=1&has_teleports=false&stage=0&limit=20&tickrate=128";
const kz_vanillaTopRecords =
    "https://kztimerglobal.com/api/v2.0/records/top/recent?modes_list_string=kz_vanilla&place_top_at_least=1&has_teleports=false&stage=0&limit=20&tickrate=128";
const kz_simpleTopRecords_nub =
    "https://kztimerglobal.com/api/v2.0/records/top/recent?modes_list_string=kz_simple&place_top_at_least=1&stage=0&limit=20&tickrate=128";
const kz_timerTopRecords_nub =
    "https://kztimerglobal.com/api/v2.0/records/top/recent?modes_list_string=kz_timer&place_top_at_least=1&stage=0&limit=20&tickrate=128";
const kz_vanillaTopRecords_nub =
    "https://kztimerglobal.com/api/v2.0/records/top/recent?modes_list_string=kz_vanilla&place_top_at_least=1&stage=0&limit=20&tickrate=128";

String topRecordsSelect(String mode, bool ifNub) => ifNub
    ? mode == 'Kztimer'
        ? kz_timerTopRecords_nub
        : mode == 'SimpleKZ'
            ? kz_simpleTopRecords_nub
            : kz_vanillaTopRecords_nub
    : mode == 'Kztimer'
        ? kz_timerTopRecords
        : mode == 'SimpleKZ'
            ? kz_simpleTopRecords
            : kz_vanillaTopRecords;

// Top records of a specific map
const kz_mapTopRecords =
    "https://kztimerglobal.com/api/v1.0/records/top?map_name=mapName&tickrate=128&stage=0&modes_list_string=mode&ifNub&limit=1";

String mapTopRecordsSelect(String mapName, String mode, bool ifNub) {
  return kz_mapTopRecords
      .replaceAll('mapName', mapName)
      .replaceAll('mode', mode)
      .replaceAll('&ifNub', ifNub ? '' : 'has_teleports=false');
}

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
