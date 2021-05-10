import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kzstats/data/shared_preferences.dart';
import 'package:kzstats/data/localPlayerClass.dart';
import 'package:http/http.dart' as http;

class SearchPlayerProvider extends ChangeNotifier {
  List<LocalPlayer> _history =
      UserSharedPreferences.getSearchPlayerHistory().take(8).toList();
  List<LocalPlayer> get history => _history;

  bool _expanded = false;
  bool _isLoading = false;
  String _query = '';
  List<LocalPlayer> _suggestions = [];

  bool get expanded => _expanded;
  bool get isLoading => _isLoading;
  String get query => _query;
  List<LocalPlayer> get suggestions => _suggestions;

  void loadHis() {
    _history = _expanded
        ? UserSharedPreferences.getSearchPlayerHistory()
        : UserSharedPreferences.getSearchPlayerHistory().take(6).toList();
    notifyListeners();
  }

  void refresh() {
    loadHis();
    notifyListeners();
  }

  void onQueryChanged(String query) async {
    if (query == _query) return;

    _query = query;
    _isLoading = true;
    notifyListeners();

    if (query.isEmpty) {
      // _suggestions = *explore*
      _suggestions = [];
    } else {
      dynamic response = await http.get(
        Uri.parse(
          (query.length == 17 && double.tryParse(query) != null)
              ? 'https://kztimerglobal.com/api/v2.0/players?steamid64_list=$query'
              : 'https://kztimerglobal.com/api/v2.0/records/top?player_name=$query&limit=50',
        ),
      );
      if (response == null) {
        _suggestions = [];
      } else {
        dynamic decoded = json.decode(response.body);
        List<LocalPlayer> converted = new List<LocalPlayer>.from(
          decoded.map((x) => LocalPlayer.fromJson(x)),
        );
        Set<String> seen = {};
        List<LocalPlayer> unique = [];
        for (LocalPlayer each in converted) {
          if (seen.contains(each.steamid64)) continue;
          seen.add(each.steamid64);
          unique.add(each);
        }
        unique.sort(
          (a, b) => a.player_name
              .indexOf(query)
              .compareTo(b.player_name.indexOf(query)),
        );
        _suggestions = unique;
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  void expand() {
    _expanded = !expanded;
    loadHis();
    notifyListeners();
  }
}
