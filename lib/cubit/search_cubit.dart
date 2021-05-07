import 'package:bloc/bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kzstats/data/shared_preferences.dart';
import 'package:kzstats/web/json/mapinfo_json.dart';

class SearchState {
  List<String> history;
  List<MapInfo> suggestions;
  SearchState({required this.history, required this.suggestions});
}

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchState(history: [], suggestions: []));

  void suggest(List<MapInfo> sug) {
    emit(SearchState(suggestions: sug, history: state.history));
  }

  void addToHistory(String newHistory) {
    List<String> temp = state.history;
    if (state.history.contains(newHistory)) {
      temp.removeWhere((element) => element == newHistory);
    }
    temp.insert(0, newHistory);
    emit(SearchState(suggestions: state.suggestions, history: temp));
  }
}

const List<MapInfo> history = [];
