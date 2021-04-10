import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget trophy(double height, double width) => SvgPicture.asset(
      'assets/icon/trophy.svg',
      height: height,
      width: width,
    );

Widget silver(double height, double width) => SvgPicture.asset(
      'assets/icon/silver.svg',
      height: height,
      width: width,
    );

Widget bronze(double height, double width) => SvgPicture.asset(
      'assets/icon/bronze.svg',
      height: height,
      width: width,
    );
