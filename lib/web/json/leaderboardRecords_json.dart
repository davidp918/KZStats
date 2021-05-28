// To parse this JSON data, do
//
//     final leaderboardRecords = leaderboardRecordsFromJson(jsonString);

import 'dart:convert';

List<LeaderboardRecords> leaderboardRecordsFromJson(String str) =>
    List<LeaderboardRecords>.from(
        json.decode(str).map((x) => LeaderboardRecords.fromJson(x)));

String leaderboardRecordsToJson(List<LeaderboardRecords> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LeaderboardRecords {
  LeaderboardRecords({
    required this.steamid64,
    required this.steamId,
    required this.count,
    required this.playerName,
  });

  String steamid64;
  String steamId;
  int count;
  String playerName;

  factory LeaderboardRecords.fromJson(Map<String, dynamic> json) =>
      LeaderboardRecords(
        steamid64: json["steamid64"],
        steamId: json["steam_id"],
        count: json["count"],
        playerName: json["player_name"],
      );

  Map<String, dynamic> toJson() => {
        "steamid64": steamid64,
        "steamId": steamId,
        "count": count,
        "playerName": playerName,
      };
}
