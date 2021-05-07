import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kzstats/data/shared_preferences.dart';
import 'package:kzstats/web/json/mapinfo_json.dart';
import 'package:kzstats/cubit/search_cubit.dart';

class SearchProvider extends ChangeNotifier {
  List<MapInfo>? allMapData = UserSharedPreferences.getMapData();
  List<MapInfo> history = UserSharedPreferences.getHistory();

  bool _isLoading = false;
  String _query = '';
  List<MapInfo> _suggestions = UserSharedPreferences.getHistory(); // = history

  bool get isLoading => _isLoading;
  String get query => _query;
  List<MapInfo> get suggestions => _suggestions;

  void onQueryChanged(String query) {
    if (query == _query) return;

    _query = query;
    _isLoading = true;
    notifyListeners();

    if (query.isEmpty || allMapData == null) {
      _suggestions = history;
    } else {
      List<MapInfo> back = [];
      for (MapInfo each in allMapData!) {
        if (each.mapName!.contains(query)) {
          back.add(each);
        }
      }
      back.sort((a, b) =>
          a.mapName!.indexOf(query).compareTo(b.mapName!.indexOf(query)));
      _suggestions = back;
    }

    _isLoading = false;
    notifyListeners();
  }

  void clear() {
    _suggestions = history;
    notifyListeners();
  }
}
