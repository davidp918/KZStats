import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class MarkState {
  List<String> mapIds;
  List<String> playerIds;
  bool readyToMarkPlayer;
  MarkState({
    required this.mapIds,
    required this.playerIds,
    required this.readyToMarkPlayer,
  });

  Map<String, dynamic> toMap() => {
        'mapIds': json.encode(mapIds),
        'playerIds': json.encode(playerIds),
        'readyToMarkPlayer': readyToMarkPlayer,
      };

  factory MarkState.fromMap(Map<String, dynamic> map) => MarkState(
        mapIds: (json.decode(map['mapIds']) as List)
            .map((e) => e.toString())
            .toList(),
        playerIds: (json.decode(map['playerIds']) as List)
            .map((e) => e.toString())
            .toList(),
        readyToMarkPlayer: map['readyToMarkPlayer'],
      );
}

class MarkCubit extends Cubit<MarkState> with HydratedMixin {
  MarkCubit()
      : super(MarkState(
          mapIds: [],
          playerIds: [],
          readyToMarkPlayer: false,
        ));

  void setMapIds(List<String> newMapIds) => emit(MarkState(
        mapIds: newMapIds,
        playerIds: state.playerIds,
        readyToMarkPlayer: state.readyToMarkPlayer,
      ));

  void setPlayerIds(List<String> newPlayerIds, BuildContext context) {
    print('marked');
    emit(MarkState(
      mapIds: state.mapIds,
      playerIds: newPlayerIds,
      readyToMarkPlayer: state.readyToMarkPlayer,
    ));
  }

  void setIfReady(bool boolean) => emit(MarkState(
        mapIds: state.mapIds,
        playerIds: state.playerIds,
        readyToMarkPlayer: boolean,
      ));

  @override
  MarkState fromJson(Map<String, dynamic> json) => MarkState.fromMap(json);

  @override
  Map<String, dynamic> toJson(MarkState state) => state.toMap();
}
