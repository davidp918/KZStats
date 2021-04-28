import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:kzstats/common/widgets/dataCells.dart';
import 'package:kzstats/theme/colors.dart';
import 'package:kzstats/web/json/record_json.dart';

class BuildDataTable extends StatefulWidget {
  final List<Record>? records;
  final String tableType;
  BuildDataTable({
    Key? key,
    required this.records,
    required this.tableType,
  }) : super(key: key);

  @override
  _BuildDataTableState createState() => _BuildDataTableState();
}

class _BuildDataTableState extends State<BuildDataTable> {
  late final List<Record>? _records;
  int? _sortColumnIndex;
  bool _isAscending = false;
  late final columns;

  @override
  void initState() {
    super.initState();
    this._records = widget.records;
  }

  void onSort(
    int columnIndex,
    bool isAscending,
  ) {
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
    if (widget.tableType == 'map_detail') {
      columns = map_detail_columns;
    } else if (widget.tableType == 'player_detail') {
      columns = player_detail_columns;
    } else {
      throw (UnimplementedError);
    }
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: PaginatedDataTable(
        dragStartBehavior: DragStartBehavior.down,
        headingRowHeight: 40,
        dataRowHeight: 42,
        horizontalMargin: 12,
        columnSpacing: 15,
        columns: getColumns(columns),
        source: RecordsSource(context, records, widget.tableType),
        sortColumnIndex: _sortColumnIndex,
      ),
    );
  }
}

class RecordsSource extends DataTableSource {
  BuildContext context;
  List<Record>? _records;
  final String tableType;
  RecordsSource(
    this.context,
    this._records,
    this.tableType,
  );
  List<DataCell> selectDataCells(
    BuildContext context,
    int index,
    dynamic record,
    String tableType,
  ) {
    if (tableType == 'map_detail') {
      return <DataCell>[
        indexDataCell(index),
        playerNameDataCell(context, record),
        timeDataCell(record),
        pointsDataCell(record),
        teleportsDataCell(record),
        createdOnDataCell(record),
        serverNameDataCell(record),
      ];
    } else if (tableType == 'player_detail') {
      return <DataCell>[
        mapNameDataCell(record),
        timeDataCell(record),
        pointsDataCell(record),
        teleportsDataCell(record),
        createdOnDataCell(record),
        serverNameDataCell(record),
      ];
    } else {
      throw (UnimplementedError);
    }
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
      cells: selectDataCells(context, index, record, tableType),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _records!.length;

  @override
  int get selectedRowCount => 0;
}
