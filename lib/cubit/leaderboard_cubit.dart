import 'package:bloc/bloc.dart';

class LeaderboardState {
  String type;
  LeaderboardState({required this.type});
}

class LeaderboardCubit extends Cubit<LeaderboardState> {
  LeaderboardCubit() : super(LeaderboardState(type: 'records'));

  void set(String newType) {
    if (newType != state.type) {
      emit(LeaderboardState(type: newType));
    }
  }
}
