import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kzstats/cubit/notification_cubit.dart';
import 'package:path_provider/path_provider.dart';

import 'package:kzstats/cubit/leaderboard_cubit.dart';
import 'package:kzstats/cubit/mode_cubit.dart';
import 'package:kzstats/cubit/user_cubit.dart';
import 'package:kzstats/cubit/tier_cubit.dart';
import 'package:kzstats/cubit/search_cubit.dart';
import 'package:kzstats/cubit/playerdisplay_cubit.dart';
import 'package:kzstats/data/shared_preferences.dart';
import 'package:kzstats/global/router.dart';
import 'package:kzstats/theme/colors.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory());
  await UserSharedPreferences.init();
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NotificationCubit>(
            create: (context) => NotificationCubit()),
        BlocProvider<UserCubit>(create: (context) => UserCubit()),
        BlocProvider<ModeCubit>(create: (context) => ModeCubit()),
        BlocProvider<TierCubit>(create: (context) => TierCubit()),
        BlocProvider<LeaderboardCubit>(create: (context) => LeaderboardCubit()),
        BlocProvider<PlayerdisplayCubit>(
            create: (context) => PlayerdisplayCubit()),
        BlocProvider<SearchCubit>(create: (context) => SearchCubit()),
      ],
      child: Builder(
        builder: (context) {
          firstStart(context);
          return MaterialApp(
            theme: ThemeData(
              scaffoldBackgroundColor: backgroundColor(),
              fontFamily: 'NotoSansHK',
              textTheme: TextTheme(
                bodyText1: TextStyle(),
                bodyText2: TextStyle(),
              ).apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
            ),
            onGenerateRoute: _appRouter.onGenerateRoute,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

Future<String?> getToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  print(token);
  return token;
}

void firstStart(BuildContext context) async {
  if (!UserSharedPreferences.getFirstStart()) return;
  print('first');
  await UserSharedPreferences.setStarted();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  BlocProvider.of<NotificationCubit>(context).toggleKZT();
  if (settings.authorizationStatus == AuthorizationStatus.authorized)
    BlocProvider.of<NotificationCubit>(context).toggleEnabled();
}
