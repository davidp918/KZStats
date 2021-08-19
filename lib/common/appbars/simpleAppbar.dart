import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kzstats/look/colors.dart';

PreferredSizeWidget defaultAppbar(String title) => PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight * 0.9),
      child: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: appbarColor(),
          statusBarBrightness: Brightness.dark,
        ),
        backgroundColor: appbarColor(),
        centerTitle: true,
        //brightness: Brightness.dark,
        title: Text('$title'),
      ),
    );
