import 'package:flutter/material.dart';
import 'package:kzstats/theme/colors.dart';

DataCell averageDataCell(double? average) {
  return DataCell(
    Text(
      '$average',
      style: TextStyle(
        color: Colors.white,
      ),
    ),
  );
}

int compareString(bool ascending, dynamic value1, dynamic value2) =>
    ascending ? value1.compareTo(value2) : value2.compareTo(value1);

DataCell vanillaDataCell(String? str) {
  late Characters re;
  str == null ? re = Characters('<Unknown>') : re = Characters(str);
  return DataCell(
    Text(
      '$re',
      style: TextStyle(
        color: Colors.white,
      ),
    ),
  );
}

DataCell buttonDataCell(
  BuildContext context,
  String? str,
  String destination,
  dynamic parameter,
) {
  late Characters re;
  str == null ? re = Characters('<Unknown>') : re = Characters(str);
  return DataCell(
    InkWell(
      onTap: () => Navigator.of(context).pushNamed(
        destination,
        arguments: parameter,
      ),
      child: Text(
        '$re',
        style: TextStyle(
          color: inkWellBlue(),
        ),
      ),
    ),
  );
}
