import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class SearchState {
  String field;
  SearchState({required this.field});

  Map<String, dynamic> toMap() => {'field': field};

  factory SearchState.fromMap(Map<String, dynamic> map) =>
      SearchState(field: map['field']);
}

class SearchCubit extends Cubit<SearchState> with HydratedMixin {
  SearchCubit() : super(SearchState(field: 'map'));

  void setField(String newField) => emit(SearchState(field: newField));

  @override
  SearchState fromJson(Map<String, dynamic> json) {
    return SearchState.fromMap(json);
  }

  @override
  Map<String, dynamic> toJson(SearchState state) {
    return state.toMap();
  }
}
