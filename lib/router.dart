import 'package:flutter/material.dart';
import 'package:kzstats/pages/bans.dart';
import 'package:kzstats/pages/homepage.dart';
import 'package:kzstats/pages/maps.dart';
import 'package:kzstats/pages/players.dart';
import 'package:kzstats/pages/settings.dart';
import 'package:kzstats/pages/details/map_detail.dart';
import 'package:kzstats/web/json/kztime_json.dart';
import 'package:kzstats/pages/details/player_detail.dart';
import 'package:kzstats/pages/loginPage.dart';
import 'package:kzstats/pages/about.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => Homepage(),
        );
      case '/homepage':
        return MaterialPageRoute(
          builder: (context) => Homepage(),
        );
      case '/players':
        return MaterialPageRoute(
          builder: (context) => Players(),
        );
      case '/maps':
        return MaterialPageRoute(
          builder: (context) => Maps(),
        );
      case '/bans':
        return MaterialPageRoute(
          builder: (context) => Bans(),
        );
      case '/settings':
        return MaterialPageRoute(
          builder: (context) => Settings(),
        );
      case '/login':
        return MaterialPageRoute(
          builder: (context) => Login(),
        );
      case '/about':
        return MaterialPageRoute(
          builder: (context) => About(),
        );
      case '/map_detail':
        final Wr prevSnapshotData = settings.arguments as Wr;
        return MaterialPageRoute(
          builder: (_) => MapDetail(
            prevSnapshotData: prevSnapshotData,
          ),
        );
      case '/player_detail':
        // [0]: steam64, [1]: player name,
        final List<String> playerInfo = settings.arguments as List<String>;
        return MaterialPageRoute(
          builder: (_) => PlayerDetail(playerInfo: playerInfo),
        );

      default:
        return null;
    }
  }
}
