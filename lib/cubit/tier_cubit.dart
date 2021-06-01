import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class FilterState {
  int sortBy;
  List<dynamic> tier;
  List<dynamic> mapper;
  FilterState({
    required this.sortBy,
    required this.tier,
    required this.mapper,
  });

  Map<String, dynamic> toMap() => {
        'sortBy': sortBy,
        'tier': json.encode(tier),
        'mapper': json.encode(mapper),
      };

  factory FilterState.fromMap(Map<String, dynamic> map) => FilterState(
        sortBy: map['sortBy'],
        tier: json.decode(map['tier']) as List<dynamic>,
        mapper: json.decode(map['mapper']) as List<dynamic>,
      );
}

class FilterCubit extends Cubit<FilterState> with HydratedMixin {
  FilterCubit()
      : super(FilterState(sortBy: 0, tier: [1, 2, 3, 4, 5, 6, 7], mapper: []));

  void setSortBy(int newSortBy) => emit(
      FilterState(sortBy: newSortBy, tier: state.tier, mapper: state.mapper));

  void setTier(List<dynamic> newTier) => emit(
      FilterState(tier: newTier, sortBy: state.sortBy, mapper: state.mapper));

  void setMapper(List<dynamic> newMapper) => emit(
      FilterState(sortBy: state.sortBy, tier: state.tier, mapper: newMapper));

  @override
  FilterState fromJson(Map<String, dynamic> json) => FilterState.fromMap(json);

  @override
  Map<String, dynamic> toJson(FilterState state) => state.toMap();
}
