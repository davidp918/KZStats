import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'mode_state.dart';

class ModeCubit extends Cubit<ModeState> {
  ModeCubit() : super(ModeState(mode: 'Kztimer'));

  void kzt() => emit(ModeState(mode: 'Kztimer'));

  void skz() => emit(ModeState(mode: 'SimpleKZ'));

  void vnl() => emit(ModeState(mode: 'Vanilla'));
}
