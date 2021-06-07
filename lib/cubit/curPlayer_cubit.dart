import 'package:bloc/bloc.dart';

class CurPlayerState {
  String? curPlayer;
  CurPlayerState({this.curPlayer});
}

class CurPlayerCubit extends Cubit<CurPlayerState> {
  CurPlayerCubit() : super(CurPlayerState(curPlayer: null));

  void set(String? newPlayer) {
    emit(CurPlayerState(curPlayer: newPlayer));
    print('Current player: $newPlayer');
  }
}
