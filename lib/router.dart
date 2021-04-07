import 'package:flutter/material.dart';
import 'package:kzstats/pages/homepage.dart';
import 'package:kzstats/pages/settings.dart';
import 'package:kzstats/pages/details/map_detail.dart';

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
        final String mapName = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => MapDetail(
            mapName: mapName,
          ),
        );
      default:
        return null;
    }
  }
}
