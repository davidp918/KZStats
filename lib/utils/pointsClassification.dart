import 'package:flutter/material.dart';
import 'package:kzstats/utils/svg.dart';

Widget classifyPoints(int? points) {
  Widget trophy;
  if (points == 1000) {
    return Row(
      children: [
        SizedBox(width: 8),
        goldSvg(26, 26),
      ],
    );
  } else if (points! >= 900) {
    trophy = silverSvg(15, 15);
  } else if (points >= 750) {
    trophy = bronzeSvg(15, 15);
  } else {
    return Text('$points', style: TextStyle(color: Colors.white));
  }
  return Row(
    children: [
      trophy,
      SizedBox(width: 4),
      Text(
        '$points',
        style: TextStyle(color: Colors.white),
      ),
    ],
  );
}
