import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'cubit_state.dart';

class ModeCubit extends Cubit<ModeState> {
  ModeCubit() : super(ModeState(mode: 'Kztimer'));

  void kzt() {
    if (state.mode != 'Kztimer') {
      emit(ModeState(mode: 'Kztimer'));
    }
  }

  void skz() {
    if (state.mode != 'SimpleKZ') {
      emit(ModeState(mode: 'SimpleKZ'));
    }
  }

  void vnl() {
    if (state.mode != 'Vanilla') {
      emit(ModeState(mode: 'Vanilla'));
    }
  }
}

class NubCubit extends Cubit<NubState> {
  NubCubit() : super(NubState(nub: false));

  void toNub() {
    if (state.nub = false) {
      emit(NubState(nub: true));
    }
  }

  void toPro() {
    if (state.nub = true) {
      emit(NubState(nub: false));
    }
  }
}
