// To parse this JSON data, do
//
//     final ban = banFromJson(jsonString);

import 'dart:convert';

List<Ban> banFromJson(String str) =>
    List<Ban>.from(json.decode(str).map((x) => Ban.fromJson(x)));

String banToJson(List<Ban> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Ban {
  Ban({
    this.id,
    this.banType,
    this.expiresOn,
    this.steamid64,
    this.playerName,
    this.steamId,
    this.notes,
    this.stats,
    this.serverId,
    this.updatedById,
    this.createdOn,
    this.updatedOn,
  });

  int? id;
  String? banType;
  DateTime? expiresOn;
  String? steamid64;
  String? playerName;
  String? steamId;
  String? notes;
  String? stats;
  int? serverId;
  String? updatedById;
  DateTime? createdOn;
  DateTime? updatedOn;

  factory Ban.fromJson(Map<String, dynamic> json) => Ban(
        id: json["id"],
        banType: json["ban_type"],
        expiresOn: DateTime.parse(json["expires_on"]),
        steamid64: json["steamid64"],
        playerName: json["player_name"],
        steamId: json["steam_id"],
        notes: json["notes"],
        stats: json["stats"],
        serverId: json["server_id"],
        updatedById: json["updated_by_id"],
        createdOn: DateTime.parse(json["created_on"]),
        updatedOn: DateTime.parse(json["updated_on"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ban_type": banType,
        "expires_on": expiresOn?.toIso8601String(),
        "steamid64": steamid64,
        "player_name": playerName,
        "steam_id": steamId,
        "notes": notes,
        "stats": stats,
        "server_id": serverId,
        "updated_by_id": updatedById,
        "created_on": createdOn?.toIso8601String(),
        "updated_on": updatedOn?.toIso8601String(),
      };
}
