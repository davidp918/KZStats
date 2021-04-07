import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kzstats/cubit/cubit_update.dart';

import 'package:kzstats/router.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ModeCubit>(
      lazy: true,
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
