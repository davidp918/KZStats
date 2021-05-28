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

DataCell vanillaDataCell(dynamic data) => DataCell(
    Text('${data == null ? '<Unknown>' : Characters(data.toString())}'));

DataCell buttonDataCell(BuildContext context, dynamic data, String destination,
        dynamic parameter) =>
    DataCell(
      InkWell(
        onTap: () =>
            Navigator.of(context).pushNamed(destination, arguments: parameter),
        child:
            Text('${data == null ? '<Unknown>' : Characters(data.toString())}'),
      ),
    );
