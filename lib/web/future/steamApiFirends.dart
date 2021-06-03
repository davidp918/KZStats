import 'package:flutter/cupertino.dart';
import 'package:kzstats/cubit/user_cubit.dart';
import 'package:kzstats/data/shared_preferences.dart';
import 'package:kzstats/web/getRequest.dart';
import 'package:kzstats/web/json/kzstatsApiPlayer_json.dart';
import 'package:kzstats/web/json/record_json.dart';
import 'package:kzstats/web/json/steamFriend_json.dart';
import 'package:kzstats/web/urls.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future refreshSteamFriends(BuildContext context) async {
  UserState userState = context.read<UserCubit>().state;
  String url = steamApiPlayerFriendList(userState.info.steam64);
  SteamFriend data = await getRequest(url, steamFriendFromJson);
  List<String> steamFriendsSteamid64 = [];
  for (Friend each in data.friendslist.friends)
    steamFriendsSteamid64.add(each.steamid);
  UserSharedPreferences.setSteamFriends(steamFriendsSteamid64);
}

Future<dynamic> getKzstatsPlayerInfo(String steamid64) async => getRequest(
      kzstatsApiPlayerInfoUrl(steamid64),
      kzstatsApiPlayerFromJson,
    );

Future<dynamic> getPlayerRecords(String steamid64, bool ifNub) async =>
    getRequest(
        globalApiPlayerRecordsUrl(ifNub, 99999, steamid64), recordFromJson);
