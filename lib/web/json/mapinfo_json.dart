// To parse this JSON data, do
//
//     final mapinfo = mapinfoFromJson(jsonString);

import 'dart:convert';

List<MapInfo> multiMapInfoFromJson(String str) =>
    List<MapInfo>.from(json.decode(str).map((x) => MapInfo.fromJson(x)));
String multiMapInfoToJson(List<MapInfo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

MapInfo mapInfoFromJson(String str) => MapInfo.fromJson(json.decode(str));

class MapInfo {
  MapInfo({
    this.mapId,
    this.mapName,
    this.filesize,
    this.validated,
    this.difficulty,
    this.createdOn,
    this.updatedOn,
    this.approvedBySteamid64,
    this.workshopUrl,
    this.downloadUrl,
  });

  int? mapId;
  String? mapName;
  int? filesize;
  bool? validated;
  int? difficulty;
  DateTime? createdOn;
  DateTime? updatedOn;
  String? approvedBySteamid64;
  String? workshopUrl;
  String? downloadUrl;

  factory MapInfo.fromJson(Map<String, dynamic> json) => MapInfo(
        mapId: json["id"],
        mapName: json["name"],
        filesize: json["filesize"],
        validated: json["validated"],
        difficulty: json["difficulty"],
        createdOn: DateTime.parse(json["created_on"]),
        updatedOn: DateTime.parse(json["updated_on"]),
        approvedBySteamid64: json["approved_by_steamid64"],
        workshopUrl: json["workshop_url"],
        downloadUrl: json["download_url"],
      );
  Map<String, dynamic> toJson() => {
        "id": mapId,
        "name": mapName,
        "filesize": filesize,
        "validated": validated,
        "difficulty": difficulty,
        "created_on": createdOn?.toIso8601String(),
        "updated_on": updatedOn?.toIso8601String(),
        "approved_by_steamid64": approvedBySteamid64,
        "workshop_url": workshopUrl,
        "download_url": downloadUrl,
      };
}
