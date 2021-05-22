import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class NotificationState {
  bool enabled;
  bool kzt;
  bool skz;
  bool vnl;
  bool nub;
  NotificationState({
    required this.enabled,
    required this.kzt,
    required this.skz,
    required this.vnl,
    required this.nub,
  });

  Map<String, dynamic> toMap() {
    return {
      'enabled': enabled,
      'kzt': kzt,
      'skz': skz,
      'vnl': vnl,
      'nub': nub,
    };
  }

  factory NotificationState.fromMap(Map<String, dynamic> map) =>
      NotificationState(
        enabled: map['enabled'],
        kzt: map['kzt'],
        skz: map['skz'],
        vnl: map['vnl'],
        nub: map['nub'],
      );

  @override
  String toString() {
    return 'NotificationState(enabled: $enabled, kzt: $kzt, skz: $skz, vnl: $vnl, nub: $nub)';
  }
}

class NotificationCubit extends Cubit<NotificationState> with HydratedMixin {
  NotificationCubit()
      : super(NotificationState(
          enabled: false,
          kzt: false,
          skz: false,
          vnl: false,
          nub: false,
        ));
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  void toggleEnabled() async {
    await subscribe(state.enabled, 'enabled');
    emit(NotificationState(
      enabled: !state.enabled,
      kzt: state.kzt,
      skz: state.skz,
      vnl: state.vnl,
      nub: state.nub,
    ));
    print(state);
  }

  void toggleKZT() async {
    await subscribe(state.kzt, 'kzt');
    emit(NotificationState(
      enabled: state.enabled,
      kzt: !state.kzt,
      skz: state.skz,
      vnl: state.vnl,
      nub: state.nub,
    ));
    print(state);
  }

  void toggleSKZ() async {
    await subscribe(state.skz, 'skz');
    emit(NotificationState(
      enabled: state.enabled,
      kzt: state.kzt,
      skz: !state.skz,
      vnl: state.vnl,
      nub: state.nub,
    ));
    print(state);
  }

  void toggleVNL() async {
    await subscribe(state.vnl, 'vnl');
    emit(NotificationState(
      enabled: state.enabled,
      kzt: state.kzt,
      skz: state.skz,
      vnl: !state.vnl,
      nub: state.nub,
    ));
    print(state);
  }

  void toggleNUB() async {
    await subscribe(state.nub, 'nub');
    emit(NotificationState(
      enabled: state.enabled,
      kzt: state.kzt,
      skz: state.skz,
      vnl: state.vnl,
      nub: !state.nub,
    ));
    print(state);
  }

  void subscribeV(bool prev, String topic) async {
    !prev
        ? await messaging.subscribeToTopic(topic)
        : await messaging.unsubscribeFromTopic(topic);
  }

  Future subscribe(bool prev, String topic) async {
    !prev
        ? await messaging.subscribeToTopic(topic)
        : await messaging.unsubscribeFromTopic(topic);
  }

  @override
  NotificationState fromJson(Map<String, dynamic> json) =>
      NotificationState.fromMap(json);

  @override
  Map<String, dynamic> toJson(NotificationState state) => state.toMap();
}
