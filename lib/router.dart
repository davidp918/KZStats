import 'package:flutter/material.dart';
import 'package:kzstats/pages/homepage.dart';
import 'package:kzstats/pages/settings.dart';
import 'package:kzstats/pages/details/map_detail.dart';
import 'package:kzstats/web/json/kztime_json.dart';
import 'package:kzstats/pages/details/player_detail.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => Homepage(),
        );
      case '/settings':
        return MaterialPageRoute(
          builder: (_) => Settings(),
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
