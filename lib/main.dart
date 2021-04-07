import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kzstats/cubit/cubit_update.dart';

import 'pages/homepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        lazy: false,
        create: (context) => ModeCubit(),
        child: MediaQuery(
          data: MediaQueryData(),
          child: MaterialApp(
            theme: ThemeData(
              scaffoldBackgroundColor: Color(0xff4a5568),
            ),
            home: Homepage(),
          ),
        ));
  }
}
