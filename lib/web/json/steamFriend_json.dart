// To parse this JSON data, do
//
//     final steamFriend = steamFriendFromJson(jsonString);

import 'dart:convert';

SteamFriend steamFriendFromJson(String str) =>
    SteamFriend.fromJson(json.decode(str));

String steamFriendToJson(SteamFriend data) => json.encode(data.toJson());

class SteamFriend {
  SteamFriend({
    required this.friendslist,
  });

  Friendslist friendslist;

  factory SteamFriend.fromJson(Map<String, dynamic> json) => SteamFriend(
        friendslist: Friendslist.fromJson(json["friendslist"]),
      );

  Map<String, dynamic> toJson() => {
        "friendslist": friendslist.toJson(),
      };
}

class Friendslist {
  Friendslist({
    required this.friends,
  });

  List<Friend> friends;

  factory Friendslist.fromJson(Map<String, dynamic> json) => Friendslist(
        friends:
            List<Friend>.from(json["friends"].map((x) => Friend.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "friends": List<dynamic>.from(friends.map((x) => x.toJson())),
      };
}

class Friend {
  Friend({
    required this.steamid,
    // required this.relationship,
    required this.friendSince,
  });

  String steamid;
  // Relationship relationship;
  int friendSince;

  factory Friend.fromJson(Map<String, dynamic> json) => Friend(
        steamid: json["steamid"],
        //   relationship: relationshipValues.map[json["relationship"]],
        friendSince: json["friend_since"],
      );

  Map<String, dynamic> toJson() => {
        "steamid": steamid,
        // "relationship": relationshipValues.reverse[relationship],
        "friend_since": friendSince,
      };
}

/* enum Relationship { FRIEND }

final relationshipValues = EnumValues({"friend": Relationship.FRIEND});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap!;
  }
} */
