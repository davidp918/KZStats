import 'package:bloc/bloc.dart';

class TierState {
  int tier;
  TierState({
    required this.tier,
  });
}

class TierCubit extends Cubit<TierState> {
  TierCubit() : super(TierState(tier: 0));

  void set(int newTier) {
    emit(TierState(tier: newTier));
  }
}
