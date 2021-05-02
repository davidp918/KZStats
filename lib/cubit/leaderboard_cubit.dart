import 'package:bloc/bloc.dart';

part 'leaderboard_state.dart';

class LeaderboardCubit extends Cubit<LeaderboardState> {
  LeaderboardCubit() : super(LeaderboardState(type: 'records'));

  void set(String newType) {
    if (newType != state.type) {
      emit(LeaderboardState(type: newType));
    }
  }
}
