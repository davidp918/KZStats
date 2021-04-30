import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kzstats/cubit/mode_cubit.dart';
import 'package:kzstats/cubit/tier_cubit.dart';
import 'package:kzstats/data/shared_preferences.dart';

import 'package:kzstats/router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:kzstats/theme/colors.dart';

void main() async {
  // establish connection between hydrated bloc and the app storage layer
  WidgetsFlutterBinding.ensureInitialized();
  Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
  HydratedBloc.storage =
      await HydratedStorage.build(storageDirectory: appDocumentsDirectory);
  await UserSharedPreferences.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ModeCubit>(
          create: (context) => ModeCubit(),
        ),
        BlocProvider<TierCubit>(
          create: (context) => TierCubit(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: backgroundColor(),
        ),
        onGenerateRoute: _appRouter.onGenerateRoute,
      ),
    );
  }
}
