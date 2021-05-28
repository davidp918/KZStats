// To parse this JSON data, do
//
//     final mapTop = mapTopFromJson(jsonString);

import 'dart:convert';

List<Record> recordFromJson(String str) =>
    List<Record>.from(json.decode(str).map((x) => Record.fromJson(x)));

class Record {
  Record({
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
    this.recordFilterId,
    this.serverName,
    this.mapName,
    this.points,
    this.replayId,
  });

  int? id;
  String? steamid64;
  String? playerName;
  String? steamId;
  int? serverId;
  int? mapId;
  int? stage;
  String? mode;
  int? tickrate;
  double? time;
  int? teleports;
  DateTime? createdOn;
  DateTime? updatedOn;
  int? updatedBy;
  int? recordFilterId;
  String? serverName;
  String? mapName;
  int? points;
  int? replayId;

  factory Record.fromJson(Map<String, dynamic> json) => Record(
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
        recordFilterId: json["record_filter_id"],
        serverName: json["server_name"],
        mapName: json["map_name"],
        points: json["points"],
        replayId: json["replay_id"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "steamid64": steamid64,
        "playerName": playerName,
        "steamId": steamId,
        "serverId": serverId,
        "mapId": mapId,
        "stage": stage,
        "mode": mode,
        "tickrate": tickrate,
        "time": time,
        "teleports": teleports,
        "createdOn": createdOn?.toIso8601String(),
        "updatedOn": updatedOn?.toIso8601String(),
        "updatedby": updatedBy,
        "recordFilterId": recordFilterId,
        "serverName": serverName,
        "mapName": mapName,
        "points": points,
        "replayId": replayId,
      };
}
