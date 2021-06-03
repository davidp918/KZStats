import 'package:flutter/cupertino.dart';
import 'package:kzstats/cubit/user_cubit.dart';
import 'package:kzstats/data/shared_preferences.dart';
import 'package:kzstats/web/getRequest.dart';
import 'package:kzstats/web/json/kzstatsApiPlayer_json.dart';
import 'package:kzstats/web/json/record_json.dart';
import 'package:kzstats/web/json/steamFriend_json.dart';
import 'package:kzstats/web/urls.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/* Future refreshSteamFriends(BuildContext context) async {
  UserState userState = context.read<UserCubit>().state;
  String url = steamApiPlayerFriendList(userState.playerInfo.steamid ?? '');
  SteamFriend data = await getRequest(url, steamFriendFromJson);
  List<String> steamFriendsSteamid64 = [];
  for (Friend each in data.friendslist.friends)
    steamFriendsSteamid64.add(each.steamid);
  await UserSharedPreferences.setSteamFriends(steamFriendsSteamid64);
} */

Future refreshFriendsRecords() async {
  List<String> friends = UserSharedPreferences.getSteamFriends();
  List<String> friendsToFetch = [];
  for (String steamid64 in friends) {
    if (UserSharedPreferences.getPlayerRecords(steamid64) == []) continue;
    friendsToFetch.add(steamid64);
  }
  print('Fetching ${friendsToFetch.length} players" data...');
  List<List<Record>> records = await Future.wait([
    for (String steamid64 in friendsToFetch) getPlayerRecords(steamid64, false)
  ]);

  for (int i = 0; i < friendsToFetch.length; i++) {
    String curSteamid64 = friendsToFetch[i];
    List<Record> curRecords = records[i];
    if (curRecords.length == 0) {
      await UserSharedPreferences.setPlayerRecords(curSteamid64, []);
      continue;
    }
    curRecords.sort((a, b) {
      if (a.createdOn != null || b.createdOn != null)
        return a.createdOn!.compareTo(b.createdOn!);
      return 0;
    });
    await UserSharedPreferences.setPlayerRecords(curSteamid64, curRecords);
  }
}
