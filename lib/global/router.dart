import 'package:flutter/material.dart';
import 'package:kzstats/pages/base.dart';
import 'package:kzstats/pages/details/filter.dart';
import 'package:kzstats/pages/details/map_detail.dart';
import 'package:kzstats/pages/details/player_detail.dart';
import 'package:kzstats/pages/details/loginPage.dart';
import 'package:kzstats/pages/details/about.dart';
import 'package:kzstats/common/search.dart';
import 'package:kzstats/pages/details/steamLogin.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => Base());

      case '/login':
        return MaterialPageRoute(builder: (context) => Login());

      case '/steamLogin':
        return MaterialPageRoute(builder: (context) => SteamLogin());

      case '/about':
        return MaterialPageRoute(builder: (context) => About());

      case '/map_detail':
        // [0]: mapId, [1]: mapName
        final List<dynamic> mapInfo = settings.arguments as List<dynamic>;
        return MaterialPageRoute(builder: (_) => MapDetail(mapInfo: mapInfo));

      case '/player_detail':
        // [0]: steam64, [1]: player name,
        final List<dynamic> playerInfo = settings.arguments as List<dynamic>;
        return MaterialPageRoute(
            builder: (_) => PlayerDetail(playerInfo: playerInfo));

      case '/search':
        return MaterialPageRoute(builder: (_) => Search());

      case '/filter':
        return MaterialPageRoute(builder: (_) => MapsFilter());

      default:
        return MaterialPageRoute(builder: (context) => Base());
    }
  }
}
