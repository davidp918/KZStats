import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kzstats/cubit/cubit_update.dart';

import 'package:kzstats/router.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  // establish connection between hydrated bloc and the app storage layer
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ModeCubit>(
      lazy: false,
      create: (context) => ModeCubit(),
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Color(0xff4a5568),
        ),
        onGenerateRoute: _appRouter.onGenerateRoute,
      ),
    );
  }
}
