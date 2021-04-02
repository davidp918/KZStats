/* Recent Records URls
*   Limit of 100 is used to grab as many records as possible without significantly increasing load times
*   Only 30 Records are displayed
*/
const kz_simpleRecords =
    "https://kztimerglobal.com/api/v2.0/records/top/recent?stage=0&tickrate=128&modes_list_string=kz_simple&limit=30";
const kz_timerRecords =
    "https://kztimerglobal.com/api/v2.0/records/top/recent?stage=0&tickrate=128&modes_list_string=kz_timer&limit=30";
const kz_vanillaRecords =
    "https://kztimerglobal.com/api/v2.0/records/top/recent?stage=0&tickrate=128&modes_list_string=kz_vanilla&limit=30";

/* Recent World Records URLs
*   Limit of 200 is used to grab as many records as possible without significantly increasing load times
*   Only 30 Records are displayed, but repeat records on the same map are filtered
*   World Records column will display less than 30 if less than 30 maps have their record beaten more than 200 times (Possible on new map releases)
*   Example: Zach47 gets 5 different improvements on bkz_apricity. Only one will display, but 5 are provided from the API.
*/
const kz_simpleTopRecords =
    "https://kztimerglobal.com/api/v2.0/records/top/recent?modes_list_string=kz_simple&place_top_at_least=1&has_teleports=false&stage=0&limit=20&tickrate=128";
const kz_timerTopRecords =
    "https://kztimerglobal.com/api/v2.0/records/top/recent?modes_list_string=kz_timer&place_top_at_least=1&has_teleports=false&stage=0&limit=20&tickrate=128";
const kz_vanillaTopRecords =
    "https://kztimerglobal.com/api/v2.0/records/top/recent?modes_list_string=kz_vanilla&place_top_at_least=1&has_teleports=false&stage=0&limit=20&tickrate=128";

// Generic Records per Mode URLs
const kz_simpleLoadMap =
    "https://kztimerglobal.com/api/v2.0/records/top?modes_list_string=kz_simple";
const kz_timerLoadMap =
    "https://kztimerglobal.com/api/v2.0/records/top?modes_list_string=kz_timer";
const kz_vanillaLoadMap =
    "https://kztimerglobal.com/api/v2.0/records/top?modes_list_string=kz_vanilla";

/* Leaderboard Points URLs
*   KZTimer (id:200): finishes_greater_than is set to 10 due to large number of times on KZTimer
*   Query limit is set to 20 to match "Top 20" style and to reduce load times (On TP leaderboards especially)
*/
const leaderboard_points_kztimer =
    "https://kztimerglobal.com/api/v2.0/player_ranks?finishes_greater_than=10&mode_ids=200&stages=0&tickrates=128&has_teleports=false&limit=20";
const leaderboard_points_simplekz =
    "https://kztimerglobal.com/api/v2.0/player_ranks?finishes_greater_than=0&mode_ids=201&stages=0&tickrates=128&has_teleports=false&limit=20";
const leaderboard_points_vanilla =
    "https://kztimerglobal.com/api/v2.0/player_ranks?finishes_greater_than=0&mode_ids=202&stages=0&tickrates=128&has_teleports=false&limit=20";

/* Leaderboard World Records URLs
*   Query limit is set to 20 to match "Top 20" style
*/
const leaderboard_records_kztimer =
    "https://kztimerglobal.com/api/v2.0/records/top/world_records?stages=0&mode_ids=200&tickrates=128&has_teleports=false&limit=20";
const leaderboard_records_simplekz =
    "https://kztimerglobal.com/api/v2.0/records/top/world_records?stages=0&mode_ids=201&tickrates=128&has_teleports=false&limit=20";
const leaderboard_records_vanilla =
    "https://kztimerglobal.com/api/v2.0/records/top/world_records?stages=0&mode_ids=202&tickrates=128&has_teleports=false&limit=20";

// Map image url, add map name e.g kz_ladderall.jpg after the url
const imageBaseURL =
    "https://raw.githubusercontent.com/KZGlobalTeam/map-images/public/thumbnails/kz_ladderall.jpg";
