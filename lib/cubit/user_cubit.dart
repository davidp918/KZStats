import 'package:bloc/bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kzstats/web/json/kzstatsApiPlayer_json.dart';

class UserState {
  KzstatsApiPlayer playerInfo;
  bool loading;
  UserState({required this.playerInfo, required this.loading});

  Map<String, dynamic> toMap() =>
      {'info': playerInfo.toJson(), 'loading': loading};

  factory UserState.fromMap(Map<String, dynamic> map) => UserState(
        playerInfo: KzstatsApiPlayer.fromJson(map['info']),
        loading: map['loading'],
      );
}

class UserCubit extends Cubit<UserState> with HydratedMixin {
  UserCubit()
      : super(UserState(playerInfo: KzstatsApiPlayer(), loading: false));

  void setinfo(KzstatsApiPlayer newinfo) =>
      emit(UserState(playerInfo: newinfo, loading: false));

  void load() => emit(UserState(playerInfo: state.playerInfo, loading: true));

  @override
  UserState fromJson(Map<String, dynamic> json) {
    return UserState.fromMap(json);
  }

  @override
  Map<String, dynamic> toJson(UserState state) {
    return state.toMap();
  }
}
