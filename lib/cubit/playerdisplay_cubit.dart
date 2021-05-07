import 'package:bloc/bloc.dart';

class PlayerdisplayState {
  String playerDisplay;
  PlayerdisplayState({required this.playerDisplay});
}

class PlayerdisplayCubit extends Cubit<PlayerdisplayState> {
  PlayerdisplayCubit() : super(PlayerdisplayState(playerDisplay: 'records'));

  void set(String newDisplay) {
    if (newDisplay != state.playerDisplay) {
      emit(PlayerdisplayState(playerDisplay: '$newDisplay'));
    }
  }
}
