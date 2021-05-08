import 'package:flutter/material.dart';
import 'package:kzstats/data/shared_preferences.dart';
import 'package:kzstats/web/json/mapinfo_json.dart';

class SearchProvider extends ChangeNotifier {
  List<MapInfo>? allMapData = UserSharedPreferences.getMapData();
  List<MapInfo> _history = UserSharedPreferences.getHistory().take(6).toList();

  bool _expanded = false;
  bool get expanded => _expanded;

  void loadHis() {
    _history = _expanded
        ? UserSharedPreferences.getHistory()
        : UserSharedPreferences.getHistory().take(6).toList();
    notifyListeners();
  }

  List<MapInfo> get history => _history;
  void refresh() {
    loadHis();
    notifyListeners();
  }

  bool _isLoading = false;
  String _query = '';
  List<MapInfo> _suggestions = []; // = history

  bool get isLoading => _isLoading;
  String get query => _query;
  List<MapInfo> get suggestions => _suggestions;

  void onQueryChanged(String query) {
    if (query == _query) return;

    _query = query;
    _isLoading = true;
    notifyListeners();

    if (query.isEmpty || allMapData == null) {
      // _suggestions = *explore*
      _suggestions = [];
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
    _suggestions = UserSharedPreferences.getHistory();
    notifyListeners();
  }

  void expand() {
    if (_expanded == false) {
      _expanded = true;
    } else {
      _expanded = false;
    }
    loadHis();
    notifyListeners();
  }
}
