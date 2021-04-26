// To parse this JSON data, do
//
//     final wr = wrFromJson(jsonString);

import 'dart:convert';

List<Wr> wrFromJson(String str) =>
    List<Wr>.from(json.decode(str).map((x) => Wr.fromJson(x)));

String wrToJson(List<Wr> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Wr {
  Wr({
    this.id,
    this.steamid64,
    this.playerName,
    this.steamId,
    this.serverId,
    this.mapId,
    this.stage,
    this.mode,
    this.tickrate,
    this.time,
    this.teleports,
    this.createdOn,
    this.updatedOn,
    this.updatedBy,
    this.place,
    this.top100,
    this.top100Overall,
    this.serverName,
    this.mapName,
    this.points,
    this.recordFilterId,
    this.replayId,
  });

  int id;
  String steamid64;
  String playerName;
  String steamId;
  int serverId;
  int mapId;
  int stage;
  String mode;
  int tickrate;
  double time;
  int teleports;
  DateTime createdOn;
  DateTime updatedOn;
  int updatedBy;
  int place;
  int top100;
  int top100Overall;
  String serverName;
  String mapName;
  int points;
  int recordFilterId;
  int replayId;

  factory Wr.fromJson(Map<String, dynamic> json) => Wr(
        id: json["id"],
        steamid64: json["steamid64"],
        playerName: json["player_name"],
        steamId: json["steam_id"],
        serverId: json["server_id"],
        mapId: json["map_id"],
        stage: json["stage"],
        mode: json["mode"],
        tickrate: json["tickrate"],
        time: json["time"].toDouble(),
        teleports: json["teleports"],
        createdOn: DateTime.parse(json["created_on"]),
        updatedOn: DateTime.parse(json["updated_on"]),
        updatedBy: json["updated_by"],
        place: json["place"],
        top100: json["top_100"],
        top100Overall: json["top_100_overall"],
        serverName: json["server_name"],
        mapName: json["map_name"],
        points: json["points"],
        recordFilterId: json["record_filter_id"],
        replayId: json["replay_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "steamid64": steamid64,
        "player_name": playerName,
        "steam_id": steamId,
        "server_id": serverId,
        "map_id": mapId,
        "stage": stage,
        "mode": mode,
        "tickrate": tickrate,
        "time": time,
        "teleports": teleports,
        "created_on": createdOn.toIso8601String(),
        "updated_on": updatedOn.toIso8601String(),
        "updated_by": updatedBy,
        "place": place,
        "top_100": top100,
        "top_100_overall": top100Overall,
        "server_name": serverName,
        "map_name": mapName,
        "points": points,
        "record_filter_id": recordFilterId,
        "replay_id": replayId,
      };
}
