import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ModeState {
  String mode;
  bool nub;

  ModeState({
    required this.mode,
    required this.nub,
  });

  Map<String, dynamic> toMap() {
    return {
      'mode': mode,
      'nub': nub,
    };
  }

  factory ModeState.fromMap(Map<String, dynamic>? map) {
    //if (map == null) return null;
    return ModeState(
      mode: map!['mode'],
      nub: map['nub'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ModeState.fromJson(String source) =>
      ModeState.fromMap(json.decode(source));
}

class ModeCubit extends Cubit<ModeState> with HydratedMixin {
  ModeCubit() : super(ModeState(mode: 'kz_timer', nub: false));

  void refresh() => emit(ModeState(mode: state.mode, nub: state.nub));

  void kzt() {
    if (state.mode != 'kz_timer') {
      emit(ModeState(mode: 'kz_timer', nub: state.nub));
    }
  }

  void skz() {
    if (state.mode != 'kz_simple') {
      emit(ModeState(mode: 'kz_simple', nub: state.nub));
    }
  }

  void vnl() {
    if (state.mode != 'kz_vanilla') {
      emit(ModeState(mode: 'kz_vanilla', nub: state.nub));
    }
  }

  void toNub() {
    if (state.nub == false) {
      emit(ModeState(nub: true, mode: state.mode));
    }
  }

  void toPro() {
    if (state.nub == true) {
      emit(ModeState(nub: false, mode: state.mode));
    }
  }

  @override
  ModeState fromJson(Map<String, dynamic> json) {
    return ModeState.fromMap(json);
  }

  @override
  Map<String, dynamic> toJson(ModeState state) {
    return state.toMap();
  }
}
