// To parse this JSON data, do
//
//     final mapinfo = mapinfoFromJson(jsonString);

import 'dart:convert';

Mapinfo mapinfoFromJson(String str) => Mapinfo.fromJson(json.decode(str));

class Mapinfo {
  Mapinfo({
    this.id,
    this.name,
    this.filesize,
    this.validated,
    this.difficulty,
    this.createdOn,
    this.updatedOn,
    this.approvedBySteamid64,
    this.workshopUrl,
    this.downloadUrl,
  });

  int id;
  String name;
  int filesize;
  bool validated;
  int difficulty;
  DateTime createdOn;
  DateTime updatedOn;
  double approvedBySteamid64;
  String workshopUrl;
  String downloadUrl;

  factory Mapinfo.fromJson(Map<String, dynamic> json) => Mapinfo(
        id: json["id"],
        name: json["name"],
        filesize: json["filesize"],
        validated: json["validated"],
        difficulty: json["difficulty"],
        createdOn: DateTime.parse(json["created_on"]),
        updatedOn: DateTime.parse(json["updated_on"]),
        approvedBySteamid64: json["approved_by_steamid64"].toDouble(),
        workshopUrl: json["workshop_url"],
        downloadUrl: json["download_url"],
      );
}
