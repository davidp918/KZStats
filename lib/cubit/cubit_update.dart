import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'cubit_state.dart';

class ModeCubit extends Cubit<ModeState> with HydratedMixin {
  ModeCubit() : super(ModeState(mode: 'Kztimer', nub: false));

  void refresh() => emit(ModeState(mode: state.mode, nub: state.nub));

  void kzt() {
    if (state.mode != 'Kztimer') {
      emit(ModeState(mode: 'Kztimer', nub: state.nub));
    }
  }

  void skz() {
    if (state.mode != 'SimpleKZ') {
      emit(ModeState(mode: 'SimpleKZ', nub: state.nub));
    }
  }

  void vnl() {
    if (state.mode != 'Vanilla') {
      emit(ModeState(mode: 'Vanilla', nub: state.nub));
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
