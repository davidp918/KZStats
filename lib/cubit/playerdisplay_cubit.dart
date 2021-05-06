import 'package:bloc/bloc.dart';

part 'playerdisplay_state.dart';

class PlayerdisplayCubit extends Cubit<PlayerdisplayState> {
  PlayerdisplayCubit() : super(PlayerdisplayState(playerDisplay: 'records'));

  void set(String newDisplay) {
    if (newDisplay != state.playerDisplay) {
      emit(PlayerdisplayState(playerDisplay: '$newDisplay'));
    }
  }
}
