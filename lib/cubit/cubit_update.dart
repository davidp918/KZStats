import 'package:bloc/bloc.dart';

part 'cubit_state.dart';

class ModeCubit extends Cubit<ModeState> {
  ModeCubit() : super(ModeState(mode: 'Kztimer', nub: false));

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

  void toNub() {
    if (state.nub == false) {
      print('nub');
      emit(ModeState(nub: true));
    }
  }

  void toPro() {
    if (state.nub == true) {
      emit(ModeState(nub: false));
    }
  }
}
