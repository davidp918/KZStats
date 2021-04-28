import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:kzstats/common/widgets/dataCells.dart';
import 'package:kzstats/theme/colors.dart';
import 'package:kzstats/web/json/record_json.dart';

class MapDetailTable extends StatefulWidget {
  final List<Record>? records;

  MapDetailTable({
    Key? key,
    required this.records,
  }) : super(key: key);

  @override
  _MapDetailTableState createState() => _MapDetailTableState();
}

class _MapDetailTableState extends State<MapDetailTable> {
  late final List<Record>? _records;
  int? _sortColumnIndex;
  bool _isAscending = false;
  List<String> columns = [
    '#',
    'Player',
    'Time',
    'Points',
    'TPs',
    'Date',
    'Server',
  ];

  @override
  void initState() {
    super.initState();
    this._records = widget.records;
  }

  int compareString(bool ascending, dynamic value1, dynamic value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

  void onSort(
    int columnIndex,
    bool isAscending,
  ) {
    switch (columnIndex) {
      case 0:
        break;
      default:
    }
    setState(
      () {
        this._sortColumnIndex = columnIndex;
        this._isAscending = isAscending;
      },
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map(
        (String column) => DataColumn(
          label: Text(
            '$column',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          onSort: onSort,
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: dividerColor(),
        textTheme: TextTheme(
          caption: TextStyle(color: Colors.white),
        ),
        cardTheme: CardTheme(
          color: Color(0xff1D202C),
        ),
      ),
      child: buildDataTable(context, _records),
    );
  }

  Widget buildDataTable(BuildContext context, List<Record>? records) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: PaginatedDataTable(
        dragStartBehavior: DragStartBehavior.down,
        headingRowHeight: 40,
        dataRowHeight: 42,
        horizontalMargin: 12,
        columnSpacing: 15,
        columns: getColumns(columns),
        source: RecordsSource(context, records),
        sortColumnIndex: _sortColumnIndex,
        sortAscending: _isAscending,
      ),
    );
  }
}

class RecordsSource extends DataTableSource {
  BuildContext context;
  List<Record>? _records;

  RecordsSource(
    this.context,
    this._records,
  );
  List<DataCell> selectDataCells(
    BuildContext context,
    int index,
    dynamic record,
  ) {
    return <DataCell>[
      indexDataCell(index),
      playerNameDataCell(context, record),
      timeDataCell(record),
      pointsDataCell(record),
      teleportsDataCell(record),
      createdOnDataCell(record),
      serverNameDataCell(record),
    ];
  }

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    final Record record = _records![index];
    return DataRow.byIndex(
      index: index,
      color: MaterialStateColor.resolveWith(
        (states) {
          if (index % 2 == 0) {
            return primarythemeBlue();
          } else {
            return secondarythemeBlue();
          }
        },
      ),
      cells: selectDataCells(context, index, record),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _records!.length;

  @override
  int get selectedRowCount => 0;
}
