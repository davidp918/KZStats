// To parse this JSON data, do
//
//     final kzstatsApiPlayer = kzstatsApiPlayerFromJson(jsonString);

import 'dart:convert';

KzstatsApiPlayer kzstatsApiPlayerFromJson(String str) =>
    KzstatsApiPlayer.fromJson(json.decode(str));

String kzstatsApiPlayerToJson(List<KzstatsApiPlayer> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class KzstatsApiPlayer {
  KzstatsApiPlayer({
    this.steamid,
    this.communityvisibilitystate,
    this.profilestate,
    this.personaname,
    this.commentpermission,
    this.profileurl,
    this.avatar,
    this.avatarmedium,
    this.avatarfull,
    this.avatarhash,
    this.personastate,
    this.primaryclanid,
    this.timecreated,
    this.personastateflags,
    this.loccountrycode,
    this.country,
    this.steamid32,
  });

  String? steamid;
  int? communityvisibilitystate;
  int? profilestate;
  String? personaname;
  int? commentpermission;
  String? profileurl;
  String? avatar;
  String? avatarmedium;
  String? avatarfull;
  String? avatarhash;
  int? personastate;
  String? primaryclanid;
  int? timecreated;
  int? personastateflags;
  String? loccountrycode;
  String? country;
  String? steamid32;

  factory KzstatsApiPlayer.fromJson(Map<String, dynamic> json) =>
      KzstatsApiPlayer(
        steamid: json["steamid"],
        communityvisibilitystate: json["communityvisibilitystate"],
        profilestate: json["profilestate"],
        personaname: json["personaname"],
        commentpermission: json["commentpermission"],
        profileurl: json["profileurl"],
        avatar: json["avatar"],
        avatarmedium: json["avatarmedium"],
        avatarfull: json["avatarfull"],
        avatarhash: json["avatarhash"],
        personastate: json["personastate"],
        primaryclanid: json["primaryclanid"],
        timecreated: json["timecreated"],
        personastateflags: json["personastateflags"],
        loccountrycode: json["loccountrycode"],
        country: json["country"],
        steamid32: json["steamid32"],
      );
  Map<String, dynamic> toJson() => {
        'steamid': steamid,
        'communityvisibilitystate': communityvisibilitystate,
        'profilestate': profilestate,
        'personaname': personaname,
        'commentpermission': commentpermission,
        'profileurl': profileurl,
        'avatar': avatar,
        'avatarmedium': avatarmedium,
        'avatarfull': avatarfull,
        'avatarhash': avatarhash,
        'personastate': personastate,
        'primaryclanid': primaryclanid,
        'timecreated': timecreated,
        'personastateflags': personastateflags,
        'loccountrycode': loccountrycode,
        'country': country,
        'steamid32': steamid32,
      };
}
