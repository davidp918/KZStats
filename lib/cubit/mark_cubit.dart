import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class MarkState {
  List<String> mapIds;
  List<String> playerIds;
  MarkState({
    required this.mapIds,
    required this.playerIds,
  });

  Map<String, dynamic> toMap() => {
        'mapIds': json.encode(mapIds),
        'playerIds': json.encode(playerIds),
      };

  factory MarkState.fromMap(Map<String, dynamic> map) => MarkState(
        mapIds: json.decode(map['mapIds']),
        playerIds: json.decode(map['playerIds']),
      );
}

class MarkCubit extends Cubit<MarkState> with HydratedMixin {
  MarkCubit() : super(MarkState(mapIds: [], playerIds: []));

  void setMapIds(List<String> newMapIds) =>
      emit(MarkState(mapIds: newMapIds, playerIds: state.playerIds));

  void setPlayerIds(List<String> newPlayerIds) =>
      emit(MarkState(mapIds: state.mapIds, playerIds: newPlayerIds));

  @override
  MarkState fromJson(Map<String, dynamic> json) => MarkState.fromMap(json);

  @override
  Map<String, dynamic> toJson(MarkState state) => state.toMap();
}
