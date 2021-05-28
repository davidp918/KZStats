// To parse this JSON data, do
//
//     final leaderboardPoints = leaderboardPointsFromJson(jsonString);

import 'dart:convert';

List<LeaderboardPoints> leaderboardPointsFromJson(String str) =>
    List<LeaderboardPoints>.from(
        json.decode(str).map((x) => LeaderboardPoints.fromJson(x)));

String leaderboardPointsToJson(List<LeaderboardPoints> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LeaderboardPoints {
  LeaderboardPoints({
    this.totalPoints,
    this.average,
    this.rating,
    this.finishes,
    this.steamid64,
    this.steamid,
    this.playerName,
  });

  int? totalPoints;
  double? average;
  double? rating;
  int? finishes;
  String? steamid64;
  String? steamid;
  String? playerName;

  factory LeaderboardPoints.fromJson(Map<String, dynamic> json) =>
      LeaderboardPoints(
        totalPoints: json["points"],
        average: json["average"].toDouble(),
        rating: json["rating"].toDouble(),
        finishes: json["finishes"],
        steamid64: json["steamid64"],
        steamid: json["steamid"],
        playerName: json["player_name"],
      );

  Map<String, dynamic> toJson() => {
        "totalPoints": totalPoints,
        "average": average,
        "rating": rating,
        "finishes": finishes,
        "steamid64": steamid64,
        "steamid": steamid,
        "playerName": playerName,
      };
}
