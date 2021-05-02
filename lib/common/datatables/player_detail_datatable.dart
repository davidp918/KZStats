import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:kzstats/common/widgets/dataCells.dart';
import 'package:kzstats/theme/colors.dart';
import 'package:kzstats/web/json/record_json.dart';

class PlayerDetailTable extends StatefulWidget {
  final List<Record>? records;

  PlayerDetailTable({
    Key? key,
    required this.records,
  }) : super(key: key);

  @override
  _PlayerDetailTableState createState() => _PlayerDetailTableState();
}

class _PlayerDetailTableState extends State<PlayerDetailTable> {
  late final List<Record>? _records;
  int? _sortColumnIndex;
  bool _isAscending = false;
  final List<String> columns = [
    'Map',
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
    onSort(4, false);
  }

  void onSort(
    int columnIndex,
    bool isAscending,
  ) {
    switch (columnIndex) {
      case 0:
        _records!.sort((value1, value2) =>
            compareString(isAscending, value1.mapName, value2.mapName));
        break;
      case 1:
        _records!.sort((value1, value2) =>
            compareString(isAscending, value1.time, value2.time));
        break;
      case 2:
        _records!.sort((value1, value2) =>
            compareString(isAscending, value1.points, value2.points));
        break;
      case 3:
        _records!.sort((value1, value2) =>
            compareString(isAscending, value1.teleports, value2.teleports));
        break;
      case 4:
        _records!.sort((value1, value2) =>
            compareString(isAscending, value1.createdOn, value2.createdOn));
        break;
      case 5:
        _records!.sort((value1, value2) =>
            compareString(isAscending, value1.serverName, value2.serverName));
        break;

      default:
        throw (UnimplementedError);
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
        headingRowHeight: 46,
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
      mapNameDataCell(context, record),
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
  int get rowCount => _records?.length == null ? 0 : _records!.length;

  @override
  int get selectedRowCount => 0;
}
