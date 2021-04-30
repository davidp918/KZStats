import 'package:bloc/bloc.dart';

part 'tier_state.dart';

class TierCubit extends Cubit<TierState> {
  TierCubit() : super(TierState(tier: 0));

  void set(int newTier) {
    emit(TierState(tier: newTier));
  }
}
