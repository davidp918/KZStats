import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget goldSvg(double height, double width) => SvgPicture.asset(
      'assets/icon/trophy.svg',
      height: height,
      width: width,
    );

Widget silverSvg(double height, double width) => SvgPicture.asset(
      'assets/icon/silver.svg',
      height: height,
      width: width,
    );

Widget bronzeSvg(double height, double width) => SvgPicture.asset(
      'assets/icon/bronze.svg',
      height: height,
      width: width,
    );
