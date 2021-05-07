import 'package:flutter/material.dart';
import 'package:kzstats/pages/bans.dart';
import 'package:kzstats/pages/homepage.dart';
import 'package:kzstats/pages/maps.dart';
import 'package:kzstats/pages/leaderboard.dart';
import 'package:kzstats/pages/settings.dart';
import 'package:kzstats/pages/details/map_detail.dart';
import 'package:kzstats/pages/details/player_detail.dart';
import 'package:kzstats/pages/loginPage.dart';
import 'package:kzstats/pages/about.dart';
import 'package:kzstats/pages/settings/tablelayout.dart';
import 'package:kzstats/common/search.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => Homepage());

      case '/homepage':
        return MaterialPageRoute(builder: (context) => Homepage());

      case '/leaderboard':
        return MaterialPageRoute(builder: (context) => Leaderboard());

      case '/maps':
        return MaterialPageRoute(builder: (context) => Maps());

      case '/bans':
        return MaterialPageRoute(builder: (context) => Bans());

      case '/settings':
        return MaterialPageRoute(builder: (context) => Settings());

      case '/login':
        return MaterialPageRoute(builder: (context) => Login());

      case '/about':
        return MaterialPageRoute(builder: (context) => About());

      case '/map_detail':
        final dynamic mapInfo = settings.arguments as dynamic;
        return MaterialPageRoute(builder: (_) => MapDetail(mapInfo: mapInfo));

      case '/player_detail':
        // [0]: steam64, [1]: player name,
        final List<dynamic> playerInfo = settings.arguments as List<dynamic>;
        return MaterialPageRoute(
            builder: (_) => PlayerDetail(playerInfo: playerInfo));

      case '/table_layout':
        return MaterialPageRoute(builder: (_) => SettingsTableLayout());

      case '/search':
        return MaterialPageRoute(builder: (_) => Search());

      default:
        return null;
    }
  }
}
