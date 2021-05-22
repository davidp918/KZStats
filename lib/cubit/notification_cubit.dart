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
          kzt: true,
          skz: false,
          vnl: false,
          nub: false,
        ));
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  void init(bool enable) {
    emit(NotificationState(
      enabled: enable,
      kzt: true,
      skz: false,
      vnl: false,
      nub: false,
    ));
    if (enable) subscribe(false, 'enabled');
    subscribe(false, 'kzt');
    print(state);
  }

  void toggleEnabled() async {
    subscribe(state.enabled, 'enabled');
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
    subscribe(state.kzt, 'kzt');
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
    subscribe(state.skz, 'skz');
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
    subscribe(state.vnl, 'vnl');
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
    !state.nub
        ? await messaging.subscribeToTopic('nub')
        : await messaging.unsubscribeFromTopic('nub');
    emit(NotificationState(
      enabled: state.enabled,
      kzt: state.kzt,
      skz: state.skz,
      vnl: state.vnl,
      nub: !state.nub,
    ));
    print(state);
  }

  void subscribe(bool prev, String topic) async {
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
