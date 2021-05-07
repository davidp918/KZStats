import 'package:bloc/bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class SearchState {
  List<String> history;
  SearchState({required this.history});
}

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchState(history: []));

  void addToHistory(String newHistory) {
    List<String> temp = state.history;
    if (state.history.contains(newHistory)) {
      temp.removeWhere((element) => element == newHistory);
    }
    temp.insert(0, newHistory);
    emit(SearchState(history: temp));
  }
}
