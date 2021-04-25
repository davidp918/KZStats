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
      case '/map_detail':
        final KzTime prevSnapshotData = settings.arguments as KzTime;
        return MaterialPageRoute(
          builder: (_) => MapDetail(
            prevSnapshotData: prevSnapshotData,
          ),
        );
      case '/player_detail':
        final int steamId64 = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => PlayerDetail(
            steamId64: steamId64,
          ),
        );

      default:
        return null;
    }
  }
}
