import 'package:bloc/bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kzstats/global/userInfo_class.dart';

class UserState {
  UserInfo info;
  bool loading;
  UserState({required this.info, required this.loading});

  Map<String, dynamic> toMap() => {'info': info.toJson(), 'loading': loading};

  factory UserState.fromMap(Map<String, dynamic> map) =>
      UserState(info: UserInfo.fromJson(map['info']), loading: map['loading']);
}

class UserCubit extends Cubit<UserState> with HydratedMixin {
  UserCubit()
      : super(UserState(
            info: UserInfo(
              avatarUrl: '',
              name: '',
              steam32: '',
              steam64: '',
            ),
            loading: false));

  void setinfo(UserInfo newinfo) =>
      emit(UserState(info: newinfo, loading: false));

  void load() => emit(UserState(info: state.info, loading: true));

  @override
  UserState fromJson(Map<String, dynamic> json) {
    return UserState.fromMap(json);
  }

  @override
  Map<String, dynamic> toJson(UserState state) {
    return state.toMap();
  }
}
