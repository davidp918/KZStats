import 'package:bloc/bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class FilterState {
  int sortBy;
  // 0: A-Z, 1: Latest, 2:Oldest, 3: Map Size
  Set<int> tier;
  Set<String> mapper;
  FilterState({
    required this.sortBy,
    required this.tier,
    required this.mapper,
  });

  Map<String, dynamic> toMap() => {
        'sortBy': sortBy,
        'tier': tier,
        'mapper': mapper,
      };

  factory FilterState.fromMap(Map<String, dynamic> map) => FilterState(
        sortBy: map['sortBy'],
        tier: map['tier'],
        mapper: map['mapper'],
      );
}

class FilterCubit extends Cubit<FilterState> with HydratedMixin {
  FilterCubit() : super(FilterState(sortBy: 0, tier: {0}, mapper: {}));

  void setTier(Set<int> newTier) => emit(
      FilterState(tier: newTier, sortBy: state.sortBy, mapper: state.mapper));

  void setSortBy(int newSortBy) => emit(
      FilterState(sortBy: newSortBy, tier: state.tier, mapper: state.mapper));

  void setMapper(Set<String> newMapper) => emit(
      FilterState(sortBy: state.sortBy, tier: state.tier, mapper: newMapper));

  @override
  FilterState fromJson(Map<String, dynamic> json) => FilterState.fromMap(json);

  @override
  Map<String, dynamic> toJson(FilterState state) => state.toMap();
}
