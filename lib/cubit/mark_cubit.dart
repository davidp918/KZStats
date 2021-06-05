import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
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
        mapIds: (json.decode(map['mapIds']) as List)
            .map((e) => e.toString())
            .toList(),
        playerIds: (json.decode(map['playerIds']) as List)
            .map((e) => e.toString())
            .toList(),
      );
}

class MarkCubit extends Cubit<MarkState> with HydratedMixin {
  MarkCubit() : super(MarkState(mapIds: [], playerIds: []));

  void setMapIds(List<String> newMapIds) =>
      emit(MarkState(mapIds: newMapIds, playerIds: state.playerIds));

  void setPlayerIds(List<String> newPlayerIds, BuildContext context) {
    if (state.playerIds.length >= 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Exceeding maximum limit of favourite players, anywhere beyond 8 will cram GlobalApi.'),
        ),
      );
    } else {
      emit(MarkState(mapIds: state.mapIds, playerIds: newPlayerIds));
    }
  }

  @override
  MarkState fromJson(Map<String, dynamic> json) => MarkState.fromMap(json);

  @override
  Map<String, dynamic> toJson(MarkState state) => state.toMap();
}
