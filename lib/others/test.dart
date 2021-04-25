import 'package:flutter/material.dart';

Widget test() {
  return Theme(
    data: Theme.of(context).copyWith(
      cardColor: Color(0xff1D202C),
      dividerColor: Color(0xff333333),
    ),
    child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: PaginatedDataTable(
        headingRowHeight: 40,
        dataRowHeight: 42,
        horizontalMargin: 12,
        columnSpacing: 20,
        columns: getColumns(columns),
        source: RecordsSource(records: mapTop),
      ),
    ),
  );
}
